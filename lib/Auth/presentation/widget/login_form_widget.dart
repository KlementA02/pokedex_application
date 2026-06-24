import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:innox/auth/presentation/data/strings.dart';
import 'package:innox/auth/shared/providers.dart';
import 'package:innox/core/presentation/widget/custom_button.dart';
import 'package:innox/core/presentation/widget/custom_text_form_field.dart';
import 'package:innox/core/presentation/widget/drop_down_form_widget.dart';
import 'package:innox/auth/presentation/widget/signin_button.dart';
import 'package:innox/theme/builders/theme.dart';

import '../../../core/presentation/widget/generic_snackbar.dart';
import '../../application/auth_state_notifier.dart';
import '../../application/session_timeout_notifier.dart';
import 'lock_screen_overlay.dart';

class TextFormWidget extends ConsumerStatefulWidget {
  const TextFormWidget({super.key});

  @override
  ConsumerState<TextFormWidget> createState() => _TextFormWidgetState();
}

class _TextFormWidgetState extends ConsumerState<TextFormWidget> {
  final _formKey = GlobalKey<FormState>();

  bool _hasTriedToSubmit = false;

  @override
  Widget build(BuildContext context) {
    final formState = ref.read(loginFormStateProvider.notifier);
    final loginState = ref.watch(loginFormStateProvider);
    final authState = ref.read(authStateProvider.notifier);
    final loadingStateNotifier = ref.read(loadingStateProvider.notifier);
    final loadingStateWatcher = ref.watch(loadingStateProvider);

    ref.listen<AuthState>(
      authStateProvider,
      (previous, next) {
        if (previous != next) {
          next.maybeWhen(
            authenticated: () {
              showFlash(
                context: context,
                duration: const Duration(seconds: 3),
                builder: (_, controller) {
                  return GFlashBar(
                    message: const Message(
                      title: "Login Successful",
                      content: "Welcome back!",
                    ),
                    controller: controller,
                    bgColor: Colors.green,
                  );
                },
              );
            },
            failure: (authFailure) {
              authFailure.when(
                server: (content) {
                  showFlash(
                    context: context,
                    duration: const Duration(seconds: 3),
                    builder: (_, controller) {
                      return GFlashBar(
                        message: Message(
                          title: "Server Error",
                          content: content,
                        ),
                        controller: controller,
                        bgColor: AppTheme.themeColor.error,
                      );
                    },
                  );
                },
                inValidCredentials: (msg) {
                  showFlash(
                    context: context,
                    duration: const Duration(seconds: 3),
                    builder: (_, controller) {
                      return GFlashBar(
                        message: Message(
                          title: "Invalid Credentials",
                          content: "$msg",
                        ),
                        controller: controller,
                        bgColor: AppTheme.themeColor.error,
                      );
                    },
                  );
                },
                storage: () {
                  showFlash(
                    context: context,
                    duration: const Duration(seconds: 3),
                    builder: (_, controller) {
                      return GFlashBar(
                        message: const Message(
                          title: "Storage Error",
                          content: "An unexpected error occurred.",
                        ),
                        controller: controller,
                        bgColor: AppTheme.themeColor.error,
                      );
                    },
                  );
                },
              );
            },
            orElse: () {
              // Do nothing for initial and unauthenticated states
            },
          );
        }
      },
    );

    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const SizedBox(
              height: 24,
            ),
            // Container(
            //   height: 40,
            //   alignment: Alignment.topLeft,
            //   child: const Image(
            //     image: AssetImage(logo),
            //   ),
            // ),
            // const Text(
            //   loginHeader,
            //   style: TextStyle(
            //     fontSize: 28,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
            // const Text(
            //   loginSubHeader,
            //   style: TextStyle(
            //       fontSize: 22,
            //       color: Color.fromARGB(255, 82, 152, 210),
            //       fontWeight: FontWeight.bold),
            // ),
            //const SizedBox(height: 32),
            TextFormFieldWidget(
              labelText: userName,
              errorText: _hasTriedToSubmit ? loginState.userNameError : null,
              valueSetter: (value) => formState.setUserName(value!),
              onChanged: (value) {
                formState.setUserName(value);
                if (_hasTriedToSubmit) {
                  formState
                      .validateSubmission(); // Re-validate on change if submission was attempted
                }
              },
            ),
            const SizedBox(height: 12),
            TextFormFieldWidget(
              labelText: pwd,
              isPassword: true,
              errorText: _hasTriedToSubmit ? loginState.passwordError : null,
              valueSetter: (value) => formState.setPassword(value!),
              onChanged: (value) {
                formState.setPassword(value);
                if (_hasTriedToSubmit) {
                  formState.validateSubmission();
                }
              },
            ),
            const SizedBox(height: 12),
            DropDownFormWidget(
              hintText: "Server",
              source: serverValues,
              keys: const ["value", "label"],
              paddingAll: 10,
              showRefreshButton: false,
              onChanged: (value) => formState.setServer(value!),
            ),
            const SizedBox(height: 24),
            CustomButton(
              fontSize: 20,
              isActive: !loadingStateWatcher,
              onTap: loadingStateWatcher
                  ? () {}
                  : () async {
                      setState(() {
                        _hasTriedToSubmit = true;
                      });
        
                      _formKey.currentState!.save();
        
                      final isValid = formState.validateSubmission();
                      if (!isValid) {
                        return;
                      }
        
                      loadingStateNotifier.state = true;
        
                      try {
                        await authState.login(
                            formState: ref.read(loginFormStateProvider),
                          onSuccess: () {
                              ref.read(lockedUsernameProvider.notifier).state = AuthStateNotifier.getFirstName();
                            ref.read(lockedUserLoginProvider.notifier).state =
                                AuthStateNotifier.getUserName();
                            ref.read(sessionTimeoutProvider.notifier).resetTimer();
                          },
                        );
                      } catch (e) {
                        debugPrint("Unexpected login error: $e");
                        showFlash(
                          context: context,
                          duration: const Duration(seconds: 3),
                          builder: (_, controller) {
                            return GFlashBar(
                              message: const Message(
                                title: "Unexpected Error",
                                content:
                                    "Something went wrong. Please try again.",
                              ),
                              controller: controller,
                              bgColor: AppTheme.themeColor.error,
                            );
                          },
                        );
                      } finally {
                        loadingStateNotifier.state = false;
                      }
                    },
              title: "Sign In",
              processing: loadingStateNotifier.state,
              processingText: "Wait a minute...",
            ),
          ],
        ),
      ),
    );
  }
}

final List<Map<String, dynamic>> serverValues = [
  {
    "label": "Cloud",
    "value": "cloud",
  },
  {
    "label": "Production",
    "value": "production",
  },
];
