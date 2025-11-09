import 'dart:math';
import 'package:flutter/material.dart';
import '../models/category.dart';
import 'quiz_page.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Star> _stars = [];

  @override
  void initState() {
    super.initState();
    _controller =
    AnimationController(vsync: this, duration: const Duration(seconds: 20))
      ..repeat();
    _initStars();
  }

  void _initStars() {
    final rnd = Random();
    for (int i = 0; i < 120; i++) {
      _stars.add(Star(
        x: rnd.nextDouble(),
        y: rnd.nextDouble(),
        size: rnd.nextDouble() * 2 + 0.8,
        speed: rnd.nextDouble() * 0.001 + 0.0002,
        twinkle: rnd.nextDouble(),
      ));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateStars() {
    for (final s in _stars) {
      s.y += s.speed;
      s.twinkle += 0.01;
      if (s.y > 1.2) {
        s.y = -0.2;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = Category.getCategories();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose a Topic'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple.shade400,
      ),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          _updateStars();
          return Stack(
            children: [
              CustomPaint(
                size: MediaQuery.of(context).size,
                painter: StarFieldPainter(_stars),
              ),
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 380),
                  child: GridView.builder(
                    padding: const EdgeInsets.symmetric(
                        vertical: 40, horizontal: 10),
                    shrinkWrap: true,
                    itemCount: categories.length,
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 1.2,
                    ),
                    itemBuilder: (context, index) {
                      final cat = categories[index];
                      return GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => QuizPage(category: cat,),
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [cat.color1, cat.color2],
                            ),
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: cat.color2.withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              cat.name,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                shadows: [
                                  Shadow(
                                    blurRadius: 4,
                                    color: Colors.black26,
                                    offset: Offset(2, 2),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class Star {
  double x;
  double y;
  double size;
  double speed;
  double twinkle;

  Star({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.twinkle,
  });
}

class StarFieldPainter extends CustomPainter {
  final List<Star> stars;
  StarFieldPainter(this.stars);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    for (final s in stars) {
      final alpha = ((0.4 + 0.6 * (0.5 + 0.5 * sin(s.twinkle))) * 255)
          .toInt()
          .clamp(30, 255);
      paint.color = Colors.white.withAlpha(alpha);
      canvas.drawCircle(
        Offset(s.x * size.width, s.y * size.height),
        s.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

