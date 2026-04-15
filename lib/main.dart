import 'package:ballconnector/GameHomePage.dart';
import 'package:ballconnector/common/admob_helper.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import 'models/game_state.dart';
import 'widgets/game_board.dart';
import 'widgets/hud_bar.dart';

Future<void> main() async {
  // ✅ Initialize AdMob
  await MobileAds.instance.initialize();

  // ✅ Child-safe config (IMPORTANT)
  MobileAds.instance.updateRequestConfiguration(
    RequestConfiguration(
      tagForChildDirectedTreatment: TagForChildDirectedTreatment.yes,
      maxAdContentRating: MaxAdContentRating.g,
    ),
  );

  final adHelper = AdmobHelper();
  WidgetsBinding.instance.addObserver(adHelper);
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
