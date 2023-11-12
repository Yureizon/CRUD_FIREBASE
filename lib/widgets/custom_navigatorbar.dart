import 'package:crud_firebase/models/student_model.dart';
import 'package:crud_firebase/providers/actual_option_provider.dart';
import 'package:crud_firebase/services/students_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomNavigatorBar extends StatelessWidget {
  const CustomNavigatorBar({super.key});

  @override
  Widget build(BuildContext context) {
    final ActualOptionProvider actualOptionProvider = Provider.of<ActualOptionProvider>(context);
    final StudentsService studentsService = Provider.of(context, listen: false);
    final currenIndex = actualOptionProvider.selectedOption;

    return BottomNavigationBar (
      //Current Index, para determinar el botón que debe marcarse
      currentIndex: currenIndex,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey,
      backgroundColor: Colors.red,

      onTap: (int i) {
        if (i == 1) {
          studentsService.selectedStudent = Student (identificationDocument: 0, name: '', age: 0);
        }
        actualOptionProvider.selectedOption = i;
      },
      // Items
      items: const <BottomNavigationBarItem> [
        BottomNavigationBarItem (icon: Icon(Icons.group), label: 'Students List'),
        BottomNavigationBarItem (icon: Icon(Icons.person_add), label: 'Create Student'),
      ],
    );
  }
}