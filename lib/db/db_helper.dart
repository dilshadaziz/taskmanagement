// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:taskmate/model/category.dart';
import 'package:taskmate/model/task.dart';

// ValueNotifier for managing a list of categories
ValueNotifier<List<Category>> categoryList = ValueNotifier([]);
ValueNotifier<List<TasksDB>> dbTasksList = ValueNotifier([]);

class DBHelper {
  // A static reference to the database
  static late Database _db;
  static late Database _db2;

  // Create the Category Database
  static Future<void> createDatabase() async {
    // Initialize and open the database
    _db = await openDatabase(
      'category',
      version: 1,
      onCreate: (db, version) async {
        // Create a 'category' table with necessary fields
        await db.execute(
          'CREATE TABLE category(id INTEGER PRIMARY KEY, title TEXT, done INTEGER, left INTEGER)',
        );
      },
    );
    debugPrint('Database created...');
  }

  //Create task Database 
  static Future<void> createTaskDatabase() async {
    _db2 = await openDatabase('tasks',version: 1,onCreate: (db, version) async {
      await db.execute('CREATE TABLE tasks (id INTEGER PRIMARY KEY,tasktitle TEXT, iscompleted INTEGER, date TEXT, starttime TEXT, endtime TEXT, color INTEGER, remind INTEGER, repeat TEXT)');
    },);
  }

  // Read Categories from the Database
  static Future<void> getCategory() async {
    final result = await _db.rawQuery('SELECT * FROM category');
    debugPrint("CATEGORY DATA: $result");
    categoryList.value.clear();
    for (var map in result) {
      final category = Category.fromMap(map);
      categoryList.value.add(category);
    }
    // Notify listeners that the category list has changed
    categoryList.notifyListeners();
  }

  // Insert a new category into the Database
  static Future<void> insertToCategory(Category categoryData) async {
    try {
      await _db.rawInsert(
        'INSERT INTO category(title, done, left) VALUES(?,?,?)',
        [categoryData.title, categoryData.done, categoryData.left],
      );
      // Update the category list after insertion
      getCategory();
    } catch (e) {
      debugPrint('Error inserting data: $e');
    }
  }


  static Future<void> getTasks() async {
    final result = await _db2.rawQuery('SELECT * FROM tasks');
    debugPrint("TASKS DATA: $result");
    dbTasksList.value.clear();
    for (var map in result) {
      final tasks = TasksDB.fromMap(map);
      dbTasksList.value.add(tasks);
    }
    // Notify listeners that the category list has changed
    dbTasksList.notifyListeners();
  }

  // Insert a new task into the Database
  static Future<void> insertToTask(TasksDB taskData) async {
    try {
      await _db2.rawInsert(
          'INSERT INTO tasks(tasktitle,iscompleted,date,starttime,endtime,color,remind,repeat) VALUES(?,?,?,?,?,?,?,?)',
          [
            taskData.taskTitle,
            taskData.isCompleted,
            taskData.date,
            taskData.startTime,
            taskData.endTime,
            taskData.color,
            taskData.remind,
            taskData.repeat,
          ]);
          // Update the category list after insertion
          getTasks();
    } catch (e) {
      debugPrint('Error task inserting : $e');
    }

  }

  // Delete a Category from the Database
  static Future<void> deleteCategory(id) async {
    await _db.delete('category', where: 'id=?', whereArgs: [id]);
    // Update the category list after deletion
    getCategory();
  }

  // Clear the entire Category Database
  static Future<void> clearDatabase() async {
    await deleteDatabase('category');
    await deleteDatabase('tasks');
  }
}
