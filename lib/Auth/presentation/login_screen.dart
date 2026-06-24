import 'dart:ui';
import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:innox/auth/presentation/data/strings.dart';
import 'package:innox/auth/presentation/widget/login_form_widget.dart';
import 'package:innox/core/presentation/widget/innox_title.dart';
import 'package:innox/theme/builders/theme.dart';

@RoutePage()
class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Stack(
          children: [
            Container(
              height: size.height,
              width: size.width,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(loginBg),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Blur Overlay
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
              child: Container(
                color: Colors.black.withValues(alpha: 0.25),
              ),
            ),
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Added a subtle branding area
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            color:
                                AppTheme.themeColor.card.withValues(alpha: 0.9),
                            shape: BoxShape.circle),
                        child: const Image(
                          height: 64,
                          width: 64,
                          image: AssetImage(logo),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Welcome to ",
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall
                                ?.copyWith(
                                    fontSize: 27.5,
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.themeColor.background),
                          ),
                          InnoX(
                            textColor: AppTheme.themeColor.background,
                          )
                        ],
                      ),
                      const SizedBox(height: 40),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 450),
                        child: Container(
                          decoration: BoxDecoration(
                            color:
                                AppTheme.themeColor.card.withValues(alpha: 0.9),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.2),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.3),
                                blurRadius: 30,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: const Padding(
                            // Adjusted padding for a more spacious feel
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 32),
                            child: TextFormWidget(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
