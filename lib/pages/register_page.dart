import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_chat_app/services/auth/auth_service.dart';
import 'package:provider_chat_app/widgets/my_text_field.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;
  const RegisterPage({super.key, this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();
  final TextEditingController confirmPasswordCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;

    void signUp() async {
      if (passwordCtrl.text != confirmPasswordCtrl.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password do not match!')),
        );
        return;
      }

      final AuthService authService =
          Provider.of<AuthService>(context, listen: false);

      try {
        await authService.signUpWithEmailAndPassword(
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
                'Let\'s create an account for you!',
                style: textTheme.displaySmall,
              ),
              const SizedBox(height: 12.0),
              MyTextField(
                controller: emailCtrl,
                hintText: 'Enter your email address',
              ),
              MyTextField(
                controller: passwordCtrl,
                hintText: 'Enter your password',
                obscureText: true,
              ),
              MyTextField(
                controller: confirmPasswordCtrl,
                hintText: 'Enter confirm your password',
                obscureText: true,
              ),
              const SizedBox(height: 8.0),
              FilledButton.tonal(
                onPressed: signUp,
                style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.background,
                    minimumSize: const Size.fromHeight(42.0)),
                child: const Text('Sign Up'),
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already a member?'),
                  const SizedBox(width: 4.0),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: const Text(
                      'Login now',
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
