import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'user_controller.dart';
import 'user.dart'; // Import your User class

class UserInputScreen extends StatelessWidget {
  final UserController controller = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Input'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Obx(()=>TextField(
              controller: TextEditingController(text: controller.name.value),
              decoration: InputDecoration(labelText: 'Name'),
              onChanged: (value) {
                controller.name.value = value;
              },
            ),),
            SizedBox(height: 16),
            Obx(()=>TextField(
              controller: TextEditingController(text: controller.age.value.toString()),
              decoration: InputDecoration(labelText: 'Age'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                // Parse the age value safely
                controller.age.value = int.tryParse(value) ?? 0;
              },
            ),),

            SizedBox(height: 16),
            Obx(()=>TextField(
              controller: TextEditingController(text: controller.email.value ?? ""),
              decoration: InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) {
                // Parse the age value safely
                controller.email.value = value;
              },
            ),),

            ElevatedButton(
              onPressed: () {
                FocusScope.of(context).unfocus();
                controller.insertUser();
              },
              child: Text('Insert User'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Obx(() {
                if (controller.users.isEmpty) {
                  return Center(child: Text('No users found'));
                }
                return ListView.builder(
                  itemCount: controller.users.length,
                  itemBuilder: (context, index) {
                    User user = controller.users[index];
                    return ListTile(
                      title: Text(user.name??"Unknown"),
                      subtitle: Text('Age: ${user.age}'),
                      trailing: Text('Email: ${user.email}'),
                      onLongPress: () => _showDeleteConfirmationDialog(context, user),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, User user) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete User'),
          content: Text('Are you sure you want to delete ${user.name}?'),
          actions: [
            TextButton(
              onPressed: () {
                Get.back(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Get.find<UserController>().deleteUser(user.id!); // Delete user
                Get.back(); // Close the dialog
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
