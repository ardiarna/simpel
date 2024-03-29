import 'package:flutter/material.dart';
import 'package:simpel/blocs/rekrutmen_bloc.dart';
import 'package:simpel/models/member_model.dart';
import 'package:simpel/models/rekrutmen_model.dart';
import 'package:simpel/utils/af_widget.dart';

class ResumeRekrutmen extends StatefulWidget {
  final RekrutmenModel rekrutmen;
  final String pelatihanKode;
  final MemberModel team;

  const ResumeRekrutmen({
    required this.rekrutmen,
    required this.pelatihanKode,
    required this.team,
    Key? key,
  }) : super(key: key);

  @override
  _ResumeRekrutmenState createState() => _ResumeRekrutmenState();
}

class _ResumeRekrutmenState extends State<ResumeRekrutmen> {
  final RekrutmenBloc _rekrutmenBloc = RekrutmenBloc();
  final TextEditingController _txtResume = TextEditingController();
  final TextEditingController _txtResumeNama = TextEditingController();
  late FocusNode _focResume;
  final double lebarA = 100;

  @override
  void initState() {
    super.initState();
    _txtResume.text = widget.rekrutmen.resume;
    _txtResumeNama.text = widget.team.nama;
    _focResume = FocusNode();
  }

  @override
  void dispose() {
    _focResume.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        title: Text(
          'Resume ${widget.rekrutmen.singkatangiat} ${widget.rekrutmen.angkatan}-${widget.rekrutmen.tahun}',
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(padding: EdgeInsets.only(top: 1)),
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
              child: Column(
                children: [
                  AFwidget.textField(
                    context: context,
                    kontroler: _txtResumeNama,
                    label: 'Oleh',
                    padding: EdgeInsets.all(10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                    readonly: true,
                  ),
                  Padding(padding: EdgeInsets.all(10)),
                  AFwidget.textField(
                    context: context,
                    kontroler: _txtResume,
                    focusNode: _focResume,
                    label: 'Resume',
                    maxLines: 2,
                    padding: EdgeInsets.all(10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 35, 15, 10),
                    child: ElevatedButton(
                      child: Text('Simpan Resume'),
                      onPressed: () async {
                        if (_txtResume.text.isEmpty) {
                          AFwidget.snack(context, 'Resume harus diisi.');
                          _focResume.requestFocus();
                          return;
                        }

                        AFwidget.circularDialog(context);
                        var a = await _rekrutmenBloc.editResume(
                          kode: widget.pelatihanKode,
                          resume: _txtResume.text,
                          resumeNik: widget.team.nik,
                        );
                        Navigator.of(context).pop();
                        if (a['status'].toString() == '1') {
                          await AFwidget.alertDialog(
                              context, const Text('Resume berhasil disimpan.'));
                          Navigator.of(context).pop();
                        } else {
                          AFwidget.alertDialog(
                              context, Text(a['message'].toString()));
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
