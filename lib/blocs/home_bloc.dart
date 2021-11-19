import 'dart:async';

class HomeBloc {
  final _strMenuBawah = StreamController<int>.broadcast();
  Stream<int> get streamMenuBawah => _strMenuBawah.stream;

  void fetchMenuBawah(int menu) async {
    _strMenuBawah.sink.add(menu);
  }

  final _strPage = StreamController<String>.broadcast();
  Stream<String> get streamPage => _strPage.stream;

  void fetchPage(String page) async {
    _strPage.sink.add(page);
  }

  void dispose() {
    _strPage.close();
    _strMenuBawah.close();
  }
}
