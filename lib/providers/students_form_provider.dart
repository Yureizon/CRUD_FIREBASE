import 'package:crud_firebase/models/student_model.dart';
import 'package:flutter/material.dart';

class StudentsFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Student student;

  StudentsFormProvider(this.student);

  bool isValidForm () {
    return formKey.currentState?.validate() ?? false;
  }
}