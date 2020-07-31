import 'package:aqui_tem_deliveryman/models/entities/settings.entity.dart';
import 'package:aqui_tem_deliveryman/repositories/settings.repository.dart';
import 'package:aqui_tem_deliveryman/repositories/settings.repository.interface.dart';
import "package:dart_amqp/dart_amqp.dart";
class RabbitMQConfig{

  ISettingsRepository settingsRepository;

  RabbitMQConfig(){
    settingsRepository = new SettingsRepository();
  }
  Future<ConnectionSettings> connect() async{
    SettingsData settingsData = await settingsRepository.getManagerServer();
    ConnectionSettings settings = ConnectionSettings(
        host : settingsData.urlMQ,
        authProvider : new PlainAuthenticator(settingsData.userMQ, settingsData.passwordMQ)
    );

    return settings;
  }
}