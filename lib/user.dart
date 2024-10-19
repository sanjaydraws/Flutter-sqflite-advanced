class User {
  int? id;        // Nullable ID field
  String? name;   // Nullable name field
  int? age;       // Nullable age field
  String? email;  // Nullable email field

  User({this.id, this.name, this.age, this.email});

  // Convert a User object into a Map.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'email': email,
    };
  }

  // A method to convert the map back to a User object
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      age: map['age'],
      email: map['email'],
    );
  }
}
