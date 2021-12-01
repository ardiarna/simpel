import 'package:flutter/material.dart';
import 'package:simpel/blocs/pelatihan_bloc.dart';
import 'package:simpel/models/member_model.dart';
import 'package:simpel/models/saran_model.dart';
import 'package:simpel/utils/af_convert.dart';
import 'package:simpel/utils/af_tabel.dart';
import 'package:simpel/utils/af_widget.dart';

class ReportPsmTiga extends StatefulWidget {
  final MemberModel team;
  final String pelatihanKode;
  final String memberNik;

  const ReportPsmTiga({
    required this.team,
    required this.pelatihanKode,
    required this.memberNik,
    Key? key,
  }) : super(key: key);

  @override
  _ReportPsmTigaState createState() => _ReportPsmTigaState();
}

class _ReportPsmTigaState extends State<ReportPsmTiga> {
  PelatihanBloc _pelatihanBloc = PelatihanBloc();

  List<String> kolom = [
    'Tanggal Target',
    'Keterangan Target',
    'Tanggal Realisasi',
    'Capaian',
    'Kendala',
    'Saran Psm'
  ];
  List<double> lebar = [120, 200, 120, 90, 200, 200];
  double tinggi = 100;

  Future<List<List<String>>> getData() async {
    List<List<String>> list = [];
    var items =
        await _pelatihanBloc.getRTL(widget.memberNik, widget.pelatihanKode);
    for (var item in items) {
      List<String> a = [];
      a.add(
          '${AFconvert.matDate(item.targetTglAwal)} s/d ${AFconvert.matDate(item.targetTglAkhir)}');
      a.add(item.targetRencana);
      a.add(AFconvert.matDate(item.tanggal));
      a.add('${item.capaian} %');
      a.add(item.kendala);
      a.add(item.psmSaran);
      list.add(a);
    }
    return list;
  }

  @override
  void dispose() {
    _pelatihanBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double tinggiTabel = MediaQuery.of(context).size.height - 120;
    return Scaffold(
      appBar: AppBar(
        title: Text('List RTL Peserta Pelatihan'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FutureBuilder<SaranModel>(
              future: _pelatihanBloc.getSaranId(
                kode: widget.pelatihanKode,
                nik: widget.memberNik,
                psmNik: widget.team.nik,
              ),
              builder: (context, snapSaran) {
                String saran = '';
                if (snapSaran.hasData) saran = snapSaran.data!.psmSaran;
                return Container(
                  padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                  height: 40,
                  child: Text('Saran PSM : $saran'),
                );
              }),
          FutureBuilder<List<List<String>>>(
              future: getData(),
              builder: (context, snap) {
                if (snap.hasData) {
                  if (snap.data!.length > 0) {
                    return AFtabelFixedScroll(
                      kolom: kolom,
                      lebar: lebar,
                      tinggi: tinggi,
                      data: snap.data!,
                      tinggiTabel: tinggiTabel,
                    );
                  } else {
                    return Center(child: Text('Data belum tersedia'));
                  }
                } else {
                  return AFwidget.circularProgress();
                }
              }),
        ],
      ),
    );
  }
}
