import 'package:ray_db/src/collection.dart';
import 'package:sqlite3/sqlite3.dart' as sq;

class Database {
  sq.Database db;

  Database(this.db) {}

  collection(String collection) {
    return Collection(collection, db);
  }

  bool hasCollection(String collection) {
    return Collection.hasCollection(db, collection);
  }
}
