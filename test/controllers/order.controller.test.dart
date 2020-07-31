import 'package:aqui_tem_deliveryman/models/entities/statistic.entities.dart';
import 'package:aqui_tem_deliveryman/models/entities/user.entities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:aqui_tem_deliveryman/components/connect.component.dart';
import 'package:aqui_tem_deliveryman/controllers/order.controller.dart';
import 'package:aqui_tem_deliveryman/enums/status.order.enum.dart';
import 'package:aqui_tem_deliveryman/models/entities/order.entities.dart';
import 'package:aqui_tem_deliveryman/models/response/validate.response.dart';
import 'package:aqui_tem_deliveryman/repositories/notification.repository.dart';
import 'package:aqui_tem_deliveryman/repositories/order.repository.dart';
import 'package:aqui_tem_deliveryman/stores/user.store.dart';
import 'package:aqui_tem_deliveryman/view_model/order.view.model.dart';

class MockOrderRepository extends Mock implements OrderRepository  {}
class MockNotificationRepository extends Mock implements NotificationRepository  {}
class MockConnect extends Mock implements ConnectComponent  {}
class MockAppStore extends Mock implements UserStore  {}

void main(){
  OrderController controller;
  MockOrderRepository orderRepository;
  MockNotificationRepository notificationRepository;
  MockConnect connect;
  MockAppStore appStore;

  setUp(() {
    appStore = MockAppStore();
    orderRepository = MockOrderRepository();
    notificationRepository = MockNotificationRepository();
    connect = MockConnect();
    appStore = MockAppStore();
    controller = OrderController.tests(orderRepository, notificationRepository, connect);
  });



  group('Listagem de pedidos', ()
  {

    test("Teste de listagem dos pedidos", () async {
      List<OrderData> listMock = [];
      OrderData orderData = OrderData();
      listMock.add(orderData);

      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(true));

      when(orderRepository.getAll("1")).thenAnswer((_) async =>
          Future.value(listMock));
      OrderViewModel viewModel = await controller.getAll("1");
      expect(viewModel.list.length, listMock.length);
    });


    test("Teste de falha de conexão", () async {
      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(false));

      OrderViewModel viewModel = await controller.getAll("1");
      expect([], viewModel.list);
      expect(false, viewModel.checkConnect);
    });
  });

  group('Atualização de status', ()
  {
    OrderData mockOrder(){
      OrderData orderData = new OrderData();
      orderData.dateUpdate = Timestamp.now();
      orderData.idEstablishment = "2L";
      orderData.historic = [];
      orderData.clientId = "1A";
      orderData.orderCode = 1;

      return orderData;
    }
    test("Teste de atualização de status", () async {
      OrderData data = mockOrder();

      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(true));

      when(orderRepository.update(data)).thenAnswer((_) async =>
          Future.value(null));


      when(notificationRepository.create(any, any, any)).thenAnswer((_) async =>
          Future.value());

      ValidateResponse response = await controller.updateStatus(data, StatusOrder.CONCLUDED);
      expect(response.success, true);
      expect(data.status, StatusOrder.CONCLUDED.index);
      expect(data.historic.length, 1);
      expect(data.historicText != "", true);
    });


    test("Teste de falha de conexão", () async {
      OrderData data = mockOrder();
      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(false));

      ValidateResponse response =  await controller.updateStatus(data, StatusOrder.CONCLUDED);
      expect(false, response.success);
    });
  });


  group('searchOrder', ()
  {
    OrderData mockOrder(){
      OrderData orderData = new OrderData();
      orderData.dateUpdate = Timestamp.now();
      orderData.idEstablishment = "2L";
      orderData.historic = [];
      orderData.clientId = "1A";
      orderData.orderCode = 1;

      return orderData;
    }
    test("searchOrder", () async {
      OrderData data = mockOrder();

      UserEntity userEntity = new UserEntity();
      userEntity.idDeliveryMan = "1L";
      when(appStore.user).thenAnswer((_) => userEntity);

      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(true));

      when(orderRepository.searchOrder(any)).thenAnswer((_) async =>
          Future.value(data));

      bool response = await controller.searchOrder(appStore);
      expect(response, true);
    });

    test("searchOrder - not found", () async {

      UserEntity userEntity = new UserEntity();
      userEntity.idDeliveryMan = "1L";
      when(appStore.user).thenAnswer((_) => userEntity);

      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(true));

      when(orderRepository.searchOrder(any)).thenAnswer((_) async =>
          Future.value(null));

      bool response = await controller.searchOrder(appStore);
      expect(response, false);
    });


    test("Teste de falha de conexão", () async {
      UserEntity userEntity = new UserEntity();
      userEntity.idDeliveryMan = "1L";
      when(appStore.user).thenAnswer((_) => userEntity);

      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(false));

      bool response =  await controller.searchOrder(appStore);
      expect(false, response);
    });
  });

  group('getStatisticDay', ()
  {
    test("getStatisticDay", () async {

      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(true));

      StatisticData data = new StatisticData();
      when(orderRepository.getStatisticDay(any)).thenAnswer((_) async =>
          Future.value(data));

      StatisticData response = await controller.getStatisticDay("1l");
      expect(response != null, true);
    });

  });


  group('refreshData', ()
  {
    OrderData mockOrder(){
      OrderData orderData = new OrderData();
      orderData.dateUpdate = Timestamp.now();
      orderData.idEstablishment = "2L";
      orderData.historic = [];
      orderData.clientId = "1A";
      orderData.orderCode = 1;

      return orderData;
    }
    test("refreshData", () async {
      OrderData orderData = mockOrder();

      when(appStore.isLoggedIn()).thenAnswer((_) => true);
      UserEntity userEntity = new UserEntity();
      userEntity.idDeliveryMan = "1L";
      when(appStore.user).thenAnswer((_) => userEntity);

      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(true));

      when(orderRepository.searchOrder(any)).thenAnswer((_) async =>
          Future.value(orderData));

      StatisticData statisticData = new StatisticData();
      when(orderRepository.getStatisticDay(any)).thenAnswer((_) async =>
          Future.value(statisticData));

      ValidateResponse response = await controller.refreshData(appStore);
      expect(response != null, true);
      expect(response.success, true);

    });

    test("refreshData - login out", () async {

      when(appStore.isLoggedIn()).thenAnswer((_) => false);

      ValidateResponse response = await controller.refreshData(appStore);
      expect(response != null, true);
      expect(response.success, false);

    });

    test("refreshData - falha internet", () async {

      when(appStore.isLoggedIn()).thenAnswer((_) => true);
      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(false));
      ValidateResponse response = await controller.refreshData(appStore);

      expect(false, response.success);

    });

  });


}