import 'package:get/get.dart';
import 'database_helper.dart'; // Import your DatabaseHelper
import 'user.dart'; // Import your User class

class UserController extends GetxController {
  final name = ''.obs;
  final age = 0.obs;
  final email = ''.obs;

  var users = <User>[].obs;

  final DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  void onInit() {
    super.onInit();
    fetchUsers(); // Fetch users when the controller is initialized
  }

  void insertUser() async {
    print("insertUser $name $age");
    if (name.value.isEmpty) {
      Get.snackbar('Error', 'Please enter a valid name');
    } else if (age.value <= 0) {
      Get.snackbar('Error', 'Please enter a valid age greater than 0');
    } else if (age.value > 100) {
      Get.snackbar('Error', 'Please enter a valid age less than or equal to 100');
    }
    else if (email.value.isEmpty) {
      Get.snackbar('Error', 'Please enter email');
    }
    else {
      User user = User(name: name.value, age: age.value,email: email.value);
      await _databaseHelper.insertUser(user);
      // Reset fields after inserting
      name.value = '';
      age.value = 0;
      email.value = '';
      fetchUsers(); // Refresh user list after inserting
    }
  }

  void fetchUsers() async {
    final userList = await _databaseHelper.getUsers();
    users.value = userList.map((userMap) => User.fromMap(userMap)).toList(); // Update the observable list
  }

  void deleteUser(int id) async {
    await _databaseHelper.deleteUser(id); // Delete user from the database
    fetchUsers(); // Refresh the user list after deletion
    Get.snackbar('Success', 'User deleted successfully'); // Show success message
  }
}
