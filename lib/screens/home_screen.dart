import 'package:crud_firebase/providers/actual_option_provider.dart';
import 'package:crud_firebase/screens/create_student_screen.dart';
import 'package:crud_firebase/screens/list_students_screen.dart';
import 'package:crud_firebase/widgets/custom_navigatorbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Tercer Reich')),
        backgroundColor: Colors.red,
      ),
      body: _HomeScreenBody(),
      bottomNavigationBar: const CustomNavigatorBar(),
    );
  }
}

class _HomeScreenBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ActualOptionProvider actualOptionProvider = Provider.of<ActualOptionProvider>(context);

    int selectedOption = actualOptionProvider.selectedOption;

    switch (selectedOption) {
      case 0:
        return const ListStudentsScreen();
      case 1: 
        return const CreateStudentScreen();
      default:
        return const ListStudentsScreen();
    }
  }
}