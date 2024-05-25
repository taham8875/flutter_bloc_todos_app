import 'package:flutter/widgets.dart';
import 'package:flutter_bloc_todos_app/bootstrap.dart';
import 'package:local_storage_todos_api/local_storage_todos_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final todosApi = LocalStorageTodosApi(
    prefs: await SharedPreferences.getInstance(),
  );

  bootstrap(todosApi: todosApi);
}