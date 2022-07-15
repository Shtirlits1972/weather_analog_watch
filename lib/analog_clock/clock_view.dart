import 'package:flutter/material.dart';
//  import 'package:intl/intl.dart';
import 'package:w_5/analog_clock/analogic_circle.dart';
import 'package:w_5/analog_clock/second_pointer.dart';

import 'hour_pointer.dart';
import 'minute_pointer.dart';

class ClockView extends StatelessWidget {
  const ClockView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Stream.periodic(
        Duration(seconds: 1),
      ),
      builder: (context, snapshot) {
        return SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  AnalogicCircle(),
                  SecondPointer(),
                  MinutePointer(),
                  HourPointer(),
                  Container(
                    height: 16,
                    width: 16,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
