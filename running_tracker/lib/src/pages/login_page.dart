import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../theme/app_theme.dart';
import '../widgets/ui.dart';
import 'activity_page.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    try {
      await Supabase.instance.client.auth.signInWithPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      if (!mounted) return;
      showToast(context, '¡Bienvenido! Sesión iniciada');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ActivityPage()),
      );
    } on AuthException catch (e) {
      if (mounted) showToast(context, e.message, error: true);
    } catch (e) {
      if (mounted) showToast(context, 'No se pudo conectar', error: true);
    }
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: appearAnimation(Column(
              children: [
                const Icon(
                  Icons.directions_run,
                  size: 80,
                  color: AppTheme.primaryColor,
                ),
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
                loadingButton(
                  text: 'Iniciar sesión',
                  loading: _loading,
                  onPressed: _login,
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RegisterPage()),
                  ),
                  child: const Text('¿No tenés cuenta? Registrate'),
                ),
              ],
            )),
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
