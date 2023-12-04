
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:foodconnect/Network/SessionManager.dart';
import 'package:http/http.dart' as http;

class ApiHelper {

  Future getApiWithHeader(
    String url,
  ) async {
    print('Api get, url $url');

    String? token = await SharedPref().getToken();
    int? orgId = await SharedPref().getOrgId();
    var responseJson;
    try {
      http.Response response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': "Bearer" + " " + token!,
          'Org-Id': orgId.toString()
        },
      );
      print(response.statusCode);
      responseJson = await _returnResponse(response);
      if (response.statusCode == 200) {
        print('api get recieved!');
      }
    } on SocketException {
      // showToastMessage("No Internet connection");

      // throw FetchDataException('No Internet connection');
    } catch (e) {}
    return await responseJson;
  }

  Future postApi(BuildContext context, String url, String params) async {
    var responseJson;
    try {
      final response = await http.post(Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json'
          },
          body: params);

      responseJson = _returnResponse(response);
    } on SocketException {
    } catch (e) {}
    return responseJson;
  }

  // Future patchApi(String url, String params) async {
  //   var responseJson;
  //   try {
  //     String? token = await PreferencesManager.getToken();
  //     int? orgId = await PreferencesManager.getOrgId();
  //     final response = await http.patch(Uri.parse(url),
  //         headers: {
  //           'Content-Type': 'application/json',
  //           'Accept': 'application/json',
  //           'Authorization': "Bearer" + " " + token!,
  //           'Org-Id': orgId.toString()
  //         },
  //         body: params);

  //     responseJson = _returnResponse(response);
  //   } on SocketException {
  //   } catch (e) {}
  //   return responseJson;
  // }

  // Future deleteApiWithHeader(String apiUrl) async {
  //   try {
  //     String? token = await PreferencesManager.getToken();
  //     int? orgId = await PreferencesManager.getOrgId();
  //     final response = await http.delete(
  //       Uri.parse(apiUrl),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Accept': 'application/json',
  //         'Authorization': "Bearer" + " " + token!,
  //         'Org-Id': orgId.toString()
  //       },
  //     );

  //     return response;
  //   } catch (error) {
  //     // Handle exceptions here
  //     print('Error: $error');
  //     throw Exception('Failed to delete the resource.');
  //   }
  // }

  dynamic _returnResponse(http.Response response) {

    switch (response.statusCode) {
      case 200:
        return response;
      case 201:
        return response;
      case 400:
        return response;
      case 401:
        return response;

      case 404:
        return response;

      case 422:
        return response;

      case 401:
        // var decodeResponse = Utf8Codec().decode(response.bodyBytes);
        // var message = jsonDecode(decodeResponse.toString())['error'] as String;

        // showToastMessage(message.toString());

        return response;

      case 403:
        // var decodeResponse = Utf8Codec().decode(response.bodyBytes);
        // var messages =
        //     jsonDecode(decodeResponse.toString())['message'] as String;
        // showToastMessage(messages.toString());
        return response;

      case 500:
        // showToastMessage(
        //     'Error occured while Communication with Server with StatusCode : ${response.statusCode}');

        return response;
      default:
        // showToastMessage(
        //     'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
        return response;
    }
  }
}