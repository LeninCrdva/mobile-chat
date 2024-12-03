import 'package:objectbox/objectbox.dart';
import 'package:simple_chat/main.dart';
import 'package:simple_chat/src/model/user.dart';
import 'package:simple_chat/src/storage/token.dart';

class SingleInstance {
  static final Box<Token> tokenBox = objectBox.store.box<Token>();
  static final Box<User> userBox = objectBox.store.box<User>();
}