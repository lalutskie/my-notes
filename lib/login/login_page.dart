import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_firebase/components/custom_loading.dart';
import 'package:hive_firebase/components/custom_snackbar_service.dart';
import 'package:hive_firebase/components/custom_textfield.dart';
import 'package:hive_firebase/features/authentication/presentations/cubits/auth_state.dart';
import 'package:hive_firebase/utils/custom_theme.dart';

import '../components/custom_button.dart';
import '../features/authentication/presentations/cubits/auth_cubit.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isLoading = false;

  void login() async {
    final String email = _emailController.text;
    final String password = _passwordController.text;

    final authCubit = context.read<AuthCubit>();

    if (email.isNotEmpty && password.isNotEmpty) {
      await authCubit.loginUser(email, password);
    } else {
      CustomSnackbarService.showError(
        context,
        'Please enter your email and password',
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'My notes',
                      style: CustomTheme.typography(context).displaySmall
                          .copyWith(
                            color: CustomTheme.colors(context).primaryText,
                            fontWeight: FontWeight.bold,
                          ),
                    ),

                    // Icon(Icons.note_sharp),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 24, 0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Login',
                        style: CustomTheme.typography(context).headlineLarge,
                      ),

                      Text(
                        'Welcome back! Just login your credentials to continue',
                        style: CustomTheme.typography(context).bodySmall
                            .copyWith(
                              color: CustomTheme.colors(context).tertiaryText,
                            ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 32, 0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextfield(
                        controller: _emailController,
                        obSecureText: false,
                        labelText: 'Email',
                        hintText: 'Enter email address',
                        textInputType: TextInputType.emailAddress,
                      ),

                      SizedBox(height: 8),

                      CustomTextfield(
                        controller: _passwordController,
                        obSecureText: true,
                        labelText: 'Password',
                        hintText: 'Enter password',
                        maxLines: 1,
                      ),

                      SizedBox(height: 8),

                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Forgot password?',
                          style: CustomTheme.typography(context).bodySmall
                              .copyWith(
                                color: CustomTheme.colors(context).tertiaryText,
                              ),
                        ),
                      ),

                      SizedBox(height: 32),

                      BlocConsumer<AuthCubit, AuthState>(
                        builder: (context, state) {
                          if (state is AuthLoading) {
                            return CustomLoading();
                          }
                          return CustomButton(
                            text: 'Login',
                            function: login,
                            width: double.infinity,
                          );
                        },
                        listener: (context, state) {
                          if (state is AuthError) {
                            CustomSnackbarService.showError(
                              context,
                              state.errorMessage,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),

                Spacer(flex: 1),

                Align(
                  alignment: Alignment.center,
                  child: Text.rich(
                    TextSpan(
                      text: "Don't have an account? ",
                      style: CustomTheme.typography(context).bodySmall.copyWith(
                        color: CustomTheme.colors(context).tertiaryText,
                      ),
                      children: [
                        TextSpan(
                          text: "Register here!",
                          style: CustomTheme.typography(context).bodySmall
                              .copyWith(
                                color: CustomTheme.colors(
                                  context,
                                ).primary, // highlight color
                                fontWeight: FontWeight.bold,
                              ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              context.push('/register');
                            },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
