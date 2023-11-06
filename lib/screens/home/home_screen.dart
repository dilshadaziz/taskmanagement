import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:taskmate/model/category.dart';
import 'package:taskmate/screens/details/details.dart';
import 'package:taskmate/screens/search/search_screen.dart';
import 'package:taskmate/screens/home/widgets/go_premium.dart';
import 'package:taskmate/screens/home/widgets/tasks.dart';
import 'package:taskmate/db/db_helper.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';


class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int bottomNavIndex =
      0; // Integer to track the selected bottom navigation index.

  @override
  Widget build(BuildContext context) {
    DBHelper.getCategory(); // Retrieve category data from the database.

    return Scaffold(
      // App Bar for the top of the screen.
      appBar: _buildappBar(),
      body: SafeArea(
        // The main content area of the app.
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const GoPremium(), // Widget for going premium.

            Container(
              padding: const EdgeInsets.all(15),
              child: const Text(
                'Tasks',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: Tasks(), // Display tasks in an expandable widget.
            ),
          ],
        ),
      ),
      bottomNavigationBar:
          _buildCurvedBottomNavigationBar(), // Bottom navigation bar.
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _floatingActionButton(), // Floating action button.
    );
  }

// Widget to build the app bar.
  _buildappBar(){
    return AppBar(
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 30,
          fontWeight: FontWeight.bold,
          height: 1.3,
        ),
        title: Row(
          children: [
            SizedBox(
              height: 40,
              width: 40,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  'assets/images/profile.jpeg',
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            const Text('Hello, Welcome!'),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
            child: IconButton(
              onPressed: () {
                Get.to(() => const Search(),
                    transition: Transition.downToUp,
                    duration: const Duration(milliseconds: 300));
              },
              icon: const Icon(Icons.search),
              iconSize: 30,
            ),
          )
        ],
      );
  }

// Widget to build the curved bottom navigation bar.
  Widget _buildCurvedBottomNavigationBar() {
    return CurvedNavigationBar(
      items: [
        Icon(
          Icons.home_rounded,
          color: bottomNavIndex == 0 ? Colors.white : Colors.black,
        ),
        Icon(
          Icons.person,
          color: bottomNavIndex == 1 ? Colors.white : Colors.black,
        ),
      ],
      onTap: (value) {
        // Handle bottom navigation item taps.
        setState(() {
          bottomNavIndex = value;
        });
      },
      animationCurve: Curves.easeInOutQuart,
      height: 60,
      color: Colors.transparent,
      buttonBackgroundColor: Colors.black,
      backgroundColor: Colors.transparent,
      animationDuration: const Duration(milliseconds: 300),
      letIndexChange: (value) => true,
    );
  }

// Create the floating action button.
  _floatingActionButton() {
    return FloatingActionButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 0,
      backgroundColor: Colors.black,
      onPressed: () {
        _showBottomSheet(
            context); // Show a bottom sheet when the button is pressed.
      },
      child: const Icon(
        Icons.add,
        size: 35,
        color: Colors.white,
      ),
    );
  }

// Handle adding a new category.
Future<void> addCategoryClicked(context) async {
  final categoryData4 = Category(
    title: 'Social',
    left: 0,
    done: 0,
  );
  await DBHelper.insertToCategory(categoryData4);
  Navigator.pop(context);
}

// Show a bottom sheet for selecting a category.
_showBottomSheet(context) {
  return showModalBottomSheet(
    context: context,
    builder: (context) => Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      height: MediaQuery.of(context).size.height * 2,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 18, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Select a Category',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(Icons.close),
                )
              ],
            ),
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: categoryList,
              builder: (context, value, child) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: GridView.builder(
                    itemCount: 4,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                    ),
                    itemBuilder: (context, index) {
                      if (index > value.length - 1) {
                        return _buildAddCategory(
                            context); // Build the "Add" category item.
                      } else {
                        return _buildCategory(context, value[index], index);
                      }
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ),
  );
}

// Build the category item.
Widget _buildCategory(BuildContext context, Category category, index) {
  final tasksList = Category.generateCategories();

  return GestureDetector(
    onTap: () {
      Get.off(
        () => Details(
          categoryname: category.title!,
          categories: category,
        ),
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
          Row(
            children: [
              _buildCategoryStatus(
                tasksList[index].btnColor!,
                tasksList[index].iconColor!,
                '${category.left} left',
              ),
              const SizedBox(
                width: 5,
              ),
              _buildCategoryStatus(
                Colors.white,
                tasksList[index].iconColor!,
                '${category.done} done',
              ),
            ],
          )
        ],
      ),
    ),
  );
}

// Build the category status decoration.
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

// Build the "Add Category" widget.
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

Future<void> deletePressed(context, Category category) async {
  // Handle the deletion of a category.
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
            content: const Text(
                'Are you sure you want to delete the Social category?'),
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
          ).animate().flip(
                duration: const Duration(milliseconds: 300),
              ));
}

}

