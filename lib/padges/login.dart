import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/padges/home.dart';
import 'package:flutter_application_1/padges/sign_up.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final controllerEmail = TextEditingController();
  final controllerPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Image.asset("assets/image.png"),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shopping_bag, size: 70, color: Colors.amberAccent),
                Text(
                  "E-SHOP",
                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                ),
              ],
            ),

            Text(
              "أهلا بك فى عالم التسوق",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 20),

            TextField(
              controller: controllerEmail,
              textAlign: TextAlign.left,
              decoration: InputDecoration(
                labelText: "البريد الالكترونى",
                filled: true,
                fillColor: Colors.grey.shade200,
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
                labelText: "كلمة المرور",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              obscureText: true,
            ),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async {
                try {
                  await FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: controllerEmail.text.trim(),
                    password: controllerPassword.text.trim(),
                  );
                  if (!context.mounted) return;
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const Home()),
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
                "تسجيل الدخول",
                style: TextStyle(color: Colors.white),
              ),
            ),

            TextButton(
              onPressed: () {},
              child: Text(
                " نسيت كلمة المرور؟",
                style: TextStyle(color: Colors.blue),
              ),
            ),

            Spacer(),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUp()),
                    );
                  },
                  child: Text(
                    "انشاء حساب جديد",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
                Text("ليس لديك حساب؟"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
