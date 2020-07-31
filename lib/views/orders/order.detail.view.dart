import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:aqui_tem_deliveryman/models/entities/order.entities.dart';
import 'package:aqui_tem_deliveryman/enums/method.payment.enum.dart';
import 'package:aqui_tem_deliveryman/enums/status.order.enum.dart';
import 'package:aqui_tem_deliveryman/views/orders/order.items.tile.view.dart';

class OrderDetailView extends StatefulWidget {
  final OrderData order;
  OrderDetailView(this.order);

  @override
  _OrderDetailViewState createState() => _OrderDetailViewState(this.order);
}

class _OrderDetailViewState extends State<OrderDetailView> {
  final OrderData order;
  DateTime date;
  StatusOrder statusOrder;
  _OrderDetailViewState(this.order);


  @override
  void initState() {
    // TODO: implement initState
    date = order.dateCreate.toDate();
    statusOrder = StatusOrder.values[order.status];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Pedido"),
          centerTitle: true,
        ),
        body: Card(
            margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child:ListView(
                  scrollDirection: Axis.vertical,
                  children: <Widget>[
                    _detailOrder(),
            ])),
            shape: RoundedRectangleBorder(
                side: new BorderSide(color: Colors.black12, width: 2.0)),
          ),
        );
  }

  Widget _detailOrder(){
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Pedido ${order.orderCode}",
          style: TextStyle(
              fontWeight: FontWeight.w500, fontSize: 16.0),
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
        Divider(),
        ListView.builder(
          shrinkWrap: true,
          physics: new NeverScrollableScrollPhysics(),
          itemCount: order.items.length,
          itemBuilder: (BuildContext ctxt, int index) {
            return ItemOrderTileView(order.items[index]);
          },
        ),
        SizedBox(
          height: 8.0,
        ),
        Text(
          "Cliente: ${order.nameClient.toUpperCase()}",
          style: TextStyle(
              fontWeight: FontWeight.w500, fontSize: 16.0),
        ),
        SizedBox(
          height: 8.0,
        ),
        Text(
          order.address,
          style: TextStyle(
              fontWeight: FontWeight.w300, fontSize: 14.0),
        ),
        Text(
          "Número: " + order.number,
          style: TextStyle(
              fontWeight: FontWeight.w300, fontSize: 14.0),
        ),
        Container(
          width: 230.0,
          child: Text(
            "Complemento: " + order.complement,
            maxLines: 3,
            style: TextStyle(
                fontWeight: FontWeight.w300, fontSize: 14.0),
          ),
        ),
        Text(
          "Bairro: " + order.neighborhood,
          style: TextStyle(
              fontWeight: FontWeight.w300, fontSize: 14.0),
        ),
        FlatButton(
          child: Text(
            "Telefone: " + order.phone,
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14.0,
                color: Theme.of(context).primaryColor),
          ),
          textColor: Colors.blue,
          padding: EdgeInsets.zero,
          onPressed: () {
            launch("tel:${order.phone}");
          },
        ),
        Divider(),


        Text(
          'Resumo do Pedido',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        SizedBox(
          height: 12.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('SubTotal'),
            Text('R\$ ${order.productsPrice.toStringAsFixed(2)}')
          ],
        ),
        Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('Desconto'),
            Text('R\$ ${order.discount.toStringAsFixed(2)}')
          ],
        ),
        Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('Taxa de entrega'),
            Text(
              order.shipPrice == 0
                  ? "Grátis"
                  : 'R\$ ${order.commissionDelivery.toStringAsFixed(2)}',
              style: TextStyle(
                  color: order.shipPrice == 0
                      ? Colors.green
                      : Colors.black),
            )
          ],
        ),
        Divider(),
        SizedBox(
          height: 12.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'Total',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            Text(
              'R\$ ${order.amount.toStringAsFixed(2)}',
              style: TextStyle(color: Colors.black, fontSize: 16.0),
            ),
          ],
        ),

        Divider(),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(order.payment.inDelivery ?  'Pagamento na entrega' : "Crédito pelo Aqui Tem",
                style: TextStyle(fontWeight: FontWeight.w500, color: order.payment.inDelivery ? Colors.red : Colors.black87)),
            order.payment.image != null
                ? Image.asset(
              order.payment.image,
              width: 25,
              height: 25,
              fit: BoxFit.contain,
            )
                : SizedBox(),
          ],
        ),

        order.payment.method.toUpperCase() == MethodPayment.MONEY ?
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text('Troco: ', style: TextStyle(fontWeight: FontWeight.w500)),
            Text(order.change == 0 ? 'Não precisa' : "para R\$${order.change.toStringAsFixed(2)}", style: TextStyle(fontWeight: FontWeight.w400)),

          ],
        ) : SizedBox(),
        Divider(),

        SizedBox(
          height: 5.0,
        ),
        Text(
          'Histórico',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        SizedBox(
          height: 12.0,
        ),
        Text(order.historicText),
        Divider(),
      ],

    );
  }

}
