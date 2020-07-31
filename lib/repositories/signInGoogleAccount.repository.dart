import 'package:aqui_tem_deliveryman/constants/error.message.constants.dart';
import 'package:aqui_tem_deliveryman/enums/login.type.enum.dart';
import 'package:aqui_tem_deliveryman/models/entities/user.entities.dart';
import 'package:aqui_tem_deliveryman/repositories/signInGoogleAccount.repository.interface.dart';
import 'package:aqui_tem_deliveryman/models/response/validate.response.dart';
import 'package:aqui_tem_deliveryman/stores/user.store.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignInGoogleAccountRepository implements ISignInGoogleAccountRepository {
  GoogleSignIn googleSignIn;
  FirebaseAuth auth = FirebaseAuth.instance;

  SignInGoogleAccountRepository(){
    googleSignIn = GoogleSignIn();
  }

  @override
  Future<ValidateResponse> signIn(UserStore store) async {
    ValidateResponse validateResponse = new ValidateResponse();

    FirebaseUser fbUser;

    await signInWithGoogle(auth, googleSignIn).then((data) async {
      fbUser = data;

      if (fbUser != null) {
        DocumentSnapshot doc = await Firestore.instance
            .collection("???")
            .document(fbUser.uid)
            .get();

        if (doc.data != null) {
          UserEntity userData = UserEntity.fromMap(doc.documentID, doc.data);
          userData.loginType = LoginType.GOOGLE.index;
          store.setUser(userData);

          await Firestore.instance
              .collection("???")
              .document(fbUser.uid)
              .updateData({"???": LoginType.GOOGLE.index});
          validateResponse.success = true;
        } else {
          await signOutGoogle();
          validateResponse.message = ErrorMessages.DELIVERY_INVALID;
        }
      }
    }).catchError((e) {
      validateResponse.message = ErrorMessages.FAIL_LOGIN;
    });

    return validateResponse;
  }

  @override
  Future<Null> signOutGoogle() async {
    await googleSignIn.signOut();
  }

  @override
  Future<FirebaseUser> signInWithGoogle(
      FirebaseAuth auth, GoogleSignIn googleSignIn) async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final FirebaseUser user = await auth.signInWithCredential(credential);

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await auth.currentUser();
    assert(user.uid == currentUser.uid);

    return user;
  }
}
