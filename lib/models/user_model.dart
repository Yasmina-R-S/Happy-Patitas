class UserModel {
  final String uid;
  final String name;
  final String email;
  final String? photoUrl;
  final String phone;
  final DateTime createdAt;
  final bool hasCompletedProfile;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.photoUrl,
    this.phone = '',
    required this.createdAt,
    this.hasCompletedProfile = false,
  });

  factory UserModel.fromMap(String uid, Map<String, dynamic> map) {
    return UserModel(
      uid: uid,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      photoUrl: map['photoUrl'],
      phone: map['phone'] ?? '',
      createdAt: (map['createdAt'] as DateTime?) ?? DateTime.now(),
      hasCompletedProfile: map['hasCompletedProfile'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'phone': phone,
      'createdAt': createdAt,
      'hasCompletedProfile': hasCompletedProfile,
    };
  }
}
