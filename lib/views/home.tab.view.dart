import 'package:aqui_tem_deliveryman/enums/status.delivery.enum.dart';
import 'package:aqui_tem_deliveryman/stores/user.store.dart';
import 'package:aqui_tem_deliveryman/views/orders/order.new.view.dart';
import 'package:aqui_tem_deliveryman/views/orders/order.view.dart';
import 'package:aqui_tem_deliveryman/views/widgets/login.dart';
import 'package:aqui_tem_deliveryman/views/widgets/widgets_commons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';


class HomeTabView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var store = Provider.of<UserStore>(context);
    return Scaffold(body: Observer(builder: (_) {
      if (store.isLoading) {
        return Center(child: CircularProgressIndicator());
      } else if (!store.isLoggedIn()) {
        return GetLoginView();
      } else {
        return Container(
            padding: EdgeInsets.all(5.0),
            child: Card(
                shape: RoundedRectangleBorder(
                    side: new BorderSide(color: Colors.black12, width: 2.0)),
                child: Container(
                  padding: EdgeInsets.all(11.0),
                  height: store.order != null ? 700 : 280,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text("Desempenho de Hoje",
                            style: TextStyle(
                                fontSize: 28.0,
                                color: Color.fromARGB(255, 54, 54, 54))),
                        SizedBox(
                          height: 20.0,
                        ),
                        Text(
                          "Ganhou",
                          style: TextStyle(
                              fontSize: 15.0,
                              color: WidgetsCommons.buttonColor()),
                        ),
                        Text(
                            "R\$${store.statistic.amountToday.toStringAsFixed(2)}",
                            style: TextStyle(
                                fontSize: 28.0, color: Colors.black87)),
                        SizedBox(
                          height: 12.0,
                        ),
                        Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Icon(
                                  Icons.motorcycle,
                                  color: Color.fromARGB(255, 79, 79, 79),
                                ),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Text(
                                  "Entregas",
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      color: Color.fromARGB(255, 79, 79, 79),
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                            Text(
                              store.statistic.deliveredOrdersToday
                                  .toString(),
                              style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Icon(
                                  Icons.check_box,
                                  color: Color.fromARGB(255, 79, 79, 79),
                                ),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Text(
                                  "Aceitos",
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      color: Color.fromARGB(255, 79, 79, 79),
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                            Text(
                              store.statistic.acceptedOrdersToday
                                  .toString(),
                              style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Icon(
                                  Icons.remove_circle,
                                  color: Color.fromARGB(255, 79, 79, 79),
                                ),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Text(
                                  "Rejeitados",
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      color: Color.fromARGB(255, 79, 79, 79),
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                            Text(
                              store.statistic.rejectedOrdersToday
                                  .toString(),
                              style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        Divider(),
                        store.order != null ? _orderPending(store, context) : SizedBox()
                      ]),
                )));
      }
    }));
  }

  Widget _orderPending(UserStore store, BuildContext context) {
    return InkWell(
        onTap: () async{
          if (StatusDelivery.PENDING.index == store.user.status) {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => OrderNewView()));
          } else {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => OrderView()));
          }
        },
        child: Card(
            shape: RoundedRectangleBorder(
                side: new BorderSide(color: Colors.red, width: 2.0)),
            child: Container(
                padding: EdgeInsets.all(11.0),
                height: 115,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Pedido ${store.order.orderCode} ${StatusDeliveryText.getTitle(store.user.status)}",
                        style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.red,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      Text(
                        store.order.establishmentData.name,
                        style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.black87,
                            fontWeight: FontWeight.w500),
                      ),
                      Divider(),
                      viewDetailOrder(),
                    ]))));
  }

  Widget viewDetailOrder() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          Icons.zoom_in,
          size: 20,
          color: WidgetsCommons.buttonColor(),
        ),
        Text(
          "Visualizar",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 15.0,
              color: Colors.black54,
              fontWeight: FontWeight.w400),
        )
      ],
    );
  }
}
