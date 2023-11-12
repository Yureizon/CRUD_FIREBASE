import 'package:crud_firebase/providers/actual_option_provider.dart';
import 'package:crud_firebase/services/students_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListStudentsScreen extends StatelessWidget {
  const ListStudentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    StudentsService studentsService = Provider.of<StudentsService>(context);
    return Scaffold(
      body: _ListStudents(),
      /*floatingActionButton: FloatingActionButton(
        onPressed: () => studentsService.loadStudents(),
        child: const Icon(Icons.refresh),
      ),
      persistentFooterButtons: [
        FloatingActionButton(
          onPressed: (){
            studentsService.students.clear();
          },
          child: const Icon(Icons.energy_savings_leaf),
        ),
      ],*/
    );
  }
}

class _ListStudents extends StatelessWidget {
  
  void displayDialog (BuildContext context, StudentsService studentsService, String id) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          elevation: 5,
          title: const Text('WARNING!'),
          shape: RoundedRectangleBorder (borderRadius: BorderRadiusDirectional.circular(10)),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Do you want to permanently delete the registry?'),
              SizedBox(height: 10),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await studentsService.deleteStudentById(id);
                studentsService.students.clear();
                await studentsService.loadStudents();
                Navigator.pop(context);
              },
              child: const Text('Yeah!'),
            ),
          ],
        );
      }
    );
  }

  void detail (BuildContext context, StudentsService studentsService, int index) {
    final students = studentsService.students; 
    showModalBottomSheet(
      showDragHandle: true,
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Student Detail", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.blue),),
              const SizedBox(height: 15,),
              Text.rich(
                TextSpan(
                  style: const TextStyle(fontSize: 15),
                  children: <TextSpan> [
                    const TextSpan(text: "Student Identification Document: ", style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold)),
                    TextSpan(text: "${students[index].identificationDocument}\n"),
                    const TextSpan(text: "Student name: ", style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold)),
                    TextSpan(text: "${students[index].name}\n"),
                    const TextSpan(text: "Student age: ", style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold)),
                    TextSpan(text: "${students[index].age}\n"),
                  ]
                )
              ),
              TextButton(
                onPressed:() => Navigator.of(context).pop(), child: const Text("Okay", style: TextStyle(color: Colors.white),),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                )
            ],
          ),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    StudentsService studentsService = Provider.of<StudentsService>(context);
    //studentsService.loadStudents(); // Esto me genera error
    final students = studentsService.students;

    return ListView.builder(
      itemCount: students.length,
      itemBuilder: (_, index) => ListTile(
        onTap: () => detail(context, studentsService, (index)),
        leading: const Icon(Icons.person),
        title: Text(students[index].name),
        subtitle: Text('${students[index].identificationDocument}\nAge: ${students[index].age}'),
        trailing: PopupMenuButton (
          onSelected: (int i) {
            if (i == 0) {
              
              studentsService.selectedStudent = students[index];
              Provider.of<ActualOptionProvider>(context, listen: false).selectedOption = 1;
              return;
            }

            displayDialog(context, studentsService, students[index].id!);
          },
          itemBuilder: (context) => [
            const PopupMenuItem(value: 0, child: Text('Update'),),
            const PopupMenuItem(value: 1, child: Text('Delete'),),
          ]
        ),
      ),
    );
  }
}