import 'package:aqui_tem_deliveryman/constants/error.message.constants.dart';
import 'package:aqui_tem_deliveryman/enums/login.type.enum.dart';
import 'package:aqui_tem_deliveryman/models/entities/user.entities.dart';
import 'package:aqui_tem_deliveryman/repositories/signInEmailAccount.repository.interfaces.dart';
import 'package:aqui_tem_deliveryman/models/response/validate.response.dart';
import 'package:aqui_tem_deliveryman/stores/user.store.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class SignInEmailAccountRepository implements ISignInEmailAccountRepository {

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseUser fbUser;

  @override
  Future<ValidateResponse> signIn({@required String email,
    @required String pass, @required UserStore store}) async {
    ValidateResponse validateResponse = new ValidateResponse();

    await auth
        .signInWithEmailAndPassword(email: email, password: pass)
        .then((user) async {
      fbUser = user;

      if (fbUser != null) {
        DocumentSnapshot doc = await Firestore.instance
            .collection("???")
            .document(fbUser.uid)
            .get();

        if(doc.data != null) {
          UserEntity userData = UserEntity.fromMap(doc.documentID, doc.data);
          userData.loginType = LoginType.EMAIL.index;
          store.setUser(userData);

          await Firestore.instance
              .collection("???")
              .document(fbUser.uid)
              .updateData({"???": LoginType.EMAIL.index});

          validateResponse.success = true;

        } else {
          validateResponse.message = ErrorMessages.DELIVERY_INVALID;

        }
      }

    }).catchError((e) {
      validateResponse.message = ErrorMessages.FAIL_LOGIN;
    });

    return validateResponse;
  }

  @override
  void signOut() async {
    await auth.signOut();

  }

  @override
  void recoverPass(String email) {
    auth.sendPasswordResetEmail(email: email);
  }

}