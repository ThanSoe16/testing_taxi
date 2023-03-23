class LoginModel {

  String? mobile;
  String? password;
  String? device_name;

  LoginModel({this.mobile, this.password, this.device_name});

  Map<String, dynamic> toJson() {
    return{
      'mobile': mobile,
      'password': password,
      'device_name': device_name
    };
  }

  @override
  String toString() {
    return 'LoginModel{phone: $mobile, password: $password, device_name: $device_name}';
  }
}


