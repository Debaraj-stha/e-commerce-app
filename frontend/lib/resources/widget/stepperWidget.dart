import 'package:another_stepper/another_stepper.dart';
import 'package:flutter/material.dart';

StepperData BuildStepperData(
  String status,
  int stateId,
  int activeId,
) {
  bool isActive = stateId <= activeId;
  return StepperData(
      title: StepperText(
        status,
      ),
      iconWidget: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? Colors.blue : Colors.grey),
      ));
}
