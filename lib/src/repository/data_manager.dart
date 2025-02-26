import 'dart:async';

import 'package:simple_chat/main.dart';
import 'package:simple_chat/objectbox.g.dart';
import 'package:simple_chat/src/model/chat.dart';
import 'package:simple_chat/src/model/message.dart';

class DataManager<T>{
  late final Box<T> _box;

  DataManager(this._box);

  void addItem(T item) {
    _box.put(item);

    if (T == Message) {
      _forceUpdate(item);
    }
  }

  void addItems(List<T> items, {bool removeAll = false}) {
    _box.putMany(items);

    if (T == Message) {
      for (var item in items) {
        _forceUpdate(item);
      }
    }
  }

  void removeItem(int idItem) {
    _box.remove(idItem);
  }

  void removeItems() {
    _box.removeAll();
  }

  Stream<List<T>> getDataByIdOrNotAsStream([int idItem = 0]) {
    if (T == Message && idItem != 0) {
      Box<Message> intBox = _box as Box<Message>;
      return intBox.query(Message_.chat.equals(idItem)).watch(triggerImmediately: true).map((query) => query.find().cast<T>());
    }

   return _box.query().watch(triggerImmediately: true).map((query) => query.find());
  }

  void _forceUpdate(T item) {
    Box<Chat> chatBox = objectBox.store.box<Chat>();
    final message = item as Message;

    final chat = message.chat.target;
    chat?.messages.add(message);
    chatBox.put(chat!);
  }
}
