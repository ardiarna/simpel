import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:simpel/models/member_model.dart';
import 'package:simpel/utils/af_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

class ReportPsmPage extends StatefulWidget {
  final MemberModel team;

  const ReportPsmPage({required this.team, Key? key}) : super(key: key);

  @override
  _ReportPsmPageState createState() => _ReportPsmPageState();
}

class _ReportPsmPageState extends State<ReportPsmPage> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  int position = 1;
  String errDeskripsi = '';

  Future<bool> isUrlCanLaunch(String url) async {
    var a = await http.get(Uri.parse(url));
    errDeskripsi = a.body.toString();
    return (a.statusCode == 200);
  }

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    String _url =
        'http://salamdesa.bbplm-jakarta.kemendesa.go.id/reportsimpel?niktim=${widget.team.nikMD5}';
    print(_url);
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<bool>(
            future: isUrlCanLaunch(_url),
            builder: (context, snap) {
              if (snap.hasData) {
                if (snap.data!) {
                  return IndexedStack(
                    index: position,
                    children: [
                      Builder(builder: (BuildContext context) {
                        return WebView(
                          initialUrl: _url,
                          javascriptMode: JavascriptMode.unrestricted,
                          onWebViewCreated:
                              (WebViewController webViewController) {
                            _controller.complete(webViewController);
                          },
                          onPageStarted: (a) {
                            setState(() {
                              position = 1;
                            });
                          },
                          onPageFinished: (a) {
                            setState(() {
                              position = 0;
                            });
                          },
                          onWebResourceError: (err) {
                            setState(() {
                              position = 2;
                              errDeskripsi = err.description;
                            });
                          },
                          navigationDelegate: (navReq) {
                            var b = navReq.url.contains('mode=export');
                            if (b) {
                              launch(navReq.url);
                              return NavigationDecision.prevent;
                            }
                            return NavigationDecision.navigate;
                          },
                          gestureNavigationEnabled: true,
                        );
                      }),
                      AFwidget.circularProgress(),
                      Container(
                        color: Colors.white,
                        child: Center(
                          child: Text(errDeskripsi),
                        ),
                      ),
                    ],
                  );
                } else {
                  return AFwidget.html(errDeskripsi);
                }
              } else {
                return AFwidget.circularProgress();
              }
            }),
      ),
    );
  }
}
