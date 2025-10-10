import 'package:supabase_flutter/supabase_flutter.dart';

class ApiClient {
  bool isConnected = false;

  SupabaseClient get client => Supabase.instance.client;

  Future<void> init() async {
    try {
      await Supabase.initialize(
        url: 'https://mlpuijdijkzsbfeynlkk.supabase.co',
        anonKey:
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1scHVpamRpamt6c2JmZXlubGtrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTk2MTk2MjIsImV4cCI6MjA3NTE5NTYyMn0.ai41fV66QvO8a4u4gl567yMbZXKWy2PUQ8ivR71eHhU',
      );
      isConnected = true;
    } catch (_) {
      isConnected = false;
    }
  }
}
