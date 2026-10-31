import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/padges/home.dart';
import 'package:flutter_application_1/padges/login.dart';

// ألوان الذهبي المستخدمة في الشاشة
const _goldLight = Color(0xFFF3DC95);
const _goldMid = Color(0xFFC9A24A);
const _goldDark = Color(0xFF9A7524);

const _goldGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [_goldLight, _goldMid, _goldDark],
);

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<double> _scale;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _scale = Tween<double>(begin: 0.85, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _controller.forward();

    // بعد 3 ثواني روح لشاشة Login
    _timer = Timer(const Duration(seconds: 5), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
  builder: (_) => FirebaseAuth.instance.currentUser == null
      ? const Login()
      : const Home(),
),
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.0,
            colors: [Colors.white, Color(0xFFE9EAEC)],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fade,
            child: ScaleTransition(
              scale: _scale,
              child: Column(
                children: [
                  const Spacer(flex: 3),
                  const _GoldShaderMask(
                    child: Icon(Icons.shopping_bag, size: 130),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "E-SHOP",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF2B2B2B),
                      letterSpacing: 1.5,
                    ),
                  ),
                  const Spacer(flex: 2),
                  const _GoldRingLogo(),
                  const Spacer(flex: 2),
                  const Text(
                    "A.A.",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2B2B2B),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "جاري التحميل...",
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 20),
                  const SizedBox(
                    width: 120,
                    child: LinearProgressIndicator(
                      minHeight: 3,
                      color: _goldMid,
                      backgroundColor: Color(0xFFE5DCC3),
                    ),
                  ),
                  const Spacer(flex: 1),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// يلوّن أي Widget (أيقونة أو نص) بتدرج ذهبي
class _GoldShaderMask extends StatelessWidget {
  final Widget child;
  const _GoldShaderMask({required this.child});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => _goldGradient.createShader(bounds),
      child: IconTheme(
        data: const IconThemeData(color: Colors.white),
        child: DefaultTextStyle.merge(
          style: const TextStyle(color: Colors.white),
          child: child,
        ),
      ),
    );
  }
}

/// الدايرة الذهبية اللي جواها حرف A
class _GoldRingLogo extends StatelessWidget {
  const _GoldRingLogo();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 170,
      height: 170,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // هالة خفيفة برا الدايرة
          Container(
            width: 170,
            height: 170,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: _goldMid.withOpacity(0.18), width: 1.5),
            ),
          ),
          Container(
            width: 145,
            height: 145,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: _goldMid.withOpacity(0.30), width: 1.5),
            ),
          ),
          // الحلقة الذهبية الأساسية
          Container(
            width: 115,
            height: 115,
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: SweepGradient(
                colors: [_goldLight, _goldDark, _goldLight, _goldMid, _goldLight],
              ),
            ),
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFFBF8EF),
              ),
              alignment: Alignment.center,
              child: const _GoldShaderMask(
                child: Text(
                  "A",
                  style: TextStyle(
                    fontSize: 62,
                    fontWeight: FontWeight.w300,
                    fontFamily: 'serif',
                  ),
                ),
              ),
            ),
          ),
          // شنطة صغيرة على يمين الدايرة
          const Positioned(
            right: 22,
            bottom: 38,
            child: _GoldShaderMask(
              child: Icon(Icons.shopping_bag, size: 26),
            ),
          ),
        ],
      ),
    );
  }
}