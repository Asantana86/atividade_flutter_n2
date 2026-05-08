import 'package:flutter/material.dart';
import '../../../core/services/auth_service.dart'; // Nosso novo serviço

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final AuthService _authService = AuthService();
  
  String userName = 'Carregando...';
  String userEmail = 'Carregando...';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {

    final user = _authService.usuarioSupabase;
    
    if (user != null) {
      setState(() {
        userEmail = user.email ?? 'tecnico@serviceflow.com';
        userName = user.userMetadata?['nome_completo'] ?? 'Técnico';
      });
    }
  }

  Future<void> _handleLogout() async {
    await _authService.logout();
    
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Dashboard",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: colorScheme.primary),
              accountName: Text(
                userName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              accountEmail: Text(userEmail),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 40, color: Colors.grey),
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Sair', style: TextStyle(color: Colors.red)),
              onTap: _handleLogout,
            ),
          ],
        ),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle_outline, size: 80, color: colorScheme.primary),
            const SizedBox(height: 16),
            Text(
              "Conectado com Sucesso!",
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Bem-vindo(a), $userName.",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "Os cards de OS serão plugados aqui em breve.",
              style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
            )
          ],
        ),
      ),
    );
  }
}