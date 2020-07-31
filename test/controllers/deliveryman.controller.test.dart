import 'package:aqui_tem_deliveryman/components/connect.component.dart';
import 'package:aqui_tem_deliveryman/components/rabbitmq.component.dart';
import 'package:aqui_tem_deliveryman/constants/error.message.constants.dart';
import 'package:aqui_tem_deliveryman/controllers/deliveryman.controller.dart';
import 'package:aqui_tem_deliveryman/models/entities/order.entities.dart';
import 'package:aqui_tem_deliveryman/models/entities/user.entities.dart';
import 'package:aqui_tem_deliveryman/models/response/validate.response.dart';
import 'package:aqui_tem_deliveryman/repositories/deliveryman.repository.dart';
import 'package:aqui_tem_deliveryman/repositories/deliveryman.repository.interface.dart';
import 'package:aqui_tem_deliveryman/repositories/order.repository.dart';
import 'package:aqui_tem_deliveryman/repositories/order.repository.interface.dart';
import 'package:aqui_tem_deliveryman/stores/user.store.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';


class DeliveryManRepositoryMock extends Mock implements DeliveryManRepository  {}
class RabbitMQComponentMock extends Mock implements RabbitMQComponent  {}
class OrderRepositoryMock extends Mock implements OrderRepository  {}
class MockConnect extends Mock implements ConnectComponent  {}
class MockUserStore extends Mock implements UserStore  {}

void main(){
  DeliveryManController controller;
  ConnectComponent connect;
  IDeliveryManRepository repository;
  IOrderRepository orderRepository;
  RabbitMQComponent rabbitMQComponent;
  MockUserStore userStore;

  setUp(() {
    repository = DeliveryManRepositoryMock();
    orderRepository = OrderRepositoryMock();
    rabbitMQComponent = RabbitMQComponentMock();
    connect = MockConnect();
    controller = DeliveryManController.tests(repository, orderRepository, rabbitMQComponent, connect);
    userStore = MockUserStore();
  });

  group('Delivery tests', ()
  {
    test("Test load", () async {
      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(true));

      UserEntity userEntity = new UserEntity();
      when(repository.load()).thenAnswer((_) async =>
          Future.value(userEntity));

      UserEntity response = await controller.load();
      expect(response != null, true);
    });

    test("Test load - null", () async {
      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(true));

      when(repository.load()).thenAnswer((_) async =>
          Future.value(null));

      UserEntity response = await controller.load();
      expect(response == null, true);
    });


    test("Teste de falha de conexão", () async {
      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(false));

      UserEntity response = await controller.load();
      expect(response == null, true);
    });
  });

  group('Completed Delivery tests', ()
  {
    test("Completed Delivery", () async {
      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(true));

      when(userStore.setDeliveredOrdersToday()).thenAnswer((_) => null);

      when(repository.update(userStore)).thenAnswer((_) async =>
          Future.value(null));

      ValidateResponse response = await controller.completedDelivery(userStore);
      expect(response != null, true);
      expect(response.success, true);
    });

    test("Teste de falha de conexão", () async {
      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(false));
      ValidateResponse response = await controller.completedDelivery(userStore);
      expect(false, response.success);
    });
  });

  group('acceptOrder Delivery tests', ()
  {
    test("acceptOrder Delivery", () async {
      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(true));

      UserEntity userEntity = new UserEntity();
      userEntity.idOrder = "1l";
      userEntity.idDeliveryMan = "2l";

      OrderData orderData = new OrderData();
      orderData.idEstablishment = "3l";
      orderData.orderCode = 10;
      orderData.id = "10l";

      when(userStore.user).thenAnswer((_) => userEntity);
      when(userStore.order).thenAnswer((_) => new OrderData());

      when(repository.verifyDeliveryOrder(any, any)).thenAnswer((_) => Future.value(true));

      when(rabbitMQComponent.sendMessage(any, any, any)).thenAnswer((_) => Future.value(null));

      when(userStore.setAcceptedOrdersToday()).thenAnswer((_) => null);

      when(repository.acceptOrder(userStore)).thenAnswer((_) async =>
          Future.value(null));

      ValidateResponse response = await controller.acceptOrder(userStore);
      expect(response != null, true);
      expect(response.success, true);
    });

    test("acceptOrder Delivery - fail verify", () async {
      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(true));

      UserEntity userEntity = new UserEntity();
      userEntity.idOrder = "1l";
      userEntity.idDeliveryMan = "2l";

      OrderData orderData = new OrderData();
      orderData.idEstablishment = "3l";
      orderData.orderCode = 10;
      orderData.id = "10l";

      when(userStore.user).thenAnswer((_) => userEntity);
      when(userStore.order).thenAnswer((_) => new OrderData());

      when(repository.verifyDeliveryOrder(any, any)).thenAnswer((_) => Future.value(false));

      when(userStore.setRejectedOrdersToday()).thenAnswer((_) => null);

      when(repository.update(userStore)).thenAnswer((_) async =>
          Future.value(null));

      ValidateResponse response = await controller.acceptOrder(userStore);
      expect(response != null, true);
      expect(response.success, false);
      expect(response.message,  ErrorMessages.ORDER_NOT_FOUND);
    });

    test("Teste de falha de conexão", () async {
      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(false));
      ValidateResponse response = await controller.completedDelivery(userStore);
      expect(false, response.success);
    });
  });



  group('rejectOrder Delivery tests', ()
  {
    test("rejectOrder Delivery ", () async {
      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(true));

      UserEntity userEntity = new UserEntity();
      userEntity.idOrder = "1l";
      userEntity.idDeliveryMan = "2l";

      OrderData orderData = new OrderData();
      orderData.idEstablishment = "3l";
      orderData.orderCode = 10;
      orderData.id = "10l";

      when(userStore.user).thenAnswer((_) => userEntity);
      when(userStore.order).thenAnswer((_) => new OrderData());

      when(rabbitMQComponent.sendMessage(any, any, any)).thenAnswer((_) => Future.value(null));

      when(userStore.setRejectedOrdersToday()).thenAnswer((_) => null);

      when(repository.update(userStore)).thenAnswer((_) async =>
          Future.value(null));

      ValidateResponse response = await controller.rejectOrder(userStore, true);
      expect(response != null, true);
      expect(response.success, true);
    });

    test("Teste de falha de conexão", () async {
      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(false));
      ValidateResponse response = await controller.completedDelivery(userStore);
      expect(false, response.success);
    });
  });
}