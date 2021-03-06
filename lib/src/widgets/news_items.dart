import 'package:flutter/material.dart';
import 'package:news_apps_flutter/src/blocs/news_bloc_provider.dart';
import 'package:news_apps_flutter/src/blocs/news_bloc.dart';
import 'package:news_apps_flutter/src/models/items_model.dart';
import 'package:news_apps_flutter/src/widgets/loading_container.dart';

class NewsItem extends StatelessWidget {
  final int id;
  NewsItem({this.id});
  @override
  Widget build(BuildContext context) {
    final NewsBloc bloc = NewsBlocProvider.of(context);
    return StreamBuilder(
      stream: bloc.itemStream,
      builder: (context, AsyncSnapshot<Map<int, Future<ItemModel>>> snapshot) {
        print("It is called stream");
        if (!snapshot.hasData) {
          return LoadingContainer();
        }
        return FutureBuilder(
          future: snapshot.data[id],
          builder: (context, AsyncSnapshot<ItemModel> sn) {
            if (!sn.hasData) {
              return LoadingContainer();
            }
            return buildItem(sn.data);
          },
        );
      },
    );
  }

  Widget buildItem(ItemModel data) {
    return Card(
      child: ListTile(
        onTap: () {
          
        },
        title: Text(data.title),
        subtitle: Text("${data.score} votes"),
        trailing: Column(children: <Widget>[
          Icon(Icons.comment),
          Text("${data.descendants}"),
        ]),
      ),
    );
  }
}
