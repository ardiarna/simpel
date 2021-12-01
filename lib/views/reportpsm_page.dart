import 'package:flutter/material.dart';
import 'package:simpel/blocs/pelatihan_bloc.dart';
import 'package:simpel/models/member_model.dart';
import 'package:simpel/utils/af_combobox.dart';
import 'package:simpel/utils/af_widget.dart';
import 'package:simpel/views/reportpsm_1_page.dart';
import 'package:simpel/views/reportpsm_2_page.dart';
import 'package:simpel/views/reportpsm_3_page.dart';

class ReportPsmPage extends StatefulWidget {
  final MemberModel team;

  const ReportPsmPage({required this.team, Key? key}) : super(key: key);

  @override
  _ReportPsmPageState createState() => _ReportPsmPageState();
}

class _ReportPsmPageState extends State<ReportPsmPage> {
  PelatihanBloc _pelatihanBloc = PelatihanBloc();

  @override
  void dispose() {
    _pelatihanBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        kontener(
          label: 'List Pelatihan',
          aksi: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ReportPsmSatu(team: widget.team),
              ),
            );
          },
        ),
        kontener(
          label: 'List Peserta Pelatihan',
          aksi: () async {
            List<Opsi> listOpsi = [];
            AFwidget.circularDialog(context);
            var items = await _pelatihanBloc.getPelatihanTeam(widget.team.nik);
            for (var item in items) {
              var opsi = Opsi(
                  id: item.kode,
                  label: '${item.singkatan} ${item.angkatan}-${item.tahun}');
              listOpsi.add(opsi);
            }
            Navigator.of(context).pop();
            var a = await AFcombobox.modalBottom(
                context: context, listOpsi: listOpsi, judul: 'List Pelatihan');
            if (a != null) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ReportPsmDua(
                    team: widget.team,
                    pelatihanKode: a.id,
                  ),
                ),
              );
            }
          },
        ),
        kontener(
          label: 'List RTL Peserta Pelatihan',
          aksi: () async {
            List<Opsi> listOpsi = [];
            AFwidget.circularDialog(context);
            var items = await _pelatihanBloc.getPelatihanTeam(widget.team.nik);
            for (var item in items) {
              var opsi = Opsi(
                id: item.kode,
                label: '${item.singkatan} ${item.angkatan}-${item.tahun}',
              );
              listOpsi.add(opsi);
            }
            Navigator.of(context).pop();
            var a = await AFcombobox.modalBottom(
                context: context, listOpsi: listOpsi, judul: 'List Pelatihan');
            if (a != null) {
              List<Opsi> listOpsiPerson = [];
              AFwidget.circularDialog(context);
              var persons = await _pelatihanBloc.getPeserta(a.id);
              for (var person in persons) {
                var opsi = Opsi(
                  id: person.nik,
                  label: '${person.nama} - ${person.bumdes}',
                );
                listOpsiPerson.add(opsi);
              }
              Navigator.of(context).pop();
              var b = await AFcombobox.modalBottom(
                  context: context,
                  listOpsi: listOpsiPerson,
                  judul: 'List Peserta Pelatihan');
              if (b != null) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ReportPsmTiga(
                      team: widget.team,
                      pelatihanKode: a.id,
                      memberNik: b.id,
                    ),
                  ),
                );
              }
            }
          },
        ),
      ],
    );
  }

  Widget kontener({
    IconData? ikon,
    required String label,
    required void Function()? aksi,
    bool withPanah = true,
  }) {
    return GestureDetector(
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
        child: Row(
          children: [
            ikon == null
                ? Container()
                : Icon(
                    ikon,
                    color: Colors.green,
                  ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.fromLTRB(15, 0, 5, 0),
                padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        label,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          // fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Visibility(
                      visible: withPanah,
                      child: const Icon(
                        Icons.arrow_forward_ios,
                        size: 15,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      onTap: aksi,
    );
  }
}
