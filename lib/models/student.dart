class Student {
  int? id;
  String firstName;
  String lastName;
  int age;
  double gpa;

  Student(
      {this.id,
      required this.firstName,
      required this.lastName,
      required this.age,
      required this.gpa,
    });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'age': age,
      'gpa': gpa,
      
    };
  }
}

class Course {
  String courses;
  int id;
  Course({required this.courses,required this.id});
  Map<String, dynamic> toMap() {
    return {'courses': courses,
    'id':id,
    };
  }
}
