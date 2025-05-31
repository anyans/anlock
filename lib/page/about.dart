import 'package:fluent_ui/fluent_ui.dart';

// ignore: camel_case_types
class about extends StatefulWidget {
  const about({super.key});

  @override
  State<about> createState() => _aboutState();
}

// ignore: camel_case_types
class _aboutState extends State<about> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      content: Stack(
        children: [
          // 左上角标题
          Positioned(
            top: 20,
            left: 50,
            child: Text(
              "关于",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                fontFamily: "MiSans",
              ),
            ),
          ),
          
          // 主体内容
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 应用图标
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    image: const DecorationImage(
                      image: AssetImage('assets/app_icon.png'),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // 应用名称
                Text(
                  "暗锁",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    fontFamily: "MiSans",
                    color: Colors.blue.normal,
                  ),
                ),
                const SizedBox(height: 12),

                // 版本信息
                InfoBar(
                  title: const Text('当前版本'),
                  content: Text(
                    '0.1.0 Pre-alpha(Dev) (2025525)',
                    style: TextStyle(fontFamily: 'MiSans'),
                  ),
                  severity: InfoBarSeverity.info,
                ),
                const SizedBox(height: 20),

                // 描述信息
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 120),
                  child: Text(
                    "一款基于 Fluent Design 设计的现代化应用程序，致力于提供优雅高效的用户体验。"
                    "本产品由 Flutter 强力驱动，支持多平台运行。"
                    "加密技术为AES-256-CTR\n\n"
                    "目前为测试阶段，代码的功能会有缺失与bug，如果发现bug或有好的建议欢迎联系作者\n"
                    "3762916796@qq.com",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: "MiSans",
                      color: Colors.grey[130],
                    ),
                  ),
                ),
                const SizedBox(height: 28),
              ],
            ),
          ),

          // 底部版权信息
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                "© 2025 暗锁. 所有版权归作者所属\n"
                "© MiSans 字体. 所有版权归小米公司所有",
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: "MiSans",
                  color: Colors.grey[120],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}