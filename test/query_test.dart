import 'package:flutter_test/flutter_test.dart';
import 'package:ray_db/src/collection.dart';
import 'package:ray_db/src/database.dart';
import 'package:sqlite3/sqlite3.dart' as sq;

void main() {
  late sq.Database sdb;
  late Database db;
  late Collection collection;

  setUp(() {
    sdb = sq.sqlite3.openInMemory();
    db = Database(sdb);
    collection = db.collection('test');
  });

  test('test equal string', () {
    collection.storeMap({'name': 'maeiee', 'career': 'coder'});
    final builder =
        collection.where().eq('name', 'maeiee').eq('career', 'coder');
    expect(builder.toSQL(),
        'SELECT id,name,career FROM test WHERE name = \'maeiee\' AND career = \'coder\';');
    expect(builder.findAll(), [
      {'id': 1, 'name': 'maeiee', 'career': 'coder'}
    ]);
  });

  test('test equal string2', () {
    collection.storeMap({'name': 'maeiee', 'career': 'coder'});
    final builder = collection.where().eq('name', 'maeiee');
    expect(builder.toSQL(),
        'SELECT id,name,career FROM test WHERE name = \'maeiee\';');
    expect(builder.findAll(), [
      {'id': 1, 'name': 'maeiee', 'career': 'coder'}
    ]);
  });

  test('test empty query', () {
    collection.storeMap({'name': 'maeiee', 'career': 'coder'});
    final builder = collection.where();
    expect(builder.toSQL(), 'SELECT id,name,career FROM test;');
    expect(builder.findAll(), [
      {'id': 1, 'name': 'maeiee', 'career': 'coder'}
    ]);
  });
}
