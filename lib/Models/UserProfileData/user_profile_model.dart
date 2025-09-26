class UserProfileModel {
  final String? id;
  final String? name;
  final String? email;
  final String? password;
  final String? permanentAddress;
  final String? gender;
  final String? dateOfBirth;
  final String? passportNumber;
  final bool isUser;

  UserProfileModel({
    this.id,
    this.name,
    this.email,
    this.password,
    this.permanentAddress,
    this.gender,
    this.dateOfBirth,
    this.passportNumber,
    this.isUser = true, // default true if you want
  });

  // Convert model → Firebase (Map)
  Map<String, dynamic> toFirebase() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'permanentAddress': permanentAddress,
      'gender': gender,
      'dateOfBirth': dateOfBirth,
      'passportNumber': passportNumber,
      'isUser': isUser,
    };
  }

  // Convert Firebase (Map) → model
  factory UserProfileModel.fromFirebase(Map<String, dynamic> data) {
    return UserProfileModel(
      id: data['id'],
      name: data['name'],
      email: data['email'],
      password: data['password'],
      permanentAddress: data['permanentAddress'],
      gender: data['gender'],
      dateOfBirth: data['dateOfBirth'],
      passportNumber: data['passportNumber'],
      isUser: data['isUser'] ?? true,
    );
  }
}
