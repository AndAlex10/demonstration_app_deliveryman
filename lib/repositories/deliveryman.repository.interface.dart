import 'package:aqui_tem_deliveryman/models/entities/user.entities.dart';
import 'package:aqui_tem_deliveryman/stores/user.store.dart';

abstract class IDeliveryManRepository {

  Future<UserEntity> load();

  Future<Null> update(UserStore userStore);

  Future<Null> acceptOrder(UserStore userStore);

  Future<Null> startFinishWork(UserEntity userEntity);

  Future<bool> verifyDeliveryOrder(String idDeliveryMan, String idOrder);

}
