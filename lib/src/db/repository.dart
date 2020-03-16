import 'package:news_apps_flutter/src/db/api_provider.dart';
import 'package:news_apps_flutter/src/db/db_provider.dart';
import 'package:news_apps_flutter/src/db/sources.dart';
import 'package:news_apps_flutter/src/models/items_model.dart';

class Repository {
  List<Sources> sources = [dbProvider, ApiProvider()];
  List<Cache> caches = [dbProvider];

  /*
  final dbProvider = DbProvider();
  final apiProvider = ApiProvider();
  */

  Future<List<int>> fetchTopIds() async {
    return await sources[1].fetchTopIds();
  }

  Future<ItemModel> fetchItem(int id) async {
    // int row = 0;
    Sources source;
    ItemModel item;
    for (source in sources) {
      item = await source.fetchItem(id);
      if (item != null) {
        break;
      }
      // row = row + 1;
    }
    // if (item != null && row > 0) {
    //   source.insertItem(item);
    // }

    // for (var origin in sources) {
    //   if (source != origin as Sources) {
    //     origin.insertItem(item);
    //   }
    // }
    for (var origin in caches) {
      if (source != origin as Sources) {
        origin.insertItem(item);
      }
    }
    print(item.toJson());
    return item;
  }

  clearData() async {
    for (var c in caches) {
      c.clearData();
    }
  }
}
