import 'package:flutter/material.dart';
import 'dart:ui'; // ImageFilterを使用するために必要
import 'dart:math';
import 'signup_screen.dart';
import 'signin_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const FigmaToCodeApp());
}

class FigmaToCodeApp extends StatelessWidget {
  const FigmaToCodeApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF102425),
        colorScheme: ThemeData.dark().colorScheme.copyWith(
              secondary: const Color(0xFFBE60AE),
            ),
        scaffoldBackgroundColor: const Color(0xFF102425),
        fontFamily: 'Inter',
      ),
      home: const Scaffold(body: Home()),
    );
  }
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        CustomHeader(),
        Expanded(child: MainContent()),
      ],
    );
  }
}

class CustomHeader extends StatelessWidget {
  const CustomHeader({Key? key}) : super(key: key);

  Widget _buildBrandName() {
    return Text(
      'Randuraft',
      style: const TextStyle(
        color: Color(0xFFBE60AE),
        fontSize: 50,
        fontWeight: FontWeight.w900,
      ),
    );
  }

  Widget _buildSignInSignUp(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignInScreen()),
            );
          },
          child: const Text(
            'Sign in',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        const SizedBox(width: 48.0),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignUpScreen()),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            decoration: BoxDecoration(
              color: Color(0xFFBE60AE),
              borderRadius: BorderRadius.circular(100),
            ),
            child: const Text(
              'Sign up',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuIcon(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.menu, color: Color(0xFFD996C7), size: 40.0),
      onPressed: () {
        showDialog(
          context: context,
          barrierDismissible: true, // 背景をタップしてもダイアログが閉じる
          barrierColor: Colors.transparent, // 背景を透明に
          builder: (BuildContext context) {
            return ModernDialog();
          },
        );
      },
    );
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 98,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 21),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 600) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildBrandName(),
                _buildSignInSignUp(context),
              ],
            );
          } else {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildBrandName(),
                _buildMenuIcon(context),
              ],
            );
          }
        },
      ),
    );
  }
}

class ModernDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Color(0xFFBF60AF),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.close, color: Colors.white, size: 30.0),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignInScreen()),
                );
              },
              child: Text(
                'Sign in',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontFamily: 'Noto Sans Japanese',
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            SizedBox(height: 40),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpScreen()),
                );
              },
              child: Text(
                'Sign up',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontFamily: 'Noto Sans Japanese',
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MainContent extends StatelessWidget {
  const MainContent({Key? key}) : super(key: key);
  Widget _buildOriginalText(double maxWidth) {
    double fontSize = 100;
    double subTextFontSize = 36; // 追加: サブテキストのフォントサイズ
    String text = 'Your Adventurer’s \nCompass';

    if (maxWidth < 600) {
      fontSize = 40;
      subTextFontSize = 20; // サブテキストのフォントサイズを調整
      text = 'Your\nAdventurer’s\nCompass';
    } else if (maxWidth < 800) {
      fontSize = 60;
      subTextFontSize = 28; // サブテキストのフォントサイズを調整
      text = 'Your Adventurer’s\nCompass';
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: maxWidth,
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: const Color(0xFFF2C9E7),
              fontSize: fontSize,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(height: 20), // 高さを増やす
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: '~Discover new paths with ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: subTextFontSize, // ここでサブテキストのフォントサイズを使用
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextSpan(
                text: 'Randuraft',
                style: TextStyle(
                  color: const Color(0xFFBE60AE),
                  fontSize: subTextFontSize, // ここでサブテキストのフォントサイズを使用
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w900,
                ),
              ),
              TextSpan(
                text: '~',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: subTextFontSize, // ここでサブテキストのフォントサイズを使用
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    // 画面の横幅に応じて3つのサイズを判定
    if (width > 800) {
      // 大のサイズ
      return Container(
        width: width,
        color: const Color(0xFF102425), // ここを変更
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // 中央に配置
          children: [
            const Frame12(),
            Center(child: _buildOriginalText(width)),
            const Frame12(),
          ],
        ),
      );
    } else {
      // 中、小のサイズ
      return SingleChildScrollView(
        child: Container(
          width: width,
          color: const Color(0xFF102425), // ここを変更
          child: Column(
            children: [
              const Frame12(),
              Center(child: _buildOriginalText(width)),
              const Frame12(),
            ],
          ),
        ),
      );
    }
  }
}

class Frame12 extends StatefulWidget {
  const Frame12({Key? key}) : super(key: key);

  @override
  _Frame12State createState() => _Frame12State();
}

class _Frame12State extends State<Frame12> {
  final Random _random = Random();
  final int numberOfSquares = 15;
  final List<double> _topOffsets = List.generate(15, (index) => 0.0);

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < numberOfSquares; i++) {
      _topOffsets[i] = _random.nextDouble();
    }
  }

  Widget _buildSquare(double size, int index) {
    // 最も外側の2行の四角形を特定
    bool isOuterSquare = index < 2 || index >= numberOfSquares - 2;

    return isOuterSquare
        ? ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  color: const Color(0xFF723873).withOpacity(0.7),
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ),
          )
        : Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: const Color(0xFF723873),
              borderRadius: BorderRadius.circular(5.0),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double maxSquareSize = 60.0;
    double squareSize = min(width / (numberOfSquares + 5), maxSquareSize);
    double spacing = squareSize / 3;
    double maxSpacing = 40.0;

    int centerSquare = numberOfSquares ~/ 2;

    double totalWidth = 0;
    int currentNumberOfSquares = numberOfSquares;
    for (int i = 0; i < currentNumberOfSquares; i++) {
      double offsetSpacing =
          min(spacing * (1 + (i - centerSquare).abs() * 0.15), maxSpacing);
      totalWidth += squareSize + offsetSpacing;
    }

    while (totalWidth > width && currentNumberOfSquares > 0) {
      currentNumberOfSquares--;
      double offsetSpacing = min(
          spacing * (1 + (currentNumberOfSquares - centerSquare).abs() * 0.15),
          maxSpacing);
      totalWidth -= (squareSize + offsetSpacing);
    }

    return Container(
      width: width,
      height: squareSize * 2,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(currentNumberOfSquares, (index) {
          double offsetSpacing = min(
              spacing * (1 + (index - centerSquare).abs() * 0.15), maxSpacing);
          return Padding(
            padding: EdgeInsets.only(
              top: _topOffsets[index % _topOffsets.length] * squareSize,
              right: offsetSpacing,
            ),
            child: _buildSquare(squareSize, index),
          );
        }),
      ),
    );
  }
}
