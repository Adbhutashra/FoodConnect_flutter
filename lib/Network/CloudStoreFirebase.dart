import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

final CollectionReference todayFoodCollection =
    FirebaseFirestore.instance.collection('food_items');

Future<void> recordLikes(
    BuildContext context, String foodItemId, String email) async {
  try {
    final foodItemRef =
        FirebaseFirestore.instance.collection('food_items').doc(foodItemId);

    final docSnapshot = await foodItemRef.get();
    final Map<String, dynamic>? data = docSnapshot.data();

    final List<dynamic>? likedEmails = data?['liked_emails'];
    final List<dynamic>? unlikedEmails = data?['unliked_emails'];

    if ((likedEmails == null || !likedEmails.contains(email)) &&
        (unlikedEmails == null || !unlikedEmails.contains(email))) {
      await foodItemRef.set({
        'liked_count': FieldValue.increment(1),
        'liked_emails': FieldValue.arrayUnion([email]),
      }, SetOptions(merge: true));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("You have already recorded your choice."),
      ));
    }
  } catch (e) {
    print("Error while updating food items: $e");
  }
}

Future<void> recordunLikes(
    BuildContext context, String foodItemId, String email) async {
  try {
    final foodItemRef =
        FirebaseFirestore.instance.collection('food_items').doc(foodItemId);

    final docSnapshot = await foodItemRef.get();
    final Map<String, dynamic>? data = docSnapshot.data();

    final List<dynamic>? likedEmails = data?['liked_emails'];
    final List<dynamic>? unlikedEmails = data?['unliked_emails'];

    if ((likedEmails == null || !likedEmails.contains(email)) &&
        (unlikedEmails == null || !unlikedEmails.contains(email))) {
      await foodItemRef.set({
        'unliked_count': FieldValue.increment(1),
        'unliked_emails': FieldValue.arrayUnion([email]),
      }, SetOptions(merge: true));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("You have already recorded your choice."),
      ));
    }
  } catch (e) {
    print("Error while updating food items: $e");
  }
}

Future<bool> isEmailLiked(
    BuildContext context, String foodItemId, String email) async {
  try {
    final foodItemRef =
        FirebaseFirestore.instance.collection('food_items').doc(foodItemId);

    final docSnapshot = await foodItemRef.get();

    if (docSnapshot.exists) {
      final List<dynamic>? likedEmails = docSnapshot['liked_emails'];

      if (likedEmails != null && likedEmails.contains(email)) {
        return true;
      } else {
        return false;
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Food item not found."),
      ));

      return false;
    }
  } catch (e) {
    print("Error while checking liked emails: $e");
    return false;
  }
}

Future<bool> isEmailunLiked(
    BuildContext context, String foodItemId, String email) async {
  try {
    final foodItemRef =
        FirebaseFirestore.instance.collection('food_items').doc(foodItemId);

    final docSnapshot = await foodItemRef.get();

    if (docSnapshot.exists) {
      final List<dynamic>? unlikedEmails = docSnapshot['unliked_emails'];

      if (unlikedEmails != null && unlikedEmails.contains(email)) {
        return true;
      } else {
        return false;
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Food item not found."),
      ));

      return false;
    }
  } catch (e) {
    print("Error while checking liked emails: $e");
    return false;
  }
}

Future<Map<String, dynamic>> getFoodItemCounts() async {
  final snapshot = await todayFoodCollection.get();
  return {
    for (var doc in snapshot.docs)
      doc.id: {'count': doc['count'], 'emails': doc['emails']}
  };
}

addFoodItem(String foodName, String imageUrl) {
  try {
    FirebaseFirestore.instance
        .collection('food_items')
        .add({'foodName': foodName, 'imageUrl': imageUrl});
  } catch (e) {
    print("Error while adding food items $e");
  }
}

Future<void> updateFoodItemDateByName(String foodName, String newDate) async {
  try {
    final QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance
            .collection('food_items')
            .where('foodName', isEqualTo: foodName)
            .get();

    if (querySnapshot.docs.isNotEmpty) {
      for (QueryDocumentSnapshot<Map<String, dynamic>> document
          in querySnapshot.docs) {
        await document.reference.update({'date': newDate});
      }
    } else {
      print('No documents found for food name: $foodName');
    }
  } catch (e) {
    print("Error while updating food item date by name: $e");
  }
}

Future<List<Map<String, dynamic>>> getFoodItems() async {
  try {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('food_items').get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  } catch (e) {
    print('Error fetching food items: $e');
    return [];
  }
}

Future<List> getTodayFoodItems() async {
  try {
    String todayDate = DateTime.now().toLocal().toString().split(' ')[0];

    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('food_items')
        .where('date', isEqualTo: todayDate)
        .get();
    return snapshot.docs;
  } catch (e) {
    print('Error fetching food items: $e');
    return [];
  }
}

Future<String?> uploadImageToStorage(File imageFile, String fileName) async {
  try {
    Reference storageReference =
        FirebaseStorage.instance.ref().child('images/$fileName');
    UploadTask uploadTask = storageReference.putFile(imageFile);

    await uploadTask.whenComplete(() => null);

    return await storageReference.getDownloadURL();
  } catch (e) {
    print('Error uploading image: $e');
    return null;
  }
}

Future<void> getLikedCountsEmail(BuildContext context, String targetDate) async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  try {
    QuerySnapshot<Map<String, dynamic>> snapshot = await firestore
        .collection('food_items')
        .where('date', isEqualTo: targetDate)
        .get();

    if (snapshot.docs.isNotEmpty) {
      DocumentSnapshot<Map<String, dynamic>> document = snapshot.docs.first;
      int likedCount = document['liked_count'] ?? 0;
      List<String> likedEmails = List.from(document['liked_emails'] ?? []);

      print('Liked Count: $likedCount');
      print('Liked Emails: $likedEmails');
      String report = generateReport(likedCount, likedEmails);

      await sendEmail(context ,report);
    } else {
      print('No document found for the target date.');
    }
  } catch (e) {
    print('Error: $e');
  }
}

String generateReport(int likedCount, List<String> likedEmails) {
  StringBuffer report = StringBuffer('Today\'s Report\n\n');

  report.write('Total Likes: $likedCount\n\n');
  report.write('Email: $likedEmails\n');

  return report.toString();
}

Future<void> sendEmail(BuildContext context , String report) async {
  final smtpServer = gmail('adbhut.a@geitpl.com', 'cwnn tyjm axua poqm');

  final message = Message()
    ..from = Address('adbhut.a@geitpl.com', 'Adbhut Ashra')
    ..recipients.add('adbhut.a@geitpl.com')
    ..subject = 'Today\'s Food Report'
    ..text = report;

  try {
    final sendReport = await send(message, smtpServer);
    print('Email sent: ${sendReport}');
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Email Sent to your mail account"),
      ));
  } catch (e) {
    print('Error sending email: $e');
  }
}
