import 'package:sqlite3/sqlite3.dart' as sq;

class Database {
  sq.Database db;

  Database(this.db);

  collection(String collection) {
    if (collection.contains(';') || collection.contains(' ')) {
      throw const FormatException();
    }
    db.execute(
        'CREATE TABLE IF NOT EXISTS $collection (id INTEGER PRIMARY KEY)');
  }

  hasCollection(String collection) {
    final ret = db.select(
        'SELECT name FROM sqlite_master WHERE type=\'table\' AND name=?',
        [collection]);
    print(ret);
    return ret.isNotEmpty;
  }
}
