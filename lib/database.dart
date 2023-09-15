import 'package:sqflite/sqflite.dart';

import 'models/student.dart';
import 'package:path/path.dart';

class StudentDatabase {
  late final Database _database;

  StudentDatabase() {
    _initDatabase().then((db) {
      _database = db;
    });
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'studentdb.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE students(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            first_name TEXT,
            last_name TEXT,
            age INTEGER,
            gpa REAL
            COURSES TEXT
          )
              CREATE TABLE courses(
            course_id INTEGER PRIMARY KEY,
        course name
            COURSES TEXT
          )
        ''');
      },
    );
  }

  Future<void> insertStudents(List<Student> students) async {
    final batch = _database.batch();
    for (final student in students) {
      batch.insert('students', student.toMap());
    }
    await batch.commit(noResult: true);
  }

  Future<int> countStudents() async {
    final count = Sqflite.firstIntValue(
      await _database.rawQuery('SELECT COUNT(*) FROM students'),
    );
    return count ?? 0;
  }

// avrg
  Future<double> calculateAverageGpa() async {
    final result =
        await _database.rawQuery('SELECT AVG(gpa) AS avg_gpa FROM students');
    final averageGpa = result.first['avg_gpa'] as double;
    return averageGpa;
  }

// 1
  Future<double> findMaxGpa() async {
    final result =
        await _database.rawQuery('SELECT MAX(gpa) AS max_gpa FROM students');
    final maxGpa = result.first['max_gpa'] as double;
    return maxGpa;
  }

// 2
  Future<double> calculateTotalGpa() async {
    final result =
        await _database.rawQuery('SELECT SUM(gpa) AS total_gpa FROM students');
    final totalGpa = result.first['total_gpa'] as double;
    return totalGpa;
  }

// 3
  Future<Map<int, double>> calculateAverageGpaByAge() async {
    final result = await _database.rawQuery('''
      SELECT age, AVG(gpa) AS avg_gpa
      FROM students
      GROUP BY age
    ''');
// 4
    final Map<int, double> averageGpaByAge = {};
    for (final row in result) {
      final age = row['age'] as int;
      final avgGpa = row['avg_gpa'] as double;
      averageGpaByAge[age] = avgGpa;
    }

    return averageGpaByAge;
  }

  Future<List<Map<String, dynamic>>> getStudentsWithHighGpa() async {
    return await _database.query(
      'students',
      columns: ['first_name', 'last_name'],
      where: 'gpa > ?',
      whereArgs: [3.5],
    );
  }

  Future<Map<int, double>> calculateAverageGpaByAgeGroup() async {
    final result = await _database.rawQuery('''
    SELECT age, AVG(gpa) as avg_gpa
    FROM students
    GROUP BY age
  ''');

    final Map<int, double> averageGpaByAge = {};
    for (final row in result) {
      final age = row['age'] as int;
      final avgGpa = row['avg_gpa'] as double;
      averageGpaByAge[age] = avgGpa;
    }

    return averageGpaByAge;
  }

// 1
  Future<List<Map<String, dynamic>>> getStudentsWithGpaAboveAverage() async {
    final averageGpa = await calculateAverageGpa();
    return await _database.query(
      'students',
      where: 'gpa > ?',
      whereArgs: [averageGpa],
    );
  }

// 2
  Future<Map<String, dynamic>?> findStudentWithHighestGpa() async {
    final result = await _database.query(
      'students',
      orderBy: 'gpa DESC',
      limit: 1,
    );

    return result.isNotEmpty ? result.first : null;
  }
}
