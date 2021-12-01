import 'package:flutter/material.dart';
import 'package:simpel/blocs/member_bloc.dart';
import 'package:simpel/models/member_model.dart';
import 'package:simpel/utils/af_widget.dart';

class BiopasswordPage extends StatefulWidget {
  final MemberModel member;
  const BiopasswordPage({required this.member, Key? key}) : super(key: key);

  @override
  _BiopasswordPageState createState() => _BiopasswordPageState();
}

class _BiopasswordPageState extends State<BiopasswordPage> {
  final MemberBloc _memberBloc = MemberBloc();
  final TextEditingController _txtPwdLama = TextEditingController();
  final TextEditingController _txtPwdBaru = TextEditingController();
  final TextEditingController _txtPwdKonf = TextEditingController();
  late FocusNode _focPwdLama;
  late FocusNode _focPwdBaru;
  late FocusNode _focPwdKonf;

  @override
  void initState() {
    super.initState();
    _focPwdLama = FocusNode();
    _focPwdBaru = FocusNode();
    _focPwdKonf = FocusNode();
  }

  @override
  void dispose() {
    _memberBloc.dispose();
    _focPwdLama.dispose();
    _focPwdBaru.dispose();
    _focPwdKonf.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ubah Password'),
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
                StreamBuilder<bool>(
                  stream: _memberBloc.streamTampilPassword,
                  builder: (context, snapTampilLama) {
                    if (snapTampilLama.hasData) {
                      return AFwidget.textField(
                        context: context,
                        kontroler: _txtPwdLama,
                        focusNode: _focPwdLama,
                        label: 'Password Lama',
                        obscuretext: !snapTampilLama.data!,
                        suffix: GestureDetector(
                          child: Icon(
                            snapTampilLama.data!
                                ? Icons.visibility
                                : Icons.visibility_off,
                            size: 20,
                          ),
                          onTap: () {
                            _memberBloc
                                .fetchTampilPassword(!snapTampilLama.data!);
                          },
                        ),
                      );
                    } else {
                      _memberBloc.fetchTampilPassword(false);
                      return Container();
                    }
                  },
                ),
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
          if (_txtPwdLama.text.isEmpty) {
            AFwidget.snack(context, 'Password lama harus diisi.');
            _focPwdLama.requestFocus();
            return;
          }

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
          var a = await _memberBloc.editPassword(
            member: widget.member,
            pwdLama: _txtPwdLama.text,
            pwdBaru: _txtPwdBaru.text,
          );
          Navigator.of(context).pop();

          if (a['status'].toString() == '1') {
            await AFwidget.alertDialog(
                context, const Text('Password baru berhasil disimpan.'));
            Navigator.of(context).pop();
          } else {
            AFwidget.alertDialog(context, Text(a['message'].toString()));
          }
        },
      ),
    );
  }
}
