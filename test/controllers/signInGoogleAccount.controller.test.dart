import 'package:aqui_tem_deliveryman/controllers/signInGoogleAccount.controller.dart';
import 'package:aqui_tem_deliveryman/repositories/signInGoogleAccount.repository.dart';
import 'package:aqui_tem_deliveryman/repositories/signInGoogleAccount.repository.interface.dart';
import 'package:aqui_tem_deliveryman/stores/user.store.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:aqui_tem_deliveryman/components/connect.component.dart';
import 'package:aqui_tem_deliveryman/models/response/validate.response.dart';


class SignInGoogleAccountRepositoryMock extends Mock implements SignInGoogleAccountRepository  {}
class MockConnect extends Mock implements ConnectComponent  {}
class MockAppStore extends Mock implements UserStore  {}

void main(){
  SignInGoogleAccountController controller;
  ConnectComponent connect;
  ISignInGoogleAccountRepository repository;
  MockAppStore appStore;

  setUp(() {
    repository = SignInGoogleAccountRepositoryMock();
    connect = MockConnect();
    controller = SignInGoogleAccountController.tests(repository, connect);
    appStore = MockAppStore();
  });

  group('Sign In Goolge tests', ()
  {
    test("Test Sign In Goolge", () async {
      ValidateResponse validateResponse = new ValidateResponse();
      validateResponse.success = true;
      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(true));

      when(appStore.configRabbitMQ()).thenAnswer((_) async => null);

      when(repository.signIn(appStore)).thenAnswer((_) async =>
          Future.value(validateResponse));

      ValidateResponse response = await controller.signIn(appStore);
      expect(response != null, true);
      expect(response.success, true);
    });

    test("Test Sign In Goolge - Fail", () async {

      when(appStore.configRabbitMQ()).thenAnswer((_) async => null);

      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(true));

      ValidateResponse validateResponse = new ValidateResponse();
      when(repository.signIn(appStore)).thenAnswer((_) async =>
          Future.value(validateResponse));
      ValidateResponse response = await controller.signIn(appStore);
      expect(response != null, true);
      expect(response.success, false);
    });

    test("Teste de falha de conexão", () async {

      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(false));

      ValidateResponse response = await controller.signIn(appStore);
      expect(false, response.success);
    });
  });

  group('Sign Out Goolge tests', ()
  {
    test("sign out Goolge", () async {
      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(true));

      when(repository.signOutGoogle()).thenAnswer((_) async =>
          Future.value(null));

      ValidateResponse response = await controller.signOutGoogle(appStore);
      expect(response != null, true);
      expect(response.success, true);
    });

    test("Teste de falha de conexão", () async {
      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(false));
      ValidateResponse response = await controller.signOutGoogle(appStore);
      expect(false, response.success);
    });
  });

}