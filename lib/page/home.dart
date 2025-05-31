// ignore_for_file: camel_case_types

import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:file_picker/file_picker.dart';
import 'package:crypto/crypto.dart' as crypto;
import 'package:pointycastle/export.dart' as pc;

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  final _keyController = TextEditingController();
  bool _isProcessing = false;

  @override
  void dispose() {
    _keyController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    if (_keyController.text.isEmpty) {
      _showError('请输入加密/解密密钥');
      return;
    }

    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.any,
      );

      if (result != null && mounted) {
        final file = result.files.first;
        final filePath = file.path!;

        setState(() => _isProcessing = true);

        final isEncrypted = filePath.toLowerCase().endsWith('.encrypted');
        final outputPath = isEncrypted
            ? filePath.replaceFirst(RegExp(r'\.encrypted$', caseSensitive: false), '')
            : '$filePath.encrypted';

        final processedFile = isEncrypted
            ? await _decryptFile(File(filePath), outputPath)
            : await _encryptFile(File(filePath), outputPath);

        if (mounted) {
          _showResult(
            title: '操作成功',
            message: '${isEncrypted ? '解密' : '加密'}文件路径: ${processedFile.path}',
          );
        }
      }
    } catch (e) {
      _showError('操作失败: ${e.toString()}');
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  Future<File> _encryptFile(File file, String outputPath) async {
    final bytes = await file.readAsBytes();
    final iv = _generateIV();
    final key = _generateKey(_keyController.text);
    
    // 加密数据
    final encrypter = _getAESEncrypter(key, iv);
    final encryptedBytes = encrypter.process(bytes);
    
    // 生成HMAC
    final hmac = crypto.Hmac(crypto.sha256, key);
    final digest = hmac.convert(encryptedBytes);

    // 组合数据：IV(16) + HMAC(32) + 密文
    final encryptedData = Uint8List(16 + 32 + encryptedBytes.length)
      ..setAll(0, iv)
      ..setAll(16, digest.bytes)
      ..setAll(48, encryptedBytes);

    return File(outputPath).writeAsBytes(encryptedData);
  }

  Future<File> _decryptFile(File file, String outputPath) async {
    final encryptedBytes = await file.readAsBytes();
    
    // 验证最小长度：IV(16) + HMAC(32) + 最小密文(1)
    if (encryptedBytes.length < 49) throw Exception('无效的加密文件');
    
    // 拆分数据
    final iv = encryptedBytes.sublist(0, 16);
    final storedHmac = encryptedBytes.sublist(16, 48);
    final cipherText = encryptedBytes.sublist(48);
    final key = _generateKey(_keyController.text);

    // 验证HMAC
    final hmac = crypto.Hmac(crypto.sha256, key);
    final calculatedHmac = hmac.convert(cipherText);

    if (!_constantTimeCompare(storedHmac, calculatedHmac.bytes)) {
      throw Exception('密钥错误或文件损坏');
    }

    // 解密数据
    final decrypter = _getAESDecrypter(key, iv);
    return File(outputPath).writeAsBytes(decrypter.process(cipherText));
  }

  Uint8List _generateKey(String password) {
    return Uint8List.fromList(
      crypto.sha256.convert(password.codeUnits).bytes.sublist(0, 32)
    );
  }

  Uint8List _generateIV() {
    return Uint8List.fromList(
      List.generate(16, (_) => Random.secure().nextInt(256))
    );
  }

  pc.StreamCipher _getAESEncrypter(Uint8List key, Uint8List iv) {
    return pc.StreamCipher('AES/CTR')
      ..init(
        true,
        pc.ParametersWithIV(pc.KeyParameter(key), iv),
      );
  }

  pc.StreamCipher _getAESDecrypter(Uint8List key, Uint8List iv) {
    return pc.StreamCipher('AES/CTR')
      ..init(
        false,
        pc.ParametersWithIV(pc.KeyParameter(key), iv),
      );
  }

  bool _constantTimeCompare(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    var result = 0;
    for (var i = 0; i < a.length; i++) {
      result |= a[i] ^ b[i];
    }
    return result == 0;
  }

  void _showResult({required String title, required String message}) {
    showDialog(
      context: context,
      builder: (context) => ContentDialog(
        title: Text(title,style: TextStyle(fontFamily: "MiSans")),
        content: Text(message,style: TextStyle(fontFamily: "MiSans")),
        actions: [
          FilledButton(
            child: const Text('确定',style: TextStyle(
              fontFamily: "MiSans",
              fontSize: 12
            )),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  void _showError(String message) {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) => ContentDialog(
        title: const Text('错误',style: TextStyle(fontFamily: "MiSans")),
        content: Text(message,style: TextStyle(fontFamily: "MiSans",fontSize: 16)),
        actions: [
          FilledButton(
            child: const Text('确定',style: TextStyle(fontFamily: "MiSans")),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 左上角主页文字
        Positioned(
          top: 20,  // 距离顶部间距
          left: 50, // 距离左侧间距
          child: Text(
            "主页",
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
              fontFamily: "MiSans",
            ),
          ),
        ),
        // 原有居中内容
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 300,
                child: TextBox(
                  controller: _keyController,
                  placeholder: '输入加密/解密密钥',
                  maxLines: 1,
                ),
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: _isProcessing ? null : _pickFile,
                style: ButtonStyle(
                  padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  ),
                ),
                child: _isProcessing
                    ? const ProgressRing(strokeWidth: 2.0)
                    : const Text(
                        "选择文件并处理",
                        style: TextStyle(
                          fontFamily: "MiSans",
                          fontSize: 16,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}