import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:get/get_connect/http/src/status/http_status.dart';

class Server {
  Future<void> initServer(String filename, String file) async {
    var server = await HttpServer.bind('localhost', 8085);
    print(server.address.toString());
    try {
      var request =
          http.MultipartRequest("POST", Uri.parse("http://127.0.0.1"));
      request.fields["audiofieldName"] = "name";
      request.fields["dateCreated"] = "date";
      Map<String, String> headers = {'Authorization': '', 'clientId': ''};
      request.headers.addAll(headers);
      var audio = http.MultipartFile.fromBytes(
          'audio', (await rootBundle.load(filename)).buffer.asUint8List(),
          filename: file);
      request.files.add(audio);
      var response = await request.send();
      var responseData = await response.stream.toBytes();
      var result = String.fromCharCodes(responseData);
      print(result);
    } catch (e) {
      print(e.toString());
    }
    // server.listen((request) async {
    //   if (request.uri.path != '/upload') {
    //     List<int> dataBytes = [];
    //     await for (var data in request) {
    //       dataBytes.addAll(data);
    //     }
    //     String? boundary = request.headers.contentType!.parameters['boundary'];
    //     final transformer = MimeMultipartTransformer(boundary);
    //     final bodyStream = Stream.fromIterable([dataBytes]);
    //     final parts = await transformer.bind(bodyStream).toList();
    //     for (var part in parts) {
    //       print(part.headers);
    //       final contentDisposition = part.headers['content-disposition'];
    //       final content = await part.toList();
    //       await File().writeAsBytes(content[0]);
    //     }
    //   }
    //   await request.response.close();
    // });
  }
}
