
import 'package:aqui_tem_deliveryman/models/entities/order.entities.dart';
import 'package:aqui_tem_deliveryman/models/entities/statistic.entities.dart';

abstract class IOrderRepository {

  Future<OrderData> getOrderCode(int id);

  Future<OrderData> getById(String id);

  Future<List<OrderData>> getAll(String id);

  Future<Null> update(OrderData orderData);

  Future<OrderData> searchOrder(String idDeliveryMan);

  Future<StatisticData> getStatisticDay(String idDeliveryMan);
}