import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  Future<void> saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> saveEmail(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
  }

  Future<String?> getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('email');
  }

  Future<void> saveOrgId(int orgId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('orgId', orgId);
  }

  Future<int?> getOrgId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('orgId');
  }

  Future<void> saveEmployeeId(int employeeId) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('employee_id', employeeId);
  }

  Future<int?> getEmployeeId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('employee_id');
  }
}
