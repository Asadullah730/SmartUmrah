class TravelAgentProfileModel {
  final String? id;
  final String? name;
  final String? email;
  final String? password;
  final String? permanentAddress;
  final String? gender;
  final String? dateOfBirth;
  final String? passportNumber;
  final String? agencyName; // New field for agency name for travel agents
  final double? expenses;
  final bool isUser;

  TravelAgentProfileModel({
    this.id,
    this.name,
    this.email,
    this.password,
    this.permanentAddress,
    this.gender,
    this.dateOfBirth,
    this.passportNumber,
    this.agencyName, // New field for agency name for travel agents
    this.expenses,
    this.isUser = true,
  });

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
      'agencyName': agencyName, // Include agency name in the map
      'expenses': expenses,
      'isUser': isUser,
    };
  }

  // Convert Firebase (Map) → model
  factory TravelAgentProfileModel.fromFirebase(Map<String, dynamic> data) {
    return TravelAgentProfileModel(
      id: data['id'],
      name: data['name'],
      email: data['email'],
      password: data['password'],
      permanentAddress: data['permanentAddress'],
      gender: data['gender'],
      dateOfBirth: data['dateOfBirth'],
      passportNumber: data['passportNumber'],
      agencyName: data['agencyName'], // Retrieve agency name from the map
      expenses: (data['expenses'] != null)
          ? double.tryParse(data['expenses'].toString())
          : null,
      isUser: data['isUser'] ?? true,
    );
  }
}
