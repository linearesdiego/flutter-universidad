import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../theme/app_theme.dart';
import '../widgets/ui.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    try {
      final response = await Supabase.instance.client.auth.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        data: {'name': _nameController.text.trim()},
      );
      if (!mounted) return;

      // Si Supabase pide confirmar el email, no devuelve sesión
      final message = response.session == null
          ? '¡Cuenta creada! Revisá tu email para confirmarla'
          : '¡Cuenta creada! Ya podés iniciar sesión';
      showToast(context, message);
      Navigator.pop(context);
      return;
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
      appBar: AppBar(title: const Text('Crear cuenta')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: appearAnimation(Column(
              children: [
                const Text(
                  'Sumate y empezá a registrar tus actividades',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppTheme.textSecondary, fontSize: 16),
                ),
                const SizedBox(height: 32),
                nameInput(_nameController),
                const SizedBox(height: 16),
                emailInput(_emailController),
                const SizedBox(height: 16),
                passwordInput(_passwordController),
                const SizedBox(height: 16),
                confirmPasswordInput(_confirmController, _passwordController),
                const SizedBox(height: 24),
                loadingButton(
                  text: 'Registrarme',
                  loading: _loading,
                  onPressed: _register,
                ),
              ],
            )),
          ),
        ),
      ),
    );
  }
}

Widget nameInput(TextEditingController controller) {
  return TextFormField(
    controller: controller,
    decoration: const InputDecoration(
      labelText: 'Nombre',
      prefixIcon: Icon(Icons.person),
    ),
    validator: (value) {
      if (value == null || value.isEmpty) return 'Ingresá tu nombre';
      return null;
    },
  );
}

Widget confirmPasswordInput(
  TextEditingController controller,
  TextEditingController passwordController,
) {
  return TextFormField(
    controller: controller,
    obscureText: true,
    decoration: const InputDecoration(
      labelText: 'Repetir contraseña',
      prefixIcon: Icon(Icons.lock),
    ),
    validator: (value) {
      if (value != passwordController.text) return 'Las contraseñas no coinciden';
      return null;
    },
  );
}
