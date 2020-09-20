import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:offer_today/mixins/posts_mixin.dart';
import 'package:offer_today/widgets/popup_dialog/popup_dialog.dart';

class ManagePost extends StatefulWidget {
  @override
  _ManagePostState createState() => _ManagePostState();
}

class _ManagePostState extends State<ManagePost> with PostMixin {
  List<Map<String, dynamic>> _items = [];
  TextEditingController _name = TextEditingController(text: "");
  bool _loading = false;

  void initFun() async {
    try {
      setState(() {
        _loading = true;
      });
      final res = await this.getTags();
      setState(() {
        _loading = false;
        _items = res;
      });
    } catch (err) {
      print("ERR: err");
    }
  }

  void _saveTag() async {
    try {
      setState(() {
        _loading = true;
      });
      final res = await this.createTag(_name.text);
      print(res);
      setState(() {
        _name.text = "";
      });
      this.initFun();
    } catch (err) {
      print("[ERR]$err");
    }
  }

  void _deleteTag(String id) async {
    try {
      setState(() {
        _loading = true;
      });
      final res = await this.deleteTag(id);
      print(res);
      this.initFun();
    } catch (err) {
      print(err);
    }
  }

  @override
  void initState() {
    super.initState();
    this.initFun();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 120.0,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                    children: _items
                        .map(
                          (item) => Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 0, horizontal: 20.0),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text("#${item['name']}"),
                                    IconButton(
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        onPressed: () =>
                                            _deleteTag(item["id"])),
                                  ],
                                ),
                                Divider(),
                              ],
                            ),
                          ),
                        )
                        .toList()),
              )
            ],
          ),
        ),
        PopupDialog(show: _loading, text: "loading"),
        Theme(
          data: ThemeData(
            brightness: Brightness.light,
          ),
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 10.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  // borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(1.0, 1.0),
                      blurRadius: 1.0,
                    ),
                  ],
                ),
                child: Column(
                  children: <Widget>[
                    TextField(
                      controller: _name,
                      onChanged: (val) {
                        print("Name ${_name.text}");
                      },
                      decoration: InputDecoration(
                          hintText: "Create new tags",
                          border: OutlineInputBorder()),
                    ),
                    RaisedButton(
                      onPressed: _saveTag,
                      child: Text("Add"),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Container(),
              ),
            ],
          ),
        )
      ],
    );
  }
}
