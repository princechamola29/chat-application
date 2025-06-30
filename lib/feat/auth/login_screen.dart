import 'package:chatapplication/feat/auth/provider/auth_providers.dart';
import 'package:chatapplication/feat/auth/repository/firebase_auth_repository.dart';
import 'package:chatapplication/feat/auth/sign_up_screen.dart';
import 'package:chatapplication/feat/auth/widgets/common_button_widget.dart';
import 'package:chatapplication/feat/auth/widgets/common_textfiled_widget.dart';
import 'package:chatapplication/feat/chat/home_chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerWidget {
  LoginScreen({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authLoadingButtonStateProviderValue = ref.watch(
      authLoadingButtonStateProvider,
    );
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.cyan,
        title: Text("LOGIN SCREEN"),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 70),
              CommonTextfiledWidget(
                keyboardType: TextInputType.emailAddress,
                hintText: "Enter email",
                controller: _emailController,
              ),
              SizedBox(height: 24),
              CommonTextfiledWidget(
                hintText: "Enter Password",
                controller: _passwordController,
              ),
              SizedBox(height: 50),
              CommonButtonWidget(
                isLoading: authLoadingButtonStateProviderValue,
                onTab: () async {
                  if (_formKey.currentState!.validate()) {
                    ref
                        .read(authLoadingButtonStateProvider.notifier)
                        .update((state) => true);
                    final value = await ref
                        .read(firebaseAuthRepositoryProvider)
                        .signInWithEmailAndPassword(
                          email: _emailController.text,
                          password: _passwordController.text,
                        );
                    ref
                        .read(authLoadingButtonStateProvider.notifier)
                        .update((state) => false);
                    if (value == "Successfully Login") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeChatScreen(),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(value),
                          backgroundColor: Colors.cyan,
                        ),
                      );
                    }
                  }
                },
                title: "LOGIN",
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("If you don't have an account?"),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpScreen()),
                      );
                    },
                    child: Text(
                      "Sign UP",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
