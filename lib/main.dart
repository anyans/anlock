import 'package:fluent_ui/fluent_ui.dart';
import 'package:anlock/page/widget.dart';
import 'package:window_manager/window_manager.dart';
import 'package:universal_platform/universal_platform.dart'; // 新增

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 使用 universal_platform 检测桌面环境（包含 Web 安全检测）
  if (UniversalPlatform.isDesktop) {
    await windowManager.ensureInitialized();

    WindowOptions windowOptions = WindowOptions(
        size: Size(700, 600),
        center: true,
        titleBarStyle: TitleBarStyle.hidden,
        title: "暗锁"
    );

    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FluentApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: FluentThemeData.light(),
      darkTheme: FluentThemeData.dark(),
      home: const widgetPage(),
    );
  }
}