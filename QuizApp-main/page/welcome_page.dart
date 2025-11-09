import 'dart:math';
import 'package:flutter/material.dart';
import 'category_page.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;
  final List<Bubble> _bubbles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    _colorAnimation = ColorTween(
      begin: Colors.deepPurpleAccent,
      end: Colors.pinkAccent,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Initialize colorful floating bubbles
    for (int i = 0; i < 30; i++) {
      _bubbles.add(Bubble(
        x: _random.nextDouble(),
        y: _random.nextDouble(),
        radius: _random.nextDouble() * 8 + 3,
        speed: _random.nextDouble() * 0.002 + 0.001,
        color: Colors.primaries[_random.nextInt(Colors.primaries.length)],
      ));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateBubbles() {
    for (final bubble in _bubbles) {
      bubble.y -= bubble.speed;
      if (bubble.y < -0.1) {
        bubble.y = 1.1;
        bubble.x = _random.nextDouble();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        _updateBubbles();
        return Scaffold(
          body: Stack(
            children: [
              // Background gradient animation
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black, _colorAnimation.value ?? Colors.blue],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),

              // Animated floating colorful bubbles
              CustomPaint(
                size: MediaQuery.of(context).size,
                painter: BubblePainter(_bubbles),
              ),

              // Main content
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Welcome to Galaxy Quiz!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Challenge yourself with fun and knowledge!',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 17,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 60, vertical: 16),
                        backgroundColor: Colors.deepPurpleAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 8,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CategoryPage()),
                        );
                      },
                      child: const Text(
                        'Start Quiz',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class Bubble {
  double x;
  double y;
  double radius;
  double speed;
  Color color;
  Bubble({
    required this.x,
    required this.y,
    required this.radius,
    required this.speed,
    required this.color,
  });
}

class BubblePainter extends CustomPainter {
  final List<Bubble> bubbles;
  BubblePainter(this.bubbles);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    for (final b in bubbles) {
      paint.color = b.color.withOpacity(0.5);
      canvas.drawCircle(
          Offset(b.x * size.width, b.y * size.height), b.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
