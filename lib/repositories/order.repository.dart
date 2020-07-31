
import 'package:aqui_tem_deliveryman/models/entities/order.entities.dart';
import 'package:aqui_tem_deliveryman/models/entities/statistic.entities.dart';
import 'package:aqui_tem_deliveryman/enums/status.order.enum.dart';
import 'package:aqui_tem_deliveryman/repositories/order.repository.interface.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderRepository implements IOrderRepository {

  @override
  Future<OrderData> getOrderCode(int id) async {
    OrderData order;

    QuerySnapshot snapshot = await Firestore.instance.collection("???").where("???", isEqualTo: id).getDocuments();
    if(snapshot.documents.length == 1) {
      order = OrderData.fromDocument(snapshot.documents[0]);
      DocumentSnapshot docUser = await Firestore.instance
          .collection("???")
          .document(order.clientId)
          .get();
      order.setClient(docUser);

      DocumentSnapshot docEstab = await Firestore.instance
          .collection("???")
          .document(order.idEstablishment)
          .get();
      order.setEstablishment(docEstab);
    }

    return order;
  }

  @override
  Future<OrderData> getById(String id) async {
    OrderData order;

    DocumentSnapshot doc = await Firestore.instance.collection("???").document(id).get();
    if(doc.data != null) {
      order = OrderData.fromDocument(doc);
      DocumentSnapshot docUser = await Firestore.instance
          .collection("???")
          .document(order.clientId)
          .get();
      order.setClient(docUser);

      DocumentSnapshot docEstab = await Firestore.instance
          .collection("???")
          .document(order.idEstablishment)
          .get();
      order.setEstablishment(docEstab);
    }

    return order;
  }

  @override
  Future<List<OrderData>> getAll(String id) async {
    List<OrderData> dataList = [];

    QuerySnapshot snapshot = await Firestore.instance.collection("???")
        .where("???", isEqualTo: id)
        .where("???", isEqualTo: StatusOrder.CONCLUDED.index)
        .getDocuments();

    OrderData order;
    for (DocumentSnapshot doc in snapshot.documents) {
      order = OrderData.fromDocument(doc);
      DocumentSnapshot docUser = await Firestore.instance
          .collection("???")
          .document(order.clientId)
          .get();
      order.setClient(docUser);

      dataList.add(order);
    }

    dataList.sort((a, b) => b.orderCode.compareTo(a.orderCode));

    return dataList;
  }

  @override
  Future<Null> update(OrderData orderData) async {
    await Firestore.instance
        .collection("???")
        .document(orderData.id)
        .updateData(orderData.toMap());
  }


  @override
  Future<OrderData> searchOrder(String idDeliveryMan) async {
    DocumentSnapshot docUser = await Firestore.instance
        .collection("???")
        .document(idDeliveryMan)
        .get();
    return await getById(docUser["???"]);
  }

  @override
  Future<StatisticData> getStatisticDay(String idDeliveryMan) async {
    StatisticData statisticData = new StatisticData();

    DocumentSnapshot docUser = await Firestore.instance
        .collection("???")
        .document(idDeliveryMan)
        .get();

    if(docUser.data["???"] != null){
      statisticData.setStatistic(docUser.data["???"]);
      if ((statisticData.today.toDate().day == Timestamp.now().toDate().day) && (statisticData.today.toDate().month == Timestamp.now().toDate().month)
          && (statisticData.today.toDate().year == Timestamp.now().toDate().year)){
        return statisticData;
      } else {
        return new StatisticData();
      }
    }

    return statisticData;
  }


}