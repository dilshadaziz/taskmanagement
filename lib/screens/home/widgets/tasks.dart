import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:taskmate/db/db_helper.dart';
import 'package:taskmate/model/category.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:taskmate/screens/details/details.dart';

class Tasks extends StatelessWidget {
  Tasks({super.key});

  // Initialize tasksList with categories
  final tasksList = Category.generateCategories();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: categoryList, // Listen to changes in categoryList
      builder: (context, value, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),

          // Category GridView List
          child: GridView.builder(
            itemCount: 4,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            itemBuilder: (context, index) {
              if (index > value.length - 1) {
                return _buildAddCategory(context); // Add Category Card
              } else {
                return _buildCategory(context, value[index], index);
              }
            },
          ),
        );
      },
    );
  }

  // Build individual category cards
  Widget _buildCategory(BuildContext context, Category category, index) {
    return GestureDetector(
      onTap: () {
        // Navigate to ShowTaskList with the selected category
        Get.to(
          () => Details(categoryname: category.title!,categories: category),
          transition: Transition.cupertino,
        );
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: tasksList[index].bgColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Social Category has an extra delete button
            index == 3
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        tasksList[index].iconData,
                        color: tasksList[index].iconColor,
                        size: 35,
                      ),
                      GestureDetector(
                        onTap: () => deletePressed(context, category),
                        child: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      )
                    ],
                  )
                : Icon(
                    index == 0
                        ? Icons.person
                        : index == 1
                            ? CupertinoIcons.briefcase_fill
                            : Icons.favorite,
                    color: tasksList[index].iconColor,
                    size: 35,
                  ),
            Text(
              category.title!,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            // Display left and done status
            Row(
              children: [
                _buildCategoryStatus(
                    tasksList[index].btnColor!,
                    tasksList[index].iconColor!,
                    '${category.left} left'),
                const SizedBox(
                  width: 5,
                ),
                _buildCategoryStatus(
                    Colors.white,
                    tasksList[index].iconColor!,
                    '${category.done} done'),
              ],
            )
          ],
        ),
      ),
    );
  }

  // Build status indicator for each category
  Widget _buildCategoryStatus(Color bgColor, Color txColor, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(color: txColor),
      ),
    );
  }

  // Add New Category card with DottedBorder
  Widget _buildAddCategory(context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text(
              'New Category',
              style: TextStyle(fontSize: 21),
            ),
            content: const Card(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Icon(
                      CupertinoIcons.person_3_fill,
                      color: Color.fromARGB(255, 127, 211, 101),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      'Social',
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.white),
                      foregroundColor: MaterialStatePropertyAll(Colors.black),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 15),
                  ElevatedButton(
                    style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.black),
                      foregroundColor: MaterialStatePropertyAll(Colors.white),
                    ),
                    onPressed: () {
                      addCategoryClicked(context);
                    },
                    child: const Text('Add'),
                  ),
                ],
              ),
            ],
          ).animate().scaleX(duration: const Duration(milliseconds: 250)),
        );
      },
      child: DottedBorder(
        borderType: BorderType.RRect,
        radius: const Radius.circular(20),
        dashPattern: const [10, 10],
        color: Colors.grey,
        strokeWidth: 2,
        child: const Center(
          child: Text(
            '+ Add',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  // Handle adding a new category
  Future<void> addCategoryClicked(context) async {
    final categoryData4 = Category(
      title: 'Social',
      left: 0,
      done: 0,
    );
    await DBHelper.insertToCategory(categoryData4);

    Navigator.pop(context);
  }

  // Handle deleting a category
  Future<void> deletePressed(context, Category category) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: const Text('Are you sure want to delete Social category ?'),
        title: const Text("Confirm"),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: const ButtonStyle(
                  foregroundColor: MaterialStatePropertyAll(Colors.black),
                ),
                child: const Text('No'),
              ),
              const SizedBox(
                width: 15,
              ),
              ElevatedButton(
                onPressed: () async {
                  DBHelper.deleteCategory(category.id);
                  Navigator.pop(context);
                },
                style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.black),
                  foregroundColor: MaterialStatePropertyAll(Colors.white),
                ),
                child: const Text('Yes'),
              ),
            ],
          ),
        ],
      ).animate().flip(duration: const Duration(milliseconds: 300)),
    );
  }
}
