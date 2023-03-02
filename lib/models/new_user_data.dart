/// The key information needed by Firebase to create a new user
class UserData {
  final String username;
  final String email;
  final String password;

  UserData({
    required this.username,
    required this.email,
    required this.password,
  });
}
