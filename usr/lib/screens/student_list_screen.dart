import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/student.dart';
import 'add_student_screen.dart';

class StudentListScreen extends StatefulWidget {
  const StudentListScreen({super.key});

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  // Local list to store students (in-memory only for now)
  final List<Student> _students = [];

  void _navigateToAddStudent() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddStudentScreen()),
    );

    if (result != null && result is Student) {
      setState(() {
        _students.add(result);
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${result.name} added successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Directory'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _students.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.school_outlined, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No students added yet',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  const Text('Tap the + button to add a student'),
                ],
              ),
            )
          : ListView.builder(
              itemCount: _students.length,
              itemBuilder: (context, index) {
                final student = _students[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                      child: Text(
                        student.name.isNotEmpty ? student.name[0].toUpperCase() : '?',
                        style: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer),
                      ),
                    ),
                    title: Text(student.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.cake, size: 14, color: Colors.grey[600]),
                            const SizedBox(width: 4),
                            Text(DateFormat('MMM d, yyyy').format(student.dateOfBirth)),
                            const SizedBox(width: 16),
                            Icon(Icons.person, size: 14, color: Colors.grey[600]),
                            const SizedBox(width: 4),
                            Text(student.gender),
                          ],
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          _students.removeAt(index);
                        });
                      },
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddStudent,
        tooltip: 'Add Student',
        child: const Icon(Icons.add),
      ),
    );
  }
}
