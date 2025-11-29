import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app/app.dart';
import 'app/di/injection_container.dart';
import 'core/config/env.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Validar que la Supabase Anon Key esté configurada
  if (Env.supabaseAnonKey.isEmpty) {
    throw Exception(
      '❌ ERROR: Supabase Anon Key no configurada.\n'
      'Por favor, agrega tu Supabase Anon Key en lib/core/config/env.dart\n'
      'Obtén la key desde: Supabase Dashboard > Settings > API',
    );
  }

  // Inicializar Supabase
  await Supabase.initialize(url: Env.supabaseUrl, anonKey: Env.supabaseAnonKey);

  await InjectionContainer.init();

  runApp(const App());
}
