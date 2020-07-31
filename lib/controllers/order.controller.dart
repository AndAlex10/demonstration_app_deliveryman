
import 'package:aqui_tem_deliveryman/components/connect.component.dart';
import 'package:aqui_tem_deliveryman/models/entities/order.entities.dart';
import 'package:aqui_tem_deliveryman/models/entities/order.filters.entities.dart';
import 'package:aqui_tem_deliveryman/models/entities/statistic.entities.dart';
import 'package:aqui_tem_deliveryman/models/response/validate.response.dart';
import 'package:aqui_tem_deliveryman/repositories/notification.repository.interface.dart';
import 'package:aqui_tem_deliveryman/repositories/order.repository.interface.dart';
import 'package:aqui_tem_deliveryman/stores/user.store.dart';
import 'package:aqui_tem_deliveryman/view_model/order.view.model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:aqui_tem_deliveryman/enums/status.order.enum.dart';
import 'package:aqui_tem_deliveryman/repositories/notification.repository.dart';
import 'package:aqui_tem_deliveryman/repositories/order.repository.dart';

class OrderController {
  IOrderRepository repository;
  INotificationRepository notificationRepository;
  ConnectComponent connect;

  OrderController(){
    repository = new OrderRepository();
    notificationRepository = new NotificationRepository();
    connect = new ConnectComponent();
  }

  OrderController.tests(this.repository, this.notificationRepository, this.connect);

  Future<OrderViewModel> getAll(String id) async {
    OrderViewModel viewModel = new OrderViewModel();
    viewModel.checkConnect = await connect.checkConnect();
    if(viewModel.checkConnect) {
      viewModel.list = await repository.getAll(id);
    }
    return viewModel;
  }

  Future<List<OrderData>> getFilters(OrderFilters filters) async {
    filters.setTags();
    List<OrderData> list = filters.ordersAll;

    if(filters.activeDate){
      list = list.where((i) =>
      DateTime(i.dateCreate.toDate().year, i.dateCreate.toDate().month, i.dateCreate.toDate().day).difference(filters.startDate.toDate()).inDays >= 0 //&&
          && DateTime(i.dateCreate.toDate().year, i.dateCreate.toDate().month, i.dateCreate.toDate().day).difference(filters.endDate.toDate()).inDays <= 0
      ).toList();
    }

    list.sort((a, b) => b.orderCode.compareTo(a.orderCode));

    return list;
  }

  Future<OrderData> getById(String id) async {
    OrderData orderData;
    orderData = await repository.getById(id);

    return orderData;
  }

  Future<ValidateResponse> updateStatus(OrderData orderData, StatusOrder status) async {
    ValidateResponse response = new ValidateResponse();
    if(await connect.checkConnect()) {
      orderData.status = status.index;
      _updateHistoric(orderData, status);
      await repository.update(orderData);

      String idTopic = StatusOrderText.getIdTopic(
          status, orderData.clientId, orderData.idEstablishment);

      await notificationRepository.create(idTopic,
          StatusOrderText.getTitleNotify(
              status, orderData.orderCode.toString()),
          StatusOrderText.getSubjectNotify(status));

      response.success = true;
    } else {
      response.failConnect();
    }

    return response;
  }

  void _updateHistoric(OrderData orderData, StatusOrder status){
    orderData.dateUpdate = Timestamp.now();
    DateTime dateUpdate = orderData.dateUpdate.toDate();
    String dateText = DateFormat('dd/MM/yyyy HH:mm a').format(dateUpdate);

    orderData.historic.add(StatusOrderText.getTitle(status).toLowerCase() + " as " + dateText);
    orderData.setHistoricText();
  }

  Future<bool> searchOrder(UserStore userStore) async{
      if (await connect.checkConnect()) {
        OrderData orderData = await repository.searchOrder(
            userStore.user.idDeliveryMan);
        userStore.addOrder(orderData);
        if (orderData != null) {
          return true;
        }
      }
    return false;
  }

  Future<ValidateResponse> refreshData(UserStore userStore) async {
    ValidateResponse response = new ValidateResponse();
    if(userStore.isLoggedIn()) {
      userStore.setLoading(true);
      if (await connect.checkConnect()) {
        await searchOrder(userStore);
        StatisticData statisticData = await getStatisticDay(
            userStore.user.idDeliveryMan);
        userStore.setStatisticUser(statisticData);
        response.success = true;
      } else {
        response.failConnect();
      }
      userStore.setLoading(false);
    } else {
      response.message = "Faça o login.";
    }
    return response;
  }

  Future<StatisticData> getStatisticDay(String idDeliveryMan) async{
    return await repository.getStatisticDay(idDeliveryMan);
  }

}