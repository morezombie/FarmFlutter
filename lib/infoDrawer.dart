import 'package:dio/dio.dart';
import 'package:farmApp/updater.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

Drawer makeInfoDrawer(BuildContext context) {
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
            ),
            ListTile(
              title: Text('版本更新', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
              trailing: Icon(Icons.upgrade),
              onTap: () {
                print('updater begins...');
                var updater = Updater();
                updater.init();
                var outdated = updater.newVersionAvailable();
                outdated.then((value) {
                  if (!value) {
                    makeDialog(context, '已是最新版本！');
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
                }).catchError( (e) {
                  return makeDialog(context, '无法连接服务器，或服务不可用');
              });
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