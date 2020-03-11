import 'dart:async';

import 'package:news_apps_flutter/src/db/repository.dart';
import 'package:news_apps_flutter/src/models/items_model.dart';
import 'package:rxdart/rxdart.dart';

class NewsBloc {
  static final _repository = Repository();
  BehaviorSubject<List<int>> _topIds = BehaviorSubject<List<int>>();

  BehaviorSubject<int> _itemId = BehaviorSubject<int>();
//getter for sink
  Function(int) get itemId => _itemId.sink.add;

  Stream<List<int>> get topIds => _topIds.stream;

  Stream<Map<int, Future<ItemModel>>> itemStream;

  ///not ideal
  ///todo remove this
  // Stream<ItemModel> notIdealStream;
  NewsBloc() {
    // notIdealStream = _itemId.stream.transform(_itemTransformer);
    itemStream = _itemId.stream.transform(_itemTransform());
  }

  /* 
  final _itemTransformer = StreamTransformer<int, ItemModel>.fromHandlers(
    handleData: (id, sink) {
      final ItemModel item = ItemModel(id: id, title: 'some title $id');
      sink.add(item);
    },
  );
  */

  fetchTopIds() async {
    final list = await _repository.fetchTopIds();
    _topIds.sink.add(list);
  }

  _itemTransform() {
    return ScanStreamTransformer(
        (Map<int, Future<ItemModel>> cache, int id, index) {
      cache[id] = _repository.fetchItem(id);
      return cache;
    }, <int, Future<ItemModel>>{});
  }

  dispose() {
    _topIds.close();
    _itemId.close();
  }
}
