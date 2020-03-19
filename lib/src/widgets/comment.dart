import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:news_apps_flutter/src/models/items_model.dart';
import 'package:news_apps_flutter/src/widgets/loading_container.dart';
import 'package:flutter_html/flutter_html.dart';

class Comment extends StatelessWidget {
  final int commentId;
  final Map<int, Future<ItemModel>> map;
  final int depth;

  const Comment({this.commentId, this.map, this.depth});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: map[commentId],
      builder: (BuildContext context, AsyncSnapshot<ItemModel> snapshot) {
        if (!snapshot.hasData) {
          return LoadingContainer();
        }
        return Column(children: <Widget>[
          buildText(snapshot.data), // recursive commment fetching
          Divider(),
          ...snapshot.data.kids.map((kidId) {
            return Comment(
              commentId: kidId,
              map: map,
              depth: depth + 1,
            );
          }).toList()
        ]);
      }, // builder
    );
  }

  buildText(ItemModel data) {
    return ListTile(
      title: Html(data: data.text ?? ""),
      subtitle: Text(data.text == null ? 'Deleted' : 'By: ${data.by}'),
      contentPadding: EdgeInsets.only(right: 16, left: depth * 16.0),
    );
  }
}
