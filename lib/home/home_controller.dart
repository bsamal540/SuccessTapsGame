import 'dart:math';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/cupertino.dart';

///check second tapped is true and random number > 0 (attempted consider to show success or failure)
///Else show attempt failed

class HomeScreenController extends ChangeNotifier {

  int randomNumber = 0;
  int timeSec = 0;
  int attemptCount = 0;
  int successScoreCount = 0;

  bool secondTimeTapped = false;
  bool? resultStatus = false;

  ///Reset values
  resetAllValue() {
    randomNumber = 0;
    timeSec = 0;
    secondTimeTapped = false;
    notifyListeners();
  }

  ///here need to check 2 times
  ///1.for initial & 2.for second tap with in time duration
  checkOnClicks(CountDownController countDownController) {
    if (timeSec == 0) {
      countDownController.start();
      timeSec = DateTime.now().second;
      attemptCount++;
      secondTimeTapped = false;
    } else {
      if (randomNumber == 0) {
        randomNumber = Random().nextInt(60);
        secondTimeTapped = true;
      }
    }
    notifyListeners();
  }

  ///After ending the time call this
  checkResult() {
    if (randomNumber == 0 && secondTimeTapped == false) {
      resultStatus = null;
    } else if (randomNumber == timeSec) {
      resultStatus = true;
      successScoreCount++;
    } else {
      resultStatus = false;
    }
  }
}
