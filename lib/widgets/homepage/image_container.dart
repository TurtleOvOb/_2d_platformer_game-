import 'package:flutter/material.dart';

/// 一个使用图片作为背景的容器组件
/// 类似于ImageTextButton，但不包含按钮功能，只是一个容器
class ImageContainer extends StatelessWidget {
  final String imagePath; // 背景图片路径
  final Widget child; // 容器内容
  final double? width; // 容器宽度
  final double? height; // 容器高度
  final BoxFit imageFit; // 图像填充方式
  final EdgeInsets? padding; // 内边距
  final EdgeInsets? margin; // 外边距
  final BorderRadius? borderRadius; // 圆角
  final BoxBorder? border; // 边框

  const ImageContainer({
    Key? key,
    required this.imagePath,
    required this.child,
    this.width,
    this.height,
    this.imageFit = BoxFit.cover,
    this.padding,
    this.margin,
    this.borderRadius,
    this.border,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        border: border,
        image: DecorationImage(image: AssetImage(imagePath), fit: imageFit),
      ),
      padding: padding,
      child: child,
    );
  }
}

/// 构建图像容器的便捷函数
Widget buildImageContainer({
  required String imagePath,
  required Widget child,
  double? width,
  double? height,
  BoxFit imageFit = BoxFit.cover,
  EdgeInsets? padding,
  EdgeInsets? margin,
  BorderRadius? borderRadius,
  BoxBorder? border,
}) {
  return ImageContainer(
    imagePath: imagePath,
    child: child,
    width: width,
    height: height,
    imageFit: imageFit,
    padding: padding,
    margin: margin,
    borderRadius: borderRadius,
    border: border,
  );
}
