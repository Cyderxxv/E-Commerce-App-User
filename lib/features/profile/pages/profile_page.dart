import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_state.dart';
import '../bloc/profile_event.dart';
import '../../history/pages/history_page.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../auth/bloc/auth_event.dart';
import '../pages/profile_debt_page.dart';
import '../pages/profile_edit_page.dart';
import '../../wishlist/pages/wishlist_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // Load profile data when page initializes
    context.read<ProfileBloc>().add(LoadProfileEvent());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
        appBar: AppBar(
          backgroundColor: const Color(0xFF3DDCFF),
          elevation: 0,
          title: const Text(
            'My Account',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_none, color: Colors.white),
              onPressed: () {},
            ),
          ],
        ),
        body: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is ProfileError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: Colors.red),
                    SizedBox(height: 16),
                    Text(
                      'Error: ${state.message}',
                      style: TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => context.read<ProfileBloc>().add(LoadProfileEvent()),
                      child: Text('Retry'),
                    ),
                  ],
                ),
              );
            } else if (state is ProfileLoaded || state is ProfileUpdateSuccess) {
              final String name;
              final String email;
              final String avatarUrl;
              final String appVersion;
              
              if (state is ProfileLoaded) {
                name = state.name;
                email = state.email;
                avatarUrl = state.avatarUrl;
                appVersion = state.appVersion;
              } else {
                final successState = state as ProfileUpdateSuccess;
                name = successState.name;
                email = successState.email;
                avatarUrl = successState.avatarUrl;
                appVersion = successState.appVersion;
              }
              
              return _buildProfileContent(name, email, avatarUrl, appVersion);
            } else {
              return const Center(
                child: Text('No profile data available'),
              );
            }
          },
        ),
      );
  }

  Widget _buildProfileContent(String name, String email, String avatarUrl, String appVersion) {
    return Column(
      children: [
        Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundImage: NetworkImage(avatarUrl),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text(email, style: const TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit, color: Color(0xFF3DDCFF)),
                        onPressed: () {
                          final profileBloc = BlocProvider.of<ProfileBloc>(context);
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => BlocProvider.value(
                                value: profileBloc,
                                child: const ProfileEditPage(),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text('General', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 8),
                _ProfileMenuItem(
                  icon: Icons.history,
                  label: 'History',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const HistoryPage(),
                      ),
                    );
                  },
                ),
                _ProfileMenuItem(
                  icon: Icons.favorite_border, 
                  label: 'Wishlist', 
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const WishlistPage(),
                      ),
                    );
                  }
                ),
                _ProfileMenuItem(
                  icon: Icons.notifications_none,
                  label: 'Debts',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ProfileDebtPage(),
                      ),
                    );
                  },
                ),
                _ProfileMenuItem(icon: Icons.lock_outline, label: 'Security', onTap: null),
                const SizedBox(height: 16),
                Expanded(child: SizedBox()),
                Text('App version: $appVersion', style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.logout),
                      label: const Text('Logout', style: TextStyle(fontSize: 16)),
                      onPressed: () {
                        // Logout using BLoC
                        context.read<AuthBloc>().add(const LogoutEvent());
                        // Don't navigate, just let the ProfileWrapper handle the state change
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _ProfileMenuItem({
    required this.icon,
    required this.label,
    this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(icon, color: Color(0xFF3DDCFF)),
              const SizedBox(width: 16),
              Expanded(
                child: Text(label, style: const TextStyle(fontSize: 16)),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
