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
}
