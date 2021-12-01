import 'package:flutter/material.dart';
import 'package:simpel/blocs/pelatihan_bloc.dart';
import 'package:simpel/models/member_model.dart';
import 'package:simpel/models/pelatihan_model.dart';
import 'package:simpel/models/resume_model.dart';
import 'package:simpel/utils/af_convert.dart';
import 'package:simpel/utils/af_widget.dart';

class ResumePage extends StatefulWidget {
  final MemberModel team;
  final MemberModel member;
  final PelatihanModel pelatihan;

  const ResumePage({
    required this.team,
    required this.member,
    required this.pelatihan,
    Key? key,
  }) : super(key: key);

  @override
  _ResumePageState createState() => _ResumePageState();
}

class _ResumePageState extends State<ResumePage> {
  final PelatihanBloc _pelatihanBloc = PelatihanBloc();
  final TextEditingController _txtResume = TextEditingController();
  late FocusNode _focResume;
  final double lebarA = 100;

  @override
  void initState() {
    super.initState();
    _focResume = FocusNode();
  }

  @override
  void dispose() {
    _pelatihanBloc.dispose();
    _focResume.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        flexibleSpace: Container(
          padding: EdgeInsets.fromLTRB(50, 19, 10, 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Resume ${widget.pelatihan.singkatan} ${widget.pelatihan.angkatan}-${widget.pelatihan.tahun}',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: Text(
                  '${widget.member.nama}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(padding: EdgeInsets.only(top: 1)),
          FutureBuilder<List<ResumeModel>>(
            future: _pelatihanBloc.getResumes(
                kode: widget.pelatihan.kode, nik: widget.member.nik),
            builder: (context, snap) {
              if (snap.hasData) {
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, i) {
                      return Container(
                        padding: EdgeInsets.fromLTRB(15, 15, 10, 15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                            bottom: BorderSide(color: Colors.grey, width: 1),
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: lebarA,
                                  child: const Text('Nama PSM'),
                                ),
                                const Text(' : '),
                                Expanded(
                                  child: Text(
                                    '${snap.data![i].psmNama}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Padding(padding: EdgeInsets.only(top: 10)),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: lebarA,
                                  child: const Text('Resume'),
                                ),
                                const Text(' : '),
                                Expanded(
                                  child: Text(
                                    '${snap.data![i].psmResume}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Padding(padding: EdgeInsets.only(top: 5)),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: lebarA,
                                  child: const Text(''),
                                ),
                                const Text('    '),
                                Expanded(
                                  child: Text(
                                    AFconvert.matDate(snap.data![i].psmTanggal),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                    childCount: snap.data!.length,
                  ),
                );
              } else {
                return SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(25),
                    child: AFwidget.circularProgress(),
                  ),
                );
              }
            },
          ),
          SliverPadding(padding: EdgeInsets.all(5)),
          FutureBuilder<ResumeModel>(
            future: _pelatihanBloc.getResumeId(
                kode: widget.pelatihan.kode,
                nik: widget.member.nik,
                psmNik: widget.team.nik),
            builder: (context, snapResume) {
              if (snapResume.hasData)
                _txtResume.text = snapResume.data!.psmResume;
              return SliverToBoxAdapter(
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                  child: Column(
                    children: [
                      AFwidget.textField(
                        context: context,
                        kontroler: _txtResume,
                        focusNode: _focResume,
                        label: 'Resume',
                        maxLines: 2,
                        padding: EdgeInsets.all(10),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(7)),
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

                            var hasil = ResumeModel(
                              kdroot:
                                  '${widget.pelatihan.giatKode}${widget.pelatihan.tahun}${widget.pelatihan.angkatan}',
                              nik: widget.member.nik,
                              psmNik: widget.team.nik,
                              psmResume: _txtResume.text,
                              psmTanggal: DateTime.now(),
                            );

                            AFwidget.circularDialog(context);
                            var a = await _pelatihanBloc.addResume(hasil);
                            Navigator.of(context).pop();
                            if (a['status'].toString() == '1') {
                              await AFwidget.alertDialog(context,
                                  const Text('Resume berhasil disimpan.'));
                              Navigator.of(context).pop(hasil);
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
              );
            },
          ),
        ],
      ),
    );
  }
}
