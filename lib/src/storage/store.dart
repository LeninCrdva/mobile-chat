import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:simple_chat/objectbox.g.dart';

class ObjectBox {
  late final Store store;
  late final Admin? admin;

  ObjectBox._create(this.store) {
    if (Admin.isAvailable()) {
      admin = Admin(store);
    }
  }

  static Future<ObjectBox> create() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final store = await openStore(directory: p.join(docsDir.path, 'objectbox'));
    return ObjectBox._create(store);
  }
}