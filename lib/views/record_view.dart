import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
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
  List<Reference> references = [];
  List<String> recordList = [];
  @override
  void initState() {
    super.initState();
    _onUploadComplete();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    initStuff();
  }

  void initStuff() async {
    _onUploadComplete();
    final dir = Directory('/data/user/0/com.example.voice_record/app_flutter');
    final List<FileSystemEntity> entities = await dir.list().toList();
    print(entities);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Expanded(
          flex: 2,
          child: RecordListView(
            references: references,
            recordList: recordList,
          ),
        ),
      ]),
    );
  }

  Future<void> _onUploadComplete() async {
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    ListResult listResult = await firebaseStorage.ref().child('uploads').list();
    List<String> records = [];
    for (int i = 0; i < listResult.items.length; i++) {
      records.add(await listResult.items[i].getDownloadURL());
    }
    setState(() {
      references = listResult.items;
      recordList = records;
    });
  }
}
