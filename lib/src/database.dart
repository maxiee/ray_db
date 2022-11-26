import 'dart:io';

import 'package:ray_db/ray_db.dart';
import 'package:ray_db/src/collection.dart';
import 'package:sqlite3/sqlite3.dart' as sq;

class Database {
  sq.Database db;

  Database(this.db) {}

  Collection collection(String collection) {
    return Collection(collection, db);
  }

  bool hasCollection(String collection) {
    return Collection.hasCollection(db, collection);
  }
}

Future<Database> openDatabase(File dbFile) async {
  final dbSQLite = sq.sqlite3.open(dbFile.path);
  return Database(dbSQLite);
}
