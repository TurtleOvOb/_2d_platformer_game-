import 'package:_2d_platformergame/pages/LevelScreen.dart';
import 'package:flutter/material.dart';
import '../homepage/image_container.dart';

class PauseDialog extends StatelessWidget {
  final VoidCallback onResume;
  final BuildContext parentContext; // 父级context用于导航

  const PauseDialog({
    super.key,
    required this.onResume,
    required this.parentContext,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ImageContainer(
        imagePath: 'assets/images/containers/BackGround1.png',
        padding: const EdgeInsets.all(24),
        margin: const EdgeInsets.symmetric(horizontal: 64),
        width: 280, // 限制最大宽度
        borderRadius: BorderRadius.circular(16),
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
            _buildButton(
              icon: Icons.play_arrow_outlined,
              label: 'Continue',
              onTap: onResume,
              isPrimary: false,
            ),
            const SizedBox(height: 16),
            _buildButton(
              icon: Icons.format_list_bulleted,
              label: 'Level Select',
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
              isPrimary: false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isPrimary = true,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color.fromARGB(255, 255, 255, 250),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
            color:
                isPrimary
                    ? const Color.fromARGB(255, 53, 53, 51)
                    : Colors.transparent,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: const Color.fromARGB(255, 255, 255, 250),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'PixelMplus12-Regular',
                  color: Color.fromARGB(255, 255, 255, 250),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
