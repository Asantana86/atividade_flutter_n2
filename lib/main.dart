import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app/core/helpers/app.config.dart';
import 'app/core/helpers/database_helper.dart';
import 'app/core/helpers/sync_system_initializer.dart';
import 'app/core/logging/log_service.dart';
import 'app/shared/app_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: AppConfig.supabaseUrl,
    anonKey: AppConfig.supabaseKey,
  );

  if (!kIsWeb) {
    await DatabaseHelper.instance.database;
    
    await LogService().initialize();

    await SyncSystemInitializer.initialize();
  }

  runApp(const AppWidget());
}