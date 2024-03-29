import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:package_info/package_info.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:dio/dio.dart';

final serverURL = '45.77.214.205:4443';
final metaFile = '/release/output-metadata.json';
final apkFile = '/release/app-release.apk';
final storeApkFile = 'farmApp.apk';

bool compareV(String l, String r) {
  if (l.isEmpty || r.isEmpty) return false;
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
  factory Updater() => _instance;
  static final Updater _instance = Updater._internal();

  var _dio;
  Updater._internal() {
    _dio = Dio();
    _dio.options = BaseOptions(
      receiveDataWhenStatusError: true,
      connectTimeout: 5000, // ms
      receiveTimeout: 30000, // ms
    );
    (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (client) {
      client.badCertificateCallback = (_certificateCheck);
    };
  }

  static String _localVersion = UNK_VERSION;
  static const String UNK_VERSION = '0.0.0';
  static Future<String> getLocalVersionAsync() async {
    if (_localVersion == UNK_VERSION) {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      _localVersion = packageInfo.version;
      print('Got local version: $_localVersion');
    }
    return _localVersion;
  }
  static String getLocalVersionSync() {
    return _localVersion;
  }


  static bool _certificateCheck(X509Certificate cert, String host, int port) =>
      true; // TODO check pem or do something meaningful

  void run() async {
    bool good = false;

    var doUpdate = newVersionAvailable();
    doUpdate.then((value) => good = value);
    if (!good)  return;

    var gotApk = downloadAPK();
    gotApk.then((value) => good = value);
    if (!good) return;

    var installed = installAPK();
    installed.then((value) => print('Update successfully!'));
  }

  Future<bool> newVersionAvailable() async {
    String latestVersion;
    // get remote version
    try {
      final res = await _dio.get('https://$serverURL$metaFile');
      if (res.statusCode == 200) {
        var json = res.data;
        List elements = json['elements'];
        var element = elements.first;
        latestVersion = element['versionName'];
        print('Got version from server: $latestVersion');
      } else
        print("server response: ${res.statusCode}");
    } on DioError catch (e) {
      throw Exception(e.message);
    }
    // local version
    String localVersion = await getLocalVersionAsync();
    return compareV(localVersion, latestVersion);
  }

  Future<bool> downloadAPK() async {
    // 获取存储卡的路径
    final directory = await getExternalStorageDirectory();
    String _localPath = directory.path;
    try {
      Response response = await _dio.get(
        'https://' + serverURL + apkFile,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            print((received / total * 100).toStringAsFixed(0) + "%");
          }
        },
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status) {
              return status < 500;
            }),
      );
      var file = File("$_localPath/$storeApkFile");
      var raf = file.openSync(mode: FileMode.write);
      // response.data is List<int> type
      raf.writeFromSync(response.data);
      await raf.close();
    } on DioError catch (e) {
      throw Exception(e.message);
    }
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
