import 'dart:async';

import 'package:news_apps_flutter/src/db/repository.dart';
import 'package:news_apps_flutter/src/models/items_model.dart';
import 'package:rxdart/rxdart.dart';

class NewsBloc {
  static final _repository = Repository();
  BehaviorSubject<List<int>> _topIds = BehaviorSubject<List<int>>();
  PublishSubject<int> _itemId = PublishSubject<int>();

  //get for sink
  Function(int) get itemId => _itemId.sink.add;

  // Stream<List<int>> get  topIds => _topIds.stream;
  Stream<Map<int, Future<ItemModel>>> get itemStream =>
      _topIds.stream.transform(_itemTransform());

  fetchTopIds() async {
    final list = await _repository.fetchTopIds();
    _topIds.sink.add(list);
  }

  Stream<List<int>> get topIds => _topIds.stream;

  get notIdealStream => _itemId.stream.transform(_itemTransformer);

  final _itemTransformer =
      StreamTransformer<int, Future<ItemModel>>.fromHandlers(
          handleData: (id, sink) {
    var item = _repository.fetchItem(id);
    sink.add(item);
  });

  _itemTransform() {
    return ScanStreamTransformer(
        (Map<int, Future<ItemModel>> cache, id, index) {
      cache[id] = _repository.fetchItem(id);
      return cache;
    }, <int, Future<ItemModel>>{});
  }

  dispose() {
    _topIds.close();
    _itemId.close();
  }
}
