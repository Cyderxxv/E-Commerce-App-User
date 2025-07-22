import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({Key? key}) : super(key: key);

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _avatarController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with empty values first
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _avatarController = TextEditingController();
    
    // Access the bloc state safely after ensuring the widget is properly mounted
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final state = context.read<ProfileBloc>().state;
        if (state is ProfileLoaded) {
          _nameController.text = state.name;
          _emailController.text = state.email;
          _avatarController.text = state.avatarUrl;
          setState(() {}); // Refresh UI with new values
        }
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _avatarController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    context.read<ProfileBloc>().add(
      UpdateProfileEvent(
        name: _nameController.text,
        email: _emailController.text,
        avatarUrl: _avatarController.text,
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully!')),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFF3DDCFC),
        title: const Text('Edit Profile', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          TextButton(
            child: const Text('Save', style: TextStyle(color: Colors.white, fontSize: 16)),
            onPressed: _saveProfile,
          ),
        ],
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, profileState) {
          if (profileState is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (profileState is ProfileError) {
            return Center(
              child: Text('Error: ${profileState.message}'),
            );
          } else if (profileState is ProfileLoaded || profileState is ProfileUpdateSuccess) {
            final String name;
            final String email;
            final String avatarUrl;
            
            if (profileState is ProfileLoaded) {
              name = profileState.name;
              email = profileState.email;
              avatarUrl = profileState.avatarUrl;
            } else {
              final successState = profileState as ProfileUpdateSuccess;
              name = successState.name;
              email = successState.email;
              avatarUrl = successState.avatarUrl;
            }
            
            // Initialize controllers if empty
            if (_nameController.text.isEmpty) {
              _nameController.text = name;
            }
            if (_emailController.text.isEmpty) {
              _emailController.text = email;
            }
            if (_avatarController.text.isEmpty) {
              _avatarController.text = avatarUrl;
            }
            
            return Padding(
              padding: const EdgeInsets.all(20),
              child: ListView(
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 44,
                      backgroundImage: NetworkImage(_avatarController.text.isNotEmpty 
                        ? _avatarController.text 
                        : avatarUrl),
                    ),
                  ),
                  const SizedBox(height: 18),
                  TextField(
                    controller: _avatarController,
                    decoration: const InputDecoration(
                      labelText: 'Avatar URL',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 18),
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 18),
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(
              child: Text('No profile data available'),
            );
          }
        },
      ),
    );
  }
}
