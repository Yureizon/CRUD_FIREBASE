import 'package:crud_firebase/providers/actual_option_provider.dart';
import 'package:crud_firebase/providers/students_form_provider.dart';
import 'package:crud_firebase/services/students_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateStudentScreen extends StatelessWidget {
  const CreateStudentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final StudentsService studentsService = Provider.of(context);
    
    return ChangeNotifierProvider(
      create: (_) => StudentsFormProvider(studentsService.selectedStudent),
      child: _CreateForm(studentsService: studentsService),
    );
  }
}

class _CreateForm extends StatelessWidget {

  final StudentsService studentsService;

  const _CreateForm({required this.studentsService});

  @override
  Widget build(BuildContext context) {

    final StudentsFormProvider studentsFormProvider = Provider.of<StudentsFormProvider>(context);

    final student = studentsFormProvider.student;

    final ActualOptionProvider actualOptionProvider = Provider.of<ActualOptionProvider>(context, listen: false);
    
    return Form(
      key: studentsFormProvider.formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          TextFormField(
            autocorrect: false,
            keyboardType: TextInputType.number,
            initialValue: student.identificationDocument.toString(),
            decoration: const InputDecoration (
              hintText: '953859',
              labelText: 'Identification Document',
              contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            ),
            onChanged: (value) {
              if (value.isNotEmpty) {
                try {
                  studentsFormProvider.student.identificationDocument = int.parse(value);
                } catch (e) {
                  print('よく書けよ、バカ、$eって何？');
                }
                
              } else {
                studentsFormProvider.student.identificationDocument = 0;
              }
            },
            validator: (value) {
              if (value != null) {
                if (value.isEmpty) {
                  return 'The field must not be empty';
                }
                try {
                  int.parse(value);
                  // Si tiene éxito, entonces es un número válido
                  return null; // Retorna null para indicar que no hay error
                } catch (e) {
                  // Si hay una excepción al intentar convertir, significa que no es un número válido
                  return 'Ingresa un número válido.';
                }
              } else {
                return 'The field must not be empty';
              }
              //return value != '' ? null : 'The field must not be empty';
            },
          ),
          const SizedBox(height: 30),
          TextFormField(
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            initialValue: student.name,
            decoration: const InputDecoration (
              hintText: 'example: Carlos',
              labelText: "Student's name",
              contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            ),
            onChanged: (value) => studentsFormProvider.student.name = value,
            validator: (value) {
              return value != '' ? null : 'The field must not be empty';
            },
          ),
          const SizedBox(height: 30),
          TextFormField(
            autocorrect: false,
            keyboardType: TextInputType.number,
            initialValue: student.age.toString(),
            decoration: const InputDecoration (
              hintText: '16',
              labelText: 'Age',
              contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            ),
            onChanged: (value) {
              if (value.isNotEmpty) {
                try {
                  studentsFormProvider.student.age = int.parse(value);
                } catch (e) {
                  print('よく書けよ、バカ、$eって何？');
                }
                
              } else {
                studentsFormProvider.student.age = 0;
              }
            },
            validator: (value) {
              if (value != null) {
                if (value.isEmpty) {
                  return 'The field must not be empty';
                }
                try {
                  int.parse(value);
                  return null; 
                } catch (e) {
                  // Si hay una excepción al intentar convertir, significa que no es un número válido
                  return 'Ingresa un número válido.';
                }
              } else {
                return 'The field must not be empty';
              }
              //return value != '' ? null : 'The field must not be empty';
            },
          ),
          const SizedBox(height: 30),
          MaterialButton (
            shape: RoundedRectangleBorder (borderRadius: BorderRadius.circular(10)),
            disabledColor: Colors.grey,
            elevation: 0,
            color: Colors.red,
            splashColor: Colors.yellow,
            onPressed: studentsService.isSaving ? null : () async {
              // Quitar teclado al terminar
              FocusScope.of(context).unfocus();

              if (!studentsFormProvider.isValidForm()) return;

              await studentsService.createOrUpdate(studentsFormProvider.student);

              studentsService.isSaving = false;

              actualOptionProvider.selectedOption = 0;
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
              child: Text(studentsService.isLoading ? 'Wait' : 'Ingresar', style: const TextStyle(color: Colors.white),),
            ),
          )
        ],
      ),
    );
  }
}