import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:simpel/blocs/home_bloc.dart';
import 'package:simpel/chat/composition_root.dart';
import 'package:simpel/models/member_model.dart';
import 'package:simpel/utils/af_widget.dart';
import 'package:simpel/views/akun_page.dart';
import 'package:simpel/views/beranda_page.dart';
import 'package:simpel/views/rekrutmen_page.dart';

import '../main.dart';

class HomePage extends StatefulWidget {
  final int menu;
  final String page;
  final MemberModel member;
  const HomePage({
    required this.menu,
    required this.page,
    required this.member,
    Key? key,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeBloc _homeBloc = HomeBloc();
  int _currentMenu = 100;
  String _currentPage = '';

  void fetchMenu(int menu) {
    if (menu != _currentMenu) {
      _currentMenu = menu;
      _homeBloc.fetchMenuBawah(menu);
    }
  }

  void fetchPage(String page) {
    if (page != _currentPage) {
      _currentPage = page;
      _homeBloc.fetchPage(page);
    }
  }

  @override
  void initState() {
    super.initState();
    try {
      messaging.subscribeToTopic(widget.member.nik);
      FirebaseMessaging.onMessage.listen((msg) {
        RemoteNotification? notification = msg.notification;
        AndroidNotification? android = msg.notification?.android;
        if (android != null && notification != null) {
          bool tampilkan = true;
          if (tampilkan) {
            flutterLocalNotificationsPlugin.show(
              notification.hashCode,
              notification.title,
              notification.body,
              NotificationDetails(
                android: AndroidNotificationDetails(
                  channel.id,
                  channel.name,
                  playSound: true,
                  icon: '@mipmap/ic_launcher',
                ),
              ),
            );
          }
        }
      });
    } catch (e) {
      AFwidget.alertDialog(
        context,
        Text(e.toString()),
      );
    }
  }

  @override
  void dispose() {
    _homeBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      bottomNavigationBar: StreamBuilder<int>(
        stream: _homeBloc.streamMenuBawah,
        builder: (context, snapMenu) {
          if (snapMenu.hasData) {
            return menuBawah(snapMenu.data!);
          } else {
            if (_currentMenu == 100) fetchMenu(widget.menu);
            return AFwidget.circularProgress();
          }
        },
      ),
      extendBody: true,
      body: SafeArea(
        child: StreamBuilder<String>(
          stream: _homeBloc.streamPage,
          builder: (context, snap) {
            if (snap.hasData) {
              switch (snap.data) {
                case 'beranda':
                  return BerandaPage(member: widget.member);
                case 'saya':
                  return AkunPage(member: widget.member);
                case 'rekrutmen':
                  return RekrutmenPage(member: widget.member);
                case 'diskusi':
                  return CompositionRoot.composeDiskusi(widget.member);
                default:
                  return AFwidget.belum(ket: snap.data!);
              }
            } else {
              if (_currentPage == '') fetchPage(widget.page);
              return AFwidget.circularProgress();
            }
          },
        ),
      ),
    );
  }

  BottomAppBar menuBawah(int index) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      color: Colors.white,
      elevation: 0,
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.black, width: 0.3),
          ),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Theme.of(context).primaryColor.withAlpha(0),
          elevation: 0,
          currentIndex: index,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.streetview),
              label: 'Rekrutmen',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.question_answer),
              label: 'Diskusi',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Saya',
            ),
          ],
          onTap: (idx) async {
            switch (idx) {
              case 0:
                fetchMenu(idx);
                fetchPage('beranda');
                break;
              case 1:
                fetchMenu(idx);
                fetchPage('rekrutmen');
                break;
              case 2:
                fetchMenu(idx);
                fetchPage('diskusi');
                break;
              case 3:
                fetchMenu(idx);
                fetchPage('saya');
                break;
            }
          },
        ),
      ),
    );
  }
}
