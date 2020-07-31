
import 'package:aqui_tem_deliveryman/models/entities/establishment.entities.dart';

abstract class IEstablishmentRepository {

  Future<EstablishmentData> getId(String idEstablishment);

  Future<List<EstablishmentData>> getAll(String idSegment, String idCategory, String city, String state);

}