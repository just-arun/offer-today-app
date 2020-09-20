import 'dart:convert';

import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:offer_today/services/config/app_config.dart';
import 'package:offer_today/services/config/service_config.dart';


class FileUpload {
  final _apiService = HttpService();

  Future<dynamic> upload(File file) async {
    //create multipart request for POST or PATCH method
    var request = http.MultipartRequest(
        "POST", Uri.parse(Config.baseUrl + "/file-upload"));
    //add text fields
    //  request.fields["text_field"] = text;
    //create multipart using filepath, string or bytes
    var pic = await http.MultipartFile.fromPath("image", file.path);
    //add multipart to request
    request.files.add(pic);
    var response = await request.send();

    //Get the response from the server
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    print(responseString);
    var data = jsonDecode(responseString);
    if (data["status"] == 200) {
      return data["data"]["url"];
    }
    throw data;
  }
}
