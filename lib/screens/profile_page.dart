import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test/provider/auth_provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final email = context.read<AuthProvider>().user?.email;
      if (email != null) {
        context.read<AuthProvider>().getProfile(email);
      }
    });

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthProvider>().signOut();
              Navigator.of(context).pushReplacementNamed('/login');
            },
          ),
        ],
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          if (authProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final user = authProvider.user;
          if (user == null) {
            return const Center(
              child: Text('No user data available'),
            );
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.blue,
                            child: Icon(Icons.person, size: 50, color: Colors.white),
                          ),
                          const SizedBox(height: 24),
                          _buildInfoTile(
                            icon: Icons.person_outline,
                            title: 'Name',
                            value: user.name,
                          ),
                          const Divider(),
                          _buildInfoTile(
                            icon: Icons.email_outlined,
                            title: 'Email',
                            value: user.email,
                          ),
                          const Divider(),
                          _buildInfoTile(
                            icon: Icons.phone_outlined,
                            title: 'Phone',
                            value: user.phone,
                          ),
                          const Divider(),
                          _buildInfoTile(
                            icon: Icons.calendar_today_outlined,
                            title: 'Date of Birth',
                            value: user.dob,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      subtitle: Text(
        value,
        style: const TextStyle(
          fontSize: 15,
        ),
      ),
    );
  }
}