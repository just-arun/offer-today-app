import 'package:flutter/material.dart';

class PopupDialog extends StatelessWidget {
  bool show;
  String text;
  PopupDialog({
    @required this.show,
    @required this.text,
  });
  @override
  Widget build(BuildContext context) {
    return show ? Container(
      color: Color.fromRGBO(0, 0, 0, 0.2),
      height: double.infinity,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 18.0,
              vertical: 20.0,
            ),
            margin: EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(5.0),
              ),
            ),
            child: Row(
              children: <Widget>[
                CircularProgressIndicator(),
                SizedBox(width: 20.0),
                Text("$text", style: TextStyle(fontSize: 17.0))
              ],
            ),
          )
        ],
      ),
    ) : SizedBox();
  }
}
