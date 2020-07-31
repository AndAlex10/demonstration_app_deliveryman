import 'package:aqui_tem_deliveryman/config/rabbitmq.config.dart';
import 'package:aqui_tem_deliveryman/controllers/deliveryman.controller.dart';
import 'package:aqui_tem_deliveryman/controllers/order.controller.dart';
import 'package:aqui_tem_deliveryman/enums/status.delivery.enum.dart';
import 'package:aqui_tem_deliveryman/models/entities/order.entities.dart';
import 'package:aqui_tem_deliveryman/models/entities/statistic.entities.dart';
import 'package:dart_amqp/dart_amqp.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobx/mobx.dart';
import 'package:aqui_tem_deliveryman/models/entities/user.entities.dart';

part 'user.store.g.dart';

class UserStore = _UserStore with _$UserStore;

abstract class _UserStore with Store {
  @observable
  int lastOnResumeCall = 0;

  @observable
  FirebaseMessaging fbMessaging;

  @observable
  UserEntity user;

  @observable
  StatisticData statistic;

  @observable
  bool isLoading = false;

  @observable
  OrderData order;

  Client connectionRabbit;

  _UserStore(this.fbMessaging){
    loadCurrentUser();
    configRabbitMQ();
  }

  @action
  void addOrder(OrderData orderData){
    this.order = orderData;
    if(orderData != null) {
      this.user.idOrder = orderData.id;
      if(this.user.status == StatusDelivery.AVAILABLE.index || this.user.status == null) {
        this.user.status = StatusDelivery.PENDING.index;
      }
    }
  }

  @action
  void setLoading(bool loading){
    this.isLoading = loading;
  }

  @action
  void setUser(UserEntity user){
    this.user = user;
  }

  @action
  void setStatisticUser(StatisticData statisticData){
    this.statistic = statisticData;
  }

  @action
  void setLastOnResumeCall(int last){
    this.lastOnResumeCall = last;
  }

  @action
  void setAcceptedOrdersToday(){
    this.statistic.acceptedOrdersToday += 1;
    this.order.idDeliveryMan = user.idDeliveryMan;
    this.user.status = StatusDelivery.DELIVERY.index;
  }

  @action
  void setRejectedOrdersToday(){
    this.statistic.rejectedOrdersToday += 1;
    this.user.idOrder = null;
    this.order = null;
    this.user.status = StatusDelivery.AVAILABLE.index;
  }

  @action
  void setDeliveredOrdersToday(){
    this.statistic.amountToday += order.commissionDelivery;
    this.statistic.deliveredOrdersToday += 1;
    this.user.idOrder = null;
    this.order = null;
    this.user.status = StatusDelivery.AVAILABLE.index;
  }

  bool isLoggedIn() {
    return user != null;
  }

  @action
  Future<Null> loadCurrentUser() async {
    this.isLoading = true;
    if(this.user == null) {
      DeliveryManController _controller = new DeliveryManController();
      this.user = await _controller.load();
      if (this.user != null) {
        configListeners();
        await _getData();
      }
    }
    this.isLoading = false;
  }

  configListeners() {
    String topic = "???" + this.user.idDeliveryMan;
    fbMessaging.subscribeToTopic(topic);
    fbMessaging.unsubscribeFromTopic(this.user.idDeliveryMan);
    fbMessaging.requestNotificationPermissions(
      const IosNotificationSettings(sound: true, badge: true, alert: true),
    );
  }

  _getData() async{
    OrderController _controller = new OrderController();
    if(this.user.idOrder != null) {
      this.order = await _controller.getById(this.user.idOrder);
    }
    this.statistic = await _controller.getStatisticDay(this.user.idDeliveryMan);
  }

  listenNotifications(VoidCallback execute) async{
    fbMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        if ((DateTime.now().microsecondsSinceEpoch - lastOnResumeCall) >
            1000000) {
          lastOnResumeCall = DateTime.now().microsecondsSinceEpoch;
          execute();
        }
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        // TODO optional
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        // TODO optional
      },
    );
  }

  void configRabbitMQ() async{
    RabbitMQConfig rabbitMQConfig = new RabbitMQConfig();
    try {
      ConnectionSettings settingsRabbitMQ = await rabbitMQConfig.connect();
      connectionRabbit = new Client(settings: settingsRabbitMQ);
    } on ConnectionFailedException catch(e){
      print(e.message);
    } catch(e){
      print(e.toString());
    }
  }

}