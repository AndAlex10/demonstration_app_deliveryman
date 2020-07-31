import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class WidgetsCommons {
  static Widget createTextFormField(String labelText, String textReturn,
      TextEditingController controller, bool valida, bool enabled) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.black38),
      ),
      enabled: enabled,
      validator: (text) {
        if (text.isEmpty && valida) return textReturn; else return null;
      },
    );
  }

  static void onSucess(GlobalKey<ScaffoldState> scaffoldKey, String text) {
    scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(text),
      backgroundColor: Color.fromARGB(255, 0, 205, 102),
      duration: Duration(seconds: 2),
    ));
  }

  static void onFail(GlobalKey<ScaffoldState> scaffoldKey, String text) {
    scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(text),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 4),
    ));
  }

  static void onGeneric(GlobalKey<ScaffoldState> scaffoldKey, String text, Color color) {
    scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(text),
      backgroundColor: color,
      duration: Duration(seconds: 2),
    ));
  }

  static Color buttonColor() {
    return Color.fromARGB(255, 251, 116, 2);
  }

  static Color labelColor() {
    return Color.fromARGB(255, 128, 0, 0);
  }


  static Widget optionTileButton(
      BuildContext context, String title, Widget widget, Icon icon) {
    return Card(
        child: ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    IconButton(
                      icon: icon,
                      color: Colors.black45,
                      onPressed: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) => widget));
                      },
                    ),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                  ],),

                IconButton(
                  icon: Icon(Icons.arrow_forward_ios, size: 20.0),
                  color: WidgetsCommons.buttonColor(),
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) => widget));
                  },
                ),
              ],
            )));
  }



  static Widget buildCircle(String title, bool small, bool complete){
    return Padding(
        padding: EdgeInsets.only(
          left: small ? 3 : 0,
        ),
        child: Row(
          children: <Widget>[
            CircleAvatar(
              radius: small ? 4.0 : 7.0,
              backgroundColor: complete ? WidgetsCommons.buttonColor() : Colors.grey[500],
            ),
            SizedBox(width: 5.0,),
            Expanded(child: Text(title, style: TextStyle(fontWeight: small ? FontWeight.w400 : FontWeight.w500),))
          ],
        ));
  }

  static Widget buildLine(){
    return
      Padding(
        padding: const EdgeInsets.only(
          left: 6,
        ),
        child: Container(
          padding: const EdgeInsets.all(0),
          width: 2,
          height: 20,
          color: Colors.grey[500],
        ),
      );
  }

  static message(BuildContext context, message, bool erro) async {
    return Alert(
      context: context,
      type: erro ? AlertType.error : AlertType.success,
      title: message,
      buttons: [
        DialogButton(
          child: Text(
            "Fechar",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          color: WidgetsCommons.buttonColor(),
          onPressed: () {
            Navigator.of(context).pop();
          },
          width: 120,
        )
      ],
    ).show();
  }


  static Widget widgetCheckBox(bool value, Function onChangedExecute, String label){
    return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Checkbox(
            value: value,
            activeColor: WidgetsCommons.buttonColor(),
            onChanged: (bool value) async {
              onChangedExecute(value);
            },
          ),
          Text(
            label,
            style: TextStyle(fontSize: 17.0),
          )
        ]
    );
  }

  static Widget widgetDate(String labelText, String dateFormatter,
      VoidCallback updateDate, bool enabled) {
    return Container(
        padding: EdgeInsets.fromLTRB(12.0, 0.0, 20.0, 0.0),
        child: new InkWell(
          onTap: enabled
              ? () async {
            updateDate();
          }
              : null,
          child: new InputDecorator(
            decoration: new InputDecoration(
                labelText: labelText, labelStyle: TextStyle(fontSize: 25.0)),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new Text(
                  dateFormatter,
                  style: TextStyle(fontSize: 18.0),
                ),
                new Icon(Icons.arrow_drop_down,
                    color: Colors.grey.shade700),
              ],
            ),
          ),
        ));
  }


  static Future<DateTime> getShowDate(BuildContext context) async {
    return await showDatePicker(
        context: context,
        firstDate: DateTime(1900),
        initialDate: DateTime.now(),
        lastDate: DateTime(2100));
  }
}