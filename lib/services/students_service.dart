import 'dart:convert';

import 'package:crud_firebase/models/student_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class StudentsService extends ChangeNotifier {

  //Asignamos la url base a un atributo para accceder a él facilmente.
  final String _baseUrl = 'studentapi-yz-default-rtdb.firebaseio.com';

  late Student selectedStudent;

  List<Student> students = [];

  bool isLoading = false;
  bool isSaving = false;

  StudentsService () {
    loadStudents();
  }

  Future<List<Student>> loadStudents () async {
    isLoading = true;
    notifyListeners();

    //Creamos la url a donde vamos a generar la solicitud
    final url = Uri.https(_baseUrl, 'students.json');
    final resp = await http.get(url);

    final Map<String, dynamic>? studentsMap = json.decode(resp.body);
    print(studentsMap);

    // studentsMap?.values.forEach((value)
    // studentsMap?.forEach((key, value)
    studentsMap?.forEach((key, value) {
      /*
        * Lo que devuelve body es:
        HiHitler: {
          f: Fuher
          r: Tercer Reich
        }
      */
      Student tempStudent = Student.fromJson(value);
      tempStudent.id = key;
      students.add(tempStudent);
    });

    isLoading = false;
    notifyListeners();
    //print('Hola $students');
    return students;
  }

  Future createOrUpdate (Student student) async {
    isSaving = true;

    if (student.id == null) {
      await createStudent(student);
    } else {
      await updateStudent(student);
    }
  }

  Future <String> createStudent (Student student) async {
    isSaving = true;
    final url = Uri.https(_baseUrl, 'students.json');
    final resp = await http.post(url, body: student.toJson());

    final decodedData = json.decode(resp.body);

    student.id = decodedData['name'];

    students.add(student);

    return student.id!;
  }

  Future<String> updateStudent (Student student) async { 

    isSaving = true;

    // Se especifica el estudiante que se actualizá
    final url = Uri.https(_baseUrl, 'students/${student.id}.json');

    // Utiliza http.patch para realizar una actualización parcial del recurso
    final resp = await http.patch(url, body: student.toJson());

    //final resp = await http.put(url, body: student.toJson());

    // final decodedData = json.decode(resp.body); // Esto qué hace?

    final index = students.indexWhere((element) => element.id == student.id);

    students[index] = student;

    return student.id!;
  }

  Future<String> deleteStudentById (String id) async {
    isLoading = true;
    // Se especifica el estudiante a eliminar
    final url = Uri.https(_baseUrl, 'students/$id.json');
    final resp = await http.delete(url, body: {"name": id});

    //final decodedData = json.decode(resp.body); // Esto qué hace?

    //loadStudents();

    return id;
  }

}