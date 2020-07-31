
import 'package:cloud_firestore/cloud_firestore.dart';

class SegmentData {
  String id;
  String name;
  String icon;
  String image;
  int order;

  SegmentData.fromDocument(DocumentSnapshot document){
    id = document.documentID;
    name = document.data['name'];
    order = document.data['order'];
    icon = document.data['icon'];
    image = document.data['imgUrl'];
  }
}