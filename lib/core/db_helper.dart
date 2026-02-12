import 'package:flutter/foundation.dart' hide Category;
import 'package:sqflite/sqflite.dart';
import 'package:to_do_app/model/category_model.dart';
import 'package:path/path.dart';
import 'package:to_do_app/model/task_model.dart';
import 'package:to_do_app/model/user_model.dart';

class DBHelper {
  static Database? _db;

  static Future<Database> getDb() async {
    if (_db != null) return _db!;
    _db = await initDb();
    return _db!;
  }

  static Future<Database> initDb() async {
    String path = join(await getDatabasesPath(), 'to_do_app.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE categories(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            isSelected INTEGER
          )
        ''');
        await db.execute('''
          CREATE TABLE tasks(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            description TEXT,
            dueDate TEXT,
            isCompleted INTEGER,
            isFavorite INTEGER,
            categoryId INTEGER,
            isSynced INTEGER DEFAULT 0
          )
        ''');
        await db.execute('''
          CREATE TABLE users(
            id TEXT PRIMARY KEY,
            name TEXT,
            email TEXT,
            imagePath TEXT
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          try {
            await db.execute(
              'ALTER TABLE tasks ADD COLUMN isSynced INTEGER DEFAULT 0',
            );
          } catch (e) {
            debugPrint("Error adding isSynced column: $e");
          }
          await db.execute('''
            CREATE TABLE IF NOT EXISTS users(
              id TEXT PRIMARY KEY,
              name TEXT,
              email TEXT,
              imagePath TEXT
            )
          ''');
        }
      },
    );
  }

  // ----------------- User -----------------
  static Future<void> saveUser(UserModel user) async {
    final db = await getDb();
    await db.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<UserModel?> getUser(String id) async {
    final db = await getDb();
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return UserModel.fromMap(maps.first);
  }

  // ----------------- Tasks -----------------
  static Future<int> insertTask(Task task) async {
    final db = await getDb();
    return await db.insert('tasks', task.toMap());
  }

  static Future<int> updateTask(Task task) async {
    final db = await getDb();
    return await db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  static Future<int> deleteTask(int id) async {
    final db = await getDb();
    return await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }

  static Future<List<Task>> getTasks() async {
    final db = await getDb();
    final List<Map<String, dynamic>> maps = await db.query('tasks');
    return maps.map((map) => Task.fromMap(map)).toList();
  }

  static Future<List<Task>> getUnsyncedTasks() async {
    final db = await getDb();
    final List<Map<String, dynamic>> maps = await db.query(
      'tasks',
      where: 'isSynced = ?',
      whereArgs: [0],
    );
    return maps.map((map) => Task.fromMap(map)).toList();
  }

  // ----------------- Categories -----------------
  static Future<int> insertCategory(Category category) async {
    final db = await getDb();
    return await db.insert('categories', category.toMap());
  }

  static Future<List<Category>> getCategories() async {
    final db = await getDb();
    final List<Map<String, dynamic>> maps = await db.query('categories');
    return maps.map((map) => Category.fromMap(map)).toList();
  }
}
