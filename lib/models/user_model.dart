class User {
  final String name;
  final String email;
  final String phone;
  final String dob;

  User({
    required this.name,
    required this.email,
    required this.phone,
    required this.dob,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    // Parse the ISO date string and format it to a more readable form
    DateTime dobDateTime = DateTime.parse(data['dob']);
    String formattedDob = '${dobDateTime.day}/${dobDateTime.month}/${dobDateTime.year}';

    return User(
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      dob: formattedDob,
    );
  }
}