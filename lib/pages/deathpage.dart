/* import 'package:flutter/material.dart';
import 'HomeScreen.dart';
import '../Game/Game_Screen.dart';
import 'package:google_fonts/google_fonts.dart';

class DeathPage extends StatelessWidget {
  const DeathPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final width = screenSize.width;
    final height = screenSize.height;

    return Scaffold(
      body: Container(
        color: const Color(0xFF673AB7),
        child: Stack(
          children: [
            // 背景装饰
            Positioned.fill(
              child: Opacity(
                opacity: 0.3,
                child: Image.asset(
                  'assets/images/background.png', // 需要确保此图片存在或替换为现有图片
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // 游戏结束标题
            Positioned(
              top: height * 0.2,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  'GAME OVER',
                  style: TextStyle(
                    fontFamily: '851ShouShu',
                    color: Colors.white,
                    fontSize: width * 0.12,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black,
                        offset: Offset(5.0, 5.0),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // 死亡原因
            Positioned(
              top: height * 0.4,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  'You were killed by a spike!',
                  style: GoogleFonts.roboto(
                    color: Colors.white,
                    fontSize: width * 0.05,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

            // 按钮区域
            Positioned(
              top: height * 0.6,
              left: width * 0.3,
              right: width * 0.3,
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // 重新开始游戏
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => GameScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF9800),
                      padding: EdgeInsets.symmetric(
                        vertical: height * 0.02,
                        horizontal: width * 0.1,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                          color: Colors.white,
                          width: width * 0.005,
                        ),
                      ),
                    ),
                    child: Text(
                      'PLAY AGAIN',
                      style: TextStyle(
                        fontFamily: '851ShouShu',
                        color: Colors.white,
                        fontSize: width * 0.05,
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.03),
                  ElevatedButton(
                    onPressed: () {
                      // 返回主页
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF9E9E9E),
                      padding: EdgeInsets.symmetric(
                        vertical: height * 0.02,
                        horizontal: width * 0.1,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                          color: Colors.white,
                          width: width * 0.005,
                        ),
                      ),
                    ),
                    child: Text(
                      'HOME',
                      style: TextStyle(
                        fontFamily: '851ShouShu',
                        color: Colors.white,
                        fontSize: width * 0.05,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
 */
