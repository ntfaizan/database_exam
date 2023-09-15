import 'package:database_exam/database.dart';
import 'package:database_exam/models/student.dart';

void main() async {
  final studentDatabase = StudentDatabase();

  final studentsToAdd = [
    Student(
      firstName: 'John',
      lastName: 'Smith',
      age: 20,
      gpa: 3.5,
    ),
    Student(
      firstName: 'mary',
      lastName: 'Johnson',
      age: 22,
      gpa: 3.8,
    ),
    Student(
      firstName: 'robert',
      lastName: 'davis',
      age: 21,
      gpa: 3.2,
    ),
    Student(
      firstName: 'sarah',
      lastName: 'Brown',
      age: 21,
      gpa: 3.9,
    ),
    // Add more students as needed
  ];
  final courses = [
    Course(courses: "mathmatics", id: 1),
    Course(courses: "science", id: 2),
    Course(courses: "litrature", id: 3),
    Course(courses: "history", id: 4),
  ];
  await studentDatabase.insertStudents(studentsToAdd);

  final highGpaStudents = await studentDatabase.getStudentsWithHighGpa();
  for (final student in highGpaStudents) {
    final firstName = student['first_name'];
    final lastName = student['last_name'];
    print('High GPA Student: $firstName $lastName');
  }

  final studentCount = await studentDatabase.countStudents();
  print('Total Number of Students: $studentCount');

  final averageGpa = await studentDatabase.calculateAverageGpa();
  print('Average GPA of All Students: $averageGpa');

  final maxGpa = await studentDatabase.findMaxGpa();
  print('Maximum GPA: $maxGpa');

  final totalGpa = await studentDatabase.calculateTotalGpa();
  print('Total GPA: $totalGpa');

  final averageGpaByAge = await studentDatabase.calculateAverageGpaByAge();
  print('Average GPA by Age:');
  averageGpaByAge.forEach((age, avgGpa) {
    print('Age $age: $avgGpa');
  });

  if (averageGpaByAge.isNotEmpty) {
    int highestAge = 0;
    double highestAvgGpa = 0.0;

    averageGpaByAge.forEach((age, avgGpa) {
      if (avgGpa > highestAvgGpa) {
        highestAge = age;
        highestAvgGpa = avgGpa;
      }
    });

    print('Age group with the highest average GPA:');
    print('Age: $highestAge, Average GPA: $highestAvgGpa');
  } else {
    print('No data available.');
  }
  final studentsWithGpaAboveAverage =
      await studentDatabase.getStudentsWithGpaAboveAverage();

  if (studentsWithGpaAboveAverage.isNotEmpty) {
    print('Students with GPA above the average:');
    for (final student in studentsWithGpaAboveAverage) {
      final firstName = student['first_name'];
      final lastName = student['last_name'];
      final gpa = student['gpa'];
      print('First Name: $firstName, Last Name: $lastName, GPA: $gpa');
    }
  } else {
    print('No students found with GPA above the average.');
  }
  final studentWithHighestGpa =
      await studentDatabase.findStudentWithHighestGpa();

  if (studentWithHighestGpa != null) {
    final firstName = studentWithHighestGpa['first_name'];
    final lastName = studentWithHighestGpa['last_name'];
    final gpa = studentWithHighestGpa['gpa'];
    print('Student with the highest GPA:');
    print('First Name: $firstName, Last Name: $lastName, GPA: $gpa');
  } else {
    print('No students found.');
  }
}
