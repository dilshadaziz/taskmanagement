// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskmate/db/db_helper.dart';
import 'package:taskmate/main.dart';
import 'package:taskmate/model/category.dart';
import 'package:taskmate/screens/home/home_screen.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key}); 

  @override
  State<OnBoarding> createState() =>
      _OnBoardingState(); 
}

class _OnBoardingState extends State<OnBoarding> {
  late PageController
      _pageController; // Page controller for managing onboarding pages.
  int _pageIndex = 0; // Current index of the onboarding page.

  @override
  void initState() {
    _pageController =
        PageController(initialPage: 0); // Initialize the page controller.
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose(); // Dispose of the page controller.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // App Bar with title and "Skip" button.
      appBar: AppBar(
        backgroundColor: Colors.white,
        titleTextStyle: const TextStyle(
            color: Colors.black,
            fontSize: 33,
            fontWeight: FontWeight.bold,
            height: 2),
        title: Padding(
          padding: const EdgeInsets.only(left: 12, top: 12),
          child: _pageIndex < 3
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('TASKMATE'),
                    TextButton(
                      onPressed: () async {
                        await checkDefaultCategoryAdded(); // Check and add default categories.
                        checkLogin(); // Check and handle login.
                      },
                      child: const Text("Skip"),
                    ),
                  ],
                )
              : const Text('TASKMATE'),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 15),
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  onPageChanged: (index) {
                    setState(() {
                      _pageIndex = index;
                    });
                  },
                  itemCount: onBoardList.length,
                  controller: _pageController,
                  itemBuilder: (context, index) => OnboardContent(
                    image: onBoardList[index].image,
                    title: onBoardList[index].title,
                    title2: onBoardList[index].title2 ?? '',
                    description: onBoardList[index].description,
                  ),
                ),
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ...List.generate(
                          onBoardList.length,
                          (index) => Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircleNavigate(
                                  isActive: index ==
                                      _pageIndex, // Identify if the circle is active.
                                ),
                              )),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  _pageIndex == 0
                      ? SizedBox(
                          height: 60,
                          width: MediaQuery.sizeOf(context).width / 1.1,
                          child: ElevatedButton(
                              onPressed: () {
                                _pageController.nextPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.ease);
                              },
                              style: ButtonStyle(
                                  backgroundColor:
                                      const MaterialStatePropertyAll(
                                          Colors.black),
                                  shape: MaterialStatePropertyAll(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)))),
                              child: Text(onBoardList[0].button,
                                  style: const TextStyle(
                                      fontSize: 20, color: Colors.white))),
                        )
                      : _pageIndex == 1 || _pageIndex == 2
                          ? SizedBox(
                              height: 60,
                              width: MediaQuery.sizeOf(context).width / 1.1,
                              child: ElevatedButton(
                                onPressed: () {
                                  _pageController.nextPage(
                                      duration:
                                          const Duration(milliseconds: 300),
                                      curve: Curves.ease);
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      const MaterialStatePropertyAll(
                                          Colors.black),
                                  shape: MaterialStatePropertyAll(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                ),
                                child: Text(
                                  onBoardList[1].button,
                                  style: const TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                              ),
                            )
                          : SizedBox(
                              height: 60,
                              width: MediaQuery.sizeOf(context).width / 1.1,
                              child: GestureDetector(
                                child: ElevatedButton(
                                  onPressed: () async {
                                    await checkDefaultCategoryAdded(); // Check and add default categories.
                                    checkLogin(); // Check and handle login.
                                  },
                                  style: ButtonStyle(
                                    backgroundColor:
                                        const MaterialStatePropertyAll(
                                            Colors.black),
                                    shape: MaterialStatePropertyAll(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    onBoardList[3].button,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CircleNavigate extends StatelessWidget {
  const CircleNavigate({
    this.isActive = false, // Boolean to identify if the circle is active.
    super.key,
  });

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      maxRadius: 10,
      backgroundColor: isActive ? Colors.black : Colors.grey.shade200,
    );
  }
}

class OnboardContent extends StatelessWidget {
  const OnboardContent({
    Key? key,
    required this.image,
    required this.title,
    required this.title2,
    required this.description,
  }) : super(key: key);
  final String image, title, title2, description;

  @override
  Widget build(BuildContext context) {
    // Column containing onboarding content.
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.sizeOf(context).height / 2.2,
          child: Image.asset(image),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
            ),
            Text(
              title2,
              style: const TextStyle(
                  color: Color.fromRGBO(0, 128, 128, 1),
                  fontSize: 34,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
              style: const TextStyle(
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
              description),
        ),
        Container()
      ],
    );
  }
}

class OnboardPages {
  final String image, title, description, button;
  final String? title2;

  OnboardPages({
    required this.image,
    required this.title,
    this.title2,
    required this.description,
    required this.button,
  });
}

final List<OnboardPages> onBoardList = [
  OnboardPages(
    image: 'assets/images/welcome.png',
    title: 'Welcome To ',
    title2: 'TaskMate',
    description:
        'Where task management goes beyond the ordinary, providing a dynamic and engaging platform to tackle your daily challenges with precision and flair. TaskMate is your all-in-one solution.',
    button: 'Get Started',
  ),
  OnboardPages(
    image: 'assets/images/schedule.png',
    title: 'Set Schedule',
    description:
        'With our set schedule feature, you can effortlessly plan your day to day events. Make the most of your time by customizing your daily routines. Tap \'Next\' and take control of your day',
    button: 'Next',
  ),
  OnboardPages(
    image: 'assets/images/reminder.png',
    title: 'Create Event Reminder',
    description:
        'Never miss a moment. Set up reminders for all your important events. Tap \'Next\' to get started.',
    button: 'Next',
  ),
  OnboardPages(
    image: 'assets/images/notes.png',
    title: 'Taking Notes',
    description: 'Taking Notes and making important to-do lists on the go',
    button: 'Let\'s Start',
  ),
];

Future<void> checkLogin() async {
  // Function to check and handle login.
  final _sharedPrefs = await SharedPreferences.getInstance();
  await _sharedPrefs.setBool(SAVE_KEY, true);
  Get.off(() => const Home(),
      transition: Transition.cupertinoDialog,
      duration: const Duration(milliseconds: 600));
}

// Function to check if default categories are added.
Future<void> checkDefaultCategoryAdded() async {
  final _sharedPrefs = await SharedPreferences.getInstance();
  final _alreadyCreated = _sharedPrefs.getBool(CATEGORY_KEY);
  if (_alreadyCreated == null || _alreadyCreated == false) {
    await addDefaultCategories(); // Add default categories if not already created.
  }
}

// Function to add default categories.
Future<void> addDefaultCategories() async {
  final categoryData1 = Category(
    title: 'Personal',
    left: 3,
    done: 1,
  );
  await DBHelper.insertToCategory(categoryData1);
  final categoryData2 = Category(
    title: 'Work',
    left: 1,
    done: 2,
  );

  await DBHelper.insertToCategory(categoryData2);
  final categoryData3 = Category(
    title: 'Health',
    left: 2,
    done: 0,
  );

  await DBHelper.insertToCategory(categoryData3);
  final _sharedPrefs = await SharedPreferences.getInstance();
  await _sharedPrefs.setBool(CATEGORY_KEY, true);
}
