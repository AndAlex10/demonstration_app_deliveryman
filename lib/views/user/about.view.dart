import 'package:aqui_tem_deliveryman/views/widgets/widgets_commons.dart';
import 'package:flutter/material.dart';
import 'package:aqui_tem_deliveryman/enums/version.enum.dart';
import 'package:aqui_tem_deliveryman/views/home.view.dart';

class AboutView extends StatefulWidget {
  @override
  _AboutViewState createState() => _AboutViewState();
}

class _AboutViewState extends State<AboutView> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (_) => HomeView()));

          return Future.value(false);
        },
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            backgroundColor: WidgetsCommons.buttonColor(),
            title: Text(
              'Sobre',
              style: TextStyle(color: Colors.white),
            ),
            centerTitle: true,
          ),
          body: ListView(padding: EdgeInsets.all(5.0), children: <Widget>[

            WidgetsCommons.optionTileButton(context, "Política de privacidade", Container(),
                Icon(Icons.subject, size: 24.0)),
            WidgetsCommons.optionTileButton(context, "Termo de uso", Container(),
                Icon(Icons.speaker_notes, size: 24.0)),

            SizedBox(height: 8.0,),
            Text(
              "Versão: " + Version.version,
              style: TextStyle(color: Colors.black54, fontSize: 20.0),
              textAlign: TextAlign.center,
            ),
          ]),
        ));
  }
}
