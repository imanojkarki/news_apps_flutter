import 'package:flutter/material.dart';
import 'package:news_apps_flutter/src/blocs/news_bloc_provider.dart';
import 'package:news_apps_flutter/src/blocs/news_bloc.dart';
import 'package:news_apps_flutter/src/models/items_model.dart';

class NewsItem extends StatelessWidget {
  final int id;
  NewsItem({this.id});
  @override
  Widget build(BuildContext context) {
    final NewsBloc bloc = NewsBlocProvider.of(context);

    return StreamBuilder(
      stream: bloc.notIdealStream,
      builder: (context, AsyncSnapshot<Future<ItemModel>> snapshot) {
        if (!snapshot.hasData) {
          return Text("Still loading data");
        }
        return FutureBuilder(
          future: snapshot.data,
          builder: (c, AsyncSnapshot<ItemModel> sn) {
            if (!sn.hasData) {
              return Text("Still loading data from future");
            }
            print("The title ${sn.data.title}");
            return Text(sn.data.title);
          },
        );
      },
    );
  }
}
