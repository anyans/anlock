import 'dart:io';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:anlock/module/window_bottons.dart';
import 'package:anlock/page/about.dart';
import 'package:window_manager/window_manager.dart';
import 'package:anlock/page/home.dart';
import 'package:anlock/page/settings.dart';

class widgetPage extends StatefulWidget {
  const widgetPage({super.key});

  @override
  State<widgetPage> createState() => _widgetPageState();
}

class _widgetPageState extends State<widgetPage> with WindowListener {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
    _init();
  }

  void _init() async {
    await windowManager.setPreventClose(true); // 阻止默认关闭行为
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  // 新增窗口关闭事件处理
  @override
  void onWindowClose() async {
    bool confirmExit = await _showExitConfirmationDialog();
    if (confirmExit && mounted) {
      windowManager.destroy();
    }
  }

  Future<bool> _showExitConfirmationDialog() async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => ContentDialog(
        title: const Text('确认退出',style: TextStyle(fontFamily: "MiSans")),
        content: const Text('您确定要退出程序吗？',style: TextStyle(fontFamily: "MiSans")),
        actions: [
          Button(
            child: const Text('取消',style: TextStyle(fontFamily: "MiSans")),
            onPressed: () => Navigator.pop(context, false),
          ),
          FilledButton(
            child: const Text('退出',style: TextStyle(fontFamily: "MiSans")),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      padding: EdgeInsets.zero,
      content: NavigationView(
        appBar: NavigationAppBar(
          height: 60,
          title: DragToMoveArea(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  const SizedBox(width: 8),
                  Icon(FluentIcons.lock, size: 22),
                  const SizedBox(width: 8),
                  Text("暗锁", style: TextStyle(fontSize: 18, fontFamily: "MiSans")),
                ],
              ),
            ),
          ),
          actions: DragToMoveArea(
            child: Row(
              children: [
                Expanded(child: Container()),
                if (Platform.isWindows) WindowButtons(),
              ],
            ),
          ),
        ),
        pane: NavigationPane(
          displayMode: PaneDisplayMode.auto,
          selected: _selectedIndex,
          onChanged: (index) => setState(() => _selectedIndex = index),
          items: [
            PaneItem(
              icon: Icon(FluentIcons.home),
              title: Text("主页", style: TextStyle(fontFamily: "MiSans")),
              body: home(), // 替换为您的实际主页组件
            ),
          ],
          footerItems: [
            PaneItem(
              icon: Icon(FluentIcons.settings),
              title: Text("设置", style: TextStyle(fontFamily: "MiSans")),
              body: settings(),
            ),
            PaneItem(
              icon: Icon(FluentIcons.info),
              title: Text("关于", style: TextStyle(fontFamily: "MiSans")),
              body: about(),
            ),
          ],
        ),
      ),
    );
  }
}