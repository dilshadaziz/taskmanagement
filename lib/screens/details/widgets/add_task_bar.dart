import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:taskmate/db/db_helper.dart';
import 'package:taskmate/model/task.dart';
import 'package:taskmate/screens/details/widgets/input_field.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TextEditingController _titleController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _startTime = DateFormat('hh:mm a').format(DateTime.now()).toString();
  String _endTime = '9:30 PM';
  int _selectedRemind = 5;
  List<int> remindList = [
    5,
    10,
    15,
    20,
  ];
  String _selectedRepeat = 'None';
  List<String> repeatList = [
    'None',
    'Daily',
    'Weekly',
    'Monthly',
  ];
  int _selectedColor = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              MyInputField(title: 'Title', hint: 'Enter your title',controller: _titleController,),
              MyInputField(
                title: 'Date',
                hint: DateFormat.yMd().format(_selectedDate),
                widget: IconButton(
                    onPressed: () {
                      _getDateFromUser();
                    },
                    icon: const Icon(
                      Icons.calendar_month_outlined,
                      color: Colors.black54,
                    )),
              ),
              Row(
                children: [
                  Expanded(
                    child: MyInputField(
                      title: 'Start Time',
                      hint: _startTime,
                      widget: IconButton(
                          onPressed: () {
                            _getTimeFromUser(isStartTime: true);
                          },
                          icon: const Icon(
                            Icons.access_time_rounded,
                            color: Colors.black54,
                          )),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: MyInputField(
                      title: 'End Time',
                      hint: _endTime,
                      widget: IconButton(
                        onPressed: () {
                          _getTimeFromUser(isStartTime: false);
                        },
                        icon: const Icon(
                          Icons.access_time_rounded,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              MyInputField(
                title: 'Remind',
                hint: '$_selectedRemind minutes early',
                widget: DropdownButton(
                  icon: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Colors.black54,
                  ),
                  iconSize: 32,
                  elevation: 4,
                  underline: const SizedBox(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedRemind = int.parse(newValue!);
                    });
                  },
                  items: remindList.map<DropdownMenuItem<String>>((int value) {
                    return DropdownMenuItem<String>(
                      value: value.toString(),
                      child: Text(value.toString()),
                    );
                  }).toList(),
                ),
              ),
              MyInputField(
                title: 'Repeat',
                hint: _selectedRepeat,
                widget: DropdownButton(
                  icon: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Colors.black54,
                  ),
                  iconSize: 32,
                  elevation: 4,
                  underline: const SizedBox(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedRepeat = newValue!;
                    });
                  },
                  items:
                      repeatList.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 18.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [_colorPallete(), _addTaskButton()],
              )
            ],
          ),
        ),
      ),
    );
  }

  _buildAppBar() {
    return AppBar(
      centerTitle: true,
      titleTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 30,
        fontWeight: FontWeight.bold,
        height: 1.3,
      ),
      leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back_ios_new_outlined)),
      title: const Text('Add Task'),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: SizedBox(
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
        ),
      ],
    );
  }

  _getDateFromUser() async {
    DateTime? _pickerDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      initialDatePickerMode: DatePickerMode.day,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
    );
    if (_pickerDate != null) {
      setState(() {
        _selectedDate = _pickerDate;
      });
    } else {
      debugPrint('Selected Date is null or something went wrong...');
    }
  }

  _getTimeFromUser({required bool isStartTime}) async {
    var _pickedTime = await _showTimePicker();
    String _formatedTime = _pickedTime.format(context);
    if (_pickedTime == null) {
      debugPrint('Time cancelled');
    } else if (isStartTime == true) {
      setState(() {
        _startTime = _formatedTime;
      });
    } else if (isStartTime == false) {
      setState(() {
        _endTime = _formatedTime;
      });
    }
  }

  _showTimePicker() {
    return showTimePicker(
      initialEntryMode: TimePickerEntryMode.input,
      context: context,
      initialTime: TimeOfDay(
        hour: int.parse(_startTime.split(':')[0]),
        minute: int.parse(
          _startTime.split(':')[1].split(' ')[0],
        ),
      ),
    );
  }

  _colorPallete() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Color',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8.0),
        Wrap(
          children: List<Widget>.generate(
              3,
              (index) => GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedColor = index;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: CircleAvatar(
                          radius: 14,
                          backgroundColor: index == 0
                              ? const Color.fromARGB(255, 255, 231, 158)
                              : index == 1
                                  ? const Color.fromARGB(255, 164, 210, 248)
                                  : const Color.fromARGB(255, 255, 146, 138),
                          child: _selectedColor == index
                              ? const Icon(
                                  Icons.done,
                                  color: Colors.white,
                                  size: 18,
                                )
                              : null),
                    ),
                  )),
        )
      ],
    );
  }

  _addTaskButton() {
    return ElevatedButton(
      onPressed: () {
        _validateTitle();
      },
      style: ButtonStyle(
        padding: MaterialStatePropertyAll(EdgeInsets.symmetric(horizontal: 20,vertical: 15)),
        backgroundColor: const MaterialStatePropertyAll(Colors.black),
        shape: MaterialStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      child: const Text(
        'Add Task',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  _validateTitle()async{
    if(_titleController.text.isNotEmpty){
      //Submit to Database
    final taskData = TasksDB(
    taskTitle: _titleController.text,
    isCompleted: 0,
    date: DateFormat.yMd().format(_selectedDate),
    startTime: _startTime,
    endTime: _endTime,
    color: _selectedColor,
    remind: _selectedRemind,
    repeat: _selectedRepeat
  );
  await DBHelper.insertToTask(taskData);

      Get.back();
    }
    else {
      Get.snackbar('Required', 'All Fields are Required !',colorText: Colors.white,backgroundColor: Colors.red,icon: const Icon(Icons.warning_amber_rounded,),margin: const EdgeInsets.all(10),forwardAnimationCurve: Curves.decelerate,snackPosition: SnackPosition.BOTTOM);
    }
  }
}
