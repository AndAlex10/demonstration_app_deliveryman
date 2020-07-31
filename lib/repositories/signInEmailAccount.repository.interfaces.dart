import 'package:aqui_tem_deliveryman/models/response/validate.response.dart';
import 'package:aqui_tem_deliveryman/stores/user.store.dart';
import 'package:flutter/cupertino.dart';

abstract class ISignInEmailAccountRepository {

  Future<ValidateResponse> signIn({@required String email,
    @required String pass, @required UserStore store});

  void signOut();

  void recoverPass(String email);

}