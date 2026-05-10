import 'package:flutter/material.dart';
import 'register_page.dart';
import 'forgot_password_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1A237E), Color(0xFF3949AB)],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: 450,
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 40, offset: const Offset(0, 20)),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.account_circle, size: 80, color: Color(0xFF1A237E)),
                  const SizedBox(height: 20),
                  const Text(
                    "Selamat Datang Kembali",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1A237E)),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Masuk untuk melanjutkan pesanan Anda",
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 40),
                  _buildTextField("Email", Icons.email_outlined, _emailController),
                  const SizedBox(height: 20),
                  _buildPasswordField(),
                  const SizedBox(height: 15),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ForgotPasswordPage()),
                        );
                      },
                      child: const Text("Lupa Password?", style: TextStyle(color: Color(0xFF1A237E))),
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Login Berhasil!"), backgroundColor: Colors.green),
                        );
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1A237E),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                      child: const Text("MASUK", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Belum punya akun?"),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const RegisterPage()),
                          );
                        },
                        child: const Text("Daftar Sekarang", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, IconData icon, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 10),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: const Color(0xFF1A237E)),
            filled: true,
            fillColor: const Color(0xFFF5F7FB),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
            hintText: "Masukkan $label Anda",
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Password", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 10),
        TextField(
          controller: _passwordController,
          obscureText: !_isPasswordVisible,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF1A237E)),
            suffixIcon: IconButton(
              icon: Icon(_isPasswordVisible ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
              onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
            ),
            filled: true,
            fillColor: const Color(0xFFF5F7FB),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
            hintText: "Masukkan Password Anda",
          ),
        ),
      ],
    );
  }
}
