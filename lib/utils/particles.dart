import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';

/// 轻量可复用的粒子效果工厂
class Particles {
  /// 收集物品时的绽放效果
  static ParticleSystemComponent collectBurst(
    Vector2 worldPosition, {
    Color color = Colors.yellow,
    int count = 18,
    double lifespan = 0.5,
    double speed = 140,
  }) {
    final rnd = Random();
    return ParticleSystemComponent(
      position: worldPosition,
      priority: 1000, // 保证在前景可见
      particle: Particle.generate(
        count: count,
        lifespan: lifespan,
        generator: (i) {
          final angle = rnd.nextDouble() * pi * 2;
          final magnitude = speed * (0.6 + rnd.nextDouble() * 0.8);
          final v = Vector2(cos(angle), sin(angle)) * magnitude;
          final baseRadius = 1.8 + rnd.nextDouble() * 1.6;
          return AcceleratedParticle(
            speed: v,
            acceleration: -v / (lifespan * 1.2), // 轻微减速
            child: ComputedParticle(
              renderer: (canvas, p) {
                // ease-out 渐隐+缩放
                final t = Curves.easeOut.transform(p.progress);
                final radius = baseRadius * (1 - t);
                final paint = Paint()..color = color.withOpacity(1 - t);
                canvas.drawCircle(Offset.zero, radius, paint);
              },
            ),
          );
        },
      ),
    );
  }

  /// 撞击火花（用于尖刺、弹墙等）
  static ParticleSystemComponent hitSpark(
    Vector2 worldPosition, {
    Color color = Colors.orange,
    int count = 14,
    double lifespan = 0.35,
    double speed = 180,
  }) {
    final rnd = Random();
    return ParticleSystemComponent(
      position: worldPosition,
      priority: 1000,
      particle: Particle.generate(
        count: count,
        lifespan: lifespan,
        generator: (i) {
          final baseAngle = rnd.nextDouble() * pi * 2;
          final jitter = (rnd.nextDouble() - 0.5) * 0.6;
          final angle = baseAngle + jitter;
          final v =
              Vector2(cos(angle), sin(angle)) *
              (speed * (0.7 + rnd.nextDouble() * 0.6));
          final baseRadius = 1.2 + rnd.nextDouble() * 1.5;
          return AcceleratedParticle(
            speed: v,
            child: ComputedParticle(
              renderer: (canvas, p) {
                final t = Curves.decelerate.transform(p.progress);
                final radius = baseRadius * (1 - t);
                final paint = Paint()..color = color.withOpacity(1 - t);
                canvas.drawCircle(Offset.zero, radius, paint);
              },
            ),
          );
        },
      ),
    );
  }

  /// 起跳/落地的灰尘
  static ParticleSystemComponent dust(
    Vector2 worldPosition, {
    Color color = const Color(0xFFBDBDBD),
    int count = 10,
    double lifespan = 0.4,
    double speed = 90,
  }) {
    final rnd = Random();
    return ParticleSystemComponent(
      position: worldPosition,
      priority: 900,
      particle: Particle.generate(
        count: count,
        lifespan: lifespan,
        generator: (i) {
          final angle = (-pi / 2) + (rnd.nextDouble() - 0.5) * pi / 1.2; // 主要向上
          final v =
              Vector2(cos(angle), sin(angle)) *
              (speed * (0.6 + rnd.nextDouble() * 0.7));
          final baseRadius = 1.5 + rnd.nextDouble() * 2;
          final baseOpacity = 0.7 + rnd.nextDouble() * 0.3; // 初始有随机透明度
          return AcceleratedParticle(
            speed: v,
            child: ComputedParticle(
              renderer: (canvas, p) {
                final t = Curves.easeOutQuad.transform(p.progress);
                final radius = baseRadius * (1 - t);
                final paint =
                    Paint()..color = color.withOpacity(baseOpacity * (1 - t));
                canvas.drawCircle(Offset.zero, radius, paint);
              },
            ),
          );
        },
      ),
    );
  }

  /// 传送门传送效果
  static ParticleSystemComponent teleportBurst(
    Vector2 worldPosition, {
    Color color = const Color(0xFF42A5F5), // 默认蓝色
    int count = 25,
    double lifespan = 0.7,
    double speed = 160,
    double gravity = 30,
  }) {
    final rnd = Random();
    return ParticleSystemComponent(
      position: worldPosition,
      priority: 1000, // 高优先级，确保在顶层显示
      particle: Particle.generate(
        count: count,
        lifespan: lifespan,
        generator: (i) {
          final angle = rnd.nextDouble() * pi * 2;
          final magnitude = speed * (0.5 + rnd.nextDouble() * 0.8);
          final v = Vector2(cos(angle), sin(angle)) * magnitude;

          // 为每个粒子添加不同的重力和大小
          final gravityForce = Vector2(
            0,
            gravity * (0.8 + rnd.nextDouble() * 0.4),
          );
          final baseRadius = 2.2 + rnd.nextDouble() * 2.0;
          final baseOpacity = 0.7 + rnd.nextDouble() * 0.3;

          return AcceleratedParticle(
            speed: v,
            acceleration: gravityForce,
            child: ComputedParticle(
              renderer: (canvas, p) {
                // 使用曲线创建非线性渐变效果
                final t = Curves.easeOutExpo.transform(p.progress);

                // 粒子随时间缩小
                final radius = baseRadius * (1 - t);

                // 创建径向渐变，中心更亮
                final paint =
                    Paint()
                      ..shader = RadialGradient(
                        colors: [
                          color.withOpacity(baseOpacity * (1 - t)),
                          color.withOpacity(baseOpacity * 0.5 * (1 - t)),
                        ],
                      ).createShader(
                        Rect.fromCircle(center: Offset.zero, radius: radius),
                      );

                // 绘制带发光效果的圆形粒子
                canvas.drawCircle(Offset.zero, radius, paint);

                // 为部分粒子添加轨迹拖尾效果
                if (i % 3 == 0 && p.progress < 0.6) {
                  final trailPaint =
                      Paint()
                        ..color = color.withOpacity(
                          baseOpacity * 0.3 * (1 - p.progress),
                        )
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = radius * 0.4;

                  canvas.drawLine(
                    Offset.zero,
                    Offset(-v.x * 0.03, -v.y * 0.03),
                    trailPaint,
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }
}
