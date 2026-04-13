import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/game_state.dart';

class HudBar extends StatelessWidget {
  const HudBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameState>(builder: (context, state, _) {
      final total = state.level.pairCount;
      final done = state.connectedPairs;
      final progress = total > 0 ? done / total : 0.0;

      return Container(
        margin: const EdgeInsets.fromLTRB(12, 0, 12, 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF12122A),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white.withOpacity(0.07)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.35),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Level info
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShaderMask(
                      shaderCallback: (b) => const LinearGradient(
                        colors: [Color(0xFF667EEA), Color(0xFFBF5AF2)],
                      ).createShader(b),
                      child: Text(
                        'LEVEL ${state.level.number}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                    Text(
                      '${state.level.gridSize}×${state.level.gridSize} Grid  ·  $total Pairs',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.4),
                        fontSize: 11,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                _HudButton(
                  icon: Icons.undo_rounded,
                  label: 'Undo',
                  enabled: state.canUndo,
                  onTap: () => context.read<GameState>().undo(),
                ),
                const SizedBox(width: 8),
                _HudButton(
                  icon: Icons.refresh_rounded,
                  label: 'Reset',
                  enabled: state.connections.isNotEmpty,
                  onTap: () => context.read<GameState>().restart(),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 5,
                backgroundColor: Colors.white.withOpacity(0.07),
                valueColor: AlwaysStoppedAnimation<Color>(
                  progress >= 1.0
                      ? const Color(0xFF32D74B)
                      : const Color(0xFF667EEA),
                ),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              '$done / $total pairs connected',
              style: TextStyle(
                color: Colors.white.withOpacity(0.28),
                fontSize: 11,
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _HudButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool enabled;
  final VoidCallback onTap;

  const _HudButton({
    required this.icon,
    required this.label,
    required this.enabled,
    required this.onTap,
  });

  @override
  State<_HudButton> createState() => _HudButtonState();
}

class _HudButtonState extends State<_HudButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        if (widget.enabled) setState(() => _pressed = true);
      },
      onTapUp: (_) {
        if (_pressed) {
          setState(() => _pressed = false);
          widget.onTap();
        }
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedOpacity(
        opacity: widget.enabled ? 1.0 : 0.3,
        duration: const Duration(milliseconds: 200),
        child: AnimatedScale(
          scale: _pressed ? 0.92 : 1.0,
          duration: const Duration(milliseconds: 100),
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.07),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.11)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(widget.icon, color: Colors.white, size: 16),
                const SizedBox(width: 5),
                Text(
                  widget.label,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
