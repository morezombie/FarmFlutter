import 'package:package_info/package_info.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:open_file/open_file.dart';

class Updater {
  Future<String>  getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String appName = packageInfo.appName;
    String packageName = packageInfo.packageName;
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;
    // 应用名称
    print("appName:$appName");
    // 包名称
    print("packageName:$packageName");
    // 版本号
    print("version: $version");
    // 构建编号
    print("buildNumber:$buildNumber");
    return version;
  }

  void getStoragePath() async {
    var tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;

    var appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;

    var directory = await getExternalStorageDirectory();

    String storageDirectory = directory.path;
    // 获取临时目录
    print("tempPath:$tempPath");
    // 获取应用的安装目录
    print("appDocDir:$appDocPath");
    // 获取存储卡的路径
    print("StorageDirectory:$storageDirectory");
  }

  void downloadAPK() async {
    // 获取存储卡的路径
    final directory = await getExternalStorageDirectory();
    String _localPath = directory.path;

    await FlutterDownloader.enqueue(
      // 远程的APK地址（注意：安卓9.0以上后要求用https）
      url: "http://www.ionic.wang/shop.apk",
      // 下载保存的路径
      savedDir: _localPath,
      // 是否在手机顶部显示下载进度（仅限安卓）
      showNotification: true,
      // 是否允许下载完成点击打开文件（仅限安卓）
      openFileFromNotification: true,
    );
    FlutterDownloader.registerCallback((id, status, progress) {
      print(status);
      print(progress);
    });
  }

  void installAPK() async {
    // 获取存储卡的路径
    final directory = await getExternalStorageDirectory();
    String localPath = directory.path;

    // 打开文件,apk的名称需要与下载时对应
    OpenFile.open("$localPath/shop.apk");
  }
}
