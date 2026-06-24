import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:innox/core/presentation/widget/custom_button.dart';
import 'package:innox/core/presentation/widget/custom_text_form_field.dart';
import '../../shared/providers.dart';


class LockScreenOverlay extends ConsumerStatefulWidget {
  const LockScreenOverlay({super.key});

  @override
  ConsumerState<LockScreenOverlay> createState() => _LockScreenOverlayState();
}

class _LockScreenOverlayState extends ConsumerState<LockScreenOverlay> {
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _errorMessage;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }
//TODO: Map the password checks to the custom function other than creating a new one for this operation
  Future<void> _onUnlock() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final username = ref.read(lockedUserLoginProvider);
      final password = _passwordController.text.trim();

      final authenticator = ref.read(authenticatorProvider);
      final result = await authenticator.login(username ?? '', password, '');

      result.fold(
        (failure) {
          setState(() {
            _errorMessage = failure.maybeMap(
              inValidCredentials: (e) => e.message ?? 'Incorrect password',
              orElse: () => 'Something went wrong. Try again.',
            );
            _isLoading = false;
          });
        },
        (_) {
          ref.read(sessionTimeoutProvider.notifier).unlock();
          _passwordController.clear();
        },
      );
    } catch (e) {
      setState(() {
        _errorMessage = 'Something went wrong. Try again.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final username = ref.watch(lockedUsernameProvider);

    return _LockScreenContent(
            username: username,
            passwordController: _passwordController,
            formKey: _formKey,
            isLoading: _isLoading,
            obscurePassword: _obscurePassword,
            errorMessage: _errorMessage,
            onUnlock: _onUnlock,
            onToggleObscure: () => setState(
              () {
                _obscurePassword = !_obscurePassword;
              },
            ),
          );
  }
}

class _LockScreenContent extends StatefulWidget {
  final String? username;
  final TextEditingController passwordController;
  final GlobalKey<FormState> formKey;
  final bool isLoading;
  final bool obscurePassword;
  final String? errorMessage;
  final VoidCallback onUnlock;
  final VoidCallback onToggleObscure;

  const _LockScreenContent({
    required this.username,
    required this.passwordController,
    required this.formKey,
    required this.isLoading,
    required this.obscurePassword,
    required this.errorMessage,
    required this.onUnlock,
    required this.onToggleObscure,
  });

  @override
  State<_LockScreenContent> createState() => _LockScreenContentState();
}

class _LockScreenContentState extends State<_LockScreenContent> {
  final FocusNode _passwordFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _passwordFocusNode.addListener(() {
      if (_passwordFocusNode.hasFocus) {
        Future.delayed(const Duration(milliseconds: 300), () {
          if (_scrollController.hasClients) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Material(
        color: Colors.black.withValues(alpha: 0.5),
        child: AnimatedPadding(
          duration: const Duration(milliseconds: 250),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom
          ),
          child: Center(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Form(
                key: widget.formKey,        // widget. prefix for all fields
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.lock_outline, size: 64, color: Colors.white),
                    const SizedBox(height: 24),
                    const Text(
                      'Session Locked',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Welcome back, ${widget.username ?? 'User'}.\nEnter your password to continue.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 14, color: Colors.white70),
                    ),
                    const SizedBox(height: 32),
                    TextFormFieldWidget(
                      focusNode: _passwordFocusNode,  // pass focus node
                      labelText: 'Password',
                      floatingLabelStyle: const TextStyle(color: Colors.white),
                      isPassword: true,
                      fillColor: Colors.white12,
                      errorText: null,
                      onChanged: (value) {
                        widget.passwordController.text = value;
                      },
                      valueSetter: (value) {
                        widget.passwordController.text = value ?? '';
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                    if (widget.errorMessage != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        widget.errorMessage!,
                        style: const TextStyle(color: Colors.redAccent, fontSize: 13),
                      ),
                    ],
                    const SizedBox(height: 24),
                    CustomButton(
                      fontSize: 16,
                      title: 'Unlock',
                      processing: widget.isLoading,
                      processingText: 'Verifying...',
                      isActive: !widget.isLoading,
                      onTap: widget.isLoading ? () {} : widget.onUnlock,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
