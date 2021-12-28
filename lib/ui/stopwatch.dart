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

class _StopwatchState extends State<Stopwatch>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  Duration _previouslyElapsed = Duration.zero;
  Duration _currentlyElapsed = Duration.zero;
  Duration get _elapsed => _previouslyElapsed + _currentlyElapsed;
  bool _isRunning = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _ticker = this.createTicker((elapsed) {
      setState(() {
        _currentlyElapsed = elapsed;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _ticker.dispose();
    super.dispose();
  }

  void _toggleButton() {
    setState(() {
      _isRunning = !_isRunning;
      if (_isRunning) {
        _ticker.start();
      } else {
        _ticker.stop();
        _previouslyElapsed = _currentlyElapsed;
        _currentlyElapsed = Duration.zero;
      }
    });
  }

  void _reset() {
    _ticker.stop();
    setState(() {
      _isRunning = false;
      _previouslyElapsed = Duration.zero;
      _currentlyElapsed = Duration.zero;
    });
  }

  void _lap() {
    setState(() {
      _isRunning = true;
      _previouslyElapsed = _currentlyElapsed;
      _currentlyElapsed = Duration.zero;
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
              height: MediaQuery.of(context).size.height * 0.6,
              child: Stack(children: [
                StopWatchRenderer(elapsed: _elapsed, radius: radius),
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              children: [
                Text("Lap"),
                SizedBox(width: 20),
                Text("$_previouslyElapsed"),
              ],
            ),
          ],
        ));
  }
}
