import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:to_do_app/core/db_helper.dart';
import 'package:flutter/foundation.dart';

class SyncService {
  static final SyncService _instance = SyncService._internal();
  factory SyncService() => _instance;
  SyncService._internal();

  void init() {
    Connectivity().onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) {
      if (results.isNotEmpty && results.first != ConnectivityResult.none) {
        syncTasks();
      }
    });
  }

  Future<void> syncTasks() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final unsyncedTasks = await DBHelper.getUnsyncedTasks();
      if (unsyncedTasks.isEmpty) return;

      debugPrint("Syncing ${unsyncedTasks.length} tasks...");

      for (var task in unsyncedTasks) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('tasks')
            .add({
              'title': task.title,
              'description': task.description,
              'dueDate': task.dueDate.toIso8601String(),
              'isCompleted': task.isCompleted ? 1 : 0,
              'isFavorite': task.isFavorite ? 1 : 0,
              'categoryId': task.categoryId,
            });

        // Mark as synced locally
        task.isSynced = true;
        await DBHelper.updateTask(task);
      }
      debugPrint("Sync complete");
    } catch (e) {
      debugPrint("Sync failed: $e");
    }
  }
}
