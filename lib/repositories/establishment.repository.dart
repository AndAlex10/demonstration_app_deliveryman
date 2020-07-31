
import 'package:aqui_tem_deliveryman/models/entities/establishment.entities.dart';
import 'package:aqui_tem_deliveryman/repositories/establishment.repository.interface.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EstablishmentRepository implements IEstablishmentRepository {

  @override
  Future<EstablishmentData> getId(String idEstablishment) async{
    DocumentSnapshot establishmentDoc = await Firestore.instance.collection("???").document(idEstablishment).get();
    EstablishmentData establishmentData = EstablishmentData.fromDocument(establishmentDoc);
    return establishmentData;
  }

  @override
  Future<List<EstablishmentData>> getAll(String idSegment, String idCategory, String city, String state) async {
    List<EstablishmentData> list = [];
    QuerySnapshot snapshot;

    if (idCategory == "") {
      snapshot = await Firestore.instance
          .collection("???")
          .where("???", isEqualTo: idSegment)
          .where("???", isEqualTo: city)
          .where("???", isEqualTo: state)
          .getDocuments();
    } else {
      snapshot = await Firestore.instance
          .collection("???")
          .where("???", isEqualTo: idSegment)
          .where("???", isEqualTo: idCategory)
          .where("???", isEqualTo: city)
          .where("???", isEqualTo: state)
          .getDocuments();
    }

    for (DocumentSnapshot doc in snapshot.documents) {
      EstablishmentData establishmentData = EstablishmentData.fromDocument(doc);

      list.add(establishmentData);
    }

    list.sort((a, b) => b.rating.compareTo(a.rating));
    return list;
  }

}