class UserModel {
  const UserModel({
    required this.id,
    required this.name,
    required this.email,
  });

  final String id;
  final String name;
  final String email;

  factory UserModel.fromJson(dynamic data) {
    return UserModel(id: data['id'], name: data['name'], email: data['email']);
  }
}
