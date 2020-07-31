import 'package:aqui_tem_deliveryman/models/response/validate.response.dart';
import 'package:aqui_tem_deliveryman/stores/user.store.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class ISignInGoogleAccountRepository {

  Future<ValidateResponse> signIn(UserStore store);

  Future<Null> signOutGoogle();

  Future<FirebaseUser> signInWithGoogle(
      FirebaseAuth auth, GoogleSignIn googleSignIn);
}
