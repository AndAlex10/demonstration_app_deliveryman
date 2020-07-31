import 'package:aqui_tem_deliveryman/models/entities/order.filters.entities.dart';
import 'package:aqui_tem_deliveryman/views/orders/order.report.view.dart';
import 'package:aqui_tem_deliveryman/views/widgets/widgets_commons.dart';
import 'package:flutter/material.dart';

class OrdersListView extends StatefulWidget {
  final OrderFilters filters;

  OrdersListView(this.filters);

  @override
  _OrdersListViewState createState() => _OrdersListViewState(this.filters);
}

class _OrdersListViewState extends State<OrdersListView> {
  final OrderFilters filters;

  _OrdersListViewState(this.filters);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: WidgetsCommons.buttonColor(),
          iconTheme: new IconThemeData(color: Colors.white),
          title: Text(
            'Pedidos',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: Card(
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
            shape: RoundedRectangleBorder(
                side: new BorderSide(color: Colors.black12, width: 2.0)),
            child: Padding(
                padding: EdgeInsets.all(9.0),
                child: ListView(
                  scrollDirection: Axis.vertical,
                  children: <Widget>[
                    Card(
                      shape: RoundedRectangleBorder(
                          side: new BorderSide(
                              color: Colors.black12, width: 2.0)),
                      child: Container(
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Filtros",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                  fontSize: 18.0),
                            ),
                            SizedBox(
                              height: 8.0,
                            ),
                            Row(
                              children: <Widget>[
                                Text(
                                  "Período: ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Color.fromARGB(255, 79, 79, 79),
                                      fontSize: 17.0),
                                ),
                                filters.activeDate
                                    ? Text(
                                        "${filters.getStartDateString()} á ${filters.getEndDateString()}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 17.0),
                                      )
                                    : Text(
                                        "Nenhum",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 17.0),
                                      )
                              ],
                            ),
                            SizedBox(
                              height: 7.0,
                            ),
                            Divider(),
                            Row(
                              children: <Widget>[
                                Text(
                                  "Total: ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Color.fromARGB(255, 79, 79, 79),
                                      fontSize: 22.0),
                                ),
                                Text(
                                  "R\$${filters.amount.toStringAsFixed(2)}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 22.0),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 8.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      "Pedidos",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 79, 79, 79),
                          fontSize: 18.0),
                      textAlign: TextAlign.center,
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: new NeverScrollableScrollPhysics(),
                      itemCount: filters.ordersFilter.length,
                      itemBuilder: (BuildContext ctxt, int index) {
                        return OrderReportView(filters.ordersFilter[index]);
                      },
                    ),
                  ],
                ))));
  }
}
