import 'package:aqui_tem_deliveryman/stores/user.store.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:aqui_tem_deliveryman/components/connect.component.dart';
import 'package:aqui_tem_deliveryman/controllers/signInEmailAccount.controller.dart';
import 'package:aqui_tem_deliveryman/models/response/validate.response.dart';
import 'package:aqui_tem_deliveryman/repositories/signInEmailAccount.repository.dart';
import 'package:aqui_tem_deliveryman/repositories/signInEmailAccount.repository.interfaces.dart';


class SignInEmailAccountRepositoryMock extends Mock implements SignInEmailAccountRepository  {}
class MockConnect extends Mock implements ConnectComponent  {}
class MockAppStore extends Mock implements UserStore  {}

void main(){
  SignInEmailAccountController controller;
  ConnectComponent connect;
  ISignInEmailAccountRepository repository;
  MockAppStore appStore;

  setUp(() {
    repository = SignInEmailAccountRepositoryMock();
    connect = MockConnect();
    controller = SignInEmailAccountController.tests(repository, connect);
    appStore = MockAppStore();
  });

  group('Sign In tests', ()
  {
    test("Test Sign In", () async {
      String email = "test@gmail.com";
      String pass = "123456";

      ValidateResponse validateResponse = new ValidateResponse();
      validateResponse.success = true;
      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(true));

      when(appStore.configRabbitMQ()).thenAnswer((_) async => null);

      when(repository.signIn(email: email, pass: pass, store: appStore)).thenAnswer((_) async =>
          Future.value(validateResponse));

      ValidateResponse response = await controller.signIn(appStore, email, pass);
      expect(response != null, true);
      expect(response.success, true);
    });

    test("Test Sign In - Fail", () async {
      String email = "test@gmail.com";
      String pass = "123456";

      when(appStore.configRabbitMQ()).thenAnswer((_) async => null);

      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(true));

      ValidateResponse validateResponse = new ValidateResponse();
      when(repository.signIn(email: email, pass: pass, store: appStore)).thenAnswer((_) async =>
          Future.value(validateResponse));
      ValidateResponse response = await controller.signIn(appStore, email, pass);
      expect(response != null, true);
      expect(response.success, false);
    });

    test("Teste de falha de conexão", () async {
      String email = "test@gmail.com";
      String pass = "123456";
      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(false));

      ValidateResponse response = await controller.signIn(appStore, email, pass);
      expect(false, response.success);
    });
  });

  group('Sign Out tests', ()
  {
    test("sign out", () async {
      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(true));

      when(repository.signOut()).thenAnswer((_) async =>
          Future.value(null));

      ValidateResponse response = await controller.signOut(appStore);
      expect(response != null, true);
      expect(response.success, true);
    });

    test("Teste de falha de conexão", () async {
      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(false));
      ValidateResponse response = await controller.signOut(appStore);
      expect(false, response.success);
    });
  });

}