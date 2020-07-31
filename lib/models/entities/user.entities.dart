import 'package:aqui_tem_deliveryman/models/entities/statistic.entities.dart';

class UserEntity {
  String name;
  String city;
  String state;
  String idDeliveryMan;
  String idOrder;
  int status;
  bool online;
  int loginType;

  StatisticData statisticData;

  UserEntity();

  UserEntity.fromMap(String idDeliveryMan, Map data) {
    this.idDeliveryMan = idDeliveryMan;
    this.name = data["name"];
    this.city = data["city"];
    this.state = data["state"];
    this.status = data["status"];
    this.online = data["online"];
    this.idOrder = data["idOrder"];
    this.loginType = data["loginType"];

    statisticData = new StatisticData();
    if(data["statistic"] != null) {
      statisticData.setStatistic(data["statistic"]);
    }
  }

  Map<String, dynamic> toMap() {
    return {
      "idOrder": this.idOrder,
      "status": this.status,
      "online": this.online,
      "loginType": this.loginType,
      "statistic": statisticData.toMap()
    };
  }
}
