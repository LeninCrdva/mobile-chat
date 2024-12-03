import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_chat/main.dart';
import 'package:simple_chat/src/model/auth_request.dart';
import 'package:simple_chat/src/service/auth_service.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  late bool _isObscure = true;

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double deviceHeight = MediaQuery.of(context).size.height;
    final double deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          vertical: deviceHeight * 0.13,
          horizontal: deviceWidth * 0.1,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(
                'Sign In',
                style: TextStyle(
                  fontSize: deviceWidth * 0.06,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: deviceHeight * 0.05,
              ),
              TextFormField(
                controller: usernameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please, enter your username';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  hintText: 'Email',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(),
                    borderRadius: BorderRadius.all(
                      Radius.circular(30),
                    ),
                  ),
                  prefixIcon: Icon(Icons.account_box_outlined),
                  hintStyle: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(
                height: deviceHeight * 0.05,
              ),
              TextFormField(
                controller: passwordController,
                obscureText: _isObscure,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(),
                    borderRadius: BorderRadius.all(
                      Radius.circular(30),
                    ),
                  ),
                  hintText: 'Password',
                  hintStyle: const TextStyle(
                    fontSize: 16,
                  ),
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: togglePassword(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please, enter your password';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: deviceHeight * 0.09,
              ),
              ElevatedButton(
                onPressed: () async {
                  await login();
                },
                child: const Text('Sign In'),
              ),
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Move to another page'),
                    ),
                  );
                },
                child: const Text.rich(
                  TextSpan(
                    text: 'Don\'t have an account? ',
                    children: [
                      TextSpan(
                        text: 'Sign Up',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget togglePassword() {
    return IconButton(
        onPressed: () {
          setState(() {
            _isObscure = !_isObscure;
          });
        },
        icon: _isObscure
            ? const Icon(Icons.visibility)
            : const Icon(Icons.visibility_off));
  }

  login() async {
    if (!mounted) return;

    final username = usernameController.text;
    final password = passwordController.text;
    final provider = Provider.of<AuthServiceProvider>(context, listen: false);

    try {
      if (_formKey.currentState!.validate()) {
        final request = AuthRequest(username: username, password: password);

        await provider.login(request);

        if (!mounted) return;

        if (provider.isLoggedIn) {
          navigatorKey.currentState!.pushNamedAndRemoveUntil('/home', (route) => false);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please, enter your credentials'),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Your credentials are incorrect, try again'),
        ),
      );
    }
  }
}
