import 'package:aqui_tem_deliveryman/models/entities/user.entities.dart';
import 'package:aqui_tem_deliveryman/repositories/deliveryman.repository.interface.dart';
import 'package:aqui_tem_deliveryman/stores/user.store.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DeliveryManRepository implements IDeliveryManRepository {

  @override
  Future<UserEntity> load() async {
    UserEntity deliveryMan;
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser fbUser;

    if (fbUser == null) fbUser = await auth.currentUser();
    if (fbUser != null) {
      DocumentSnapshot docUser = await Firestore.instance
          .collection("???")
          .document(fbUser.uid)
          .get();

      if(docUser.data != null) {
        deliveryMan = UserEntity.fromMap(docUser.documentID, docUser.data);
      }
    }

    return deliveryMan;
  }

  @override
  Future<Null> update(UserStore store) async {
    store.user.statisticData = store.statistic;
    if (store.user.idDeliveryMan != null) {
      await Firestore.instance
          .collection("???")
          .document(store.user.idDeliveryMan)
          .updateData(store.user.toMap());
    }
  }

  @override
  Future<Null> acceptOrder(UserStore store) async{
    if (store.user.idDeliveryMan != null) {
      await update(store);
      await Firestore.instance
          .collection("???")
          .document(store.user.idOrder)
          .updateData({"???": store.user.idDeliveryMan});
    }
  }

  @override
  Future<Null> startFinishWork(UserEntity userEntity) async {
    if (userEntity.idDeliveryMan != null) {
      if (userEntity.online) {
        userEntity.online = false;
      } else {
        userEntity.online = true;
      }

      await Firestore.instance
          .collection("???")
          .document(userEntity.idDeliveryMan)
          .updateData({"???": userEntity.online});
    }
  }

  @override
  Future<bool> verifyDeliveryOrder(String idDeliveryMan, String idOrder) async {
    DocumentSnapshot doc = await Firestore.instance.collection("???").document(idDeliveryMan).get();
    if(doc.data != null) {
      if(doc.data["???"] == idOrder) {
        return true;
      }
    }

    return false;
  }



}
