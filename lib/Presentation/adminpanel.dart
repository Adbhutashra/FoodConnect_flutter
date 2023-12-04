import 'dart:io';

import 'package:flutter/material.dart';
import 'package:foodconnect/Network/CloudStoreFirebase.dart';
import 'package:foodconnect/Presentation/drawer.dart';
import 'package:foodconnect/Utilities/colors.dart';
import 'package:image_picker/image_picker.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  final TextEditingController foodNameController = TextEditingController();
  // final TextEditingController dateController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  // DateTime selectedDate = DateTime.now();
  File? imageFile;
  String? imageUrl;
  String? imageUrlNetwork;
  Future<List<Map<String, dynamic>>>? foodItems;

  @override
  void initState() {
    super.initState();
    foodItems = getFoodItems();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: source);

      if (pickedFile != null) {
        // Use the picked image (File)
        setState(() {
          imageFile = File(pickedFile.path);
        });
        Navigator.pop(context);
        await _uploadImage();
        // Do something with the imageFile
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<void> _uploadImage() async {
    if (imageFile != null) {
      imageUrlNetwork =
          await uploadImageToStorage(imageFile!, DateTime.now().toString());

      if (imageUrlNetwork != null) {
        setState(() {
          imageUrlNetwork = imageUrlNetwork;
        });
      }
    }
  }

  // Future<void> _selectDate(BuildContext context) async {
  //   final DateTime? picked = await showDatePicker(
  //     context: context,
  //     initialDate: selectedDate,
  //     firstDate: DateTime(2000),
  //     lastDate: DateTime(2101),
  //   );

  //   if (picked != null && picked != selectedDate) {
  //     setState(() {
  //       selectedDate = picked;
  //       DateTime timestamp = DateTime.parse(selectedDate.toString());
  //       String formattedDate =
  //           '${timestamp.year}-${timestamp.month}-${timestamp.day}';
  //       dateController.text = formattedDate;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Food Items"),
      ),
      drawer: const DrawerWidget(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Container(
                    padding: EdgeInsets.all(16),
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: foodNameController,

                            textCapitalization: TextCapitalization.none,
                            obscureText: false,
                            decoration: InputDecoration(
                              labelText: 'Food Name',
                              icon: Icon(Icons.restaurant),
                              // labelStyle: FlutterFlowTheme.of(context).labelMedium,
                              // hintStyle: FlutterFlowTheme.of(context).labelMedium,
                              enabledBorder: UnderlineInputBorder(
                                borderSide: const BorderSide(
                                  // color: FlutterFlowTheme.of(context).alternate,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: const BorderSide(
                                  color: primary,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              errorBorder: UnderlineInputBorder(
                                borderSide: const BorderSide(
                                  // color: FlutterFlowTheme.of(context).error,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedErrorBorder: UnderlineInputBorder(
                                borderSide: const BorderSide(
                                  // color: FlutterFlowTheme.of(context).error,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            validator: (foodName) {
                              if (foodName!.isEmpty) {
                                return "Food Name can't be empty";
                              }

                              return null;
                            },
                            // style: FlutterFlowTheme.of(context).bodyMedium,
                            // validator: textController1Validator
                            // .asValidator(context),
                          ),
                          // TextFormField(
                          //   controller: dateController,
                          //   readOnly: true,

                          //   textCapitalization: TextCapitalization.none,
                          //   obscureText: false,
                          //   onTap: () => _selectDate(context),
                          //   decoration: InputDecoration(
                          //     icon: Icon(Icons.calendar_month),
                          //     labelText: 'Select Date',
                          //     // labelStyle: FlutterFlowTheme.of(context).labelMedium,
                          //     // hintStyle: FlutterFlowTheme.of(context).labelMedium,
                          //     enabledBorder: UnderlineInputBorder(
                          //       borderSide: const BorderSide(
                          //         // color: FlutterFlowTheme.of(context).alternate,
                          //         width: 2,
                          //       ),
                          //       borderRadius: BorderRadius.circular(8),
                          //     ),
                          //     focusedBorder: UnderlineInputBorder(
                          //       borderSide: const BorderSide(
                          //         color: primary,
                          //         width: 2,
                          //       ),
                          //       borderRadius: BorderRadius.circular(8),
                          //     ),
                          //     errorBorder: UnderlineInputBorder(
                          //       borderSide: const BorderSide(
                          //         // color: FlutterFlowTheme.of(context).error,
                          //         width: 2,
                          //       ),
                          //       borderRadius: BorderRadius.circular(8),
                          //     ),
                          //     focusedErrorBorder: UnderlineInputBorder(
                          //       borderSide: const BorderSide(
                          //         // color: FlutterFlowTheme.of(context).error,
                          //         width: 2,
                          //       ),
                          //       borderRadius: BorderRadius.circular(8),
                          //     ),
                          //   ),
                          //   validator: (date) {
                          //     if (date!.isEmpty) {
                          //       return "Date can't be empty";
                          //     }

                          //     return null;
                          //   },
                          //   // style: FlutterFlowTheme.of(context).bodyMedium,
                          //   // validator: textController1Validator
                          //   // .asValidator(context),
                          // ),
                          // SizedBox(height: 20),
                          imageFile != null
                              ? Image.file(
                                  imageFile!,
                                  width: 150,
                                  height: 150,
                                  fit: BoxFit.cover,
                                )
                              : ElevatedButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(actions: [
                                            Column(
                                              children: [
                                                ListTile(
                                                  onTap: () {
                                                    _pickImage(
                                                        ImageSource.gallery);
                                                  },
                                                  title: const Text("Gallery"),
                                                ),
                                                ListTile(
                                                  title: const Text("Camera"),
                                                  onTap: () {
                                                    _pickImage(
                                                        ImageSource.camera);
                                                  },
                                                )
                                              ],
                                            ),
                                          ]);
                                        });
                                  },
                                  child: const Text("Upload Image")),
                          SizedBox(height: 20),
                          SizedBox(
                            width: 300,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {
                                  await addFoodItem(foodNameController.text,
                                  imageUrlNetwork == null ? "null" : 
                                      imageUrlNetwork!);
                                Navigator.pop(context);
                                }
                              },
                              child: const Text("Add Food"),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                });
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          FutureBuilder<List<Map<String, dynamic>>>(
              future: foodItems,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.data!.isEmpty) {
                  return Column(
                    children: [
                      SizedBox(height: MediaQuery.of(context).size.height / 2),
                      Center(
                          child: Text(
                        "No Items",
                        style: TextStyle(fontSize: 25),
                      )),
                    ],
                  );
                } else {
                  List<Map<String, dynamic>> data = snapshot.data!;
                  return ListView.builder(
                    itemCount: data.length,
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    itemBuilder: (context, index) {
                      String foodName = data[index]['foodName'];
                      String imageUrl = data[index]['imageUrl'];
                      // String date = data[index]['date'];

                      return Card(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        // color: FlutterFlowTheme.of(context).secondaryBackground,
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
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.asset(
                                          'assets/noimage.jpg',
                                          width: 150,
                                          height: 150,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          imageUrl,
                                          height: 150,
                                          width: 150,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      30, 0, 0, 100),
                                  child: Text(
                                    foodName,
                                   
                                  ),
                                ),
                                // Padding(
                                //   padding: EdgeInsetsDirectional.fromSTEB(
                                //       30, 0, 0, 100),
                                //   child: Text(
                                //     date,
                                //     // style: FlutterFlowTheme.of(context)
                                //     //     .bodyMedium
                                //     //     .override(
                                //     //       fontFamily: 'Readex Pro',
                                //     //       fontSize: 26,
                                //     //     ),
                                //   ),
                                // ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
              })
        ]),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    foodNameController.dispose();
    
    imageFile = null;
  }
}
