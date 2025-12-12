import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Joystick extends JoystickComponent with HasVisibility {
  Joystick()
      : super(
          knob: CircleComponent(radius: 20, paint: Paint()..color = const Color(0xFF00FF00)),
          background: CircleComponent(radius: 50, paint: Paint()..color = const Color(0x7700FF00)),
          margin: const EdgeInsets.only(left: 40, bottom: 40),
        );
}