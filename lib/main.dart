import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class ThemeProvider with ChangeNotifier {
  bool isDarkMode = false;
  
  void toggleTheme() {
    isDarkMode = !isDarkMode;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            theme: themeProvider.isDarkMode ? ThemeData.dark() : ThemeData.light(),
            home: const FadingTextScreen(),
          );
        },
      ),
    );
  }
}

class FadingTextScreen extends StatefulWidget {
  const FadingTextScreen({super.key});

  @override
  _FadingTextScreenState createState() => _FadingTextScreenState();
}

class _FadingTextScreenState extends State<FadingTextScreen> {
  Color _textColor = Colors.black;
  final PageController _pageController = PageController();

  void _changeTextColor() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Pick a color"),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: _textColor,
              onColorChanged: (color) {
                setState(() {
                  _textColor = color;
                });
              },
            ),
          ),
          actions: [
            TextButton(
              child: const Text("Done"),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fading Text Animation"),
        actions: [
          IconButton(
            icon: Icon(themeProvider.isDarkMode ? Icons.nightlight_round : Icons.wb_sunny),
            onPressed: themeProvider.toggleTheme,
          ),
          IconButton(
            icon: const Icon(Icons.color_lens),
            onPressed: _changeTextColor,
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        children: [
          FadingTextAnimation(duration: const Duration(seconds: 1), textColor: _textColor),
          FadingTextAnimation(duration: const Duration(seconds: 3), textColor: _textColor),
        ],
      ),
    );
  }
}

class FadingTextAnimation extends StatefulWidget {
  final Duration duration;
  final Color textColor;

  const FadingTextAnimation({super.key, required this.duration, required this.textColor});

  @override
  _FadingTextAnimationState createState() => _FadingTextAnimationState();
}

class _FadingTextAnimationState extends State<FadingTextAnimation> {
  bool _isVisible = true;

  void _toggleVisibility() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: _toggleVisibility,
        child: AnimatedOpacity(
          opacity: _isVisible ? 1.0 : 0.0,
          duration: widget.duration,
          curve: Curves.easeInOut,
          child: Text(
            'Hello, Flutter!',
            style: TextStyle(fontSize: 24, color: widget.textColor),
          ),
        ),
      ),
    );
  }
}
