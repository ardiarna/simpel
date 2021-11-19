import 'dart:async';

import 'package:flutter/material.dart';
import 'package:simpel/utils/af_cache.dart';
import 'package:simpel/utils/af_constant.dart';
import 'package:simpel/utils/af_widget.dart';
import 'package:simpel/views/home_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final AFcache _aFcache = AFcache();

  @override
  void initState() {
    super.initState();
    try {
      _aFcache.cekUserId().then((value) {
        if (value != null) {
          _aFcache.getUser().then((member) async {
            return Timer(
              const Duration(milliseconds: 500),
              () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) =>
                      HomePage(menu: 0, page: 'beranda', member: member),
                ),
              ),
            );
          });
        } else {
          return Timer(
            const Duration(milliseconds: 1500),
            () => Navigator.of(context).pushReplacementNamed(loginRoute),
          );
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Image(
                  image: AssetImage('images/logo.png'),
                ),
                Padding(padding: EdgeInsets.all(3)),
                Text(
                  'Simpel',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Spacer(),
            AFwidget.circularProgress(warna: Colors.white),
            const Padding(padding: EdgeInsets.all(8)),
            const Text(
              'Copyright © Simpel 2021 . All Rights Reserved',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
