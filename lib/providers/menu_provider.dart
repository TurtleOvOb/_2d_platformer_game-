import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter/material.dart';

class MenuState {
  final String? selectedButton;
  final Offset? selectionPosition;
  final Size? selectionSize;

  const MenuState({
    this.selectedButton,
    this.selectionPosition,
    this.selectionSize,
  });

  MenuState copyWith({
    String? selectedButton,
    Offset? selectionPosition,
    Size? selectionSize,
  }) {
    return MenuState(
      selectedButton: selectedButton ?? this.selectedButton,
      selectionPosition: selectionPosition ?? this.selectionPosition,
      selectionSize: selectionSize ?? this.selectionSize,
    );
  }
}

class MenuNotifier extends StateNotifier<MenuState> {
  MenuNotifier() : super(const MenuState());

  void selectButton(String buttonId, Offset position, Size size) {
    if (state.selectedButton == buttonId) {
      // 如果点击的是当前选中的按钮，不做任何改变
      return;
    }
    // 否则更新选中状态为新的按钮
    state = state.copyWith(
      selectedButton: buttonId,
      selectionPosition: position,
      selectionSize: size,
    );
  }

  // 清除选择状态
  void clearSelection() {
    state = state.copyWith(
      selectedButton: null,
      selectionPosition: null,
      selectionSize: null,
    );
  }

  bool isSelected(String buttonId) => state.selectedButton == buttonId;
}

final menuProvider = StateNotifierProvider<MenuNotifier, MenuState>((ref) {
  return MenuNotifier();
});
