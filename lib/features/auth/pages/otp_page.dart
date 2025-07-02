import 'package:flutter/material.dart';

class OtpPage extends StatefulWidget {
  final String phoneNumber;
  const OtpPage({Key? key, required this.phoneNumber}) : super(key: key);

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final TextEditingController _otpController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  void _onProceed() {
    final otp = _otpController.text.trim();
    if (otp.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the OTP')),
      );
      return;
    }
    // TODO: Xử lý xác thực OTP ở đây
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('OTP entered: $otp')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const Text(
                'One-time Password',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'An OTP has been send to number\n(+84)${widget.phoneNumber.substring(widget.phoneNumber.length - 9).padLeft(widget.phoneNumber.length, 'x')}.  Check your phone then enter the provided OTP to below box.',
                style: const TextStyle(fontSize: 15, color: Colors.grey),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: '123456',
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
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
                  onPressed: _onProceed,
                  child: const Text('Proceed'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
