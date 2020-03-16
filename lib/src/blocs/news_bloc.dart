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

  // Stream<Map<int, Future<ItemModel>>> itemStream;

  BehaviorSubject<Map<int, Future<ItemModel>>> _itemStream =
      BehaviorSubject<Map<int, Future<ItemModel>>>();

  Stream<Map<int, Future<ItemModel>>> get itemStream => _itemStream.stream;

  ///not ideal
  ///todo remove this
  // Stream<ItemModel> notIdealStream;
  NewsBloc() {
    // notIdealStream = _itemId.stream.transform(_itemTransformer);
    _itemId.stream.transform(_itemTransform()).pipe(_itemStream);
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
      print("It is called $index times");
      cache[id] = _repository.fetchItem(id);
      return cache;
    }, <int, Future<ItemModel>>{});
  }

  clearData() async {
    return _repository.clearData();
  }

  dispose() {
    _topIds.close();
    _itemId.close();
    _itemStream.close();
  }
}
