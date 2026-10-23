import 'package:flutter/material.dart';

import 'activity_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (!_formKey.currentState!.validate()) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const ActivityPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Icon(Icons.directions_run, size: 80, color: Colors.green),
                const SizedBox(height: 16),
                const Text(
                  'Running Tracker',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 32),
                emailInput(_emailController),
                const SizedBox(height: 16),
                passwordInput(_passwordController),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: _login,
                  child: const Text('Iniciar sesión'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget emailInput(TextEditingController controller) {
  return TextFormField(
    controller: controller,
    keyboardType: TextInputType.emailAddress,
    decoration: const InputDecoration(
      labelText: 'Email',
      prefixIcon: Icon(Icons.email),
    ),
    validator: (value) {
      if (value == null || value.isEmpty) return 'Ingresá tu email';
      if (!value.contains('@')) return 'Email inválido';
      return null;
    },
  );
}

Widget passwordInput(TextEditingController controller) {
  return TextFormField(
    controller: controller,
    obscureText: true,
    decoration: const InputDecoration(
      labelText: 'Contraseña',
      prefixIcon: Icon(Icons.lock),
    ),
    validator: (value) {
      if (value == null || value.isEmpty) return 'Ingresá tu contraseña';
      if (value.length < 6) return 'Mínimo 6 caracteres';
      return null;
    },
  );
}
