import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:voice_record/views/record_list_view.dart';

class RecordView extends StatefulWidget {
  const RecordView({super.key});

  @override
  State<RecordView> createState() => _RecordViewState();
}

class _RecordViewState extends State<RecordView> {
  List<String> records = [];
  List<String> recordList = [];
  @override
  void initState() {
    initStuff();
    print("recccord: $recordList");
    super.initState();
  }

  void initStuff() async {
    final dir = Directory('/data/user/0/com.example.voice_record/app_flutter');
    final List<FileSystemEntity> entities = await dir.list().toList();
    print(entities);
    entities.forEach((element) {
      if (element.toString().contains('.wav')) {
        records.add(element.toString());
      }
    });
    setState(() {
      recordList = records;
    });
    print("recordsssss: ${records}");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(children: [
          Expanded(
            flex: 2,
            child: RecordListView(
              records: records,
            ),
          ),
        ]),
      ),
    );
  }
}
