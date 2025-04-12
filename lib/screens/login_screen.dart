import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';

  bool _isLoginMode = true;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(title: Text(_isLoginMode ? 'Login' : 'Register')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Email Field
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  onSaved: (value) => _email = value!.trim(),
                  validator: (value) => (value == null || !value.contains('@')) ? 'Enter a valid email' : null,
                ),
                const SizedBox(height: 16),
                // Password Field
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  onSaved: (value) => _password = value!.trim(),
                  validator: (value) => (value == null || value.length < 6) ? 'Password must be at least 6 characters' : null,
                ),
                const SizedBox(height: 16),
                if (_errorMessage != null)
                  Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
                const SizedBox(height: 16),
                // Submit Button
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      setState(() {
                        _isLoading = true;
                        _errorMessage = null;
                      });
                      try {
                        if (_isLoginMode) {
                          await authProvider.signInWithEmail(_email, _password);
                        } else {
                          await authProvider.signUpWithEmail(_email, _password);
                        }
                      } catch (e) {
                        setState(() {
                          _errorMessage = e.toString();
                        });
                      }
                      setState(() {
                        _isLoading = false;
                      });
                    }
                  },
                  child: Text(_isLoginMode ? 'Login' : 'Register'),
                ),
                const SizedBox(height: 16),
                // Google Sign In Button
                _isLoading
                    ? const SizedBox()
                    : ElevatedButton.icon(
                  icon: const Icon(Icons.login),
                  label: const Text('Sign in with Google'),
                  onPressed: () async {
                    setState(() {
                      _isLoading = true;
                      _errorMessage = null;
                    });
                    try {
                      await authProvider.signInWithGoogle();
                    } catch (e) {
                      setState(() {
                        _errorMessage = e.toString();
                      });
                    }
                    setState(() {
                      _isLoading = false;
                    });
                  },
                ),
                const SizedBox(height: 16),
                // Toggle between Login and Register
                TextButton(
                  onPressed: () => setState(() => _isLoginMode = !_isLoginMode),
                  child: Text(_isLoginMode
                      ? 'Don\'t have an account? Register here'
                      : 'Already have an account? Login here'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
