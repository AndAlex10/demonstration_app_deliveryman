import 'package:aqui_tem_deliveryman/components/connect.component.dart';
import 'package:aqui_tem_deliveryman/repositories/signInEmailAccount.repository.dart';
import 'package:aqui_tem_deliveryman/models/response/validate.response.dart';
import 'package:aqui_tem_deliveryman/repositories/signInEmailAccount.repository.interfaces.dart';
import 'package:aqui_tem_deliveryman/stores/user.store.dart';

class SignInEmailAccountController {

  ISignInEmailAccountRepository repository;
  ConnectComponent connect;

  SignInEmailAccountController(){
    repository = new SignInEmailAccountRepository();
    connect = new ConnectComponent();
  }

  SignInEmailAccountController.tests(this.repository, this.connect);

  Future<ValidateResponse> signIn(UserStore store, String email, String pass) async {
    store.setLoading(true);
    ValidateResponse validateResponse;
    if(await connect.checkConnect()) {
      validateResponse = await repository.signIn(
          email: email, pass: pass, store: store);

      if(validateResponse.success){
        store.configRabbitMQ();
      }
    } else {
      validateResponse = new ValidateResponse();
      validateResponse.failConnect();
    }
    store.setLoading(false);
    return validateResponse;
  }

  Future<ValidateResponse> signOut(UserStore store) async {
    ValidateResponse response = new ValidateResponse();

    if(await connect.checkConnect()) {
      store.setUser(null);
      repository.signOut();
      response.success = true;
    } else {
      response.failConnect();
    }

    return response;
  }

  void recoverPass(String email) {
    repository.recoverPass(email);
  }

}