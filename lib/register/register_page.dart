import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../components/custom_back_button.dart';
import '../components/custom_button.dart';
import '../components/custom_snackbar_service.dart';
import '../components/custom_textfield.dart';
import '../features/authentication/presentations/cubits/auth_cubit.dart';
import '../features/authentication/presentations/cubits/auth_state.dart';
import '../utils/custom_theme.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  void registerUser() async {

    final String fullName = _fullnameController.text.trim();
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();
    final String confirmPass = _confirmPasswordController.text.trim();

    if(fullName.isEmpty || email.isEmpty || password.isEmpty || confirmPass.isEmpty) {
      return CustomSnackbarService.showError(context, 'Please ensure the fields are not empty');
    }

    if(password != confirmPass) {
      return CustomSnackbarService.showError(context, "Password doesn't match");
    }

    final authCubit = context.read<AuthCubit>();

    await authCubit.registeruser(email, password, fullName);

   
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
                    CustomBackButton(function: () => context.pop()),

                    Icon(Icons.diversity_3_rounded),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 24, 0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Register',
                        style: CustomTheme.typography(context).headlineLarge,
                      ),

                      Text(
                        'Create your account to continue in our app',
                        style: CustomTheme.typography(context).bodySmall.copyWith(
                          color: CustomTheme.colors(context).tertiaryText
                        ),
                      ),
                    ],
                  ),
                ),

                // Input textfields
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 32, 0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextfield(
                        controller: _fullnameController,
                        obSecureText: false,
                        labelText: 'Full name',
                        hintText: 'Enter your full name',
                        keyboardType: TextInputType.name,
                      ),

                      SizedBox(height: 8),

                      CustomTextfield(
                        controller: _emailController,
                        obSecureText: false,
                        labelText: 'Email',
                        hintText: 'Enter email address',
                        keyboardType: TextInputType.emailAddress,
                      ),

                      SizedBox(height: 8),

                      CustomTextfield(
                        controller: _passwordController,
                        obSecureText: true,
                        labelText: 'Password',
                        hintText: 'Enter password',
                      ),

                      SizedBox(height: 8),

                      CustomTextfield(
                        controller: _confirmPasswordController,
                        obSecureText: true,
                        labelText: 'Confirm Password',
                        hintText: 'Re-enter password',
                      ),

                      SizedBox(height: 32),

                      BlocConsumer<AuthCubit, AuthState>(
                        builder: (context, state) {
                          if (state is AuthLoading) {
                            return Center(
                              child: CircularProgressIndicator(
                                color: CustomTheme.colors(context).primary,
                              ),
                            );
                          }

                          return CustomButton(
                            text: 'Register account',
                            function: () => registerUser(),
                            width: double.infinity,
                          );
                        },
                        listener: (context, state) {
                          if (state is AuthError) {
                            return CustomSnackbarService.showError(
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
                      text: "Already have an account? ",
                      style: CustomTheme.typography(context).bodySmall.copyWith(
                        color: CustomTheme.colors(context).tertiaryText,
                      ),
                      children: [
                        TextSpan(
                          text: "Login here!",
                          style: CustomTheme.typography(context).bodySmall
                              .copyWith(
                                color: CustomTheme.colors(
                                  context,
                                ).primary, // highlight color
                                fontWeight: FontWeight.bold,
                              ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              context.pop();
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
