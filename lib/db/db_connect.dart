import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:voice_record/db/record_db.dart';
import 'package:path/path.dart';

class RecordProvider {
  late Database db;
  String table = "records";
  RecordedAudio recordedAudio;
  RecordProvider({required this.recordedAudio});

  Future _open() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'demo.db');
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
create table $table ( 
  ID integer primary key autoincrement, 
  TEXT text not null,
  SENTIMENT text not null,
  DATE text not null)
''');
    });
  }

  Future<RecordedAudio> insert(RecordedAudio record) async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'demo.db');
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
create table $table ( 
  ID integer primary key autoincrement, 
  TEXT text not null,
  SENTIMENT text not null,
  DATE text not null)
''');
    });
    record.id = await db.insert(table, record.toMap());
    return record;
  }

  Future<List<Map<String, dynamic>>> getAllRecords() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'demo.db');
    db = await openDatabase(path, version: 1);
    List<Map<String, dynamic>> list =
        await db.rawQuery('SELECT * FROM records');
    list.forEach((element) {
      print(element);
    });
    return list;
  }

  Future<RecordedAudio?> getRecords(int id) async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'demo.db');
    db = await openDatabase(path, version: 1);
    List<Map<String, dynamic>> maps = await db.query(table,
        columns: ['ID', 'TEXT', 'SENTIMENT', 'DATE'],
        where: 'ID = ?',
        whereArgs: [id]);
    if (maps.isNotEmpty) {
      return RecordedAudio.fromMap(maps.first);
    }
    return null;
  }

  // Future<int> delete(int id) async {
  //   return await db.delete(tableTodo, where: '$columnId = ?', whereArgs: [id]);
  // }

  // Future<int> update(Todo todo) async {
  //   return await db.update(tableTodo, todo.toMap(),
  //       where: '$columnId = ?', whereArgs: [todo.id]);
  // }

  Future close() async => db.close();
}
