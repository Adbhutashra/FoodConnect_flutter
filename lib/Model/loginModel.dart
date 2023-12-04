class LoginModel {
  LoginModel({
    required this.email,
    required this.token,
    required this.permissions,
    required this.permissionsAll,
    required this.orgId,
    required this.employeeId,
  });
  late final String email;
  late final String token;
  late final Permissions permissions;
  late final PermissionsAll permissionsAll;
  late final int orgId;
  late final int employeeId;
  
  LoginModel.fromJson(Map<String, dynamic> json){
    email = json['email'];
    token = json['token'];
    permissions = Permissions.fromJson(json['permissions']);
    permissionsAll = PermissionsAll.fromJson(json['permissions_all']);
    orgId = json['org_id'];
    employeeId = json['employee_id'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['email'] = email;
    _data['token'] = token;
    _data['permissions'] = permissions.toJson();
    _data['permissions_all'] = permissionsAll.toJson();
    _data['org_id'] = orgId;
    _data['employee_id'] = employeeId;
    return _data;
  }
}

class Permissions {
  Permissions();
  
  Permissions.fromJson(Map json);

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    return _data;
  }
}

class PermissionsAll {
  PermissionsAll({
    required this.holiday,
    required this.leave,
    required this.attendance,
  });
  late final List<String> holiday;
  late final List<String> leave;
  late final List<String> attendance;
  
  PermissionsAll.fromJson(Map<String, dynamic> json){
    holiday = List.castFrom<dynamic, String>(json['holiday']);
    leave = List.castFrom<dynamic, String>(json['leave']);
    attendance = List.castFrom<dynamic, String>(json['attendance']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['holiday'] = holiday;
    _data['leave'] = leave;
    _data['attendance'] = attendance;
    return _data;
  }
}