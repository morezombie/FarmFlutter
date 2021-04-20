import 'package:package_info/package_info.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:open_file/open_file.dart';
import 'package:http/http.dart' as http;

final serverURL = 'http://45.77.214.205:8000/';

bool compareV(String l, String r) {
  final llist = l.split('.');
  final rlist = r.split('.');
  for (int i = 0; i < llist.length && i < rlist.length; ++i) {
    if (int.parse(llist[i]) < int.parse(rlist[i])) {
      return true;
    }
  }
  return false;
}

class Updater {

  void run() async {
    if (!await checkVersion()) {
      return;
    }
    if (!await downloadAPK()) {
      return;
    }
    if (!await installAPK()) {
      return;
    }
  }

  Future<bool>  checkVersion() async {
    // local version
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String localVersion = packageInfo.version;
    // get remote version
    final res = await http.get(serverURL + '/version.json');
    String latestVersion;
    if (res.statusCode == 200) {
      latestVersion = res.body;
    }
    return compareV(localVersion, latestVersion);
  }

  Future<bool> downloadAPK() async {
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
    return true;
  }

  Future<bool> installAPK() async {
    // 获取存储卡的路径
    final directory = await getExternalStorageDirectory();
    String localPath = directory.path;

    // 打开文件,apk的名称需要与下载时对应
    OpenFile.open("$localPath/shop.apk");
    return true;
  }
}
