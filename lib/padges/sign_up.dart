import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/padges/home.dart';
import 'package:flutter_application_1/padges/login.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final controllerFullName = TextEditingController();
  final controllerEmail = TextEditingController();
  final controllerPassword = TextEditingController();
  final controllerConfirmPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shopping_bag, size: 50, color: Colors.amberAccent),
              SizedBox(width: 10),
              Text(
                "E-SHOP",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              "Sign Up",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 20),

            TextField(
              controller: controllerFullName,
              textAlign: TextAlign.left,
              decoration: InputDecoration(
                labelText: "Full Name",
                filled: true,
                fillColor: Colors.grey.shade200,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),

            SizedBox(height: 20),

            TextField(
              controller: controllerEmail,
              textAlign: TextAlign.left,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey.shade200,
                labelText: "Email",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),

            SizedBox(height: 20),

            TextField(
              controller: controllerPassword,
              textAlign: TextAlign.left,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey.shade200,
                labelText: "Password",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              obscureText: true,
            ),

            SizedBox(height: 20),

            TextField(
              controller: controllerConfirmPassword,
              textAlign: TextAlign.left,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey.shade200,
                labelText: "Confirm Password",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              obscureText: true,
            ),

            SizedBox(height: 40),

            ElevatedButton(
              onPressed: () async {
                if (controllerPassword.text != controllerConfirmPassword.text) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("كلمتا المرور غير متطابقتين")),
                  );
                  return;
                }
                try {
                  final cred = await FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                        email: controllerEmail.text.trim(),
                        password: controllerPassword.text.trim(),
                      );
                  await cred.user?.updateDisplayName(
                    controllerFullName.text.trim(),
                  );
                  if (!context.mounted) return;
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const Home()),
                    (route) => false,
                  );
                } on FirebaseAuthException catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(e.message ?? "حصل خطأ")),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlue,
              ),
              child: Text(
                "Create Account",
                style: TextStyle(color: Colors.white),
              ),
            ),

            SizedBox(height: 25),

            Text("Already have an account?"),

            TextButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  MaterialPageRoute(builder: (context) => Login()),
                );
              },
              child: Text("Login", style: TextStyle(color: Colors.blue)),
            ),
          ],
        ),
      ),
    );
  }
}
