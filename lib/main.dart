import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app/shared/app_widget.dart';
import 'app/core/services/database_helper.dart';
import 'app/core/workers/agendador_worker.dart';
import 'package:flutter/foundation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://satolreskncjkdomaoix.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNhdG9scmVza25jamtkb21hb2l4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzc3MzQ0NTAsImV4cCI6MjA5MzMxMDQ1MH0.eY6CPQAeRTuGCtOl6c2_Zd_iCJ4q9wbr0doGbb6aro8',
  );

  if (!kIsWeb) {
    await DatabaseHelper().database;
  }

  AgendadorWorker().iniciar();

  runApp(const AppWidget());
}
