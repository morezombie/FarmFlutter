import 'package:farmApp/updater.dart';
import 'package:flutter/material.dart';

Drawer makeInfoDrawer(BuildContext context, void callback()) {
  // try detect newer version and react updating
  if (Updater.getLocalVersionSync() == Updater.UNK_VERSION) {
    Updater.getLocalVersionAsync().then((value) {
      reactUpdate(context);
      callback();
    });
  }
  return Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
                image: DecorationImage(
                  image: AssetImage("lib/assets/bb.jpg"),
                    fit: BoxFit.cover),
              ),
              child: Text('动物农场', style: TextStyle(color: Colors.white, fontSize: 20),),
            ),
            ListTile(
              title: Text('版本更新', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
              subtitle: Text('当前版本：${Updater.getLocalVersionSync()}'),
              trailing: Icon(Icons.upgrade),
              onTap: () {
                print('updater begins...');
                autoUpdate(context);
              },
            ),
            ListTile(
              title: Text('用法', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
              trailing: Icon(Icons.integration_instructions_outlined),
              subtitle: Text(
                  '\n\t1. 点击主页面右上角的齿轮配置动物价格、动物生长周期，保存返回主页面\n\n'
                  '\t2. 在主页面填运营时间、动物初始状态，点击右下角按钮开始计算\n\n'
                  '\t3. 在弹出的页面展示动物数量变化、收入变化，可以双值放大缩小和移动图面\n\n'),
            ),
            ListTile(
              title: Text('联系我们', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
              subtitle: Text('panghuachong@gmail.com'),
              trailing: Icon(Icons.mail_outline_sharp),
            ),
          ],
        ),
      );
}

Future<dynamic> makeDialog(BuildContext context, String text) {
  return showDialog(
  context: context,
  builder: (context) {
    return AlertDialog(
      content: Text(text),
    );
  });
}

void autoUpdate(BuildContext context) {
  var updater = Updater();
  var outdated = updater.newVersionAvailable();
  outdated.then((value) {
    if (!value) {
      return makeDialog(context, '已是最新版本！');
    }
    makeDialog(context, '开始下载新版本...');
    updater.downloadAPK().then((value) {
      Navigator.pop(context);
      if (!value) {
        return makeDialog(context, '下载失败！');
      }
      updater.installAPK();
    }).catchError((e) {
      Navigator.pop(context);
      return makeDialog(context, '下载超时！');
    });
  }).catchError((e) {
    return makeDialog(context, '无法连接服务器，或服务不可用');
  });
}


void reactUpdate(BuildContext context) {
  var updater = Updater();
  var outdated = updater.newVersionAvailable();
  outdated.then((value) {
    if (!value) {
      return;
    }

    showDialog(context: context,
    builder: (context) {
      return AlertDialog(content: Text('是否安装新版本？'), actions: <Widget>[
            TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text('是')),
            TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('否')),
          ]);
        }).then((value) {
      if (value == null || !value) return;
      makeDialog(context, '开始下载新版本...');
      updater.downloadAPK().then((value) {
        Navigator.pop(context);
        if (!value) {
          return makeDialog(context, '下载失败！');
        }
        updater.installAPK();
      }).catchError((e) {
        Navigator.pop(context);
        return makeDialog(context, '下载超时！');
      });
    });
  }).catchError((e) {
    return;
  });
}