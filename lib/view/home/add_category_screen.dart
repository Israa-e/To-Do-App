import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:to_do_app/core/db_helper.dart';
import 'package:to_do_app/model/category_model.dart';
import 'package:to_do_app/model/task_model.dart';
import 'package:to_do_app/widget/app_snackbar.dart';
import 'package:to_do_app/widget/build_textfield.dart';
import 'package:to_do_app/widget/primary_button.dart';

class AddCategoryScreen extends StatefulWidget {
  const AddCategoryScreen({super.key, this.task});
  final Task? task;

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  TextEditingController categoryNameController = TextEditingController();
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  bool isLoading = false;
  void addCategory() async {
    if (categoryNameController.text.trim().isEmpty) {
      AppSnackbar.error("Category name cannot be empty");
      return;
    }
    setState(() => isLoading = true);
    try {
      Category category = Category(name: categoryNameController.text.trim());

      await DBHelper.insertCategory(category);

      await firebaseFirestore
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('categories')
          .add({
            'name': categoryNameController.text.trim(),
            'isSelected': false,
            'createdAt': FieldValue.serverTimestamp(),
          });
      Get.back();
      setState(() {});
      AppSnackbar.success("Category added successfully");
    } catch (e) {
      AppSnackbar.error("Failed to add category: $e");
      print("============ $e ===================");
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: TextButton(
          onPressed: () async {
            Get.back();
          },
          child: Icon(Icons.arrow_back_ios, color: Colors.white, size: 16),
        ),
      ),
      body: SingleChildScrollView(
        child: Stack(
          alignment: Alignment.center,
          children: [
            isLoading
                ? Align(
                    alignment: Alignment.center,
                    child: Center(child: CircularProgressIndicator()),
                  )
                : SizedBox(),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Add New Category",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 53),

                    BuildTextFormField(
                      text: "New Category Name",
                      hintText: "Category Name",
                      controller: categoryNameController,
                    ),

                    SizedBox(height: 24),

                    primaryButton(
                      context: context,
                      text: "Add Category",
                      onTap: addCategory,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
