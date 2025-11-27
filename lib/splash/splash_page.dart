import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_firebase/features/authentication/presentations/cubits/auth_cubit.dart';
import 'package:hive_firebase/features/authentication/presentations/cubits/auth_state.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    // Wait 2 seconds then go to HomePage
    Timer(const Duration(seconds: 2), () {
      if (mounted) {
        final authState = context.read<AuthCubit>().state;

        if(authState is Authenticated) {
          context.go('/home');
        } else {
          context.go('/login');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // or any color you like
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/edit.png',
              width: 120,
              height: 120,
            ),
            const SizedBox(height: 16),
            const Text(
              'My Notes',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
