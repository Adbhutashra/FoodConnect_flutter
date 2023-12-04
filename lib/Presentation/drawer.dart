import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:foodconnect/Network/SessionManager.dart';
import 'package:foodconnect/Network/apiHelper.dart';
import 'package:foodconnect/Presentation/adminpanel.dart';
import 'package:foodconnect/Presentation/feedback.dart';
import 'package:foodconnect/Presentation/homepage.dart';
import 'package:foodconnect/Presentation/login.dart';
import 'package:foodconnect/Presentation/todayitem.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  String? designation;
  @override
  void initState() {
    super.initState();
    getDesignationData();
  }

  getDesignationData() async {
    int? employeeId = await SharedPref().getEmployeeId();
    await fetchEmployees(employeeId!);
  }

  Future<dynamic> fetchEmployees(int employeeId) async {
    var responseJson = await new ApiHelper().getApiWithHeader(
        "https://www.flickerp.com/api/v1/employees/$employeeId/");

    if (responseJson.statusCode == 200) {
      Map<String, dynamic> jsonData = json.decode(responseJson.body);
      designation = jsonData['designation']['name'];
      setState(() {});
      return json.decode(responseJson.body);
    } else {
      throw Exception('Failed to load employee');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 16,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              'https://goldeneagle.ai/static/images/logo/logo1.png',
              height: 120,
              fit: BoxFit.cover,
            ),
          ),
          InkWell(
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () async {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomePageWidget()),
              );
              
            },
            child: ListTile(
              title: Text(
                'Home',
                // style: FlutterFlowTheme.of(context).titleLarge,
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                // color: FlutterFlowTheme.of(context).secondaryText,
                size: 20,
              ),
              // tileColor: FlutterFlowTheme.of(context).secondaryBackground,
              dense: false,
            ),
          ),
          designation == "Sr. Developer"
              ? InkWell(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AdminPanel()),
                    );
                  },
                  child: ListTile(
                    title: Text(
                      'Food Items',
                      // style: FlutterFlowTheme.of(context).titleLarge,
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      // color: FlutterFlowTheme.of(context).secondaryText,
                      size: 20,
                    ),
                    // tileColor: FlutterFlowTheme.of(context).secondaryBackground,
                    dense: false,
                  ),
                )
              : SizedBox(),
          designation == "Sr. Developer"
              ? InkWell(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const TodayItem()),
                    );
                  },
                  child: ListTile(
                    title: Text(
                      'Select Today\'s Item',
                      // style: FlutterFlowTheme.of(context).titleLarge,
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      // color: FlutterFlowTheme.of(context).secondaryText,
                      size: 20,
                    ),
                    // tileColor: FlutterFlowTheme.of(context).secondaryBackground,
                    dense: false,
                  ),
                )
              : SizedBox(),
          InkWell(
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () async {
              // context.pushNamed('Settings');
            },
            child: ListTile(
              title: Text(
                'Settings',
                // style: FlutterFlowTheme.of(context).titleLarge,
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                // color: FlutterFlowTheme.of(context).secondaryText,
                size: 20,
              ),
              // tileColor: FlutterFlowTheme.of(context).secondaryBackground,
              dense: false,
            ),
          ),
          InkWell(
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () async {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  FeedbackForm()),
              );
            },
            child: ListTile(
              title: Text(
                'Feedback',
                // style: FlutterFlowTheme.of(context).titleLarge,
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                // color: FlutterFlowTheme.of(context).secondaryText,
                size: 20,
              ),
              // tileColor: FlutterFlowTheme.of(context).secondaryBackground,
              dense: false,
            ),
          ),
          TextButton(
              onPressed: () async {
                final SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                await prefs.clear();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const LoginPageWidget()),
                );
              },
              child: Text("Logout"))
        ],
      ),
    );
  }
}
