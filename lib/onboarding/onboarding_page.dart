
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_firebase/components/custom_button.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {


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
              children:[
                CustomButton(text: 'Go to login', function: () => context.push('/login'),)
              ]  ),
          ),
        ),
      ),
    );
  }
}
