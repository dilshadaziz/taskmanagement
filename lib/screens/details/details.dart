import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskmate/constants/colors.dart';
import 'package:taskmate/db/db_helper.dart';
import 'package:taskmate/model/category.dart';
import 'package:taskmate/model/task.dart';
import 'package:taskmate/screens/details/widgets/add_task_bar.dart';

class Details extends StatefulWidget {
  final String categoryname;
  final Category categories;

  const Details(
      {required this.categoryname, required this.categories, super.key});

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  DateTime _selectedDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
      floatingActionButton: _buildFloatingActionButton(),
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  )),
              child: Padding(
                padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDateBar(),
                    _buildTaskTitle(),
                  ],
                ),
              ),
            ),
          ),
          ValueListenableBuilder(
            valueListenable: dbTasksList,
            builder: (context, taskList, child) => taskList.isEmpty
                ? SliverFillRemaining(
                    child: Container(
                      color: Colors.white,
                      child: const Center(
                        child: Text('No task today'),
                      ),
                    ),
                  )
                : SliverList(
                    delegate: SliverChildListDelegate([
                      _buildCard(taskList[0].taskTitle, taskList[0].startTime, taskList[0].endTime)
                    ])
                  ),
          )
        ],
      ),
    );
  }

  _buildFloatingActionButton() {
    return FloatingActionButton(
      backgroundColor: Colors.white,
      onPressed: () {
        DBHelper.getTasks();
        Get.to(() => const AddTaskPage(), transition: Transition.size);
      },
      child: const Icon(Icons.add),
    );
  }

  Widget _buildAppBar(context) {
    return SliverAppBar(
      expandedHeight: 90,
      backgroundColor: Colors.black,
      leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_outlined,
            size: 20,
            color: Colors.white,
          )),
      flexibleSpace: FlexibleSpaceBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${widget.categoryname} tasks',
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              'You have ${widget.categories.left} tasks for today!',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateBar() {
    return DatePicker(
      DateTime.now(),
      height: 80,
      width: 50,
      initialSelectedDate: DateTime.now(),
      selectionColor: Colors.grey.shade400,
      selectedTextColor: Colors.white,
      monthTextStyle: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
      dayTextStyle: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
      dateTextStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      onDateChange: (selectedDate) {
        _selectedDate = selectedDate;
        debugPrint('$_selectedDate');
      },
    );
  }

  Widget _buildTaskTitle() {
    return Container(
      padding: const EdgeInsets.all(15),
      child: const Text(
        'Tasks',
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildCard(title, start, end) {
    debugPrint('listed title : $title');
    return Container(
      decoration: BoxDecoration(
          color: TasksDB().color == 1
              ? kYellowLight
              : TasksDB().color == 2
                  ? kBlueLight
                  : kRedLight,
          borderRadius: const BorderRadius.only(
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10))),
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [Text('$title'), Text('$start - $end')],
      ),
    );
  }
}
