import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Services extends InheritedWidget {
  final AuthService authService;
  final NotesService notesService;

  Services._({
    required this.authService,
    required this.notesService,
    required Widget child,
  }) : super(child: child);

  factory Services({required Widget child}) {
    final client = SupabaseClient('https://xvjretabvavhxqyaftsr.supabase.co',
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inh2anJldGFidmF2aHhxeWFmdHNyIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NTQ1OTEzMzYsImV4cCI6MTk3MDE2NzMzNn0.3Iuz9BYCPWVDbELfJa2b_jzU9OVzW95St099K2RS_YU');
    final authService = AuthService(client.auth);
    final notesService = NotesService(client);
    return Services._(
      authService: authService,
      notesService: notesService,
      child: child,
    );
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return false;
  }

  static Services of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Services>()!;
  }
}
