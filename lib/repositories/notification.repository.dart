
import 'package:aqui_tem_deliveryman/repositories/notification.repository.interface.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationRepository implements INotificationRepository {

  @override
  Future<Null> create(String idTopic, String title, String subject)async{
    await Firestore.instance.collection("???").add(
        {
          "???": title,
          "???": subject,
          "???": idTopic,
        }
    );
  }
}