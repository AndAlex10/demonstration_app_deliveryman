import 'package:aqui_tem_deliveryman/controllers/deliveryman.controller.dart';
import 'package:aqui_tem_deliveryman/controllers/order.controller.dart';
import 'package:aqui_tem_deliveryman/stores/user.store.dart';
import 'package:aqui_tem_deliveryman/views/home.view.dart';
import 'package:aqui_tem_deliveryman/views/widgets/widgets_commons.dart';
import 'package:flutter/material.dart';
import 'package:aqui_tem_deliveryman/models/entities/order.entities.dart';
import 'package:aqui_tem_deliveryman/enums/status.order.enum.dart';
import 'package:aqui_tem_deliveryman/views/orders/order.detail.view.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderView extends StatefulWidget {

  @override
  _OrderViewState createState() => _OrderViewState();
}

class _OrderViewState extends State<OrderView> {
  StatusOrder statusOrder;
  OrderController _controller = new OrderController();
  DeliveryManController _deliveryManController = new DeliveryManController();


  @override
  Widget build(BuildContext context) {
    var store = Provider.of<UserStore>(context);
    return WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => HomeView()));
          return false;
        },
        child: Scaffold(
            appBar: AppBar(
              iconTheme: new IconThemeData(color: Colors.white),
              title: Text("Pedido", style: TextStyle(color: Colors.white)),
              centerTitle: true,
              backgroundColor: Theme.of(context).primaryColor,
            ),
            body: Observer(builder: (_) {
              if (store.isLoading){
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (store.order != null){
                statusOrder = StatusOrder.values[store.order.status];
                return Container(
                    padding: EdgeInsets.all(5.0),
                    child: Card(
                        shape: RoundedRectangleBorder(
                            side: new BorderSide(
                                color: Colors.black12, width: 2.0)),
                        child: Container(
                          padding: EdgeInsets.all(11.0),
                          child: ListView(children: <Widget>[
                            Divider(),
                            getSteps(store.order),
                            SizedBox(
                              height: 5.0,
                            ),
                            viewDetailOrder(store.order),
                            SizedBox(
                              height: 15.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Center(
                                    child: Container(
                                        decoration: new BoxDecoration(
                                          color: WidgetsCommons.buttonColor(),
                                          shape: BoxShape.circle,
                                        ),
                                        width: 70,
                                        height: 70,
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.phone,
                                            size: 35.0,
                                            color: Colors.white,
                                          ),
                                          onPressed: () {
                                            String phone = statusOrder ==
                                                    StatusOrder
                                                        .READY_FOR_DELIVERY
                                                ? store.order.establishmentData
                                                    .phone
                                                : store.order.phone;
                                            launch("tel:$phone");
                                          },
                                        ))),
                                Center(
                                    child: Container(
                                        decoration: new BoxDecoration(
                                          color: WidgetsCommons.buttonColor(),
                                          shape: BoxShape.circle,
                                        ),
                                        width: 70,
                                        height: 70,
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.location_on,
                                            size: 35.0,
                                            color: Colors.white,
                                          ),
                                          onPressed: () {
                                            String long = statusOrder ==
                                                    StatusOrder
                                                        .READY_FOR_DELIVERY
                                                ? store.order.establishmentData
                                                    .longitude
                                                : store.order.longitude;
                                            String lat = statusOrder ==
                                                    StatusOrder
                                                        .READY_FOR_DELIVERY
                                                ? store.order.establishmentData
                                                    .latitude
                                                : store.order.latitude;
                                            launch(
                                                "https://www.google.com/maps/search/?api=1&query=$lat,"
                                                "$long");
                                          },
                                        ))),
                              ],
                            ),
                            SizedBox(
                              height: 40.0,
                            ),
                            statusOrder != StatusOrder.CONCLUDED
                                ? _updateStatus(store)
                                : SizedBox(),
                          ]),
                        )));
              } else {
                return Container();
              }
            })));
  }

  Widget _updateStatus(UserStore store) {
    return Padding(
        padding: EdgeInsets.all(12.0),
        child: SizedBox(
          height: 44.0,
          child: RaisedButton(
            child: Text(
              StatusOrderText.getNextStatus(
                  StatusOrder.values[statusOrder.index]),
              style: TextStyle(fontSize: 14.0),
            ),
            textColor: Colors.white,
            color: WidgetsCommons.buttonColor(),
            onPressed: () async {
              store.setLoading(true);
              await _controller
                  .updateStatus(
                      store.order, StatusOrder.values[statusOrder.index + 1])
                  .then((val) async {
                if (val.success) {
                  if (StatusOrder.values[store.order.status] ==
                      StatusOrder.CONCLUDED) {
                    await _deliveryManController.completedDelivery(store);

                    await WidgetsCommons.message(
                        context, "Corrida Finalizada!", false);
                    store.setLoading(false);
                    Navigator.of(context).pop();
                  } else {
                    store.setLoading(false);
                  }
                } else {
                  await WidgetsCommons.message(context, val.message, true);
                  store.setLoading(false);
                }
              });
            },
          ),
        ));
  }

  Widget viewDetailOrder(OrderData order) {
    return Column(
      children: <Widget>[
        Divider(),
        Card(
            child: FlatButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => OrderDetailView(order)));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.zoom_in,
                      size: 30,
                      color: WidgetsCommons.buttonColor(),
                    ),
                    Text(
                      "Ver Detalhes",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.black54,
                          fontWeight: FontWeight.w400),
                    )
                  ],
                ))),
        Divider(),
      ],
    );
  }

  Widget getSteps(OrderData order) {
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            WidgetsCommons.buildCircle("Estabelecimento", false, true),
            WidgetsCommons.buildLine(),
            WidgetsCommons.buildCircle(
                order.establishmentData.name,
                true,
                statusOrder.index >=
                    StatusOrder.DELIVERY_ARRIVED_ESTABLISHMENT.index),
            WidgetsCommons.buildLine(),
            WidgetsCommons.buildCircle(
                "${order.establishmentData.address}, ${order.establishmentData.number}, ${order.establishmentData.neighborhood}",
                true,
                statusOrder.index >=
                    StatusOrder.DELIVERY_ARRIVED_ESTABLISHMENT.index),
            WidgetsCommons.buildLine(),
            WidgetsCommons.buildCircle("Endereço de Entrega", false,
                statusOrder.index >= StatusOrder.DELIVERY_ARRIVED_CLIENT.index),
            WidgetsCommons.buildLine(),
            WidgetsCommons.buildCircle(
                "${order.address}, ${order.number}, ${order.neighborhood}, ${order.complement != null ? order.complement : ""}",
                true,
                statusOrder.index >= StatusOrder.DELIVERY_ARRIVED_CLIENT.index),
          ],
        ));
  }
}
