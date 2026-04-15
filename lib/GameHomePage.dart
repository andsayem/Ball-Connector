// import 'package:ballconnector/models/game_state.dart';
// import 'package:ballconnector/widgets/game_board.dart';
// import 'package:ballconnector/widgets/hud_bar.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class GameHomePage extends StatelessWidget {
//   const GameHomePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Container(
//           width: double.infinity,
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               colors: [Color(0xFF0A0F26), Color(0xFF090B18)],
//             ),
//           ),
//           child: Column(
//             children: [
//               const SizedBox(height: 16),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 18),
//                 child: Row(
//                   children: [
//                     const Expanded(
//                       child: Text(
//                         'Ball Connector',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 28,
//                           fontWeight: FontWeight.bold,
//                           letterSpacing: 1.1,
//                         ),
//                       ),
//                     ),
//                     IconButton(
//                       onPressed: () => context.read<GameState>().restart(),
//                       icon: const Icon(Icons.refresh_rounded),
//                       color: Colors.white.withOpacity(0.82),
//                       tooltip: 'Restart current level',
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 8),
//               const HudBar(),
//               const SizedBox(height: 12),
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 14),
//                   child: Center(
//                     child: LayoutBuilder(
//                       builder: (context, constraints) {
//                         final boardSize = constraints.maxWidth < 520
//                             ? constraints.maxWidth
//                             : 520.0;
//                         return SizedBox(
//                           width: boardSize,
//                           height: boardSize,
//                           child: Stack(
//                             children: [
//                               const GameBoard(),
//                               Consumer<GameState>(
//                                 builder: (context, state, _) {
//                                   if (!state.isComplete) return const SizedBox.shrink();
//                                   return Positioned.fill(
//                                     child: Container(
//                                       decoration: BoxDecoration(
//                                         color: Colors.black.withOpacity(0.48),
//                                         borderRadius: BorderRadius.circular(22),
//                                       ),
//                                       child: Center(
//                                         child: Column(
//                                           mainAxisSize: MainAxisSize.min,
//                                           children: [
//                                             const Text(
//                                               'Level Complete!',
//                                               textAlign: TextAlign.center,
//                                               style: TextStyle(
//                                                 color: Colors.white,
//                                                 fontSize: 28,
//                                                 fontWeight: FontWeight.w900,
//                                               ),
//                                             ),
//                                             const SizedBox(height: 12),
//                                             Text(
//                                               'Great job! You solved level ${state.level.number}.',
//                                               textAlign: TextAlign.center,
//                                               style: TextStyle(
//                                                 color: Colors.white.withOpacity(0.82),
//                                                 fontSize: 14,
//                                               ),
//                                             ),
//                                             const SizedBox(height: 20),
//                                             FilledButton(
//                                               style: FilledButton.styleFrom(
//                                                 backgroundColor: const Color(0xFF5E78FF),
//                                                 padding: const EdgeInsets.symmetric(
//                                                   horizontal: 28,
//                                                   vertical: 14,
//                                                 ),
//                                               ),
//                                               onPressed: () {
//                                                 if (state.currentLevelIndex + 1 < state.totalLevels) {
//                                                   state.nextLevel();
//                                                 } else {
//                                                   state.loadLevel(0);
//                                                 }
//                                               },
//                                               child: Text(
//                                                 state.currentLevelIndex + 1 < state.totalLevels
//                                                     ? 'Next Level'
//                                                     : 'Play Again',
//                                                 style: const TextStyle(
//                                                   color: Colors.white,
//                                                   fontSize: 16,
//                                                 ),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   );
//                                 },
//                               ),
//                             ],
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: const [
//                     Text(
//                       'How to play',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 16,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                     SizedBox(height: 8),
//                     Text(
//                       'Draw smooth lines between matching balls. Avoid crossing or overlapping lines. Connect all pairs to complete the level.',
//                       style: TextStyle(
//                         color: Colors.white70,
//                         fontSize: 13,
//                         height: 1.5,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:ballconnector/common/admob_helper.dart';
import 'package:ballconnector/models/game_state.dart';
import 'package:ballconnector/widgets/game_board.dart';
import 'package:ballconnector/widgets/hud_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameHomePage extends StatefulWidget {
  const GameHomePage({super.key});

  @override
  State<GameHomePage> createState() => _GameHomePageState();
}

class _GameHomePageState extends State<GameHomePage> {
  @override
  void initState() {
    super.initState();

    // ✅ ensure first frame complete then load game safely
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = context.read<GameState>();
      state.loadLevel(0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<GameState>();

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

              /// 🔝 HEADER
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

              /// 🎮 GAME AREA
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Center(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final boardSize =
                            constraints.maxWidth < 520 ? constraints.maxWidth : 520.0;

                        return SizedBox(
                          width: boardSize,
                          height: boardSize,
                          child: Stack(
                            children: [
                              const GameBoard(),

                              /// ✅ LEVEL COMPLETE OVERLAY
                              if (state.isComplete)
                                Positioned.fill(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(22),
                                    ),
                                    child: Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Text(
                                            '🎉 Level Complete!',
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
                                              color: Colors.white.withOpacity(0.85),
                                              fontSize: 14,
                                            ),
                                          ),
                                          const SizedBox(height: 20),

                                          /// ▶️ NEXT BUTTON + AD
                                          FilledButton(
                                            style: FilledButton.styleFrom(
                                              backgroundColor: const Color(0xFF5E78FF),
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 28,
                                                vertical: 14,
                                              ),
                                            ),
                                            onPressed: () {
                                              AdmobHelper.showInterstitialAd(
                                                onAdDismissed: () {
                                                  if (!mounted) return;

                                                  final gameState =
                                                      context.read<GameState>();

                                                  if (gameState.currentLevelIndex +
                                                          1 <
                                                      gameState.totalLevels) {
                                                    gameState.nextLevel();
                                                  } else {
                                                    gameState.loadLevel(0);
                                                  }
                                                },
                                              );
                                            },
                                            child: Text(
                                              state.currentLevelIndex + 1 <
                                                      state.totalLevels
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
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),

              /// 📘 HOW TO PLAY
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