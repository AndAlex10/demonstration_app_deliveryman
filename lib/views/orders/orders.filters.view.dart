import 'package:aqui_tem_deliveryman/controllers/order.controller.dart';
import 'package:aqui_tem_deliveryman/models/entities/order.filters.entities.dart';
import 'package:aqui_tem_deliveryman/stores/user.store.dart';
import 'package:aqui_tem_deliveryman/view_model/order.view.model.dart';
import 'package:aqui_tem_deliveryman/views/orders/orders.list.view.dart';
import 'package:aqui_tem_deliveryman/views/widgets/connect.fail.dart';
import 'package:aqui_tem_deliveryman/views/widgets/login.dart';
import 'package:aqui_tem_deliveryman/views/widgets/widgets_commons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class OrdersFiltersView extends StatefulWidget {
  @override
  _OrdersFiltersViewState createState() => _OrdersFiltersViewState();
}

class _OrdersFiltersViewState extends State<OrdersFiltersView> {
  OrderFilters orderFilters = new OrderFilters();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  OrderController _controller = new OrderController();

  @override
  Widget build(BuildContext context) {
    var store = Provider.of<UserStore>(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: WidgetsCommons.buttonColor(),
          iconTheme: new IconThemeData(color: Colors.white),
          title: Text(
            'Filtros',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        key: _scaffoldKey,
        body: store.isLoading
    ? Center(
    child: CircularProgressIndicator(),
    )
        : !store.isLoggedIn()
    ? GetLoginView()
        :  FutureBuilder<OrderViewModel>(
                  future: _controller
                      .getAll(store.user.idDeliveryMan),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (!snapshot.data.checkConnect) {
                      return Center(child: ConnectFail(onRefresh));
                    } else {
                      orderFilters.ordersAll = snapshot.data.list;
                      return Container(
                        padding: EdgeInsets.all(5.0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                              side: new BorderSide(
                                  color: Colors.black12, width: 2.0)),
                          child: Container(
                            padding: EdgeInsets.all(4.0),
                            child: ListView(
                              scrollDirection: Axis.vertical,
                              children: <Widget>[
                                WidgetsCommons.widgetCheckBox(orderFilters.activeDate,
                                    onChangedActiveDate, "Por período"),
                                WidgetsCommons.widgetDate(
                                    "Início",
                                    orderFilters.activeDate
                                        ? orderFilters.getStartDateString()
                                        : "Não Habilitado",
                                    _updateStartDate,
                                    orderFilters.activeDate),
                                WidgetsCommons.widgetDate(
                                    "Final",
                                    orderFilters.activeDate
                                        ? orderFilters.getEndDateString()
                                        : "Não Habilitado",
                                    _updateEndDate,
                                    orderFilters.activeDate),
                                SizedBox(
                                  height: 30.0,
                                ),
                                _search(store),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                  })

          );
  }

  _updateStartDate() async {
    DateTime dateTime = await WidgetsCommons.getShowDate(context);
    if (dateTime != null) {
      orderFilters.startDate = Timestamp.fromDate(dateTime);
    }
    setState(() {});
  }

  _updateEndDate() async {
    DateTime dateTime = await WidgetsCommons.getShowDate(context);
    if (dateTime != null) {
      orderFilters.endDate = Timestamp.fromDate(dateTime);
    }
    setState(() {});
  }

  void onChangedActiveDate(bool value) {
    orderFilters.activeDate = value;
    setState(() {});
  }

  Widget _search(UserStore store) {
    return Padding(
        padding: EdgeInsets.all(12.0),
        child: SizedBox(
          height: 44.0,
          child: RaisedButton(
            child: Text(
              "Buscar",
              style: TextStyle(fontSize: 18.0),
            ),
            textColor: Colors.white,
            color: WidgetsCommons.buttonColor(),
            onPressed: () async {
              store.setLoading(true);
              setState(() {});
              orderFilters.id = store.user.idDeliveryMan;
              await _controller.getFilters(orderFilters).then((list) {
                store.setLoading(false);
                setState(() {});
                if (list.length == 0) {
                  WidgetsCommons.message(context, "Nenhum Pedido encontrado", true);
                } else {
                  orderFilters.ordersFilter = list;
                  orderFilters.setAmount();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => OrdersListView(orderFilters)));
                }
              });
            },
          ),
        ));
  }

  onRefresh(){
    setState(() { });
  }
}
