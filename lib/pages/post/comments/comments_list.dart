import 'package:flutter/material.dart';
import 'package:offer_today/mixins/posts_mixin.dart';

class CommentList extends StatefulWidget {
  final String postId;
  CommentList({@required this.postId});

  @override
  _CommentListState createState() => _CommentListState();
}

class _CommentListState extends State<CommentList> with PostMixin {
  void initFun() async {
    try {
      final data = await this.getComments(widget.postId);
      print(data);
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
    return ListView(
      children: <Widget>[],
    );
  }
}
