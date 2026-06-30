// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokedex_application/pokedex_screens/presentation/shared/presentation_provider.dart';
import '../../application/pokedex_provider.dart';

class PostPage extends ConsumerStatefulWidget {
  const PostPage({super.key});

  @override
  ConsumerState<PostPage> createState() => _PostPageState();
}

class _PostPageState extends ConsumerState<PostPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _hpController = TextEditingController();
  final TextEditingController _attackController = TextEditingController();
  final TextEditingController _defenseController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();

  Future<void> _handlePost() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // 1. Prepare Data
      final newPokemon = {
        'name': _nameController.text.trim(),
        'type': [_typeController.text.trim()],
        'hp': int.tryParse(_hpController.text) ?? 0,
        'image': _imageController.text.trim(),
        'abilities': ['Unknown'],
        'attack': int.tryParse(_attackController.text) ?? 0,
        'defense': int.tryParse(_defenseController.text) ?? 0,
      };
      ref.read(pageNumber.notifier).state = 0;
  
      await ref.read(pokedexNotifierProvider.notifier).postPokemon(newPokemon);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gotcha! Pokemon Added!'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Team Rocket error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Register Pokemon'),
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section (Same as your original)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 30),
              decoration: const BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: const Column(
                children: [
                  Icon(Icons.catching_pokemon, size: 80, color: Colors.white),
                  SizedBox(height: 10),
                  Text(
                    "New Entry",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: _buildInputDecoration(
                        'Pokemon Name',
                        Icons.badge,
                      ),
                      validator: (v) => v!.isEmpty ? 'What is its name?' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _typeController,
                      decoration: _buildInputDecoration(
                        'Type (e.g. Water)',
                        Icons.auto_awesome,
                      ),
                      validator: (v) => v!.isEmpty ? 'Select a type' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _imageController,
                      decoration: _buildInputDecoration(
                        'Pokemon Image (Emoji)',
                        Icons.image,
                      ),
                      validator: (v) =>
                          v!.isEmpty ? 'What emoji best describes it?' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _hpController,
                      decoration: _buildInputDecoration(
                        'Health Points (HP)',
                        Icons.favorite,
                      ),
                      keyboardType: TextInputType.number,
                      validator: (v) => (v == null || int.tryParse(v) == null)
                          ? 'Enter valid HP'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _attackController,
                      decoration: _buildInputDecoration(
                        'Attack',
                        Icons.flash_on_sharp,
                      ),
                      keyboardType: TextInputType.number,
                      validator: (v) => (v == null || int.tryParse(v) == null)
                          ? 'Enter Attack'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _defenseController,
                      decoration: _buildInputDecoration(
                        'Defense Points',
                        Icons.shield,
                      ),
                      keyboardType: TextInputType.number,
                      validator: (v) => (v == null || int.tryParse(v) == null)
                          ? 'Enter Defense'
                          : null,
                    ),
                    const SizedBox(height: 32),

                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                        ),
                        onPressed: _isLoading ? null : _handlePost,
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                'ADD TO POKEDEX',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
