import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:simple_chat/components/shared/connection_state.dart';
import 'package:simple_chat/route/named_routes.dart';
import 'package:simple_chat/src/service/auth_service.dart';
import 'package:simple_chat/src/service/profile_service.dart';
import 'package:simple_chat/src/service/toast_service.dart';
import 'package:simple_chat/src/storage/store.dart';
import 'package:simple_chat/src/storage/token.dart';
import 'package:simple_chat/utils/theme/theme_color.dart';

late ObjectBox objectBox;
late Token? tokenFromBox;
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {

  if (kReleaseMode) {
    await dotenv.load(fileName: '.env.production');
  }

  if (kDebugMode) {
    await dotenv.load(fileName: '.env.development');
  }

  objectBox = await ObjectBox.create();
  tokenFromBox = objectBox.store.box<Token>().get(1) ??
      Token(accessToken: '', refreshToken: '');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthServiceProvider()),
        ChangeNotifierProvider(create: (_) {
          ProfileService profileSvc = ProfileService();
          profileSvc.loadProfile();
          return profileSvc;
        }),
      ],
      child: MaterialApp(
        scaffoldMessengerKey: ToastService().scaffoldKey,
        navigatorKey: navigatorKey,
        initialRoute: tokenFromBox!.accessToken.length > 1
            ? NamedRoute.home
            : NamedRoute.login,
        routes: NamedRoute.routes,
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        builder: (context, child) {
          return Stack(
            children: [
              child!,
              const WConnectionState(),
            ],
          );
        },
      ),
    ),
  );
}