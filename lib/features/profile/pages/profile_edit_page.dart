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
  late TextEditingController _dateOfBirthController;
  late TextEditingController _addressController;
  String _selectedGender = 'Male';
  
  final List<String> _genderOptions = ['Male', 'Female'];

  @override
  void initState() {
    super.initState();
    // Initialize controllers with empty values first
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _avatarController = TextEditingController();
    _dateOfBirthController = TextEditingController();
    _addressController = TextEditingController();
    
    // Access the bloc state safely after ensuring the widget is properly mounted
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final state = context.read<ProfileBloc>().state;
        if (state is ProfileLoaded) {
          print('🔧 ProfileEditPage loading state data:');
          print('  - dateOfBirth: ${state.dateOfBirth}');
          print('  - gender: ${state.gender}');
          print('  - address: ${state.address}');
          
          _nameController.text = state.name;
          _emailController.text = state.email;
          _avatarController.text = state.avatarUrl;
          // Load actual data from user profile
          _dateOfBirthController.text = state.dateOfBirth ?? '1990-01-01';
          _selectedGender = state.gender ?? 'Male';
          _addressController.text = state.address ?? '';
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
    _dateOfBirthController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    context.read<ProfileBloc>().add(
      UpdateProfileEvent(
        name: _nameController.text,
        email: _emailController.text,
        avatarUrl: _avatarController.text,
        dateOfBirth: _dateOfBirthController.text,
        gender: _selectedGender,
        address: _addressController.text,
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Profile updated successfully!\n'
          'Date of Birth: ${_dateOfBirthController.text}\n'
          'Gender: $_selectedGender\n'
          'Address: ${_addressController.text}'
        ),
      ),
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
            final String? dateOfBirth;
            final String? gender;
            final String? address;
            
            if (profileState is ProfileLoaded) {
              name = profileState.name;
              email = profileState.email;
              avatarUrl = profileState.avatarUrl;
              dateOfBirth = profileState.dateOfBirth;
              gender = profileState.gender;
              address = profileState.address;
              
              print('🔧 ProfileEditPage build - ProfileLoaded:');
              print('  - dateOfBirth: $dateOfBirth');
              print('  - gender: $gender');
              print('  - address: $address');
            } else {
              final successState = profileState as ProfileUpdateSuccess;
              name = successState.name;
              email = successState.email;
              avatarUrl = successState.avatarUrl;
              dateOfBirth = successState.dateOfBirth;
              gender = successState.gender;
              address = successState.address;
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
            if (_dateOfBirthController.text.isEmpty) {
              _dateOfBirthController.text = dateOfBirth ?? '1990-01-01';
            }
            if (_addressController.text.isEmpty) {
              _addressController.text = address ?? '';
            }
            // Update gender if available from state
            if (gender != null && gender.isNotEmpty) {
              _selectedGender = gender;
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
                  const SizedBox(height: 18),
                  TextField(
                    controller: _dateOfBirthController,
                    decoration: const InputDecoration(
                      labelText: 'Date of Birth (YYYY-MM-DD)',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    readOnly: true,
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.tryParse(_dateOfBirthController.text) ?? DateTime(1990),
                        firstDate: DateTime(1950),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) {
                        setState(() {
                          _dateOfBirthController.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 18),
                  DropdownButtonFormField<String>(
                    value: _selectedGender,
                    decoration: const InputDecoration(
                      labelText: 'Gender',
                      border: OutlineInputBorder(),
                    ),
                    items: _genderOptions.map((String gender) {
                      return DropdownMenuItem<String>(
                        value: gender,
                        child: Text(gender),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _selectedGender = newValue;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 18),
                  TextField(
                    controller: _addressController,
                    decoration: const InputDecoration(
                      labelText: 'Address',
                      border: OutlineInputBorder(),
                      hintText: 'Enter your full address',
                    ),
                    maxLines: 3,
                    textInputAction: TextInputAction.newline,
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
