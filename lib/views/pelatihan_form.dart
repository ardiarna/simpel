import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simpel/blocs/pelatihan_bloc.dart';
import 'package:simpel/models/evaluasi_model.dart';
import 'package:simpel/models/kuis_model.dart';
import 'package:simpel/models/materi_model.dart';
import 'package:simpel/models/member_model.dart';
import 'package:simpel/models/pelatihan_model.dart';
import 'package:simpel/models/rekrutmen_model.dart';
import 'package:simpel/models/survey_model.dart';
import 'package:simpel/models/tugas_model.dart';
import 'package:simpel/utils/af_convert.dart';
import 'package:simpel/utils/af_sliver_subheader.dart';
import 'package:simpel/utils/af_widget.dart';
import 'package:simpel/views/rtl_page.dart';
import 'package:url_launcher/url_launcher.dart';

class PelatihanForm extends StatefulWidget {
  final MemberModel member;
  final PelatihanModel pelatihan;

  const PelatihanForm({
    required this.member,
    required this.pelatihan,
    Key? key,
  }) : super(key: key);

  @override
  _PelatihanFormState createState() => _PelatihanFormState();
}

class _PelatihanFormState extends State<PelatihanForm> {
  final PelatihanBloc _pelatihanBloc = PelatihanBloc();
  int _currentMenu = 100;
  String _currentPage = '';

  void fetchMenu(int menu) {
    if (menu != _currentMenu) {
      _currentMenu = menu;
      _pelatihanBloc.fetchMenu(menu);
    }
  }

  void fetchPage(String page) {
    if (page != _currentPage) {
      _currentPage = page;
      _pelatihanBloc.fetchPage(page);
    }
  }

  @override
  void dispose() {
    _pelatihanBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leadingWidth: 30,
        title: Text(
            '${widget.pelatihan.singkatan} ${widget.pelatihan.angkatan}-${widget.pelatihan.tahun}'),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 55),
            child: StreamBuilder<String>(
              stream: _pelatihanBloc.streamPage,
              builder: (context, snapPage) {
                if (snapPage.hasData) {
                  switch (snapPage.data) {
                    case 'materi':
                      return FutureBuilder<List<MateriModel>>(
                        future: _pelatihanBloc.getMateri(widget.pelatihan.kode),
                        builder: (context, snap) {
                          if (snap.hasData) {
                            if (snap.data!.length > 0) {
                              return tabMateri(snap.data!);
                            } else {
                              return Center(child: Text('- Belum ada Materi'));
                            }
                          } else {
                            return Center(child: AFwidget.circularProgress());
                          }
                        },
                      );
                    case 'tugas':
                      return FutureBuilder<List<TugasModel>>(
                        future: _pelatihanBloc.getTugas(widget.pelatihan.kode),
                        builder: (context, snap) {
                          if (snap.hasData) {
                            if (snap.data!.length > 0) {
                              return tabTugas(snap.data!);
                            } else {
                              return Center(child: Text('- Belum ada Tugas'));
                            }
                          } else {
                            return Center(child: AFwidget.circularProgress());
                          }
                        },
                      );
                    case 'kuis':
                      return FutureBuilder<List<KuisModel>>(
                        future: _pelatihanBloc.getKuis(widget.pelatihan.kode),
                        builder: (context, snap) {
                          if (snap.hasData) {
                            if (snap.data!.length > 0) {
                              return tabKuis(snap.data!);
                            } else {
                              return Center(child: Text('- Belum ada Quiz'));
                            }
                          } else {
                            return Center(child: AFwidget.circularProgress());
                          }
                        },
                      );
                    case 'survey':
                      return FutureBuilder<List<SurveyModel>>(
                        future: _pelatihanBloc.getSurvey(
                            widget.member.nik, widget.pelatihan.kode),
                        builder: (context, snap) {
                          if (snap.hasData) {
                            if (snap.data!.length > 0) {
                              return tabSurvey(snap.data!);
                            } else {
                              return Center(child: Text('- Belum ada Survey'));
                            }
                          } else {
                            return Center(child: AFwidget.circularProgress());
                          }
                        },
                      );
                    case 'evaluasi':
                      return FutureBuilder<List<EvaluasiModel>>(
                        future: _pelatihanBloc.getEvaluasi(
                            widget.member.nik, widget.pelatihan.kode),
                        builder: (context, snap) {
                          if (snap.hasData) {
                            if (snap.data!.length > 0) {
                              return tabEvaluasi(snap.data!);
                            } else {
                              return Center(
                                  child: Text('- Belum ada Evaluasi'));
                            }
                          } else {
                            return Center(child: AFwidget.circularProgress());
                          }
                        },
                      );
                    case 'informasi':
                      return FutureBuilder<RekrutmenModel>(
                        future:
                            _pelatihanBloc.getRekrutmen(widget.pelatihan.kode),
                        builder: (context, snap) {
                          if (snap.hasData) {
                            return tabInformasi(snap.data!);
                          } else {
                            return Center(child: Text(''));
                          }
                        },
                      );
                    case 'psm':
                      return FutureBuilder<List<PersonPSMModel>>(
                        future: _pelatihanBloc.getPSM(widget.pelatihan.kode),
                        builder: (context, snapPSM) {
                          if (snapPSM.hasData) {
                            if (snapPSM.data!.length > 0) {
                              return tabPSM(snapPSM.data!);
                            } else {
                              return Center(
                                  child: Text('- PSM tidak ditemukan'));
                            }
                          } else {
                            return Center(child: AFwidget.circularProgress());
                          }
                        },
                      );
                    case 'peserta':
                      return FutureBuilder<List<PersonPesertaModel>>(
                        future:
                            _pelatihanBloc.getPeserta(widget.pelatihan.kode),
                        builder: (context, snap) {
                          if (snap.hasData) {
                            if (snap.data!.length > 0) {
                              return tabPeserta(snap.data!);
                            } else {
                              return Center(
                                  child: Text('- Peserta tidak ditemukan'));
                            }
                          } else {
                            return Center(child: AFwidget.circularProgress());
                          }
                        },
                      );
                    case 'rtl':
                      return RTLTab(
                        member: widget.member,
                        pelatihan: widget.pelatihan,
                      );
                    default:
                      return Center(
                        child: Text("${snapPage.data} tidak ditemukan"),
                      );
                  }
                } else {
                  if (_currentPage == '') fetchPage('rtl');
                  return AFwidget.circularProgress();
                }
              },
            ),
          ),
          StreamBuilder<int>(
              stream: _pelatihanBloc.streamMenu,
              builder: (context, snapMenu) {
                if (snapMenu.hasData) {
                  return BottomAppBar(
                    elevation: 1,
                    child: BottomNavigationBar(
                      backgroundColor: Colors.green,
                      unselectedItemColor: Colors.white,
                      selectedItemColor: Colors.black87,
                      currentIndex: snapMenu.data!,
                      elevation: 1,
                      type: BottomNavigationBarType.fixed,
                      items: [
                        BottomNavigationBarItem(
                          icon: Icon(Icons.receipt_long),
                          label: 'RTL',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.description),
                          label: 'Materi',
                        ),
                        // BottomNavigationBarItem(
                        //   icon: Icon(Icons.work),
                        //   label: 'Tugas',
                        // ),
                        // BottomNavigationBarItem(
                        //   icon: Icon(Icons.quiz_outlined),
                        //   label: 'Quiz',
                        // ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.record_voice_over),
                          label: 'PSM',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.supervisor_account),
                          label: 'Peserta',
                        ),
                        // BottomNavigationBarItem(
                        //   icon: Icon(Icons.menu),
                        //   label: 'Lainnya',
                        // ),
                      ],
                      onTap: (idx) {
                        switch (idx) {
                          case 0:
                            fetchMenu(idx);
                            fetchPage('rtl');
                            break;
                          case 1:
                            fetchMenu(idx);
                            fetchPage('materi');
                            break;
                          case 2:
                            fetchMenu(idx);
                            fetchPage('psm');
                            break;
                          case 3:
                            fetchMenu(idx);
                            fetchPage('peserta');
                            break;
                          // case 4:
                          //   AFwidget.modalBottom(
                          //     context: context,
                          //     isScrollControlled: false,
                          //     judul: 'Menu Pelatihan Lainnya',
                          //     konten: Padding(
                          //       padding: const EdgeInsets.fromLTRB(0, 15, 0, 5),
                          //       child: Wrap(
                          //         children: [
                          //           ikonSatu(
                          //             label: 'Survey',
                          //             icon: FontAwesome5.voteYea,
                          //             aksi: () {
                          //               fetchMenu(idx);
                          //               fetchPage('survey');
                          //               Navigator.of(context).pop();
                          //             },
                          //           ),
                          //           ikonSatu(
                          //             label: 'Evaluasi',
                          //             icon: FontAwesome5.clipboardList,
                          //             aksi: () {
                          //               fetchMenu(idx);
                          //               fetchPage('evaluasi');
                          //               Navigator.of(context).pop();
                          //             },
                          //           ),
                          //           ikonSatu(
                          //             label: 'Sertifikat',
                          //             icon: FontAwesome5.fileContract,
                          //             aksi: () async {
                          //               String url =
                          //                   _pelatihanBloc.dirSertifikat +
                          //                       widget.pelatihan.fileSertifikat;
                          //               bool a = await canLaunch(url);
                          //               if (widget.pelatihan.fileSertifikat !=
                          //                       '' &&
                          //                   a) {
                          //                 launch(url);
                          //               } else {
                          //                 await AFwidget.alertDialog(
                          //                   context,
                          //                   Text(
                          //                       'Maaf, Sertifikat belum bisa diakses.'),
                          //                 );
                          //               }
                          //               Navigator.of(context).pop();
                          //             },
                          //           ),
                          //           ikonSatu(
                          //             label: 'PSM',
                          //             icon: FontAwesome5.userTie,
                          //             aksi: () {
                          //               fetchMenu(idx);
                          //               fetchPage('psm');
                          //               Navigator.of(context).pop();
                          //             },
                          //           ),
                          //           ikonSatu(
                          //             label: 'Peserta',
                          //             icon: FontAwesome5.users,
                          //             aksi: () {
                          //               fetchMenu(idx);
                          //               fetchPage('peserta');
                          //               Navigator.of(context).pop();
                          //             },
                          //           ),
                          //           ikonSatu(
                          //             label: 'Informasi',
                          //             icon: FontAwesome5.infoCircle,
                          //             aksi: () {
                          //               fetchMenu(idx);
                          //               fetchPage('informasi');
                          //               Navigator.of(context).pop();
                          //             },
                          //           ),
                          //         ],
                          //       ),
                          //     ),
                          //   );
                          //   break;
                        }
                      },
                    ),
                  );
                } else {
                  if (_currentMenu == 100) fetchMenu(0);
                  return AFwidget.circularProgress();
                }
              }),
        ],
      ),
    );
  }

  Widget tabMateri(List<MateriModel> el) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(9),
            child: Text(
              'MATERI',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate((context, i) {
            return Container(
              margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  left: BorderSide(color: Colors.orange, width: 3),
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
                  Padding(
                    padding: const EdgeInsets.only(bottom: 7),
                    child: Text(
                      el[i].nama,
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                  el[i].keterangan != ''
                      ? Text(
                          el[i].keterangan,
                          style: TextStyle(
                            fontSize: 13,
                          ),
                        )
                      : Container(),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 9, 0, 7),
                    child: Text(
                      '${AFconvert.matDate(el[i].createdOn)} Oleh: ${el[i].createdBy}',
                      style: TextStyle(
                        fontSize: 13,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                  el[i].url != ''
                      ? TextButton.icon(
                          icon: Icon(
                            Icons.download_outlined,
                            size: 19,
                          ),
                          label: Text(
                            'Lampiran',
                            style: TextStyle(
                              fontSize: 13,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            side: BorderSide(color: Colors.orange),
                          ),
                          onPressed: () async {
                            String url = _pelatihanBloc.dirMateri + el[i].url;
                            var a = await canLaunch(url);

                            if (a) {
                              launch(url);
                            } else {
                              AFwidget.alertDialog(
                                context,
                                Text('Lampiran tidak ditemukan'),
                              );
                            }
                          },
                        )
                      : Container(),
                ],
              ),
            );
          }, childCount: el.length),
        ),
      ],
    );
  }

  Widget tabTugas(List<TugasModel> el) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(9),
            child: Text(
              'TUGAS',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, i) {
              return Container(
                margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    left: BorderSide(color: Colors.purple, width: 3),
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
                    Padding(
                      padding: const EdgeInsets.only(bottom: 7),
                      child: Text(
                        el[i].nama,
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                    el[i].keterangan != ''
                        ? Text(
                            el[i].keterangan,
                            style: TextStyle(
                              fontSize: 13,
                            ),
                          )
                        : Container(),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 7, 0, 0),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.calendar_today_outlined,
                            size: 20,
                            color: Colors.green,
                          ),
                          const Padding(padding: EdgeInsets.only(right: 5)),
                          Text(
                            'Tanggal : ${AFconvert.matDate(el[i].tanggal)}',
                            style: TextStyle(
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 7, 0, 0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.upload_outlined,
                            size: 20,
                            color: Colors.green,
                          ),
                          Padding(padding: EdgeInsets.only(right: 5)),
                          FutureBuilder<List<TugasDetailModel>>(
                            future: _pelatihanBloc.getTugasDetail(
                              widget.member.nik,
                              el[i].klasi + el[i].root + el[i].id.toString(),
                            ),
                            builder: (context, snap) {
                              int jml = (snap.hasData && snap.data!.length > 0)
                                  ? snap.data!.length
                                  : 0;
                              return Text(
                                'Upload : $jml',
                                style: TextStyle(
                                  fontSize: 13,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 7, 0, 7),
                      child: Text(
                        '${AFconvert.matDate(el[i].createdOn)} Oleh: ${el[i].createdBy}',
                        style: TextStyle(
                          fontSize: 13,
                          fontStyle: FontStyle.italic,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        el[i].url != '' && el[i].url != '#'
                            ? TextButton.icon(
                                icon: Icon(
                                  Icons.download_outlined,
                                  size: 19,
                                ),
                                label: Text(
                                  'Lampiran',
                                  style: TextStyle(
                                    fontSize: 13,
                                  ),
                                ),
                                style: TextButton.styleFrom(
                                  side: BorderSide(color: Colors.purple),
                                ),
                                onPressed: () async {
                                  String url = el[i].jenis == 'Upload'
                                      ? _pelatihanBloc.dirTugas + el[i].url
                                      : el[i].url;
                                  var a = await canLaunch(url);

                                  if (a) {
                                    launch(url);
                                  } else {
                                    AFwidget.alertDialog(
                                      context,
                                      Text('Lampiran tidak ditemukan'),
                                    );
                                  }
                                },
                              )
                            : Container(),
                        FutureBuilder<List<TugasDetailModel>>(
                          future: _pelatihanBloc.getTugasDetail(
                            widget.member.nik,
                            el[i].klasi + el[i].root + el[i].id.toString(),
                          ),
                          builder: (context, snap) {
                            if (snap.hasData && snap.data!.length > 0) {
                              return TextButton.icon(
                                icon: Icon(
                                  Icons.search_outlined,
                                  size: 19,
                                ),
                                label: Text(
                                  'Lihat',
                                  style: TextStyle(
                                    fontSize: 13,
                                  ),
                                ),
                                style: TextButton.styleFrom(
                                  side: BorderSide(color: Colors.purple),
                                ),
                                onPressed: () {
                                  AFwidget.modalBottom(
                                    context: context,
                                    konten: tabTugasDetail(snap.data!),
                                    judul: el[i].nama,
                                  );
                                },
                              );
                            } else {
                              return Container();
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
            childCount: el.length,
          ),
        ),
      ],
    );
  }

  Widget tabTugasDetail(List<TugasDetailModel> el) {
    return ListView.builder(
      itemBuilder: (context, i) {
        return Container(
          margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              left: BorderSide(color: Colors.green, width: 3),
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
              Padding(
                padding: const EdgeInsets.only(bottom: 7),
                child: Text(
                  el[i].keterangan,
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 7),
                child: Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 20,
                      color: Colors.green,
                    ),
                    const Padding(padding: EdgeInsets.only(right: 5)),
                    Text(
                      'Tanggal Upload : ${AFconvert.matDate(el[i].createdOn)}',
                      style: TextStyle(
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 7),
                child: Text(
                  'Dikoreksi Oleh : ${el[i].koreksiBy}',
                  style: TextStyle(
                    fontSize: 13,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 7),
                child: Text(
                  'Catatan Koreksi : ${el[i].koreksi}',
                  style: TextStyle(
                    fontSize: 13,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 7),
                child: Text(
                  'Tanggal Koreksi : ${AFconvert.matDate(el[i].koreksiOn)}',
                  style: TextStyle(
                    fontSize: 13,
                  ),
                ),
              ),
              el[i].url != '' && el[i].url != '#'
                  ? TextButton.icon(
                      icon: Icon(
                        Icons.download_outlined,
                        size: 19,
                      ),
                      label: Text(
                        'Lampiran',
                        style: TextStyle(
                          fontSize: 13,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        side: BorderSide(color: Colors.green),
                      ),
                      onPressed: () async {
                        String url = el[i].jenis == 'Upload'
                            ? _pelatihanBloc.dirTugasUpload + el[i].url
                            : el[i].url;
                        var a = await canLaunch(url);

                        if (a) {
                          launch(url);
                        } else {
                          AFwidget.alertDialog(
                            context,
                            Text('Lampiran tidak ditemukan'),
                          );
                        }
                      },
                    )
                  : Container(),
            ],
          ),
        );
      },
      itemCount: el.length,
    );
  }

  Widget tabKuis(List<KuisModel> el) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(9),
            child: Text(
              'QUIZ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, i) {
              return Container(
                margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    left: BorderSide(color: Colors.blue, width: 3),
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
                    Padding(
                      padding: const EdgeInsets.only(bottom: 7),
                      child: Text(
                        el[i].nama,
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                    el[i].keterangan != ''
                        ? Text(
                            el[i].keterangan,
                            style: TextStyle(
                              fontSize: 13,
                            ),
                          )
                        : Container(),
                    Padding(
                      padding: const EdgeInsets.only(top: 7),
                      child: Text(
                        'Jenis : ${el[i].jenis}',
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 7, 0, 0),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.calendar_today_outlined,
                            size: 20,
                            color: Colors.green,
                          ),
                          const Padding(padding: EdgeInsets.only(right: 5)),
                          Text(
                            'Tanggal : ${AFconvert.matDate(el[i].tanggal)}',
                            style: TextStyle(
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 11, 0, 0),
                      child: FutureBuilder<List<KuisDetailModel>>(
                        future: _pelatihanBloc.getKuisDetail(
                          widget.member.nik,
                          el[i].id.toString(),
                        ),
                        builder: (context, snap) {
                          bool isSudah =
                              (snap.hasData && snap.data!.length > 0);
                          Widget lblStatus = Row(
                            children: [
                              Text(
                                'Status : ',
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                              Container(
                                padding:
                                    const EdgeInsets.fromLTRB(15, 5, 15, 5),
                                decoration: BoxDecoration(
                                  color: isSudah ? Colors.green : Colors.red,
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(15),
                                  ),
                                ),
                                child: Text(
                                  isSudah ? 'Sudah' : 'Belum',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            ],
                          );

                          if (isSudah) {
                            int jmlBenar = 0;
                            int jmlSalah = 0;
                            snap.data!.forEach((dtl) {
                              if (dtl.answer == dtl.key) {
                                jmlBenar += 1;
                              } else {
                                jmlSalah += 1;
                              }
                            });
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                lblStatus,
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 11, 0, 0),
                                  child: Text(
                                    'Benar : $jmlBenar       Salah : $jmlSalah',
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton.icon(
                                    icon: Icon(
                                      Icons.search_outlined,
                                      size: 19,
                                    ),
                                    label: Text(
                                      'Lihat',
                                      style: TextStyle(
                                        fontSize: 13,
                                      ),
                                    ),
                                    style: TextButton.styleFrom(
                                      side: BorderSide(color: Colors.blue),
                                    ),
                                    onPressed: () {
                                      AFwidget.modalBottom(
                                        context: context,
                                        konten: tabKuisDetail(snap.data!),
                                        judul: el[i].nama,
                                      );
                                    },
                                  ),
                                )
                              ],
                            );
                          } else {
                            return lblStatus;
                          }
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
            childCount: el.length,
          ),
        ),
      ],
    );
  }

  Widget tabKuisDetail(List<KuisDetailModel> el) {
    return ListView.builder(
      itemBuilder: (context, i) {
        Color berwarna = (el[i].answer == el[i].key)
            ? Colors.green.shade100
            : Colors.red.shade100;
        return Container(
          margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              left: BorderSide(color: Colors.green, width: 3),
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
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 25,
                      child: Text((i + 1).toString() + '.'),
                    ),
                    Expanded(
                      child: Text(
                        el[i].question,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                color: (el[i].answer == 'A') ? berwarna : Colors.transparent,
                margin: const EdgeInsets.only(left: 20),
                padding: const EdgeInsets.all(5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 15,
                      child: Text('A.'),
                    ),
                    Expanded(
                      child: Text(
                        el[i].pilihanA,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                color: (el[i].answer == 'B') ? berwarna : Colors.transparent,
                margin: const EdgeInsets.only(left: 20),
                padding: const EdgeInsets.all(5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 15,
                      child: Text('B.'),
                    ),
                    Expanded(
                      child: Text(
                        el[i].pilihanB,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                color: (el[i].answer == 'C') ? berwarna : Colors.transparent,
                margin: const EdgeInsets.only(left: 20),
                padding: const EdgeInsets.all(5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 15,
                      child: Text('C.'),
                    ),
                    Expanded(
                      child: Text(
                        el[i].pilihanC,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                color: (el[i].answer == 'D') ? berwarna : Colors.transparent,
                margin: const EdgeInsets.only(left: 20),
                padding: const EdgeInsets.all(5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 15,
                      child: Text('D.'),
                    ),
                    Expanded(
                      child: Text(
                        el[i].pilihanD,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text('Jawaban yang Benar : ${el[i].key}'),
              ),
            ],
          ),
        );
      },
      itemCount: el.length,
    );
  }

  Widget tabSurvey(List<SurveyModel> el) {
    Map<String, String> arrPilihan = {
      '': '',
      '1': 'Tidak Setuju',
      '2': 'Kurang Setuju',
      '3': 'Setuju',
      '4': 'Sangat Setuju',
    };
    String cekKategori = '';
    int noKategori = 0;
    String nilai = '';
    String lblJawaban = '';
    Map<String, List<SurveyModel>> list = {};
    List<Widget> lsWidget = [];
    el.forEach((survey) {
      if (survey.kategori != cekKategori) {
        cekKategori = survey.kategori;
        list[cekKategori] = [survey];
      } else {
        list[cekKategori]!.add(survey);
      }
    });

    lsWidget.add(AFsliverSubHeader(
      maxHeight: 40,
      minHeight: 40,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(9),
        child: Text(
          'SURVEY',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ));
    list.forEach((kategori, lsSurvey) {
      noKategori++;
      lsWidget.add(AFsliverSubHeader(
        maxHeight: 50,
        minHeight: 50,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 15,
                child: Text(
                  '$noKategori.',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  kategori,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ));
      lsWidget.add(
        SliverList(
          delegate: SliverChildBuilderDelegate((context, i) {
            switch (lsSurvey[i].jenis) {
              case 'ANGKA':
                nilai = lsSurvey[i].nilai;
                lblJawaban = 'Penilaian anda : ';
                break;
              case 'PILIHAN':
                nilai = arrPilihan[lsSurvey[i].nilai]!;
                lblJawaban = 'Jawaban anda : ';
                break;
              case 'ISIAN':
                nilai = lsSurvey[i].nilai;
                lblJawaban = 'Saran & Masukkan anda : ';
                break;
            }
            return Container(
              margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  left: BorderSide(color: Colors.pink, width: 3),
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
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 25,
                          child: Text((i + 1).toString() + '.'),
                        ),
                        Expanded(
                          child: Text(
                            lsSurvey[i].tanya,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 20),
                    padding: const EdgeInsets.all(5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Text(
                            lblJawaban,
                            style: TextStyle(
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            nilai,
                            style: TextStyle(
                              color: Colors.red.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }, childCount: lsSurvey.length),
        ),
      );
    });
    lsWidget.add(SliverToBoxAdapter(
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(10),
        child: Text(
          'Terima kasih sudah melakukan Survey',
          style: TextStyle(
            color: Colors.red.shade700,
          ),
        ),
      ),
    ));

    return CustomScrollView(
      slivers: lsWidget,
    );
  }

  Widget tabEvaluasi(List<EvaluasiModel> el) {
    String cekKategori = '';
    int noKategori = 0;
    String nilai = '';
    String lblJawaban = '';
    Map<String, List<EvaluasiModel>> list = {};
    List<Widget> lsWidget = [];
    el.forEach((eva) {
      if (eva.kategori != cekKategori) {
        cekKategori = eva.kategori;
        list[cekKategori] = [eva];
      } else {
        list[cekKategori]!.add(eva);
      }
    });

    lsWidget.add(AFsliverSubHeader(
      maxHeight: 40,
      minHeight: 40,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(9),
        child: Text(
          'EVALUASI',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ));
    lsWidget.add(SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
        child: Table(
          border: TableBorder.all(color: Colors.grey),
          columnWidths: {
            0: IntrinsicColumnWidth(),
            1: IntrinsicColumnWidth(),
          },
          children: [
            TableRow(
              children: [
                selKolom(
                  isi: 'Range',
                  warna: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                selKolom(
                  isi: 'Keterangan',
                  warna: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
            TableRow(
              children: [
                selKolom(isi: '1 - 40'),
                selKolom(isi: 'Kurang Sekali'),
              ],
            ),
            TableRow(
              children: [
                selKolom(isi: '41 - 55'),
                selKolom(isi: 'Kurang'),
              ],
            ),
            TableRow(
              children: [
                selKolom(isi: '56 - 70'),
                selKolom(isi: 'Cukup'),
              ],
            ),
            TableRow(
              children: [
                selKolom(isi: '71 - 85'),
                selKolom(isi: 'Baik'),
              ],
            ),
            TableRow(
              children: [
                selKolom(isi: '86 - 100'),
                selKolom(isi: 'Baik Sekali'),
              ],
            ),
          ],
        ),
      ),
    ));
    list.forEach((kategori, lsSurvey) {
      noKategori++;
      lsWidget.add(AFsliverSubHeader(
        maxHeight: 50,
        minHeight: 50,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 15,
                child: Text(
                  '$noKategori.',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  kategori,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ));
      lsWidget.add(
        SliverList(
          delegate: SliverChildBuilderDelegate((context, i) {
            switch (lsSurvey[i].jenis) {
              case 'ANGKA':
                nilai = lsSurvey[i].nilai;
                lblJawaban = 'Penilaian anda : ';
                break;
              case 'PILIHAN':
                nilai = lsSurvey[i].nilai;
                lblJawaban = 'Jawaban anda : ';
                break;
              case 'ISIAN':
                nilai = lsSurvey[i].nilai;
                lblJawaban = 'Saran & Masukkan anda : ';
                break;
            }
            return Container(
              margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  left: BorderSide(color: Colors.red, width: 3),
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
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 25,
                          child: Text((i + 1).toString() + '.'),
                        ),
                        Expanded(
                          child: Text(
                            lsSurvey[i].tanya,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 20),
                    padding: const EdgeInsets.all(5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Text(
                            lblJawaban,
                            style: TextStyle(
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            nilai,
                            style: TextStyle(
                              color: Colors.red.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }, childCount: lsSurvey.length),
        ),
      );
    });
    lsWidget.add(SliverToBoxAdapter(
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(10),
        child: Text(
          'Terima kasih sudah melakukan Evaluasi',
          style: TextStyle(
            color: Colors.red.shade700,
          ),
        ),
      ),
    ));

    return CustomScrollView(
      slivers: lsWidget,
    );
  }

  Widget tabInformasi(RekrutmenModel rekrutmen) {
    double lebarA = 100;
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: 40,
            alignment: Alignment.center,
            padding: EdgeInsets.all(9),
            child: Text(
              'INFORMASI',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(5, 5, 5, 0),
            padding: const EdgeInsets.fromLTRB(10, 15, 10, 10),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(width: lebarA, child: const Text('Kategori')),
                    const Text(' : '),
                    Expanded(
                      child: Text(
                        rekrutmen.nmgiat,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const Padding(padding: EdgeInsets.only(bottom: 15)),
                Row(
                  children: [
                    SizedBox(width: lebarA, child: const Text('Tahun')),
                    const Text(' : '),
                    Text(
                      rekrutmen.tahun.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(right: 25)),
                    const Text('Angkatan : '),
                    Text(
                      rekrutmen.angkatan.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const Padding(padding: EdgeInsets.only(bottom: 15)),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 20,
                      color: Colors.green,
                    ),
                    const Padding(padding: EdgeInsets.only(right: 5)),
                    const Text('Tanggal : '),
                    Text(
                      AFconvert.matDate(rekrutmen.tglMulai),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(' s/d '),
                    Text(
                      AFconvert.matDate(rekrutmen.tglSelesai),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const Padding(padding: EdgeInsets.only(bottom: 10)),
                Row(
                  children: const [
                    Icon(
                      Icons.location_on_outlined,
                      size: 20,
                      color: Colors.green,
                    ),
                    Padding(padding: EdgeInsets.only(right: 5)),
                    Text('Lokasi : '),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(25, 5, 0, 10),
                  child: Text(
                    '${rekrutmen.dusun} KEL/DESA : ${rekrutmen.kelLabel}, KEC : ${rekrutmen.kecLabel}, KAB : ${rekrutmen.kabLabel}, PROV : ${rekrutmen.provLabel}.',
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget tabPSM(List<PersonPSMModel> el) {
    List<PersonPSMModel> _listPSM = [];
    List<PersonPSMModel> _listFilterPSM = [];
    final TextEditingController _txtPSM = TextEditingController();
    return CustomScrollView(
      slivers: [
        AFsliverSubHeader(
          maxHeight: 40,
          minHeight: 40,
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(9),
            child: Text(
              'PSM',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: AFwidget.textField(
            context: context,
            label: 'Cari PSM...',
            kontroler: _txtPSM,
            padding: EdgeInsets.all(10),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(7)),
            onchanged: (value) {
              _listFilterPSM = [];
              for (var a in _listPSM) {
                bool cek = a.nama.toLowerCase().contains(value.toLowerCase());
                if (cek) {
                  _listFilterPSM.add(a);
                }
              }
              _pelatihanBloc.fetchPSM(_listFilterPSM);
            },
          ),
        ),
        SliverToBoxAdapter(
          child: StreamBuilder<List<PersonPSMModel>>(
            stream: _pelatihanBloc.streamPSM,
            builder: (context, snapPSM) {
              if (snapPSM.hasData) {
                if (snapPSM.data!.isNotEmpty) {
                  List<TableRow> lsTRPSM = [];
                  int no = 0;
                  lsTRPSM.add(TableRow(
                    children: [
                      selKolom(
                        isi: 'NO.',
                        warna: Colors.white,
                        fontWeight: FontWeight.bold,
                        backGround: Colors.orange,
                      ),
                      selKolom(
                        isi: 'POSISI',
                        warna: Colors.white,
                        fontWeight: FontWeight.bold,
                        backGround: Colors.orange,
                      ),
                      selKolom(
                        isi: 'NAMA PSM',
                        warna: Colors.white,
                        fontWeight: FontWeight.bold,
                        backGround: Colors.orange,
                      ),
                    ],
                  ));
                  snapPSM.data!.forEach((el) {
                    no++;
                    lsTRPSM.add(TableRow(
                      children: [
                        selKolom(
                          isi: '$no',
                          warna: Colors.black,
                        ),
                        selKolom(
                          isi: el.posisi,
                          warna: Colors.black,
                        ),
                        selKolom(
                          isi: el.nama,
                          warna: Colors.black,
                          align: Alignment.centerLeft,
                        ),
                      ],
                    ));
                  });
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 15),
                    child: Table(
                      border: TableBorder.all(color: Colors.grey),
                      columnWidths: {
                        0: IntrinsicColumnWidth(),
                        1: IntrinsicColumnWidth(),
                        2: IntrinsicColumnWidth(),
                      },
                      children: lsTRPSM,
                    ),
                  );
                } else {
                  return Padding(
                    padding: EdgeInsets.all(15),
                    child: Text('PSM tidak ditemukan.'),
                  );
                }
              } else {
                if (_listPSM.length < 1) {
                  _listPSM = el;
                  _pelatihanBloc.fetchPSM(el);
                } else {
                  _pelatihanBloc.fetchPSM(_listPSM);
                }
                return AFwidget.circularProgress();
              }
            },
          ),
        ),
      ],
    );
  }

  Widget tabPeserta(List<PersonPesertaModel> el) {
    List<PersonPesertaModel> _listPeserta = [];
    List<PersonPesertaModel> _listFilterPeserta = [];
    final TextEditingController _txtPeserta = TextEditingController();
    return CustomScrollView(
      slivers: [
        AFsliverSubHeader(
          maxHeight: 40,
          minHeight: 40,
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(9),
            child: Text(
              'PESERTA',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
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
        SliverToBoxAdapter(
          child: StreamBuilder<List<PersonPesertaModel>>(
            stream: _pelatihanBloc.streamPeserta,
            builder: (context, snapPeserta) {
              if (snapPeserta.hasData) {
                if (snapPeserta.data!.isNotEmpty) {
                  List<TableRow> lsTR = [];
                  int no = 0;
                  lsTR.add(TableRow(
                    children: [
                      selKolom(
                        isi: 'NO.',
                        warna: Colors.white,
                        fontWeight: FontWeight.bold,
                        backGround: Colors.orange,
                      ),
                      selKolom(
                        isi: 'NAMA PESERTA',
                        warna: Colors.white,
                        fontWeight: FontWeight.bold,
                        backGround: Colors.orange,
                      ),
                    ],
                  ));
                  snapPeserta.data!.forEach((el) {
                    no++;
                    lsTR.add(TableRow(
                      children: [
                        selKolom(
                          isi: '$no',
                          warna: Colors.black,
                        ),
                        selKolom(
                          isi: el.nama,
                          warna: Colors.black,
                          align: Alignment.centerLeft,
                        ),
                      ],
                    ));
                  });
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 15),
                    child: Table(
                      border: TableBorder.all(color: Colors.grey),
                      columnWidths: {
                        0: IntrinsicColumnWidth(),
                        1: IntrinsicColumnWidth(),
                      },
                      children: lsTR,
                    ),
                  );
                } else {
                  return Padding(
                    padding: EdgeInsets.all(15),
                    child: Text('Peserta tidak ditemukan.'),
                  );
                }
              } else {
                if (_listPeserta.length < 1) {
                  _listPeserta = el;
                  _pelatihanBloc.fetchPeserta(el);
                } else {
                  _pelatihanBloc.fetchPeserta(_listPeserta);
                }
                return AFwidget.circularProgress();
              }
            },
          ),
        ),
      ],
    );
  }

  Widget ikonSatu({
    required String label,
    required IconData icon,
    Function()? aksi,
  }) {
    return Container(
      width: MediaQuery.of(context).size.width / 4,
      height: 77,
      margin: EdgeInsets.only(bottom: 5),
      child: TextButton(
        child: Column(
          children: [
            Icon(icon, color: Colors.green.shade900),
            Padding(padding: EdgeInsets.only(top: 7)),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  color: Colors.green.shade900,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        onPressed: aksi,
      ),
    );
  }

  Widget selKolom({
    String isi = '',
    Color warna = Colors.red,
    FontWeight fontWeight = FontWeight.normal,
    Color? backGround,
    Alignment align = Alignment.center,
  }) {
    return Container(
      color: backGround,
      alignment: align,
      padding: EdgeInsets.all(5),
      child: Text(
        isi,
        style: TextStyle(
          color: warna,
          fontWeight: fontWeight,
        ),
      ),
    );
  }
}
