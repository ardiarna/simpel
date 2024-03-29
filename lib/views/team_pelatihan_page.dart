import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';
import 'package:simpel/blocs/pelatihan_bloc.dart';
import 'package:simpel/models/member_model.dart';
import 'package:simpel/models/pelatihan_model.dart';
import 'package:simpel/utils/af_sliver_subheader.dart';
import 'package:simpel/utils/af_widget.dart';
import 'package:simpel/views/rtl_real_page.dart';
import 'package:simpel/views/saran_dinas_page.dart';
import 'package:simpel/views/saran_psm_page.dart';

class TeamPelatihanPage extends StatefulWidget {
  final MemberModel team;
  final PelatihanModel pelatihan;

  const TeamPelatihanPage({
    required this.team,
    required this.pelatihan,
    Key? key,
  }) : super(key: key);

  @override
  _TeamPelatihanPageState createState() => _TeamPelatihanPageState();
}

class _TeamPelatihanPageState extends State<TeamPelatihanPage> {
  final PelatihanBloc _pelatihanBloc = PelatihanBloc();

  @override
  void dispose() {
    _pelatihanBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 30,
        title: Text(
            '${widget.pelatihan.singkatan} ${widget.pelatihan.angkatan}-${widget.pelatihan.tahun}'),
        // elevation: 0.5,
        // flexibleSpace: Container(
        //   padding: EdgeInsets.fromLTRB(50, 19, 10, 5),
        //   child: Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [
        //       Text(
        //         'Pelatihan : ',
        //         style: TextStyle(
        //           color: Colors.white,
        //           fontWeight: FontWeight.bold,
        //         ),
        //       ),
        //       Padding(
        //         padding: const EdgeInsets.only(left: 25),
        //         child: Text(
        //           '${widget.pelatihan.singkatan} ${widget.pelatihan.angkatan}-${widget.pelatihan.tahun}',
        //           style: TextStyle(
        //             color: Colors.white,
        //             fontSize: 19,
        //             fontWeight: FontWeight.bold,
        //           ),
        //           maxLines: 2,
        //           overflow: TextOverflow.ellipsis,
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
      ),
      body: FutureBuilder<List<PersonPesertaModel>>(
        future: _pelatihanBloc.getPeserta(widget.pelatihan.kode),
        builder: (context, snap) {
          if (snap.hasData) {
            if (snap.data!.length > 0) {
              return tabPeserta(snap.data!);
            } else {
              return Center(
                child: Text('Peserta tidak ditemukan'),
              );
            }
          } else {
            return AFwidget.circularProgress();
          }
        },
      ),
    );
  }

  Widget tabPeserta(List<PersonPesertaModel> el) {
    double lebarA = 100;
    List<PersonPesertaModel> _listPeserta = [];
    List<PersonPesertaModel> _listFilterPeserta = [];
    final TextEditingController _txtPeserta = TextEditingController();
    return CustomScrollView(
      slivers: [
        AFsliverSubHeader(
          minHeight: 55,
          maxHeight: 65,
          child: AFwidget.textField(
            context: context,
            label: 'Cari Peserta...',
            kontroler: _txtPeserta,
            padding: EdgeInsets.all(10),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(7)),
            onchanged: (value) {
              _listFilterPeserta = [];
              for (var a in _listPeserta) {
                bool cek = a.nama.toLowerCase().contains(value.toLowerCase());
                if (cek) {
                  _listFilterPeserta.add(a);
                }
              }
              _pelatihanBloc.fetchPeserta(_listFilterPeserta);
            },
          ),
        ),
        SliverPadding(padding: EdgeInsets.only(bottom: 10)),
        StreamBuilder<List<PersonPesertaModel>>(
          stream: _pelatihanBloc.streamPeserta,
          builder: (context, snapPeserta) {
            if (snapPeserta.hasData) {
              if (snapPeserta.data!.isNotEmpty) {
                return SliverList(
                  delegate: SliverChildBuilderDelegate((context, i) {
                    return Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                          padding: const EdgeInsets.fromLTRB(10, 20, 10, 15),
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
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: lebarA,
                                    child: const Text('Nama'),
                                  ),
                                  const Text(' : '),
                                  Expanded(
                                    child: Text(
                                      '${snapPeserta.data![i].nama}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const Padding(
                                  padding: EdgeInsets.only(bottom: 15)),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: lebarA,
                                    child: Text(widget.pelatihan.giatKode ==
                                                '001' ||
                                            widget.pelatihan.giatKode == '01'
                                        ? 'Nama Bumdes'
                                        : 'Jabatan Didesa'),
                                  ),
                                  const Text(' : '),
                                  Expanded(
                                    child: Text(
                                      widget.pelatihan.giatKode == '001' ||
                                              widget.pelatihan.giatKode == '01'
                                          ? snapPeserta.data![i].bumdes
                                          : snapPeserta.data![i].kedudukan,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const Padding(
                                  padding: EdgeInsets.only(bottom: 10)),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: lebarA,
                                    child: const Text('Alamat'),
                                  ),
                                  const Text(' : '),
                                  Expanded(
                                    child: Text(
                                      StringUtils.capitalize(
                                          '${snapPeserta.data![i].kecLabel}, ${snapPeserta.data![i].kelLabel}',
                                          allWords: true),
                                      maxLines: 4,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              // const Padding(
                              //     padding: EdgeInsets.only(bottom: 15)),
                              // Row(
                              //   crossAxisAlignment: CrossAxisAlignment.start,
                              //   children: [
                              //     SizedBox(
                              //       width: lebarA,
                              //       child: const Text('Saran Psm'),
                              //     ),
                              //     const Text(' : '),
                              //     Expanded(
                              //       child: FutureBuilder<SaranModel>(
                              //         future: _pelatihanBloc.getSaranIdPsm(
                              //             kode: widget.pelatihan.kode,
                              //             nik: snapPeserta.data![i].nik,
                              //             psmNik: widget.team.nik),
                              //         builder: (context, snapSaran) {
                              //           if (snapSaran.hasData) {
                              //             return Text(
                              //               snapSaran.data!.psmSaran,
                              //               style: const TextStyle(
                              //                 fontWeight: FontWeight.normal,
                              //               ),
                              //             );
                              //           } else {
                              //             return Text('');
                              //           }
                              //         },
                              //       ),
                              //     ),
                              //   ],
                              // ),
                              // const Padding(
                              //     padding: EdgeInsets.only(bottom: 15)),
                              // Row(
                              //   crossAxisAlignment: CrossAxisAlignment.start,
                              //   children: [
                              //     SizedBox(
                              //       width: lebarA,
                              //       child: const Text('Nama Psm'),
                              //     ),
                              //     const Text(' : '),
                              //     Expanded(
                              //       child: FutureBuilder<SaranModel>(
                              //         future: _pelatihanBloc.getSaranIdPsm(
                              //             kode: widget.pelatihan.kode,
                              //             nik: snapPeserta.data![i].nik,
                              //             psmNik: widget.team.nik),
                              //         builder: (context, snapSaran) {
                              //           if (snapSaran.hasData) {
                              //             return Text(
                              //               snapSaran.data!.psmNama,
                              //               style: const TextStyle(
                              //                 fontWeight: FontWeight.normal,
                              //               ),
                              //             );
                              //           } else {
                              //             return Text('');
                              //           }
                              //         },
                              //       ),
                              //     ),
                              //   ],
                              // ),
                              const Padding(
                                  padding: EdgeInsets.only(bottom: 20)),
                              // Row(
                              //   crossAxisAlignment: CrossAxisAlignment.start,
                              //   children: [
                              //     SizedBox(
                              //       width: lebarA,
                              //       child: const Text('Resume'),
                              //     ),
                              //     const Text(' : '),
                              //     Expanded(
                              //       child: FutureBuilder<ResumeModel>(
                              //         future: _pelatihanBloc.getResumeId(
                              //             kode: widget.pelatihan.kode,
                              //             nik: snapPeserta.data![i].nik,
                              //             psmNik: widget.team.nik),
                              //         builder: (context, snapResume) {
                              //           if (snapResume.hasData) {
                              //             return Text(
                              //               snapResume.data!.psmResume,
                              //               style: const TextStyle(
                              //                 fontWeight: FontWeight.normal,
                              //               ),
                              //             );
                              //           } else {
                              //             return Text('');
                              //           }
                              //         },
                              //       ),
                              //     ),
                              //   ],
                              // ),
                              // const Padding(
                              //     padding: EdgeInsets.only(bottom: 15)),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 5),
                                    child: ElevatedButton(
                                      child: Text('Foto'),
                                      style: TextButton.styleFrom(
                                        minimumSize: Size.zero,
                                        padding:
                                            EdgeInsets.fromLTRB(15, 10, 15, 10),
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      onPressed: () {
                                        AFwidget.modalBottom(
                                          context: context,
                                          konten: snapPeserta.data![i].foto !=
                                                  ''
                                              ? AFwidget.cachedNetworkImage(
                                                  _pelatihanBloc
                                                          .dirImageMember +
                                                      snapPeserta.data![i].foto,
                                                )
                                              : Icon(
                                                  Icons.person,
                                                  size: 50,
                                                  color: Colors.green,
                                                ),
                                        );
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 5),
                                    child: ElevatedButton(
                                      child: Text('Saran Dinas'),
                                      style: TextButton.styleFrom(
                                        minimumSize: Size.zero,
                                        padding: EdgeInsets.all(10),
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      onPressed: () {
                                        AFwidget.modalBottom(
                                          context: context,
                                          konten: SaranDinasPage(
                                            nikPeserta:
                                                snapPeserta.data![i].nik,
                                            pelatihan: widget.pelatihan,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 5),
                                    child: ElevatedButton(
                                      child: Text('RTL'),
                                      style: TextButton.styleFrom(
                                        minimumSize: Size.zero,
                                        padding:
                                            EdgeInsets.fromLTRB(15, 10, 15, 10),
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      onPressed: () {
                                        MemberModel member =
                                            MemberModel.dariMap(
                                                snapPeserta.data![i].keMap());
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => RTLrealPage(
                                              member: member,
                                              pelatihan: widget.pelatihan,
                                              team: widget.team,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  ElevatedButton(
                                    child: Text('Saran Psm'),
                                    style: TextButton.styleFrom(
                                      minimumSize: Size.zero,
                                      padding: EdgeInsets.all(10),
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    onPressed: () async {
                                      MemberModel member = MemberModel.dariMap(
                                          snapPeserta.data![i].keMap());
                                      await Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => SaranPage(
                                            team: widget.team,
                                            member: member,
                                            pelatihan: widget.pelatihan,
                                          ),
                                        ),
                                      );
                                      setState(() {});
                                    },
                                  ),
                                  // const Padding(
                                  //     padding: EdgeInsets.only(left: 5)),
                                  // ElevatedButton(
                                  //   child: Text('Resume'),
                                  //   onPressed: () async {
                                  //     MemberModel member =
                                  //         MemberModel.dariMap(
                                  //             snapPeserta.data![i].keMap());
                                  //     await Navigator.of(context).push(
                                  //       MaterialPageRoute(
                                  //         builder: (context) => ResumePage(
                                  //           team: widget.team,
                                  //           member: member,
                                  //           pelatihan: widget.pelatihan,
                                  //         ),
                                  //       ),
                                  //     );
                                  //     setState(() {});
                                  //   },
                                  // ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 50,
                          height: 20,
                          decoration: BoxDecoration(
                            color: Colors.green.shade700,
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            (i + 1).toString(),
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    );
                  }, childCount: snapPeserta.data!.length),
                );
              } else {
                return SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Text('Peserta tidak ditemukan.'),
                  ),
                );
              }
            } else {
              if (_listPeserta.length < 1) {
                _listPeserta = el;
                _pelatihanBloc.fetchPeserta(el);
              } else {
                _pelatihanBloc.fetchPeserta(_listPeserta);
              }
              return SliverToBoxAdapter(child: AFwidget.circularProgress());
            }
          },
        ),
      ],
    );
  }
}
