import 'package:aqui_tem_deliveryman/models/entities/order.entities.dart';
import 'package:aqui_tem_deliveryman/enums/status.order.enum.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderReportView extends StatefulWidget {
  final OrderData order;

  OrderReportView(this.order);
  @override
  _OrderReportViewState createState() => _OrderReportViewState(this.order);
}

class _OrderReportViewState extends State<OrderReportView> {
  final OrderData order;
  DateTime date;
  StatusOrder statusOrder;

  _OrderReportViewState(this.order);

  @override
  void initState() {
    // TODO: implement initState
    date = order.dateCreate.toDate();
    statusOrder = StatusOrder.values[order.status];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
          side: new BorderSide(color: Colors.black12, width: 1.0)),
      child: Container(
          padding: EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "${order.orderCode} - ",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Color.fromARGB(255, 79, 79, 79),
                        fontSize: 16.0),
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Icon(
                          Icons.calendar_today,
                          color: Theme.of(context).primaryColor,
                          size: 16.0,
                        ),
                        Text(
                          " ${DateFormat('dd/MM/yyyy HH:mm a').format(date)}",
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w400,
                              fontSize: 16.0),
                        ),
                      ]),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Situação: ${StatusOrderText.getTitle(StatusOrder.values[order.status])} ",
                    style:
                        TextStyle(fontWeight: FontWeight.w400, fontSize: 16.0),
                  ),
                  order.rating != null
                      ? Row(
                          children: <Widget>[
                            SizedBox(
                              width: 8.0,
                            ),
                            Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 14.0,
                            ),
                            Text(
                              "${order.rating}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0,
                                  color: Colors.amber),
                            ),
                          ],
                        )
                      : SizedBox(),
                ],
              ),
              Row(
                children: <Widget>[
                  Text(
                    "Valor: ",
                    style:
                        TextStyle(fontWeight: FontWeight.w400, fontSize: 16.0),
                  ),
                  Text(
                    "R\$${order.commissionDelivery.toStringAsFixed(2)}",
                    style:
                        TextStyle(fontWeight: FontWeight.w400, fontSize: 16.0),
                  ),
                ],
              ),
            ],
          )),
    );
  }
}
