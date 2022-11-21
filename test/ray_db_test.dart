import 'package:flutter_test/flutter_test.dart';
import 'package:ray_db/src/collection.dart';
import 'package:ray_db/src/column.dart';
import 'package:ray_db/src/constants.dart';
import 'package:ray_db/src/database.dart';
import 'package:sqlite3/sqlite3.dart' as sq;

void main() {
  late sq.Database sdb;
  late Database db;

  setUp(() {
    sdb = sq.sqlite3.openInMemory();
    db = Database(sdb);
  });
  tearDown(() => sdb.dispose());

  test('test hasCollection', () async {
    expect(db.hasCollection('test'), false);
    db.collection('test');
    expect(db.hasCollection('test'), true);
  });

  test('test init collection columns', () async {
    Collection collection = db.collection('test');
    expect(collection.columns.containsKey('id'), true);
    Column column = collection.columns['id']!;
    expect(column.name, 'id');
    expect(column.type, DataType.INTEGER);
    expect(column.notNull, false);
    expect(column.defaultValue, null);
    expect(column.primaryKey, true);
  });

  test('test hasCollection', () async {
    expect(db.hasCollection('test'), false);
    db.collection('test');
    expect(db.hasCollection('test'), true);
    final stmt = db.db.prepare("PRAGMA table_list;");
    final ret = stmt.select();
    print(ret);
  });
}
