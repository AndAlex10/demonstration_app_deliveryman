
import 'package:aqui_tem_deliveryman/components/connect.component.dart';
import 'package:aqui_tem_deliveryman/repositories/signInGoogleAccount.repository.dart';
import 'package:aqui_tem_deliveryman/models/response/validate.response.dart';
import 'package:aqui_tem_deliveryman/repositories/signInGoogleAccount.repository.interface.dart';
import 'package:aqui_tem_deliveryman/stores/user.store.dart';

class SignInGoogleAccountController {

  ISignInGoogleAccountRepository repository;
  ConnectComponent connect;

  SignInGoogleAccountController(){
    repository = new SignInGoogleAccountRepository();
    connect = new ConnectComponent();
  }

  SignInGoogleAccountController.tests(this.repository, this.connect);

  Future<ValidateResponse> signIn(UserStore store) async {
    store.setLoading(true);
    ValidateResponse validateResponse;
    if(await connect.checkConnect()) {
      validateResponse = await repository.signIn(store);
      if(validateResponse.success){
        store.configRabbitMQ();
      }
    } else{
      validateResponse.failConnect();
    }

    store.setLoading(false);
    return validateResponse;
  }

  Future<ValidateResponse> signOutGoogle(UserStore userStore) async {
    ValidateResponse response = new ValidateResponse();

    if(await connect.checkConnect()) {
      userStore.setUser(null);
      repository.signOutGoogle();
      response.success = true;
    } else {
      response.failConnect();
    }

    return response;
  }

}