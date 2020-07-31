
import 'package:aqui_tem_deliveryman/models/entities/order.entities.dart';
import 'package:aqui_tem_deliveryman/enums/status.order.enum.dart';
import 'package:aqui_tem_deliveryman/views/orders/order.detail.view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderTileView extends StatefulWidget {
  final OrderData order;

  OrderTileView(this.order);

  @override
  _OrderTileViewState createState() => _OrderTileViewState(this.order);
}

class _OrderTileViewState extends State<OrderTileView> {

  final OrderData order;
  DateTime date;
  StatusOrder statusOrder;

  _OrderTileViewState(this.order);

  @override
  void initState() {
    // TODO: implement initState
    date = order.dateCreate.toDate();
    statusOrder = StatusOrder.values[order.status];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => OrderDetailView(order)));
        },
        child: Card(
          margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Pedido ${order.orderCode} - ",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 16.0),
                            ),
                            Text(
                              " ${StatusOrderText.getTitle(StatusOrder.values[order.status])} ",
                              style: TextStyle(
                                backgroundColor: StatusOrder.values[order.status] == StatusOrder.PENDING ? Colors.red : Theme.of(context).primaryColor,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500, fontSize: 16.0),
                            ),

                            order.rating != null ? Row(
                              children: <Widget>[
                                SizedBox(width: 8.0,),
                                Icon(Icons.star, color: Colors.amber, size: 14.0,),
                                Text(
                                  "${order.rating}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 14.0, color: Colors.amber),
                                ),
                              ],
                            ) : SizedBox(),
                          ],
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
                        Text(
                          order.nameClient.toUpperCase(),
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16.0),
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        Text(
                          order.address,
                          style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 14.0),
                        ),
                        Text(
                          "Número: " + order.number,
                          style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 14.0),
                        ),
                        Container(
                          width: 230.0,
                          child: Text(
                            "Complemento: " + order.complement,
                            maxLines: 3,
                            style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 14.0),
                          ),
                        ),
                        Text(
                          "Bairro: " + order.neighborhood,
                          style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 14.0),
                        ),
                        order.status != StatusOrder.CANCELED.index ? SizedBox() :
                        Text(
                          "Motivo: " + order.reason,
                          style: TextStyle(
                              fontWeight: FontWeight.w300
                              , fontSize: 14.0),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    )

          ),
          shape: RoundedRectangleBorder(
              side: new BorderSide(color: Colors.black12, width: 2.0)),
        ));
  }

}
