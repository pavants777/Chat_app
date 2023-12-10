class UserModles {
  final String name;
  final String email;
  final String uid;

  UserModles({required this.name, required this.email, required this.uid});

  factory UserModles.fromJson(Map<String, dynamic> json) {
    return UserModles(
      name: json['userName'] ?? 'UNKOWN',
      email: json['email'],
      uid: json['uid'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'uid': uid,
    };
  }
}
