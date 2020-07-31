
abstract class INotificationRepository {

  Future<Null> create(String idTopic, String title, String subject);
}