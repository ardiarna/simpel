import 'package:flutter/material.dart';
import 'package:simpel/blocs/pelatihan_bloc.dart';
import 'package:simpel/models/pelatihan_model.dart';
import 'package:simpel/models/saran_model.dart';
import 'package:simpel/utils/af_widget.dart';

class SaranDinasPage extends StatefulWidget {
  final String nikPeserta;
  final PelatihanModel pelatihan;

  const SaranDinasPage({
    required this.nikPeserta,
    required this.pelatihan,
    Key? key,
  }) : super(key: key);

  @override
  _SaranDinasPageState createState() => _SaranDinasPageState();
}

class _SaranDinasPageState extends State<SaranDinasPage> {
  final PelatihanBloc _pelatihanBloc = PelatihanBloc();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<SaranModel>>(
      future: _pelatihanBloc.getSaransDinas(
        kode: widget.pelatihan.kode,
        nik: widget.nikPeserta,
      ),
      builder: (context, snap) {
        if (snap.hasData) {
          if (snap.data!.length > 0) {
            return ListView.builder(
              itemCount: snap.data!.length,
              itemBuilder: (context, i) {
                return Container(
                  margin: const EdgeInsets.fromLTRB(10, 5, 10, 7),
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        spreadRadius: 0.5,
                        blurRadius: 1,
                        offset: const Offset(1, 1),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        margin: EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          color: Colors.green.shade700,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          (i + 1).toString(),
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 5),
                        child: Text(
                          '- Nama Dinas :',
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 5),
                        child: Text(snap.data![i].psmNama),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 5),
                        child: Text(
                          '- Saran Dinas :',
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 5),
                        child: Text(snap.data![i].psmSaran),
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return Center(
              child: Text(
                'Belum ada saran dinas',
              ),
            );
          }
        } else {
          return AFwidget.circularProgress();
        }
      },
    );
  }
}
