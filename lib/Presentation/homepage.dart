import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:foodconnect/Network/CloudStoreFirebase.dart';
import 'package:foodconnect/Network/SessionManager.dart';
import 'package:foodconnect/Network/apiHelper.dart';
import 'package:foodconnect/Presentation/drawer.dart';
import 'package:foodconnect/Utilities/colors.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({super.key});

  @override
  State<HomePageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  String? email;
  String? todayDate;
  String? designation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }

  getUserData() async {
    email = await SharedPref().getEmail();
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
    return Scaffold(
      backgroundColor: white,
      drawer: const DrawerWidget(),
      appBar: AppBar(
        backgroundColor: primary,
        title: const Text(
          'Today\'s Food',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Outfit',
            color: white,
            fontSize: 30,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        top: true,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 30, 0, 0),
                child: FutureBuilder<List>(
                    future: getTodayFoodItems(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (snapshot.data!.isEmpty) {
                        return Column(
                          children: [
                            const Center(
                                child: Text(
                              "No Items For Today",
                              style: TextStyle(fontSize: 25),
                            )),
                          ],
                        );
                      } else {
                        List data = snapshot.data!;

                        return ListView.builder(
                          itemCount: data.length,
                          shrinkWrap: true,
                          physics: const ScrollPhysics(),
                          itemBuilder: (context, index) {
                            String foodName = data[index]['foodName'];
                            String imageUrl = data[index]['imageUrl'];
                            String documentId = data[index].id;
                            todayDate = data[index]['date'];

                            return FutureBuilder<bool>(
                              future: isEmailLiked(context, documentId, email!),
                              builder: (context, snapshotLiked) {
                                return FutureBuilder<bool>(
                                  future: isEmailunLiked(
                                      context, documentId, email!),
                                  builder: (context, snapshotUnLiked) {
                                    bool isLiked = snapshotLiked.data ?? false;
                                    bool isUnLiked =
                                        snapshotUnLiked.data ?? false;

                                    return Card(
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      elevation: 4,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              imageUrl == "null"
                                                  ? ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      child: Image.network(
                                                        'https://t4.ftcdn.net/jpg/02/51/95/53/360_F_251955356_FAQH0U1y1TZw3ZcdPGybwUkH90a3VAhb.jpg',
                                                        width: 150,
                                                        height: 150,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    )
                                                  : ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      child: Image.network(
                                                        imageUrl,
                                                        width: 150,
                                                        height: 150,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                              Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(
                                                        30, 0, 0, 100),
                                                child: Text(
                                                  foodName.toUpperCase(),
                                                  style:
                                                      TextStyle(fontSize: 22),
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  isLiked
                                                      ? SizedBox()
                                                      : isUnLiked
                                                          ? Text(
                                                              "Thank you\nfor your Response")
                                                          : IconButton(
                                                              icon: const Icon(
                                                                Icons
                                                                    .thumb_down_alt_sharp,
                                                                color: Color(
                                                                    0xFFE40B0B),
                                                                size: 24,
                                                              ),
                                                              onPressed: () {
                                                                showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) {
                                                                      return AlertDialog(
                                                                          actionsPadding:
                                                                              EdgeInsets.all(20.0),
                                                                          actions: [
                                                                            Text(
                                                                              "Are you sure you dont't want to eat?",
                                                                              style: TextStyle(fontSize: 20),
                                                                            ),
                                                                            Row(
                                                                              children: [
                                                                                TextButton(
                                                                                    onPressed: () {
                                                                                      Navigator.pop(context);
                                                                                    },
                                                                                    child: Text("No")),
                                                                                TextButton(
                                                                                    onPressed: () {
                                                                                      recordunLikes(context, documentId, email!);
                                                                                      Navigator.pop(context);

                                                                                      setState(() {});
                                                                                    },
                                                                                    child: Text("Yes"))
                                                                              ],
                                                                            )
                                                                          ]);
                                                                    });
                                                              },
                                                            ),
                                                  isUnLiked
                                                      ? SizedBox()
                                                      : isLiked
                                                          ? Icon(
                                                              Icons.verified,
                                                              color: Color(
                                                                  0xFF1BCF1B),
                                                              size: 24,
                                                            )
                                                          : IconButton(
                                                              icon: const Icon(
                                                                Icons
                                                                    .thumb_up_alt_sharp,
                                                                color: Color(
                                                                    0xFF1BCF1B),
                                                                size: 24,
                                                              ),
                                                              onPressed:
                                                                  () async {
                                                                await recordLikes(
                                                                    context,
                                                                    documentId,
                                                                    email!);

                                                                setState(() {});
                                                              },
                                                            )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          },
                        );
                      }
                    }),
              ),
              designation == "Sr. Developer"
                  ? ElevatedButton(
                      onPressed: () async {
                        await getLikedCountsEmail(context, todayDate!);
                      },
                      child: Text("Get Report"))
                  : SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}
