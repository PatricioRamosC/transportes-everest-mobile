import 'package:flutter/material.dart';
import 'dart:async';

class WaitingTimerWidget extends StatefulWidget {
  final DateTime startTime;
  final bool isActive;
  final Function()? onTimerFinished;

  const WaitingTimerWidget({
    Key? key,
    required this.startTime,
    required this.isActive,
    this.onTimerFinished,
  }) : super(key: key);

  @override
  _WaitingTimerWidgetState createState() => _WaitingTimerWidgetState();
}

class _WaitingTimerWidgetState extends State<WaitingTimerWidget> {
  late Duration _elapsedTime;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _elapsedTime = DateTime.now().difference(widget.startTime);
    _startTimerIfActive();
  }

  @override
  void didUpdateWidget(WaitingTimerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Si el estado cambió de activo a inactivo
    if (oldWidget.isActive && !widget.isActive) {
      _timer?.cancel();
      widget.onTimerFinished?.call();
    }

    // Si el estado cambió de inactivo a activo
    if (!oldWidget.isActive && widget.isActive) {
      _startTimerIfActive();
    }
  }

  void _startTimerIfActive() {
    if (widget.isActive) {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          _elapsedTime = DateTime.now().difference(widget.startTime);
        });
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: widget.isActive ? Colors.orange[50] : Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: widget.isActive ? Colors.orange : Colors.grey,
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.isActive ? 'En espera' : 'Espera finalizada',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: widget.isActive ? Colors.orange[800] : Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _formatDuration(_elapsedTime),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: widget.isActive ? Colors.orange : Colors.grey,
            ),
          ),
          Text(
            'hor:min:seg',
            style: TextStyle(
              fontSize: 10,
              color: widget.isActive ? Colors.orange[600] : Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}
