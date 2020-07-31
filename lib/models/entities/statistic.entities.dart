
import 'package:cloud_firestore/cloud_firestore.dart';

class StatisticData {
  Timestamp today;
  double amountToday = 0.00;
  int deliveredOrdersToday = 0;
  int acceptedOrdersToday = 0;
  int rejectedOrdersToday = 0;


  setStatistic(Map data){
    this.today = data["today"];
    this.deliveredOrdersToday = data["deliveredOrdersToday"];
    this.acceptedOrdersToday = data["acceptedOrdersToday"];
    this.rejectedOrdersToday = data["rejectedOrdersToday"];
    this.amountToday = data["amountToday"] == null ? 0.00 : data["amountToday"];
  }

  Map<String, dynamic> toMap() {
    return {
      "deliveredOrdersToday": this.deliveredOrdersToday,
      "acceptedOrdersToday": this.acceptedOrdersToday,
      "rejectedOrdersToday": this.rejectedOrdersToday,
      "today": Timestamp.now(),
      "amountToday": amountToday,
    };
  }
}