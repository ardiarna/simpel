import 'package:flutter/material.dart';
import 'package:simpel/utils/af_widget.dart';
import 'package:simpel/utils/db_helper.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  Future<String> getAbout() async {
    var a = await DBHelper.getData(
      methodeRequest: MethodeRequest.post,
      rute: 'identity',
      mode: 'get',
      body: {'code': 'about'},
    );
    return a != null ? a['value'] : '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tentang Aplikasi'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(15, 10, 15, 25),
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                logo(),
                Padding(padding: EdgeInsets.all(10)),
                FutureBuilder<String>(
                  future: getAbout(),
                  builder: (context, snap) {
                    if (snap.hasData) {
                      return AFwidget.html(snap.data!);
                    } else {
                      return AFwidget.circularProgress();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget logo() {
    return Image(
      image: AssetImage('images/logo.png'),
      fit: BoxFit.fitWidth,
    );
  }
}
