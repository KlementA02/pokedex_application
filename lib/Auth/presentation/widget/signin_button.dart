import 'package:flutter/material.dart';
import 'package:innox/auth/presentation/data/strings.dart';

class SignInButton extends StatelessWidget {
  final void Function()? onPressed;
  final bool? isLoading;
  const SignInButton({super.key, this.onPressed, this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: isLoading ?? false
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              )
            : const Icon(Icons.arrow_back_rounded),
        label: const Text(
          signInLabel,
          style: TextStyle(fontSize: 16),
        ),
        style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
            backgroundColor: isLoading ?? false
                ? Colors.grey.shade500
                : const Color.fromARGB(255, 18, 18, 18),
            foregroundColor: Colors.white),
      ),
    );
  }
}
