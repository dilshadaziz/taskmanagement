import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taskmate/constants/colors.dart';

class Category {
  int? id;
  IconData? iconData;
  String? title;
  Color? bgColor;
  Color? iconColor;
  Color? btnColor;
  num? left;
  num? done;
  bool isLast;
  Category({
    this.id,
    this.title,
    this.bgColor,
    this.iconData,
    this.btnColor,
    this.iconColor,
    this.left,
    this.done,
    this.isLast = false,
  });
  static List<Category> generateCategories() {
    return [
      Category(
        title: 'Person',
        iconData :  Icons.person,
        bgColor: kYellowLight,
        iconColor: kYellowDark,
        btnColor: kYellow,
      ),
      Category(
        title: 'Work',
        iconData :  CupertinoIcons.briefcase_fill,
       bgColor: kRedLight,
        iconColor: kRedDark,
        btnColor: kRed,
      ),
      Category(
        title: 'Health',
        iconData :  Icons.favorite,
        bgColor: kBlueLight,
        iconColor: kBlueDark,
        btnColor: kBlue,
      ),
      Category(
        title: 'Social',
        iconData :  CupertinoIcons.person_3_fill,
        bgColor: kGreenLight,
        iconColor: kGreenDark,
        btnColor: kGreen,
      ),
    ];
  }

   static Category fromMap(Map<String, Object?> map) {
    int id = map['id'] as int;
    String title = map['title'] as String;
    int left = map['left'] as int;
    int done = map['done'] as int;

    return Category(
      left: left,
      done: done,
     id : id,
     title : title,
     );
  }

}
