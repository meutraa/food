import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';

class BackupManager {
  static const _lastBackupKey = "lastBackupDate";
  static const _selectedDirectoryKey = "selectedDirectory";

  BackupManager();

  Future<void> backupDatabaseIfNeeded() async {
    final prefs = await SharedPreferences.getInstance();
    final lastBackupString = prefs.getString(_lastBackupKey);
    final lastBackupDate = DateTime.parse(lastBackupString ?? "2000-01-01");
    final currentDate = DateTime.now();

    if (!isSameDay(currentDate, lastBackupDate)) {
      await backupDatabase(false);
      await prefs.setString(_lastBackupKey, currentDate.toIso8601String());
    }
  }

  Future<void> backupDatabase(bool manual) async {
    String? selectedDirectory;
    final prefs = await SharedPreferences.getInstance();

    if (manual) {
      selectedDirectory = await FilePicker.platform.getDirectoryPath();
      if (selectedDirectory != null) {
        await prefs.setString(_selectedDirectoryKey, selectedDirectory);
      }
    } else {
      selectedDirectory = prefs.getString(_selectedDirectoryKey);
    }

    if (selectedDirectory == null) {
      return;
    }

    final appDocDir = await getApplicationDocumentsDirectory();
    final appDocPath = appDocDir.path;

    final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
    final backupFolderPath = "$selectedDirectory/objectbox_backup_$timestamp";

    await _copyDirectory(Directory(appDocPath), Directory(backupFolderPath));
  }

  Future<void> _copyDirectory(Directory source, Directory destination) async {
    await destination.create(recursive: true);
    await for (var entity in source.list()) {
      if (entity is Directory) {
        var newDirectory = Directory(
            '${destination.absolute.path}/${entity.path.split('/').last}');
        await _copyDirectory(entity.absolute, newDirectory);
      } else if (entity is File) {
        await entity.copy('${destination.path}/${entity.path.split('/').last}');
      }
    }
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
