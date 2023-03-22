import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:voice_record/db/record_db.dart';
import 'package:path/path.dart';

class RecordProvider {
  late Database db;
  String table = "records";
  RecordedAudio? recordedAudio;
  RecordProvider({this.recordedAudio});

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

  Future<List> getRec() async {
    var databasesPath = await getDatabasesPath();
    List recs_id = [];
    List recs_sent = [];
    String path = join(databasesPath, 'demo.db');
    db = await openDatabase(path, version: 1);
    List<Map<String, dynamic>> list =
        await db.rawQuery('SELECT * FROM records');
    int count = 0;
    list.forEach((element) {
      if (count < 100) {
        recs_id.add(element["ID"]);
        if (element["SENTIMENT"] == "POSITIVE") {
          recs_sent.add(1);
        } else if (element["SENTIMENT"] == "NEGATIVE") {
          recs_sent.add(-1);
        } else {
          recs_sent.add(0);
        }
        count += 1;
      }
    });
    return recs_sent;
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
