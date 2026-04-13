import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/game_state.dart';
import 'widgets/game_board.dart';
import 'widgets/hud_bar.dart';

void main() {
  runApp(const BallConnectorApp());
}

class BallConnectorApp extends StatelessWidget {
  const BallConnectorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GameState(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Ball Connector',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.indigo,
            brightness: Brightness.dark,
          ),
          scaffoldBackgroundColor: const Color(0xFF060C24),
          textTheme: Typography.whiteMountainView,
        ),
        home: const GameHomePage(),
      ),
    );
  }
}

class GameHomePage extends StatelessWidget {
  const GameHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF0A0F26), Color(0xFF090B18)],
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Ball Connector',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => context.read<GameState>().restart(),
                      icon: const Icon(Icons.refresh_rounded),
                      color: Colors.white.withOpacity(0.82),
                      tooltip: 'Restart current level',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              const HudBar(),
              const SizedBox(height: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Center(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final boardSize = constraints.maxWidth < 520
                            ? constraints.maxWidth
                            : 520.0;
                        return SizedBox(
                          width: boardSize,
                          height: boardSize,
                          child: Stack(
                            children: [
                              const GameBoard(),
                              Consumer<GameState>(
                                builder: (context, state, _) {
                                  if (!state.isComplete) return const SizedBox.shrink();
                                  return Positioned.fill(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.48),
                                        borderRadius: BorderRadius.circular(22),
                                      ),
                                      child: Center(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Text(
                                              'Level Complete!',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 28,
                                                fontWeight: FontWeight.w900,
                                              ),
                                            ),
                                            const SizedBox(height: 12),
                                            Text(
                                              'Great job! You solved level ${state.level.number}.',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.white.withOpacity(0.82),
                                                fontSize: 14,
                                              ),
                                            ),
                                            const SizedBox(height: 20),
                                            FilledButton(
                                              style: FilledButton.styleFrom(
                                                backgroundColor: const Color(0xFF5E78FF),
                                                padding: const EdgeInsets.symmetric(
                                                  horizontal: 28,
                                                  vertical: 14,
                                                ),
                                              ),
                                              onPressed: () {
                                                if (state.currentLevelIndex + 1 < state.totalLevels) {
                                                  state.nextLevel();
                                                } else {
                                                  state.loadLevel(0);
                                                }
                                              },
                                              child: Text(
                                                state.currentLevelIndex + 1 < state.totalLevels
                                                    ? 'Next Level'
                                                    : 'Play Again',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'How to play',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Draw smooth lines between matching balls. Avoid crossing or overlapping lines. Connect all pairs to complete the level.',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
