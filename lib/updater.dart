import 'dart:convert';

import 'package:package_info/package_info.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:open_file/open_file.dart';
import 'package:http/http.dart' as http;

final serverURL = '45.77.214.205:4443';
final metaFile = '/release/output-metadata.json';
final apkFile = '/release/app-release.apk';

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
    bool good = false;

    var outdated = isVersionOutdated();
    outdated.then((value) => good = value);
    if (!good)  return;

    var gotApk = downloadAPK();
    gotApk.then((value) => good = value);
    if (!good) return;

    var installed = installAPK();
    installed.then((value) => print('Update successfully!'));
  }

  Future<bool>  isVersionOutdated() async {
    // local version
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String localVersion = packageInfo.version;
    // get remote version
    final res = await http.get(Uri.https(serverURL, metaFile));
    String latestVersion;
    if (res.statusCode == 200) {
      var json = jsonDecode(res.body);
      latestVersion = json['elements']['versionName'];
      print('Got version from server: $latestVersion');
    } else print("server response: ${res.statusCode}");
    return compareV(localVersion, latestVersion);
  }

  Future<bool> downloadAPK() async {
    // 获取存储卡的路径
    final directory = await getExternalStorageDirectory();
    String _localPath = directory.path;

    await FlutterDownloader.enqueue(
      // 远程的APK地址（注意：安卓9.0以上后要求用https）
      url: serverURL + apkFile,
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
    OpenFile.open("$localPath/farmApp.apk");
    return true;
  }
}
