import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

class EndScreenConfetti extends StatefulWidget {
  static late Function playConfetti;
  static late Function stopConfetti;

  const EndScreenConfetti({Key? key}) : super(key: key);

  @override
  _EndScreenConfettiState createState() => _EndScreenConfettiState();
}

class _EndScreenConfettiState extends State<EndScreenConfetti> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    EndScreenConfetti.playConfetti = () => _confettiController.play();
    EndScreenConfetti.stopConfetti = () => _confettiController.stop();
    _confettiController = ConfettiController();
  }

  @override
  void dispose() {
    super.dispose();
    _confettiController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Stack(
          children: <Widget> [
            Align(
              alignment: Alignment.center,
              child: ConfettiWidget(
                confettiController: _confettiController,
                emissionFrequency: 0.05,
                numberOfParticles: 20,
                maxBlastForce: 50,
                minBlastForce: 20,
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: true,
                colors: const [
                  Colors.green,
                  Colors.red,
                  Colors.white,
                  Colors.amber,
                  Colors.blue
                ],
              ),
            ),
          ],
        )
    );
  }
}