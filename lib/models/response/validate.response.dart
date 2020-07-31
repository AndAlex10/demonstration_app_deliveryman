
import 'package:aqui_tem_deliveryman/constants/error.message.constants.dart';

class ValidateResponse {
  bool success = false;
  String message;

  failConnect(){
    success = false;
    message = ErrorMessages.CONNECT_INTERNET;
  }
}