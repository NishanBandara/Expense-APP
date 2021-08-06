import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HTTPRequest extends StatefulWidget {
  @override
  _HTTPRequestState createState() => _HTTPRequestState();
}

class _HTTPRequestState extends State<HTTPRequest> {
  List irrigationDataList = [];
  Map irrigationData;
  bool result;

  Future getIrrigationData() async {
    http.Response response =
        await http.get("https://app.ceylonlinux.lk/jsonFileWrite/testapi.php");
    irrigationData = json.decode(response.body);
    setState(() {
      result = irrigationData['result'];
    });

    debugPrint("GET Response-" + result.toString());
  }

  @override
  void initState() {
    getIrrigationData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("Data is saved (" + result.toString() + ")"),
    );
  }
}
