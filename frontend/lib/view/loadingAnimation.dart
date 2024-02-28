import 'package:flutter/material.dart';
import 'package:frontend/resources/appColors.dart';

class LoadingAnimation extends StatefulWidget {
  const LoadingAnimation({super.key});

  @override
  State<LoadingAnimation> createState() => _LoadingAnimationState();
}

class _LoadingAnimationState extends State<LoadingAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<Offset>> _sequenceAnimation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 4));

    _sequenceAnimation = List.generate(5, (index) {
      print("begin index $index ${index/5}}");
        print("end index $index ${(index+1)/5}");
      return TweenSequence<Offset>(<TweenSequenceItem<Offset>>[
        TweenSequenceItem(
            tween: Tween(
              begin: const Offset(-300, 0),
              end: const Offset(0, 0),
            ),
            weight: 20),
        TweenSequenceItem(
            tween: Tween(
              begin: const Offset(0, 0),
              end: const Offset(300, 0),
            ),
            weight: 20),
      ]).animate(CurvedAnimation(
        reverseCurve: Curves.decelerate,
        parent: _controller,
        curve: Interval(
          index / 5,
          (index + 1) / 5,
          curve: Curves.bounceOut,
        ),
      ));
    });

    _controller.addListener(() {
      if (_controller.value > 0.5 && _controller.value < 0.7) {
        _controller.stop();
        print("stop");
        Future.delayed(const Duration(seconds: 2));
        _controller.forward();
        print("forwarrd");
        // Add a delay before starting the animation loop again
        // Future.delayed(const Duration(seconds: 2), () {

        // });
      }
    });
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reset();
        _controller.forward();
      }
    });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Wrap(
              children: List.generate(5, (index) {
                return AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: _sequenceAnimation[index].value,
                      child: Container(
                        margin: const EdgeInsets.all(5),
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blue, // Replace with your color
                        ),
                      ),
                    );
                  },
                );
              }),
            )
          ],
        ),
      ),
    );
  }
}
