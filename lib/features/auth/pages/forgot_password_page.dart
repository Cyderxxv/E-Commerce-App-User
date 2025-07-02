import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../model/input_forgot_password_model.dart';
import 'otp_page.dart';
import 'register_page.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _onForgotPasswordPressed() {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập số điện thoại')),
      );
      return;
    }
    context.read<AuthBloc>().add(
      ForgotPasswordEvent(data: ForgotPasswordModel(phoneNumber: phone)),
    );
  }

  void _onRegisterTap() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const RegisterPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: SafeArea(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is ForgotPasswordState && state.success) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message ?? 'OTP sent')),
              );
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => OtpPage(phoneNumber: _phoneController.text.trim()),
                ),
              );
            } else if (state is ForgotPasswordState && !state.success) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message ?? 'Gửi OTP thất bại')),
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  const Text(
                    'Forgot Password?',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Enter your phone number and then we\'ll send an OTP code to your phone.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 32),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.mail_outline, color: Colors.grey),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              labelText: 'Phone Number',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4DD0EE),
                        foregroundColor: Colors.white,
                        textStyle: const TextStyle(fontWeight: FontWeight.bold),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      onPressed: _onForgotPasswordPressed,
                      child: const Text('Log In', style: TextStyle(fontSize: 18)),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account? ", style: TextStyle(color: Colors.black54)),
                      GestureDetector(
                        onTap: _onRegisterTap,
                        child: const Text(
                          'Register',
                          style: TextStyle(color: Color(0xFF4DD0EE), fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
