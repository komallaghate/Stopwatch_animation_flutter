import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:stopwatch_flutter/ui/elapsed_time_text.dart';
import 'package:stopwatch_flutter/ui/elapsed_time_text_basic.dart';
import 'package:stopwatch_flutter/ui/reset_button.dart';
import 'package:stopwatch_flutter/ui/start_stop_button.dart';
import 'package:stopwatch_flutter/ui/stopwatch_renderer.dart';

class Stopwatch extends StatefulWidget {
  @override
  _StopwatchState createState() => _StopwatchState();
}

class _StopwatchState extends State<Stopwatch> with TickerProviderStateMixin {
  late final Ticker _ticker;
  late final Ticker _lapticker;
  Duration _previouslyElapsed = Duration.zero;
  Duration _currentlyElapsed = Duration.zero;
  Duration _currentlyElapsedLap = Duration.zero;
  Duration get _elapsed => _previouslyElapsed + _currentlyElapsed;
  Duration get _lapElapsed => _currentlyElapsedLap;
  Duration _previousLap = Duration.zero;
  bool _isRunning = false;
  bool _isLapPressed = false;
  List laps = [];
  var colors = [
    Colors.white,
    Colors.green,
    Colors.red,
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _ticker = this.createTicker((elapsed) {
      setState(() {
        _currentlyElapsed = elapsed;
      });
    });
    _lapticker = this.createTicker((lapElapsed) {
      setState(() {
        _currentlyElapsedLap = lapElapsed;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _ticker.dispose();
    _lapticker.dispose();
    super.dispose();
  }

  void _toggleButton() {
    setState(() {
      _isRunning = !_isRunning;
      if (_isRunning) {
        _ticker.start();
        _previouslyElapsed = _elapsed;
        _startLap();
      } else {
        _ticker.stop();
        _lapticker.stop();
      }
    });
  }

  void _reset() {
    _ticker.stop();
    setState(() {
      _isRunning = false;
      _isLapPressed = false;
      _previouslyElapsed = Duration.zero;
      _currentlyElapsed = Duration.zero;
      laps.removeRange(0, laps.length);
    });
  }

  void _startLap() {
    setState(() {
      _isRunning = true;
      _lapDisplay(context);
    });
  }

  bool isLapPressedAgain = false;
  void _lap() {
    setState(() {
      _isLapPressed == true ? _lapticker.stop() : null;
      _lapticker.start();
      _isRunning = true;
      _isLapPressed = true;
      laps.add(_elapsed - _previousLap);
    });
    _lapDisplay(context);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final radius = constraints.maxWidth / 2;
        return Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.5,
              child: Stack(children: [
                StopWatchRenderer(
                  elapsed: _elapsed,
                  radius: radius,
                  isLapPressed: _isLapPressed,
                  lapElapsed: _lapElapsed,
                ),
                Align(
                    alignment: Alignment.bottomLeft,
                    child: SizedBox(
                        width: 80,
                        height: 80,
                        child: ResetButton(
                          onPressed: _isRunning ? _lap : _reset,
                          isRunning: _isRunning,
                        ))),
                Align(
                    alignment: Alignment.bottomRight,
                    child: SizedBox(
                        width: 80,
                        height: 80,
                        child: StartStopButton(
                          onPressed: _toggleButton,
                          isRunning: _isRunning,
                        ))),
              ]),
            ),
            _lapDisplay(context),
          ],
        );
      },
    );
  }

  Widget _lapDisplay(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.2,
        child: Column(
          children: [
            _isRunning
                ? Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Divider(
                          color: Colors.grey.withOpacity(0.4),
                          thickness: 1,
                          height: 1,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Lap ${laps.length + 1} "),
                          SizedBox(width: 20),
                          Text(laps.length + 1 == 1
                              ? "${_elapsed}"
                              : "${_lapElapsed}"),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Divider(
                          color: Colors.grey.withOpacity(0.4),
                          thickness: 1,
                          height: 1,
                        ),
                      ),
                    ],
                  )
                : Container(),
            Container(
              height: MediaQuery.of(context).size.height * 0.2,
              child: ListView.builder(
                  itemCount: laps.length,
                  itemBuilder: (context, index) {
                    _previousLap = laps[laps.length - 1];
                    return _isLapPressed == true
                        ? Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Lap ${index + 1}",
                                      style:
                                          TextStyle(color: colors[index % 3])),
                                  SizedBox(width: 20),
                                  Text("${laps[index]}"),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Divider(
                                  color: Colors.grey.withOpacity(0.4),
                                  thickness: 1,
                                  height: 1,
                                ),
                              ),
                            ],
                          )
                        : Container();
                  }),
            ),
          ],
        ));
  }
}
