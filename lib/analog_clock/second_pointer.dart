import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';

import 'package:w_5/Repo/RepoCity.dart';

class SecondPointer extends StatelessWidget {
  const SecondPointer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    Duration dur = Duration(
        seconds: Provider.of<RepoCity>(context, listen: false)
            .getCurentCity()
            .TimeZone);
    DateTime dtL = DateTime.now().toUtc().add(dur);

    final second = dtL.second.toDouble();
    final angleSecond = (-pi * (second / -60)) * 2;
    final width = MediaQuery.of(context).size.width;
    bool isPortait = height > width;
    return RotatedBox(
      quarterTurns: 2,
      child: Transform.rotate(
        angle: angleSecond,
        child: Transform.translate(
          offset: Offset(0, 34),
          child: Center(
            child: Container(
              height: isPortait ? height * 0.15 : width * 0.10,
              width: 2,
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.9),
                borderRadius: BorderRadius.circular(32),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
