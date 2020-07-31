import 'package:aqui_tem_deliveryman/controllers/deliveryman.controller.dart';
import 'package:aqui_tem_deliveryman/models/entities/order.entities.dart';
import 'package:aqui_tem_deliveryman/stores/user.store.dart';
import 'package:aqui_tem_deliveryman/views/orders/order.view.dart';
import 'package:aqui_tem_deliveryman/views/widgets/widgets_commons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderNewView extends StatelessWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _controller = new DeliveryManController();

  @override
  Widget build(BuildContext context) {
    var store = Provider.of<UserStore>(context);
    return Scaffold(
        key: _scaffoldKey,
        body: Container(
            padding: EdgeInsets.all(5.0),
            child: Card(
                shape: RoundedRectangleBorder(
                    side: new BorderSide(color: Colors.black12, width: 2.0)),
                child: Container(
                  padding: EdgeInsets.all(11.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 20.0,
                        ),
                        Text(
                          "Pedido Novo!",
                          style: TextStyle(
                              fontSize: 28.0,
                              color: WidgetsCommons.buttonColor()),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Text(
                            "Valor: R\$${store.order.commissionDelivery.toStringAsFixed(2)}",
                            style: TextStyle(
                                fontSize: 24.0, color: Colors.black87),
                            textAlign: TextAlign.center),
                        SizedBox(
                          height: 12.0,
                        ),
                        Divider(),
                        getSteps(store.order),
                        SizedBox(
                          height: 5.0,
                        ),
                        Divider(),
                        SizedBox(
                          height: 25.0,
                        ),
                        Column(
                          children: <Widget>[
                            acceptOrder(store, context),
                            SizedBox(
                              height: 15.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Icon(
                                  Icons.cancel,
                                  color: Colors.black54,
                                ),
                                Text(
                                  "Arraste para rejeitar/aceitar",
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      color: Color.fromARGB(255, 79, 79, 79),
                                      fontWeight: FontWeight.w500),
                                  textAlign: TextAlign.center,
                                ),
                                Icon(
                                  Icons.check_circle,
                                  color: Colors.black54,
                                ),
                              ],
                            )
                          ],
                        ),
                      ]),
                ))));
  }

  Dismissible acceptOrder(UserStore store, BuildContext context) {
    return Dismissible(
      onDismissed: (DismissDirection direction) async {
        if (direction.index == 3) {
          await _controller
              .acceptOrder(store)
              .then((result) async {
            if (result.success) {
              WidgetsCommons.onGeneric(
                  _scaffoldKey, "Pedido Aceito!", WidgetsCommons.buttonColor());
              await Future.delayed(Duration(seconds: 1));
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => OrderView()));
            } else {
              WidgetsCommons.onFail(
                  _scaffoldKey, result.message);
              await Future.delayed(Duration(seconds: 2));
              Navigator.of(context).pop();
            }

          });

        } else {
          await _controller.rejectOrder(store, true).then((val) async{
            if(val.success){
              WidgetsCommons.onFail(_scaffoldKey, "Pedido Rejeitado!");
              await Future.delayed(Duration(seconds: 2));
            } else {
              WidgetsCommons.onFail(_scaffoldKey, val.message);
              await Future.delayed(Duration(seconds: 2));
            }
            Navigator.of(context).pop();
          });


        }
      },
      key: Key(DateTime.now().toString()),
      background: Container(
        color: WidgetsCommons.buttonColor(),
      ),
      secondaryBackground: Container(
        color: Colors.red,
      ),
      child: Center(
          child: Container(
              decoration: new BoxDecoration(
                color: WidgetsCommons.buttonColor(),
                shape: BoxShape.circle,
              ),
              width: 80,
              height: 80,
              child: Icon(
                Icons.assistant_photo,
                color: Colors.white,
              ))),
    );
  }

  Widget getSteps(OrderData orderData) {
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            WidgetsCommons.buildCircle("Estabelecimento", false, true),
            WidgetsCommons.buildLine(),
            WidgetsCommons.buildCircle(orderData.establishmentData.name, true, false),
            WidgetsCommons.buildLine(),
            WidgetsCommons.buildCircle("Endereço de Entrega", false, true),
            WidgetsCommons.buildLine(),
            WidgetsCommons.buildCircle(
                "${orderData.address}, ${orderData.number}, ${orderData.neighborhood}",
                true, false),
          ],
        ));
  }
}
