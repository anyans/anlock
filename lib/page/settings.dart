import 'package:fluent_ui/fluent_ui.dart';

// ignore: camel_case_types
class settings extends StatefulWidget {
  const settings({super.key});

  @override
  State<settings> createState() => _settingsState();
}

// ignore: camel_case_types
class _settingsState extends State<settings> {
@override
Widget build(BuildContext context) {
  return ScaffoldPage(
    content: Stack(
      children: [
        // 左上角主页文字
        Positioned(
          top: 12,   // 根据实际布局调整
          left: 50,
          child: Text(
            "主页",
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
              fontFamily: "MiSans",
            ),
          ),
        ),
        // 原有内容
        Center(
          child: Text("程序目前太简单，还没什么要设置的QAQ\n"
          "(作者太懒了...)", 
              style: TextStyle(fontFamily: "MiSans")),
        ),
      ],
    ),
  );
}
}