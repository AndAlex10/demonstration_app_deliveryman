import 'package:aqui_tem_deliveryman/components/rabbitmq.component.dart';
import 'package:aqui_tem_deliveryman/constants/error.message.constants.dart';
import 'package:aqui_tem_deliveryman/constants/order.actions.execute.constants.dart';
import 'package:aqui_tem_deliveryman/models/entities/order.entities.dart';
import 'package:aqui_tem_deliveryman/models/entities/user.entities.dart';
import 'package:aqui_tem_deliveryman/models/request/order.request.dart';
import 'package:aqui_tem_deliveryman/models/response/validate.response.dart';
import 'package:aqui_tem_deliveryman/repositories/deliveryman.repository.dart';
import 'package:aqui_tem_deliveryman/repositories/deliveryman.repository.interface.dart';
import 'package:aqui_tem_deliveryman/repositories/order.repository.dart';
import 'package:aqui_tem_deliveryman/repositories/order.repository.interface.dart';
import 'package:aqui_tem_deliveryman/components/connect.component.dart';
import 'package:aqui_tem_deliveryman/stores/user.store.dart';
import 'package:dart_amqp/dart_amqp.dart';

class DeliveryManController {
  IDeliveryManRepository repository;
  IOrderRepository orderRepository;
  ConnectComponent connect;
  RabbitMQComponent rabbitMQComponent;

  DeliveryManController() {
    repository = new DeliveryManRepository();
    orderRepository = new OrderRepository();
    connect = new ConnectComponent();
    rabbitMQComponent = new RabbitMQComponent();
  }

  DeliveryManController.tests(this.repository, this.orderRepository, this.rabbitMQComponent, this.connect);

  Future<UserEntity> load() async {
    UserEntity userEntity;
    if (await connect.checkConnect()) {
      userEntity = await repository.load();
    }

    return userEntity;
  }

  Future<Null> startFinishWork(UserEntity userEntity) async {
    if (await connect.checkConnect()) {
      await repository.startFinishWork(userEntity);
    }
  }

  Future<ValidateResponse> completedDelivery(UserStore store) async {
    ValidateResponse response = new ValidateResponse();
    if (await connect.checkConnect()) {
      store.setDeliveredOrdersToday();
      await repository.update(store);

      response.success = true;
    } else {
      response.failConnect();
    }

    return response;
  }

  Future<ValidateResponse> acceptOrder(UserStore store) async {
    ValidateResponse response = new ValidateResponse();
    if (await connect.checkConnect()) {
      await repository
          .verifyDeliveryOrder(store.user.idDeliveryMan, store.user.idOrder)
          .then((result) async {
        if (result) {
          await _sendOrderQueue(store.connectionRabbit, store.user.idDeliveryMan, store.order, ActionOrder.ORDER_ACCEPT_DELIVERYMAN);
          store.setAcceptedOrdersToday();
          await repository.acceptOrder(store);
          response.success = true;
        } else {
          await rejectOrder(store, false);
          response.message = ErrorMessages.ORDER_NOT_FOUND;
        }
      });
    } else {
      response.message = ErrorMessages.CONNECT_INTERNET;
    }
    return response;
  }

  Future<ValidateResponse> rejectOrder(UserStore store, bool notify) async {
    ValidateResponse response = new ValidateResponse();
    if (await connect.checkConnect()) {
      if(notify) {
        await _sendOrderQueue(
            store.connectionRabbit, store.user.idDeliveryMan, store.order,
            ActionOrder.ORDER_REJECTED_DELIVERYMAN);
      }
      store.setRejectedOrdersToday();
      await repository.update(store);

      response.success = true;
    } else {
      response.message = ErrorMessages.CONNECT_INTERNET;
    }
    return response;
  }

  Future<Null> _sendOrderQueue(Client connectionRabbit, String idDeliveryMan, OrderData orderData, String action) async{
    OrderRequest orderRequest = new OrderRequest.from(orderData.id, orderData.orderCode.toString(), orderData.idEstablishment, action, idDeliveryMan);
    await rabbitMQComponent.sendMessage(connectionRabbit, "orders", orderRequest.toMap().toString());
  }

}
