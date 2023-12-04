import 'package:flutter/material.dart';
import 'package:foodconnect/Network/CloudStoreFirebase.dart';
import 'package:foodconnect/Presentation/drawer.dart';

class TodayItem extends StatefulWidget {
  const TodayItem({super.key});

  @override
  State<TodayItem> createState() => _TodayItemState();
}

class _TodayItemState extends State<TodayItem> {
  Future<List<Map<String, dynamic>>>? foodItems;
  DateTime selectedDate = DateTime.now();
  String? date;

  @override
  void initState() {
    super.initState();
    foodItems = getFoodItems();
  }

  Future<void> _selectDate(BuildContext context, String foodname) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        DateTime timestamp = DateTime.parse(selectedDate.toString());
        String formattedDate =
            '${timestamp.year}-${timestamp.month}-${timestamp.day.toString().padLeft(2, '0')}';
        date = formattedDate;
      });
      await updateFoodItemDateByName(foodname, date!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Today's Food"),
      ),
      drawer: const DrawerWidget(),
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
                        "Please Add Items",
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
                      date = data[index]['date'] ?? "Select Date";

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
                                GestureDetector(
                                  onTap: () {
                                    _selectDate(context, foodName);
                                  },
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        30, 0, 0, 100),
                                    child: Text(
                                      date!,
                                    ),
                                  ),
                                ),
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
}
