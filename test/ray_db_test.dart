import 'package:flutter_test/flutter_test.dart';
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
}
