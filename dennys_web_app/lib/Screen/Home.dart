import 'package:flutter/material.dart';

void main() {
  runApp(const FigmaToCodeApp());
}

class FigmaToCodeApp extends StatelessWidget {
  const FigmaToCodeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(255, 18, 32, 47),
      ),
      home: Scaffold(
        body: ListView(children: [
          Home(),
        ]),
      ),
    );
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: 832,
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: Color(0xFF102425),
            shape: RoundedRectangleBorder(side: BorderSide(width: 0.50)),
          ),
          child: Stack(
            children: [
              // ... (省略された部分はそのまま)

              Positioned(
                left: 49,
                top: 177,
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // ... (省略された部分はそのまま)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 91,
                top: 301,
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 1099,
                        height: 263,
                        child: Text(
                          'Your Adventurer’s Compass',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFFF2C9E7),
                            fontSize: 100,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: '~Discover new paths with ',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 36,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            TextSpan(
                              text: 'Runduraft',
                              style: TextStyle(
                                color: Color(0xFFBE60AE),
                                fontSize: 36,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            TextSpan(
                              text: '~',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 36,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              // ここまでメインコンテンツの追加

              // カスタムヘッダーの動作を維持
              // カスタムヘッダーの動作を維持
              Positioned(
                left: 0,
                top: 0,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 98,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 21),
                  decoration: BoxDecoration(color: Color(0xFFF2C9E7)),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth > 600) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Runduraft',
                              style: TextStyle(
                                color: Color(0xFFBE60AE),
                                fontSize: 50,
                                fontFamily: 'Noto Sans Japanese',
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  'Sign in',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 28,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(width: 48.0),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: Color(0xFF102425),
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: Text(
                                    'Sign up',
                                    style: TextStyle(
                                      color: Color(0xFFF2C9E7),
                                      fontSize: 28,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      } else {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Runduraft',
                              style: TextStyle(
                                color: Color(0xFFBE60AE),
                                fontSize: 50,
                                fontFamily: 'Noto Sans Japanese',
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.menu, color: Colors.black, size: 40.0),
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
                                            child: Text("Sign in"),
                                            onPressed: () {
                                              // Sign inの処理
                                            },
                                          ),
                                          TextButton(
                                            child: Text("Sign up"),
                                            onPressed: () {
                                              // Sign upの処理
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
