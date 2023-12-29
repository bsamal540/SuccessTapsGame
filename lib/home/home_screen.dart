import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:kjbn/util/string_constant.dart';
import 'package:provider/provider.dart';

import 'home_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CountDownController countDownController = CountDownController();
  HomeScreenController? homeScreenController;
  @override
  void initState() {
    homeScreenController =
        Provider.of<HomeScreenController>(context, listen: false);
    super.initState();
  }

  @override
  void dispose() {
    countDownController.reset();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: headerWidget(),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints mediaQuery) {
          return Padding(
            padding: EdgeInsets.symmetric(
              vertical: mediaQuery.maxHeight * 0.05,
              horizontal: mediaQuery.maxWidth * 0.08,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Consumer<HomeScreenController>(
                    builder: (context, homeScreenController, child) =>
                        matchNumberCardWidget(mediaQuery, homeScreenController),
                  ),
                  Consumer<HomeScreenController>(
                    builder: (context, homeScreenController, child) =>
                        successResponseWidget(mediaQuery, homeScreenController),
                  ),
                  timerWidget(mediaQuery),
                  buttonClickWidget(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  headerWidget() {
    return AppBar(
        centerTitle: true,
        title: const Text(StringConstant.projectTitle),
        backgroundColor: Colors.purple);
  }

  matchNumberCardWidget(
      BoxConstraints mediaQuery, HomeScreenController homeScreenController) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Card(
          color: Colors.brown,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                const Text("Current Second",
                    style:
                    TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                const SizedBox(
                  height: 10,
                ),
                const Divider(color: Colors.black, thickness: 2),
                Text("${homeScreenController.timeSec}")
              ],
            ),
          ),
        ),
        SizedBox(
          width: mediaQuery.maxWidth * 0.04,
        ),
        Card(
          color: Colors.pinkAccent,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                const Text("Random Number",
                    style:
                    TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                const SizedBox(
                  height: 10,
                ),
                const Divider(color: Colors.black, thickness: 2),
                Text("${homeScreenController.randomNumber}")
              ],
            ),
          ),
        ),
      ],
    );
  }

  successResponseWidget(
      BoxConstraints mediaQuery,
      HomeScreenController homeScreenController,
      ) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: mediaQuery.maxHeight * 0.08,
        horizontal: mediaQuery.maxWidth * 0.08,
      ),
      child: Card(
        color: homeScreenController.resultStatus == null
            ? Colors.grey
            : homeScreenController.resultStatus == true
            ? Colors.green
            : Colors.redAccent,
        child: Column(
          children: [
            Center(
              child: homeScreenController.attemptCount == 0
                  ? const Text(
                "Click To Start",
                style: TextStyle(fontSize: 30,color: Colors.white),
              )
                  : Text(
                textAlign: TextAlign.center,
                homeScreenController.resultStatus == null
                    ? "Sorry timeout and one attempt is considered as penalty with total attempts"
                    : homeScreenController.resultStatus == true
                    ? "Success:)"
                    : "Sorry Try Again!",
                style: TextStyle(
                    fontSize: homeScreenController.resultStatus == null
                        ? 20
                        : 30,color: Colors.white),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            homeScreenController.resultStatus == null
                ? const SizedBox()
                : const Divider(color: Colors.black, thickness: 2),
            homeScreenController.resultStatus == null
                ? const SizedBox()
                : Text(
              homeScreenController.resultStatus == true
                  ? "Scores : ${homeScreenController.successScoreCount}/${homeScreenController.attemptCount}"
                  : "Attempts : ${homeScreenController.attemptCount}",
              style: const TextStyle(fontSize: 20,color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  timerWidget(BoxConstraints mediaQuery) {
    return CircularCountDownTimer(
      textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      timeFormatterFunction: (defaultFormatterFunction, duration) {
        if (duration.inSeconds == 5) {
          return "0:05";
        } else {
          return "0:0${Function.apply(defaultFormatterFunction, [duration])}";
        }
      },
      strokeWidth: 15.0,
      initialDuration: 0,
      width: mediaQuery.maxWidth / 3,
      height: mediaQuery.maxHeight / 3,
      duration: 5,
      fillColor: Colors.blue,
      ringColor: Colors.grey.shade400,
      controller: countDownController,
      autoStart: false,
      isReverse: true,
      isReverseAnimation: true,
      onStart: () {
        // Here, do whatever you want
        debugPrint('Countdown Started');
      },
      onComplete: () {
        // homeScreenController?.timeSec = 0;
        // homeScreenController?.randomNumber = 0;
        homeScreenController?.checkResult();
        homeScreenController?.resetAllValue();
        // setState(() {});
        debugPrint('Countdown Ended');
      },
    );
  }

  buttonClickWidget() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
            backgroundColor: Colors.blue),
        onPressed: () {
          homeScreenController?.checkOnClicks(countDownController);
        },
        child: const Text(
          "Click",
          style: TextStyle(color: Colors.white),
        ));
  }
}
