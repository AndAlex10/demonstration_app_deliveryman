import 'package:aqui_tem_deliveryman/models/entities/establishment.entities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:aqui_tem_deliveryman/models/entities/payment.order.entities.dart';

class OrderData {

  String id;
  int orderCode;
  String idEstablishment;
  String clientId;
  Timestamp dateCreate;
  Timestamp dateUpdate;
  int status;
  bool goGet;
  String address;
  String number;
  String neighborhood;
  String complement;
  String city;
  String state;
  String phone;
  String codePostal;
  String longitude;
  String latitude;
  String reason;
  String reasonBy;
  double amount;
  double productsPrice;
  double shipPrice;
  double discount;
  double change;
  PaymentOrder payment;
  String idDeliveryMan;
  List<Items> items = [];
  List historic = [];
  String historicText;
  String nameClient;
  double commissionDelivery = 0.0;
  double rating;

  EstablishmentData establishmentData;

  OrderData();

  OrderData.fromDocument(DocumentSnapshot snapshot){
    id = snapshot.documentID;
    orderCode = snapshot.data['orderCode'];
    idEstablishment = snapshot.data['idEstablishment'];
    clientId = snapshot.data['clientId'];
    dateCreate = snapshot.data['dateCreate'];
    dateUpdate = snapshot.data['dateUpdate'];
    goGet = snapshot.data['goGet'];
    status = snapshot.data['status'];
    address = snapshot.data['address'];
    number = snapshot.data['number'];
    neighborhood = snapshot.data['neighborhood'];
    complement = snapshot.data['complement'];
    city = snapshot.data['city'];
    state = snapshot.data['state'];
    phone = snapshot.data['phone'];
    codePostal = snapshot.data['codePostal'];
    longitude = snapshot.data['longitude'];
    latitude = snapshot.data['latitude'];
    reason = snapshot.data['reason'];
    reasonBy = snapshot.data['reasonBy'];
    rating = snapshot.data['rating'];
    if(reason == null) {
      reason = "";
    }

    if(reasonBy == null) {
      reasonBy = "";
    }
    amount = double.parse(snapshot.data['amount'].toString());
    productsPrice = double.parse(snapshot.data['productsPrice'].toString());
    shipPrice = double.parse(snapshot.data['shipPrice'].toString());
    discount = double.parse(snapshot.data['discount'].toString());
    change = double.parse(snapshot.data['change'].toString());
    idDeliveryMan = snapshot.data['idDeliveryMan'];
    commissionDelivery = snapshot.data['commissionDelivery'];

    if(commissionDelivery == null){
      commissionDelivery = 0.00;
    }
    payment = PaymentOrder.fromMap(snapshot.data['payment']);
    historicText = "";
    if(snapshot.data['historic'] != null) {
      List list = snapshot.data['historic'];
      for(int i = 0; i < list.length; i++){
        historicText += "${list[i]} \n";
        historic.add(list[i]);
      }
    }


    for (var i = 0; i < snapshot.data["products"].length; i++) {
      Items item = Items.fromDocument(snapshot.data["products"][i]);
      items.add(item);
    }

  }

  void setHistoricText(){
    historicText = "";
    for(int i = 0; i < historic.length; i++){
      historicText += "${historic[i]} \n";
    }
  }

  void setClient(DocumentSnapshot document){
    nameClient = document.data['name'];
    phone = document.data['phone'];
  }

  void setEstablishment(DocumentSnapshot document){
    establishmentData = EstablishmentData.fromDocument(document);
  }

  Map<String, dynamic> toMap(){
    return {
      "dateUpdate": dateUpdate,
      "idDeliveryMan": idDeliveryMan,
      "historic": historic,
      "status": status
    };
  }


}

class Items {
  String title;
  int quantity;
  double price;
  double amount;
  String obs;
  List<Additional> additionalList = [];

  Items();
  Items.fromDocument(Map document) {
    title = document['product']['title'];
    quantity = document['quantity'];
    price = double.parse(document['product']['price'].toString());
    amount = price;
    obs = document['obs'];

    if (document["additional"] != null) {
      for (var i = 0; i < document["additional"].length; i++) {
        Additional additional = Additional.fromDocument(document["additional"][i]);
        amount += additional.price;
        additionalList.add(additional);
      }
    }
    amount = amount * quantity;
  }
}

class Additional {
  String title;
  double price;

  Additional();

  Additional.fromDocument(Map document) {
    title = document['title'];
    price = double.parse(document['price'].toString());
  }
}