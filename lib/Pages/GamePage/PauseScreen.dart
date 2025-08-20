import 'package:_2d_platformergame/widgets/levepage/LevelScreen.dart';
import 'package:flutter/material.dart';
<<<<<<< HEAD:lib/Pages/GamePage/PauseScreen.dart
=======
import '../homepage/image_container.dart';
import '../homepage/image_text_button.dart';
>>>>>>> overlay-refactor:lib/widgets/game_page/pause_dialog.dart

class PauseScreen extends StatelessWidget {
  final VoidCallback onResume;
  final BuildContext parentContext; // 父级context用于导航

  const PauseScreen({
    super.key,
    required this.onResume,
    required this.parentContext,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
<<<<<<< HEAD:lib/Pages/GamePage/PauseScreen.dart
      child: Container(
=======
      child: ImageContainer(
        imagePath: 'assets/images/containers/BackGround2.png',
>>>>>>> overlay-refactor:lib/widgets/game_page/pause_dialog.dart
        padding: const EdgeInsets.all(24),
        margin: const EdgeInsets.symmetric(horizontal: 64),
        constraints: const BoxConstraints(maxWidth: 280), // 限制最大宽度
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 255, 141, 26).withAlpha(200),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'PAUSED',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'PixelMplus12-Regular',
                color: Color.fromARGB(255, 248, 248, 248),
              ),
            ),
            const SizedBox(height: 24),
            ImageTextButton(
              text: 'Continue',
              imagePath: 'assets/images/buttons/Button1.png',
              onTap: onResume,
              icon: Icon(
                Icons.play_arrow_outlined,
                color: Color.fromARGB(255, 255, 255, 250),
                size: 20,
              ),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'PixelMplus12-Regular',
                color: Color.fromARGB(255, 255, 255, 250),
              ),
              width: 150,
              height: 48,
              imageFit: BoxFit.fill,
            ),
            const SizedBox(height: 16),
            ImageTextButton(
              text: 'Level Select',
              imagePath: 'assets/images/buttons/Button1.png',
              onTap: () {
                // 首先关闭当前对话框
                Navigator.of(context).pop();

                // 使用Future.microtask确保对话框完全关闭后再导航
                Future.microtask(() {
                  // 使用父上下文进行导航
                  Navigator.of(parentContext).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const LevelScreen(),
                    ),
                    (route) => false,
                  );
                });
              },
              icon: Icon(
                Icons.format_list_bulleted,
                color: Color.fromARGB(255, 255, 255, 250),
                size: 20,
              ),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'PixelMplus12-Regular',
                color: Color.fromARGB(255, 255, 255, 250),
              ),
              width: 150,
              height: 48,
              imageFit: BoxFit.fill,
            ),
          ],
        ),
      ),
    );
  }
}
