import 'package:flutter/material.dart';
import 'dart:ui'; // ImageFilterを使用するために必要
import 'dart:math';
import 'signup_screen.dart';
import 'signin_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // この行を追加
  await Firebase.initializeApp(); // この行を追加
  runApp(const FigmaToCodeApp());
}
class FigmaToCodeApp extends StatelessWidget {
  const FigmaToCodeApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(255, 18, 32, 47),
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
        fontFamily: 'Noto Sans Japanese',
        fontWeight: FontWeight.w900,
      ),
    );
  }

  Widget _buildSignInSignUp(BuildContext context) {
    return Row(
      children: [
        GestureDetector(  // GestureDetectorを追加
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignInScreen()),  // SignInScreenに遷移
            );
          },
          child: const Text(
            'Sign in',
            style: TextStyle(
              color: Colors.black,
              fontSize: 28,
              fontFamily: 'Noto Sans Japanese',
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        const SizedBox(width: 48.0),
        GestureDetector(  // この部分を追加
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignUpScreen()),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            decoration: BoxDecoration(
              color: Color(0xFF102425),
              borderRadius: BorderRadius.circular(100),
            ),
            child: const Text(
              'Sign up',
              style: TextStyle(
                color: Color(0xFFF2C9E7),
                fontSize: 28,
                fontFamily: 'Noto Sans Japanese',
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
      icon: const Icon(Icons.menu, color: Colors.black, size: 40.0),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextButton(
                    child: const Text("Sign in"),
                    onPressed: () {},
                  ),
                  TextButton(
                    child: const Text("Sign up"),
                    onPressed: () {},
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 98,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 21),
      decoration: BoxDecoration(color: const Color(0xFFF2C9E7)),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 600) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildBrandName(),
                _buildSignInSignUp(context),  // ここでcontextを渡します
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
    if (width > 800) { // 大のサイズ
      return Container(
        width: width,
        clipBehavior: Clip.antiAlias,
        decoration: const ShapeDecoration(
          color: Color(0xFF102425),
          shape: RoundedRectangleBorder(side: BorderSide(width: 0.50)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // 中央に配置
          children: [
            const Frame12(),
            Center(child: _buildOriginalText(width)),
            const Frame12(),
          ],
        ),
      );
    } else { // 中、小のサイズ
      return SingleChildScrollView(
        child: Container(
          width: width,
          clipBehavior: Clip.antiAlias,
          decoration: const ShapeDecoration(
            color: Color(0xFF102425),
            shape: RoundedRectangleBorder(side: BorderSide(width: 0.50)),
          ),
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
      double offsetSpacing = min(spacing * (1 + (i - centerSquare).abs() * 0.15), maxSpacing);
      totalWidth += squareSize + offsetSpacing;
    }

    while (totalWidth > width && currentNumberOfSquares > 0) {
      currentNumberOfSquares--;
      double offsetSpacing = min(spacing * (1 + (currentNumberOfSquares - centerSquare).abs() * 0.15), maxSpacing);
      totalWidth -= (squareSize + offsetSpacing);
    }

    return Container(
      width: width,
      height: squareSize * 2,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(currentNumberOfSquares, (index) {
          double offsetSpacing = min(spacing * (1 + (index - centerSquare).abs() * 0.15), maxSpacing);
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
