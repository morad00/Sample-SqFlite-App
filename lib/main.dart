import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'view/emp_and_depview_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshConfiguration(
      headerBuilder: () => const ClassicHeader(
        completeText: '',
        releaseText: '',
        idleText: '',
        idleIcon: null,
        failedText: '',
        completeIcon: null,
        refreshingIcon: CupertinoActivityIndicator(),
        completeDuration: Duration(milliseconds: 0),
      ),
      footerBuilder: () => const ClassicFooter(
        loadingText: '',
        idleText: '',
        idleIcon: null,
        canLoadingIcon: null,
        canLoadingText: '',
        failedText: '',
        noDataText: '',
        loadingIcon: CupertinoActivityIndicator(),
      ),
      springDescription: const SpringDescription(stiffness: 170, damping: 16, mass: 1.9),
      maxOverScrollExtent: 100,
      maxUnderScrollExtent: 0,
      enableScrollWhenRefreshCompleted: true,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const EmployeesViewPage(),
      ),
    );
  }
}
