import 'package:flutter/material.dart';
import 'package:sistema_equipamento/Home/home.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final String mockUsername = "admin";
  final String mockPassword = "123";

  void _login() {
    if (_usernameController.text == mockUsername &&
        _passwordController.text == mockPassword) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => EquipmentScreen(),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Login falhou'),
          content: const Text('Usuário ou senha inválidos.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const blueColor = Color(0xFF003DA5); // PMS 286 C
    const greenColor = Color(0xFFA8C539); // PMS 2285 C

    return Scaffold(
      backgroundColor: Colors.white, // Alterado para fundo branco
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            // Logo
            Image.asset(
              'assets/jagua_logo.png', // Certifique-se de salvar o logo em assets/jagua_logo.png
              height: 100,
            ),
            const SizedBox(height: 16),
            // Título
            const Text(
              'Bem-vindo',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: blueColor,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Faça login para continuar',
              style: TextStyle(
                fontSize: 16,
                color: greenColor,
              ),
            ),
            const SizedBox(height: 40),
            // Formulário de Login
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'Usuário',
                      prefixIcon: const Icon(Icons.person, color: blueColor),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Senha',
                      prefixIcon: const Icon(Icons.lock, color: blueColor),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: blueColor, // Botão azul
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Entrar',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Texto adicional
            const Text(
              'Esqueceu sua senha?',
              style: TextStyle(
                color: blueColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}