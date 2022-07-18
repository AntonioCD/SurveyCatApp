import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:surveycat_app/helpers/controller.dart';
import 'package:surveycat_app/helpers/syncronizationData.dart';
import 'package:surveycat_app/models/token.dart';

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
  //..customAnimation = CustomAnimation();
}

class SyncDataScreen extends StatefulWidget {
  final Token token;

  SyncDataScreen({required this.token});

  @override
  State<SyncDataScreen> createState() => _SyncDataScreenState();
}

class _SyncDataScreenState extends State<SyncDataScreen> {
  late Timer _timer;

  late List list;
  bool loading = true;
  Future userList() async {
    list = await Controller().fetchData();
    setState(() {
      loading = false;
    });
    //print(list);
  }

  Future syncToMysql() async {
    /*  await SyncronizationData().GetLocalParcelas().then((userList) async {
      EasyLoading.show(status: 'Dont close app. we are sync...');
      await SyncronizationData().synchronizeParcelas(userList);
      EasyLoading.showSuccess('Successfully save to mysql');
    }); */
  }

  Future isInternet() async {
    await SyncronizationData.isInternet().then((connection) {
      if (connection) {
        print("Internet connection abailale");
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("No Internet")));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    userList();
    isInternet();
    EasyLoading.addStatusCallback((status) {
      print('EasyLoading Status $status');
      if (status == EasyLoadingStatus.dismiss) {
        _timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sync Sqflite to Mysql"),
        actions: [
          IconButton(
              icon: Icon(Icons.refresh_sharp),
              onPressed: () async {
                await SyncronizationData.isInternet().then((connection) {
                  if (connection) {
                    syncToMysql();
                    print("Internet connection abailale");
                  } else {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text("No Internet")));
                  }
                });
              })
        ],
      ),
      body: Column(children: [
        loading
            ? Center(child: CircularProgressIndicator())
            : Expanded(
                child: ListView.builder(
                  itemCount: list.length == null ? 0 : list.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(list[index]['id'].toString()),
                          SizedBox(
                            width: 5,
                          ),
                          Text(list[index]['codEnc']),
                        ],
                      ),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(list[index]['codEnc']),
                          Text(list[index]['codEnc']),
                        ],
                      ),
                    );
                  },
                ),
              ),
      ]),
    );
  }
}
