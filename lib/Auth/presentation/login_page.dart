import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Login Page'),
        foregroundColor: Colors.white,
        backgroundColor: Colors.redAccent,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.catching_pokemon, size: 100, color: Colors.black),
          SizedBox(height: 10),
          Text(
            "Catch the Pokemon",
            style: TextStyle(
              color: Colors.black,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: usernameController,
              decoration: _buildInputDecoration(
                'Enter your username',
                Icons.badge,
              ),
              validator: (v) => v!.isEmpty ? 'Please enter your name?' : null,
            ),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: passwordController,
              decoration: _buildInputDecoration(
                'Enter your password',
                Icons.auto_awesome,
              ),
              validator: (v) =>
                  v!.isEmpty ? 'Please enter your password' : null,
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {},
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                if (states.contains(WidgetState.hovered) &&
                    states.contains(WidgetState.focused)) {
                  return Colors.blueAccent;
                }

                if (states.contains(WidgetState.error)) {
                  return Colors.red;
                }
                if (states.contains(WidgetState.focused)) {
                  return Colors.blue;
                }
                if (states.contains(WidgetState.disabled)) {
                  return Colors.black;
                }

                return Colors.grey[900]!;
              }),
              foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                if (states.contains(WidgetState.disabled)) return Colors.grey;
                return Colors.white;
              }),
            ),
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }
}

InputDecoration _buildInputDecoration(String label, IconData icon) {
  return InputDecoration(
    labelText: label,
    prefixIcon: Icon(icon, color: Colors.redAccent),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.redAccent, width: 2),
    ),
    filled: true,
    fillColor: Colors.white,
  );
}
