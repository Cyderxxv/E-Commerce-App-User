class InputLoginModel {
  final String phoneNumber;
  final String password;

  InputLoginModel({
    required this.phoneNumber,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'phoneNumber': phoneNumber,
      'password': password,
    };
  }
}