import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // <-- Add this import

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.pink),
      home: DailyChecklist(),
      title: "Amore", // <-- App name changed here to something romantic
    );
  }
}

class DailyChecklist extends StatefulWidget {
  @override
  _DailyChecklistState createState() => _DailyChecklistState();
}

class _DailyChecklistState extends State<DailyChecklist> {
  List<String> morningTasks = ['Drink Water', 'Eat Breakfast', 'Stretch', 'Brush Teeth']; // Added "Brush Teeth"
  List<String> healthyHabits = ['Clean', 'More Water', 'Yummy Dinner', 'Read', 'Study', 'Workout', 'Self Care'];
  List<String> mentalTasks = ['Write a Positive Affirmation', '5 Minute Meditation', 'Reflect on Positive Thoughts'];
  List<String> nightTasks = ['Drink More Water', 'Sleep Long', 'Sweet Dreams', 'Brush Teeth']; // Added "Brush Teeth"

  List<List<bool>> taskCompletionStatus = [
    [false, false, false, false], // For morningTasks (updated size)
    [false, false, false, false, false, false, false], // For healthyHabits
    [false, false, false], // For mentalTasks
    [false, false, false, false], // For nightTasks (updated size)
  ];

  @override
  void initState() {
    super.initState();
    _loadTaskStatus(); // Load task status when the app starts
  }

  // Method to load task completion status from shared preferences
  void _loadTaskStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    for (int i = 0; i < taskCompletionStatus.length; i++) {
      for (int j = 0; j < taskCompletionStatus[i].length; j++) {
        bool? taskStatus = prefs.getBool('task_$i$j');
        if (taskStatus != null) {
          setState(() {
            taskCompletionStatus[i][j] = taskStatus;
          });
        }
      }
    }
  }

  // Method to save task completion status to shared preferences
  void _saveTaskStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    for (int i = 0; i < taskCompletionStatus.length; i++) {
      for (int j = 0; j < taskCompletionStatus[i].length; j++) {
        prefs.setBool('task_$i$j', taskCompletionStatus[i][j]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      appBar: AppBar(
        title: Text("Uppgifter för min älskling", style: TextStyle(fontFamily: 'Cursive', fontSize: 24)),
        backgroundColor: Colors.pink,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildTaskSection('Morning 🌞', morningTasks, 0),
            _buildTaskSection('Healthy Habits 💞', healthyHabits, 1),
            _buildTaskSection('Mental 🦢', mentalTasks, 2),
            _buildTaskSection('End of Night 😴', nightTasks, 3),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskSection(String sectionTitle, List<String> tasks, int sectionIndex) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            sectionTitle,
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.pink[700]),
          ),
          SizedBox(height: 10),
          ...tasks.asMap().entries.map((entry) {
            int index = entry.key;
            String task = entry.value;
            return CheckboxListTile(
              title: Text(
                task,
                style: TextStyle(fontSize: 18, color: Colors.pink[800]),
              ),
              value: taskCompletionStatus[sectionIndex][index],
              onChanged: (bool? value) {
                setState(() {
                  if (taskCompletionStatus[sectionIndex].isNotEmpty) {
                    taskCompletionStatus[sectionIndex][index] = value!;
                  }
                });
                _saveTaskStatus();
              },
            );
          }).toList(),
        ],
      ),
    );
  }
}
