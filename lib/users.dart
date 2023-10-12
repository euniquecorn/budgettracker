class Users {
  final String id;
  final String name;
  final String email;

  Users({
    required this.id,
    required this.name,
    required this.email,
  });

  static Users fromJson(Map<String, dynamic> json) => Users(
        id: json['id'],
        name: json['name'],
        email: json['email'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
      };
}
