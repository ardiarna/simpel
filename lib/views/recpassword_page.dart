import 'package:flutter/material.dart';
import 'package:simpel/blocs/member_bloc.dart';
import 'package:simpel/utils/af_widget.dart';

class RecpasswordPage extends StatefulWidget {
  final String kategori;
  final String nik;
  final String pwdLama;

  const RecpasswordPage({
    required this.kategori,
    required this.nik,
    required this.pwdLama,
    Key? key,
  }) : super(key: key);

  @override
  _RecpasswordPageState createState() => _RecpasswordPageState();
}

class _RecpasswordPageState extends State<RecpasswordPage> {
  final MemberBloc _memberBloc = MemberBloc();
  final TextEditingController _txtPwdBaru = TextEditingController();
  final TextEditingController _txtPwdKonf = TextEditingController();
  late FocusNode _focPwdBaru;
  late FocusNode _focPwdKonf;
  final Map<String, String> _mapKategori = {
    'member': 'Peserta',
    'team': 'Tim',
    // 'dinas': 'Dinas',
  };

  @override
  void initState() {
    super.initState();
    _focPwdBaru = FocusNode();
    _focPwdKonf = FocusNode();
  }

  @override
  void dispose() {
    _memberBloc.dispose();
    _focPwdBaru.dispose();
    _focPwdKonf.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.fromLTRB(10, 5, 10, 70),
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  _mapKategori[widget.kategori] ?? '',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'NIK : ${widget.nik}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(padding: EdgeInsets.all(7)),
                StreamBuilder<bool>(
                  stream: _memberBloc.streamTampilPasswordBaru,
                  builder: (context, snapTampilBaru) {
                    if (snapTampilBaru.hasData) {
                      return AFwidget.textField(
                        context: context,
                        kontroler: _txtPwdBaru,
                        focusNode: _focPwdBaru,
                        label: 'Password Baru',
                        obscuretext: !snapTampilBaru.data!,
                        suffix: GestureDetector(
                          child: Icon(
                            snapTampilBaru.data!
                                ? Icons.visibility
                                : Icons.visibility_off,
                            size: 20,
                          ),
                          onTap: () {
                            _memberBloc
                                .fetchTampilPasswordBaru(!snapTampilBaru.data!);
                          },
                        ),
                      );
                    } else {
                      _memberBloc.fetchTampilPasswordBaru(false);
                      return Container();
                    }
                  },
                ),
                StreamBuilder<bool>(
                  stream: _memberBloc.streamTampilPasswordKonf,
                  builder: (context, snapTampilKonf) {
                    if (snapTampilKonf.hasData) {
                      return AFwidget.textField(
                        context: context,
                        kontroler: _txtPwdKonf,
                        focusNode: _focPwdKonf,
                        label: 'Konfirmasi Password Baru',
                        obscuretext: !snapTampilKonf.data!,
                        suffix: GestureDetector(
                          child: Icon(
                            snapTampilKonf.data!
                                ? Icons.visibility
                                : Icons.visibility_off,
                            size: 20,
                          ),
                          onTap: () {
                            _memberBloc
                                .fetchTampilPasswordKonf(!snapTampilKonf.data!);
                          },
                        ),
                      );
                    } else {
                      _memberBloc.fetchTampilPasswordKonf(false);
                      return Container();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: ElevatedButton(
        child: const Text('Simpan'),
        onPressed: () async {
          if (_txtPwdBaru.text.isEmpty) {
            AFwidget.snack(context, 'Password baru harus diisi.');
            _focPwdBaru.requestFocus();
            return;
          }

          if (_txtPwdKonf.text.isEmpty) {
            AFwidget.snack(context, 'Konfirmasi password baru harus diisi.');
            _focPwdKonf.requestFocus();
            return;
          }

          if (_txtPwdKonf.text != _txtPwdBaru.text) {
            AFwidget.snack(context, 'Konfirmasi password baru tidak cocok.');
            _focPwdKonf.requestFocus();
            return;
          }

          AFwidget.circularDialog(context);
          var a = await _memberBloc.recoveryPassword(
            kategori: widget.kategori,
            nik: widget.nik,
            pwdLama: widget.pwdLama,
            pwdBaru: _txtPwdBaru.text,
          );
          Navigator.of(context).pop();

          if (a['status'].toString() == '1') {
            await AFwidget.alertDialog(
                context,
                const Text(
                    'Password baru berhasil disimpan, silakan login dengan password baru.'));
            Navigator.of(context).pop();
          } else {
            AFwidget.alertDialog(context, Text(a['message'].toString()));
          }
        },
      ),
    );
  }
}
