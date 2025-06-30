import 'package:chatapplication/feat/auth/provider/auth_providers.dart';
import 'package:chatapplication/feat/auth/repository/firebase_auth_repository.dart';
import 'package:chatapplication/feat/auth/widgets/common_button_widget.dart';
import 'package:chatapplication/feat/auth/widgets/common_textfiled_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignUpScreen extends ConsumerWidget {
  SignUpScreen({super.key});

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _fromKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authLoadingButtonStateProviderValue = ref.watch(
      authLoadingButtonStateProvider,
    );
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.cyan,
        title: Text("Registration Screen"),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _fromKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 70),
                CommonTextfiledWidget(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Name Can't be empty";
                    } else {
                      return null;
                    }
                  },
                  hintText: "Enter Name",
                  controller: _nameController,
                ),
                SizedBox(height: 24),
                CommonTextfiledWidget(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Email Can't be empty";
                    } else {
                      return null;
                    }
                  },
                  hintText: "Enter Email",
                  controller: _emailController,
                ),
                SizedBox(height: 24),
                CommonTextfiledWidget(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Password Can't be empty";
                    } else if (value.length < 6) {
                      return "Password should be atLeast 6 character";
                    } else {
                      return null;
                    }
                  },
                  hintText: "Enter Password",
                  controller: _passwordController,
                ),
                SizedBox(height: 50),
                CommonButtonWidget(
                  isLoading: authLoadingButtonStateProviderValue,
                  onTab: () async {
                    if (_fromKey.currentState!.validate()) {
                      ref
                          .read(authLoadingButtonStateProvider.notifier)
                          .update((state) => true);
                      final value = await ref
                          .read(firebaseAuthRepositoryProvider)
                          .signUpWithEmailAndPassword(
                            email: _emailController.text,
                            password: _passwordController.text,
                            name: _nameController.text,
                          );
                      ref
                          .read(authLoadingButtonStateProvider.notifier)
                          .update((state) => false);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(value),
                          backgroundColor: Colors.cyan,
                        ),
                      );
                    }
                  },
                  title: "Sign up",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
