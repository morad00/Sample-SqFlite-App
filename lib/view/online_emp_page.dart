import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:untitled/model/online_employee.dart';
import 'package:http/http.dart' as http;

class OnlineEmployeePage extends StatefulWidget {
  const OnlineEmployeePage({Key? key}) : super(key: key);

  @override
  State<OnlineEmployeePage> createState() => _OnlineEmployeePageState();
}

class _OnlineEmployeePageState extends State<OnlineEmployeePage> {
  int pageIndex = 1;
  final RefreshController refreshController = RefreshController(initialRefresh: false);
  late Future<List<EmployeeList>> _future;
  List<EmployeeList> employeeList = [];

  @override
  void initState() {
    super.initState();
    _future = getFutureData();
  }

  Future<List<EmployeeList>> getFutureData() async {
    final response = await http.get(Uri.parse('https://reqres.in/api/users?page=$pageIndex'));
    log('response ${response.body}');
    if (response.statusCode == 200) {
      return onlineEmployeeFromJson(response.body).data;
    } else {
      throw Exception('Failed to load album');
    }
  }

  void onRefreshDownLoadMore() async {
    pageIndex++;
    List<EmployeeList> loadedEmployeeList = await getFutureData();
    employeeList.addAll(loadedEmployeeList);
    refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Online Employees'), centerTitle: true),
      body: FutureBuilder<List<EmployeeList>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            employeeList = snapshot.data!;

            /// Not a good ux if we use the Data table widget
            // return DataTable(
            //   columns: const [
            //     DataColumn(label: Text('Email')),
            //     DataColumn(label: Text('First name')),
            //     DataColumn(label: Text('Last name')),
            //     DataColumn(label: Text('Picture')),
            //   ],
            //   rows: snapshot.data!.data // Loops through dataColumnText, each iteration assigning the value to element
            //       .map(
            //         ((item) => DataRow(
            //               cells: <DataCell>[
            //                 DataCell(Text(item.firstName)), //Extracting from Map element the value
            //                 DataCell(Text(item.firstName)), //Extracting from Map element the value
            //                 DataCell(Text(item.lastName)), //Extracting from Map element the value
            //                 DataCell(Image.network(item.avatar)), //Extracting from Map element the value
            //               ],
            //             )),
            //       )
            //       .toList(),
            //
            //   // border: TableBorder.all(color: Colors.black12),
            // );
            /// so I'll create a custom view for it
            return SmartRefresher(
              onLoading: () {
                if (mounted) {
                  setState(() {
                    onRefreshDownLoadMore();
                  });
                }
              },
              controller: refreshController,
              enablePullDown: false,
              enablePullUp: true,
              child: ListView.builder(
                itemCount: employeeList.length,
                itemBuilder: (context, index) {
                  var employeeItem = employeeList[index];
                  return Card(
                    child: ListTile(
                      leading: Image.network(employeeItem.avatar),
                      title: Text("${employeeItem.firstName} ${employeeItem.lastName}",
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      subtitle: Text(employeeItem.email, style: const TextStyle(fontSize: 14)),
                      trailing: const SizedBox(),
                    ),
                  );
                },
              ),
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return Container(
            alignment: AlignmentDirectional.center,
            child: const CupertinoActivityIndicator(),
          );
        },
      ),
    );
  }
}
