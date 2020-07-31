import 'package:cloud_firestore/cloud_firestore.dart';

class EstablishmentData {
  String id;
  String name;
  String address;
  String number;
  String neighborhood;
  String complement;
  String city;
  String state;
  String phone;
  String cnpj;
  String codePostal;
  String instagram;
  String longitude;
  String latitude;
  String type;
  double rating;
  bool open;
  int sequence;
  String feeDelivery;
  bool fee = false;
  String imgUrl;

  EstablishmentData();

  EstablishmentData.fromDocument(DocumentSnapshot document){
    id = document.documentID;
    name = document.data['name'];
    address = document.data['address'];
    number = document.data['number'];
    neighborhood = document.data['neighborhood'];
    complement = document.data['complement'];
    city = document.data['city'];
    state = document.data['state'];
    phone = document.data['phone'];
    cnpj = document.data['cnpj'];
    codePostal = document.data['codePostal'];
    instagram = document.data['instagram'];
    longitude = document.data['longitude'];
    latitude = document.data['latitude'];
    open = document.data['open'];
    imgUrl = document.data['imgUrl'];
  }


}
