import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_chat_app/services/auth/auth_service.dart';
import 'package:provider_chat_app/widgets/my_text_field.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();

  void signIn() async {
    final AuthService authService =
        Provider.of<AuthService>(context, listen: false);

    try {
      await authService.signInWithEmailAndPassword(
          email: emailCtrl.text, password: passwordCtrl.text);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 2),
          content: Text(e.toString()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            physics: const BouncingScrollPhysics(),
            children: [
              const SizedBox(height: 72.0),
              Icon(
                Icons.message_rounded,
                color: colorScheme.primary,
                size: 62.0,
              ),
              const SizedBox(height: 22.0),
              Text(
                'Hello, welcome back to our account',
                style: textTheme.displaySmall,
              ),
              const SizedBox(height: 12.0),
              MyTextField(
                controller: emailCtrl,
                hintText: 'Your email address',
              ),
              MyTextField(
                controller: passwordCtrl,
                hintText: 'Your password',
                obscureText: true,
              ),
              const SizedBox(height: 8.0),
              FilledButton.tonal(
                onPressed: signIn,
                style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.background,
                    minimumSize: const Size.fromHeight(42.0)),
                child: const Text('Sign In'),
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Not a member?'),
                  const SizedBox(width: 4.0),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: const Text(
                      'Register now',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
