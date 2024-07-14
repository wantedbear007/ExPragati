// To parse this JSON data, do
//
//     final employeeModel = employeeModelFromJson(jsonString);

import 'dart:convert';

EmployeeModel employeeModelFromJson(String str) => EmployeeModel.fromJson(json.decode(str));

String employeeModelToJson(EmployeeModel data) => json.encode(data.toJson());

class EmployeeModel {
  final Employee? employee;
  final String? token;
  final String? message;
  final String? status;

  EmployeeModel({
    this.employee,
    this.token,
    this.message,
    this.status,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) => EmployeeModel(
    employee: json["employee"] == null ? null : Employee.fromJson(json["employee"]),
    token: json["token"],
    message: json["message"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "employee": employee?.toJson(),
    "token": token,
    "message": message,
    "status": status,
  };
}

class Employee {
  final String? id;
  final String? empUsername;
  final String? empPassword;
  final String? empName;
  final String? empNumber;
  final String? empEmail;
  final String? empGender;
  final String? empImage;
  final String? empWorkDept;
  final String? empDesignation;
  final DateTime? empDob;
  final DateTime? empHiredDate;
  final dynamic empReginedDate;
  final String? empType;
  final String? empWorkType;
  final String? empJobType;
  final String? empJoiningMode;
  final String? empRefferedBy;
  final String? empReportingManager;
  final String? empToken;
  final String? empAppToken;
  final String? empStatus;
  final String? empDescription;
  final String? fromIp;
  final String? fromBrowser;
  final String? createdBy;
  final String? updatedBy;
  final int? version;
  final String? empId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;
  final bool? isReportingManager;
  final bool? calenderAuth;
  final bool? birthday;
  final bool? notificationPermissions;

  Employee({
    this.id,
    this.empUsername,
    this.empPassword,
    this.empName,
    this.empNumber,
    this.empEmail,
    this.empGender,
    this.empImage,
    this.empWorkDept,
    this.empDesignation,
    this.empDob,
    this.empHiredDate,
    this.empReginedDate,
    this.empType,
    this.empWorkType,
    this.empJobType,
    this.empJoiningMode,
    this.empRefferedBy,
    this.empReportingManager,
    this.empToken,
    this.empAppToken,
    this.empStatus,
    this.empDescription,
    this.fromIp,
    this.fromBrowser,
    this.createdBy,
    this.updatedBy,
    this.version,
    this.empId,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.isReportingManager,
    this.calenderAuth,
    this.birthday,
    this.notificationPermissions,
  });

  factory Employee.fromJson(Map<String, dynamic> json) => Employee(
    id: json["_id"],
    empUsername: json["emp_username"],
    empPassword: json["emp_password"],
    empName: json["emp_name"],
    empNumber: json["emp_number"],
    empEmail: json["emp_email"],
    empGender: json["emp_gender"],
    empImage: json["emp_image"],
    empWorkDept: json["emp_work_dept"],
    empDesignation: json["emp_designation"],
    empDob: json["emp_dob"] == null ? null : DateTime.parse(json["emp_dob"]),
    empHiredDate: json["emp_hired_date"] == null ? null : DateTime.parse(json["emp_hired_date"]),
    empReginedDate: json["emp_regined_date"],
    empType: json["emp_type"],
    empWorkType: json["emp_work_type"],
    empJobType: json["emp_job_type"],
    empJoiningMode: json["emp_joining_mode"],
    empRefferedBy: json["emp_reffered_by"],
    empReportingManager: json["emp_reporting_manager"],
    empToken: json["emp_token"],
    empAppToken: json["emp_app_token"],
    empStatus: json["emp_status"],
    empDescription: json["emp_description"],
    fromIp: json["from_ip"],
    fromBrowser: json["from_browser"],
    createdBy: json["created_by"],
    updatedBy: json["updated_by"],
    version: json["version"],
    empId: json["emp_id"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    isReportingManager: json["isReportingManager"],
    calenderAuth: json["calenderAuth"],
    birthday: json["birthday"],
    notificationPermissions: json["notificationPermissions"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "emp_username": empUsername,
    "emp_password": empPassword,
    "emp_name": empName,
    "emp_number": empNumber,
    "emp_email": empEmail,
    "emp_gender": empGender,
    "emp_image": empImage,
    "emp_work_dept": empWorkDept,
    "emp_designation": empDesignation,
    "emp_dob": empDob?.toIso8601String(),
    "emp_hired_date": empHiredDate?.toIso8601String(),
    "emp_regined_date": empReginedDate,
    "emp_type": empType,
    "emp_work_type": empWorkType,
    "emp_job_type": empJobType,
    "emp_joining_mode": empJoiningMode,
    "emp_reffered_by": empRefferedBy,
    "emp_reporting_manager": empReportingManager,
    "emp_token": empToken,
    "emp_app_token": empAppToken,
    "emp_status": empStatus,
    "emp_description": empDescription,
    "from_ip": fromIp,
    "from_browser": fromBrowser,
    "created_by": createdBy,
    "updated_by": updatedBy,
    "version": version,
    "emp_id": empId,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
    "isReportingManager": isReportingManager,
    "calenderAuth": calenderAuth,
    "birthday": birthday,
    "notificationPermissions": notificationPermissions,
  };
}
