class Users {
  final String name;
  final String email;

  Users({
    required this.name,
    required this.email,
  });

  static Users fromJson(Map<String, dynamic> json) => Users(
        name: json['name'],
        email: json['email'],
      );
}
