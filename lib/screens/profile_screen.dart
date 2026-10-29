import 'package:flutter/material.dart';
import '../providers/providers.dart';
import '../theme/app_theme.dart';

class ProfileScreen extends StatefulWidget {
  final AuthProvider authProvider;

  const ProfileScreen({super.key, required this.authProvider});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _emailController = TextEditingController();
  final _passController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.authProvider.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile & Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: user == null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Sign In to VeriMart',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Manage your marketplace orders, wishlist, and shipping addresses.',
                    style: TextStyle(color: AppTheme.secondaryTextColor),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email Address',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _passController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock_outline),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_emailController.text.isNotEmpty) {
                          widget.authProvider.login(
                            _emailController.text,
                            _passController.text,
                          );
                        }
                      },
                      child: const Text('Sign In'),
                    ),
                  ),
                ],
              )
            : Column(
                children: [
                  const CircleAvatar(
                    radius: 45,
                    backgroundColor: AppTheme.primaryColor,
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    user.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    user.email,
                    style: const TextStyle(
                      color: AppTheme.secondaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Card(
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.phone,
                              color: AppTheme.primaryColor),
                          title: const Text('Phone Number'),
                          subtitle: Text(user.phone),
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.home,
                              color: AppTheme.primaryColor),
                          title: const Text('Shipping Address'),
                          subtitle: Text(user.address),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                      ),
                      icon: const Icon(Icons.logout),
                      label: const Text('Sign Out'),
                      onPressed: () {
                        widget.authProvider.logout();
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
