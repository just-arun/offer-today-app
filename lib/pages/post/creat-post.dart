import 'package:flutter/material.dart';

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:offer_today/mixins/posts_mixin.dart';
import 'package:offer_today/services/config/app_config.dart';
import 'package:offer_today/services/modules/image_upload_service.dart';

class Tag {
  final String id;
  final String name;
  const Tag({this.id, this.name});
}

class CreatePost extends StatefulWidget {
  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> with PostMixin {
  File _image;
  String _imagePath = "";
  final _formKey = GlobalKey<FormState>();
  String _description = "";
  String _title = "";
  String _selectedTag = "Select Tag";
  List<String> _postTags = [];
  List<Map<String, dynamic>> _tagItems = [];

  Future _getImage() async {
    var _picker = ImagePicker();
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final File file = File(pickedFile.path);
      print(file);
      setState(() {
        _image = file;
      });
      this._saveImage();
    }
  }

  Widget showImage() {
    return Container(
      constraints: BoxConstraints(
        maxWidth: 300.0,
        maxHeight: 300.0,
      ),
      child: Image.network(
        "${Config.baseUrl}/$_imagePath",
        errorBuilder: (context, error, stackTrace) => new Icon(Icons.error),
      ),
    );
  }

  void _saveImage() async {
    await FileUpload().upload(_image).then((res) {
      print(res);
      setState(() {
        _imagePath = res;
      });
    });
  }

  String _getTagId() {
    var tagID = "";
    this._tagItems.forEach((ele) {
      if (ele["name"] == this._selectedTag) {
        tagID = ele["id"];
        print("selected Id ${ele['id']}");
      }
    });
    return tagID;
  }

  void _getTags() async {
    try {
      final result = await this.getTags();
      final List<String> tags = ["Select Tag"];
      result.forEach((ele) {
        tags.add(ele["name"]);
      });
      setState(() {
        _tagItems = result;
        _postTags = tags;
      });
    } catch (err) {
      print(err);
    }
  }

  Widget _postImage() {
    print("image type ${_imagePath.runtimeType}");
    return (_imagePath != null && _imagePath != "")
        ? this.showImage()
        : RaisedButton.icon(
            shape: StadiumBorder(),
            onPressed: () => _getImage(),
            icon: Icon(Icons.camera_front),
            label: Text(
              "Post Picture",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
              ),
            ),
          );
  }

  Widget _formInput(String label, String controll, int lines,
      void Function(String val) onChange, String Function(String) validator) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "$label",
          style: GoogleFonts.poppins(
              fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.grey),
        ),
        TextFormField(
          onChanged: (value) => onChange(value),
          maxLines: lines,
          validator: validator,
          decoration: InputDecoration(
            hintText: "$label",
            hintMaxLines: 200,
            helperMaxLines: 50,
          ),
        ),
      ],
    );
  }

  void _savePost() async {
    if (_formKey.currentState.validate()) {
      if (this._imagePath == null) {
        return;
      }
      String tagId = this._getTagId();
      print(tagId);
      await this
          .createPost(
            this._description,
            this._imagePath,
            this._title,
            tagId,
          )
          .then((res) => {Navigator.of(context).popAndPushNamed("/home")});
    }
  }

  @override
  void initState() {
    this._getTags();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("New Post"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 20.0,
              ),
              Container(
                constraints: BoxConstraints(minHeight: 100.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _postImage(),
                  ],
                ),
              ),
              DropdownButton(
                value: _selectedTag,
                items: _postTags.map<DropdownMenuItem<String>>((String item) {
                  return DropdownMenuItem<String>(
                    child: Text("$item"),
                    value: item,
                  );
                }).toList(),
                onChanged: (val) {
                  setState(() {
                    _selectedTag = val;
                  });
                },
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 30.0,
                ),
                child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        _formInput("Post Title", _title, 1, (val) {
                          this._title = val;
                        }, (val) {
                          if (val == null) {
                            return "title is required";
                          }
                          if (val.length < 5) {
                            return "title should be atleast 5 charaters long";
                          }
                          return null;
                        }),
                        SizedBox(
                          height: 20.0,
                        ),
                        _formInput("Post Description", _description, 5, (val) {
                          this._description = val;
                        }, (val) {
                          if (val == null) {
                            return "description is required";
                          }
                          if (val.length < 20 || val.length > 300) {
                            print("charLen: ${val.length}");
                            return "description should be between 20 to 300 charaters long";
                          }
                          return null;
                        }),
                      ],
                    )),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    RaisedButton(
                      onPressed: _savePost,
                      child: Text(
                        "SAVE",
                        style: GoogleFonts.poppins(),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
