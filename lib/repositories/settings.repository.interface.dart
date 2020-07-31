

import 'package:aqui_tem_deliveryman/models/entities/settings.entity.dart';

abstract class ISettingsRepository {

  Future<SettingsData> getManagerServer();
}