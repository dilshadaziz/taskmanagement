import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:taskmate/db/db_helper.dart';
import 'package:taskmate/model/category.dart';
import 'package:taskmate/screens/details/details.dart';


class Search extends StatefulWidget {
  const Search({super.key}); 

  @override
  State<Search> createState() =>
      _SearchState(); 
}

class _SearchState extends State<Search> {
  List<Category> findCategory = []; // List to store filtered categories.
  final tasksList =
      Category.generateCategories(); // List of category properties.

  @override
  void initState() {
    super.initState();

    // Initialize the findCategory list with all categories.
    findCategory = categoryList.value;
  }

  void _runFilter(String enteredKeyword) {
    List<Category> result = [];

    // Reset to the original list if the search is empty.
    if (enteredKeyword.isEmpty) {
      result = categoryList.value;
    }
    // Filter based on Category properties.
    else {
      result = categoryList.value
          .where(
            (element) => element.title!.toLowerCase().contains(
                  enteredKeyword.toLowerCase(),
                ),
          )
          .toList();
    }
    setState(() {
      findCategory =
          result; // Update the findCategory list with filtered categories.
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App Bar with a search input field.
      appBar: AppBar(
        title: TextField(
          onChanged: (value) =>
              _runFilter(value), // Handle text input changes for filtering.
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            hintText: 'Search...',
          ),
        ),
      ),
      body: SafeArea(
        // The main content area of the app.
        child: ValueListenableBuilder<List<Category>>(
          valueListenable: categoryList,
          builder: (context, categoryListValue, child) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),

            // List the Category items based on search results.

            child: ListView.builder(
              itemCount: findCategory.length,
              itemBuilder: (context, index) {
                final findCategoryItem = findCategory[index];
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    onTap: () {
                      Get.off(
                          () => Details(
                              categoryname: findCategoryItem.title!,categories: findCategoryItem,),
                          transition: Transition.cupertino);
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),

                    // ListTile Decoration based on category.

                    tileColor: findCategoryItem.title == 'Personal'
                        ? tasksList[0].bgColor
                        : findCategoryItem.title == 'Work'
                            ? tasksList[1].bgColor
                            : findCategoryItem.title == 'Health'
                                ? tasksList[2].bgColor
                                : tasksList[3].bgColor,

                    // Leading Icon based on category.

                    leading: findCategoryItem.title == 'Personal'
                        ? Icon(
                            Icons.person,
                            color: tasksList[0].iconColor,
                          )
                        : findCategoryItem.title == 'Work'
                            ? Icon(
                                CupertinoIcons.briefcase_fill,
                                color: tasksList[1].iconColor,
                              )
                            : findCategoryItem.title == 'Health'
                                ? Icon(
                                    Icons.favorite,
                                    color: tasksList[2].iconColor,
                                  )
                                : Icon(
                                    CupertinoIcons.person_3_fill,
                                    color: tasksList[3].iconColor,
                                  ),

                    // Title of the category.

                    title: Text(
                      findCategoryItem.title!,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),

                    // Trailing action (Delete for 'Social' category).

                    trailing: findCategoryItem.title == 'Social'
                        ? IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              deletePressed(context, findCategoryItem);
                            },
                          )
                        : null, // Display null if not 'Social' category.
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

// Handle the deletion of a category.
Future<void> deletePressed(context, Category category) async {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      content:
          const Text('Are you sure you want to delete the Social category?'),
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
        )
      ],
    ).animate().scaleY(duration: const Duration(milliseconds: 250)),
  );
}
