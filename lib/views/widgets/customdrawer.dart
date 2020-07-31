import 'package:aqui_tem_deliveryman/controllers/deliveryman.controller.dart';
import 'package:aqui_tem_deliveryman/stores/user.store.dart';
import 'package:aqui_tem_deliveryman/views/user/login.view.dart';
import 'package:flutter/material.dart';
import 'package:aqui_tem_deliveryman/views/widgets/drawer.tile.view.dart';
import 'package:provider/provider.dart';

class CustomDrawer extends StatefulWidget {
  final PageController pageController;

  CustomDrawer(this.pageController);
  @override
  _CustomDrawerState createState() => _CustomDrawerState(pageController);
}

class _CustomDrawerState extends State<CustomDrawer> {
  final PageController pageController;

  _CustomDrawerState(this.pageController);

  DeliveryManController _controller = new DeliveryManController();
  @override
  Widget build(BuildContext context) {
    var store = Provider.of<UserStore>(context);

    Widget _buildDrawerBack() => Container(
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
              colors: [Colors.white12, Colors.white],
              begin: Alignment.center,
              end: Alignment.bottomCenter)),
    );
    return Drawer(
      child: Stack(
        children: <Widget>[
          _buildDrawerBack(),
          ListView(
            padding: EdgeInsets.only(left: 32.0, top: 32.0),
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 8.0),
                padding: EdgeInsets.fromLTRB(0.0, 16.0, 16.0, 8.0),
                height: 230.0,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      top: 8.0,
                      left: 0.0,
                      child: Text(
                        'É pra Já Delivery',
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Positioned(
                        left: 0.0,
                        bottom: 0.0,
                        child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  !store.isLoggedIn()
                                      ? SizedBox(
                                    height: 44.0,
                                    child: RaisedButton(
                                      child: Text(
                                        "ENTRAR",
                                        style: TextStyle(fontSize: 18.0),
                                      ),
                                      textColor: Colors.white,
                                      color: Colors.green,
                                      onPressed: () async {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    LoginView(false)));
                                      },
                                    ),
                                  )
                                      : Container(
                                    width: 230.0,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          "Olá " + store.user.name,
                                          maxLines: 2,
                                          style: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 22.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 8.0,),
                                        Row(children: <Widget>[
                                          Icon(Icons.location_on, color: Color.fromARGB(255, 79,79,79),),
                                          Text(
                                            store.user.city,
                                            maxLines: 2,
                                            style: TextStyle(
                                                color: Color.fromARGB(255, 79,79,79),
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ],),
                                        Divider(),
                                      ],
                                    )
                                  ),
                                  SizedBox(
                                    height: 15.0,
                                  ),
                                  store.isLoggedIn()
                                      ? SizedBox(
                                    height: 44.0,
                                    child: RaisedButton(
                                      child: Text(
                                        store.user == null
                                            ? "INDISPONÍVEL"
                                            : store.user.online
                                            ? "DISPONÍVEL"
                                            : "INDISPONÍVEL",
                                        style: TextStyle(fontSize: 18.0),
                                      ),
                                      textColor: Colors.white,
                                      color: store.user == null
                                          ? Colors.red
                                          : store.user.online
                                          ? Colors.green
                                          : Colors.red,
                                      onPressed: () async {
                                        await _controller.startFinishWork(store.user).then((_){
                                          setState(() {});
                                        });
                                      },
                                    ),
                                  )
                                      : SizedBox(
                                    height: 15.0,
                                  ),
                                ],
                              )
                            ),
                  ],
                ),
              ),
              Divider(),
              DrawerTile(Icons.home, 'Inicio', pageController, 0),
              DrawerTile(Icons.list, 'Relatório', pageController, 1),
              DrawerTile(Icons.input, 'Sair', pageController, 2),
            ],
          )
        ],
      ),
    );
  }
}

