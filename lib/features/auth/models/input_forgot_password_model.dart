class ForgotPasswordModel {
  final String phoneNumber;

  ForgotPasswordModel({required this.phoneNumber});

  Map<String, dynamic> toJson() {
    return {
      'phoneNumber': phoneNumber,
    };
  }

  factory ForgotPasswordModel.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordModel(
      phoneNumber: json['phoneNumber'] as String,
    );
  }
}