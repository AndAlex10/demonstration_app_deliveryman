import 'package:aqui_tem_deliveryman/stores/user.store.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aqui_tem_deliveryman/views/home.view.dart';
import 'package:flutter/services.dart';
import 'package:screen/screen.dart';

void main() => runApp(MyApp());


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Screen.keepOn(true);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return MultiProvider(
      providers: [
        Provider<UserStore>(
          create:  (_) => UserStore(new FirebaseMessaging()),
        ),
      ],
      child: MaterialApp(
          title: 'É pra Já Delivery',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            primaryColor: Color.fromARGB(255, 251, 116, 2),
          ),
          debugShowCheckedModeBanner: false,
          home: HomeView()),
    );
  }
}
