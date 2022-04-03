import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:simpel/blocs/beranda_bloc.dart';
import 'package:simpel/models/giat_model.dart';
import 'package:simpel/models/member_model.dart';
import 'package:simpel/models/pelatihan_model.dart';
import 'package:simpel/models/rekrutmen_model.dart';
import 'package:simpel/models/slide_model.dart';
import 'package:simpel/utils/af_convert.dart';
import 'package:simpel/utils/af_sliver_subheader.dart';
import 'package:simpel/utils/af_widget.dart';
import 'package:simpel/views/pelatihan_page.dart';
import 'package:simpel/views/resume_rekrutmen.dart';
import 'package:simpel/views/team_pelatihan_page.dart';
import 'package:basic_utils/basic_utils.dart';

class BerandaPage extends StatefulWidget {
  final MemberModel member;
  const BerandaPage({required this.member, Key? key}) : super(key: key);

  @override
  _BerandaPageState createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage> {
  final BerandaBloc _berandaBloc = BerandaBloc();
  final ScrollController _scroller = ScrollController();
  final CarouselController _caroller = CarouselController();
  bool _isShowSlide = true;
  List<PelatihanModel> _listPelatihan = [];
  List<PelatihanModel> _listFilterPelatihan = [];
  final TextEditingController _txtCari = TextEditingController();

  _scrollListener() {
    if (_scroller.offset >= 135 &&
        _scroller.position.userScrollDirection == ScrollDirection.reverse &&
        _isShowSlide) {
      _berandaBloc.fetchShowSlid(false);
    } else if (_scroller.offset <= 135 &&
        _scroller.position.userScrollDirection == ScrollDirection.forward &&
        !_isShowSlide) {
      _berandaBloc.fetchShowSlid(true);
    }
  }

  @override
  void initState() {
    super.initState();
    _scroller.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scroller
      ..removeListener(_scrollListener)
      ..dispose();
    _berandaBloc.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double _lebarMedia = MediaQuery.of(context).size.width;
    double _tinggiA = widget.member.kategori == 'team' ? 50 : 40;
    return Container(
      // color: Colors.white,
      constraints: const BoxConstraints.expand(),
      child: Stack(
        children: [
          kontenSlider(),
          CustomScrollView(
            controller: _scroller,
            slivers: [
              const SliverToBoxAdapter(
                child: SizedBox(
                  height: 180,
                  width: 0,
                ),
              ),
              AFsliverSubHeader(
                maxHeight: _tinggiA,
                minHeight: _tinggiA,
                color: Colors.transparent,
                child: Container(
                  height: _tinggiA,
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                  padding:
                      EdgeInsets.all(widget.member.kategori == 'team' ? 0 : 10),
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
                        offset: const Offset(0, -1),
                      ),
                    ],
                  ),
                  child: widget.member.kategori == 'team'
                      ? AFwidget.textField(
                          context: context,
                          label: 'Cari Pelatihan...',
                          kontroler: _txtCari,
                          padding: EdgeInsets.all(10),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(7)),
                          onchanged: (value) {
                            _listFilterPelatihan = [];
                            bool cek = false;
                            for (var a in _listPelatihan) {
                              cek = a.singkatan
                                  .toLowerCase()
                                  .contains(value.toLowerCase());
                              if (cek) {
                                _listFilterPelatihan.add(a);
                              } else {
                                cek = a.tahun
                                    .toString()
                                    .toLowerCase()
                                    .contains(value.toLowerCase());
                                if (cek) {
                                  _listFilterPelatihan.add(a);
                                } else {
                                  cek = a.angkatan
                                      .toString()
                                      .toLowerCase()
                                      .contains(value.toLowerCase());
                                  if (cek) {
                                    _listFilterPelatihan.add(a);
                                  }
                                }
                              }
                            }
                            _berandaBloc
                                .fetchPelatihanTeam(_listFilterPelatihan);
                          },
                        )
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Halo, ',
                              style: const TextStyle(
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            Text(
                              StringUtils.capitalize(
                                widget.member.nama,
                                allWords: true,
                              ),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              widget.member.kategori == 'team'
                  ? FutureBuilder<List<PelatihanModel>>(
                      future: _berandaBloc.getPelatihanTeam(widget.member.nik),
                      builder: (context, snap) {
                        if (snap.hasData) {
                          return kontenPelatihan(_lebarMedia, snap.data!);
                        } else {
                          return SliverToBoxAdapter(
                            child: Container(
                              width: _lebarMedia,
                              height: _lebarMedia,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.5),
                                    spreadRadius: 0.5,
                                    blurRadius: 1,
                                    offset: const Offset(1, 1),
                                  ),
                                ],
                              ),
                              margin: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                              child: AFwidget.circularProgress(),
                            ),
                          );
                        }
                      })
                  : PelatihanPage(member: widget.member),
            ],
          ),
        ],
      ),
    );
  }

  Widget kontenSlider() {
    return FutureBuilder<List<SlidModel>>(
      future: _berandaBloc.getSlides(),
      builder: (context, snapSlid) {
        if (snapSlid.hasData) {
          return StreamBuilder<bool>(
              stream: _berandaBloc.streamShowSlid,
              builder: (context, snapShow) {
                if (snapShow.hasData) {
                  _isShowSlide = snapShow.data!;
                }
                return Visibility(
                  visible: _isShowSlide,
                  child: Stack(
                    alignment: AlignmentDirectional.bottomCenter,
                    children: [
                      CarouselSlider(
                        items: snapSlid.data!.map((el) {
                          return AFwidget.cachedNetworkImageNoCek(
                            _berandaBloc.dirImageSlid + el.image,
                            fit: BoxFit.fill,
                          );
                        }).toList(),
                        carouselController: _caroller,
                        options: CarouselOptions(
                          autoPlay: true,
                          enlargeCenterPage: false,
                          viewportFraction: 1.0,
                          height: 200,
                          onPageChanged: (index, reason) {
                            _berandaBloc.fetchCurentSlid(index);
                          },
                        ),
                      ),
                      StreamBuilder<int>(
                        stream: _berandaBloc.streamCurrentSlid,
                        builder: (context, snapCurrentSlid) {
                          if (snapCurrentSlid.hasData) {
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(15, 0, 15, 30),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children:
                                    snapSlid.data!.asMap().entries.map((entry) {
                                  return Container(
                                    width: 7.0,
                                    height: 7.0,
                                    margin: const EdgeInsets.only(right: 8),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: entry.key == snapCurrentSlid.data
                                          ? Colors.red
                                          : Colors.black,
                                    ),
                                  );
                                }).toList(),
                              ),
                            );
                          } else {
                            _berandaBloc.fetchCurentSlid(0);
                            return Container();
                          }
                        },
                      ),
                    ],
                  ),
                );
              });
        } else {
          return Container(
            height: 200,
            color: Colors.white,
            child: AFwidget.circularProgress(),
          );
        }
      },
    );
  }

  Widget kontenKegiatan(double _lebarMedia) {
    return FutureBuilder<List<GiatModel>>(
      future: _berandaBloc.getGiates(),
      builder: (context, snap) {
        double lebar = (_lebarMedia - 40) / 2;
        if (snap.hasData) {
          List<Widget> list = [];
          for (var i = 0; i < snap.data!.length; i++) {
            list.add(
              Container(
                width: lebar,
                height: lebar * 1.2,
                constraints: BoxConstraints(
                  minHeight: 225,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(10),
                        topLeft: Radius.circular(10),
                      ),
                      child: AFwidget.cachedNetworkImageNoCek(
                        _berandaBloc.dirImageGiat + snap.data![i].image,
                        fit: BoxFit.fill,
                        width: lebar,
                        height: lebar / 1.5,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(11, 10, 11, 0),
                      child: Text(
                        snap.data![i].singkatan,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(11, 5, 11, 11),
                        child: Text(
                          snap.data![i].nama,
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 4,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return SliverToBoxAdapter(
            child: Container(
              color: Colors.grey.shade200,
              margin: const EdgeInsets.fromLTRB(10, 15, 10, 15),
              padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(5, 10, 5, 15),
                    child: Text(
                      'PELATIHAN',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: list,
                  ),
                ],
              ),
            ),
          );
        } else {
          return SliverToBoxAdapter(
            child: Container(
                width: lebar,
                height: lebar * 1.2,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      spreadRadius: 0.5,
                      blurRadius: 1,
                      offset: const Offset(1, 1),
                    ),
                  ],
                ),
                margin: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                child: AFwidget.circularProgress()),
          );
        }
      },
    );
  }

  Widget kontenPelatihan(double _lebarMedia, List<PelatihanModel> el) {
    double lebarA = 65;
    return StreamBuilder<List<PelatihanModel>>(
      stream: _berandaBloc.streamPelatihanTeam,
      builder: (context, snapLatih) {
        double lebar = (_lebarMedia - 40) / 2;
        if (snapLatih.hasData) {
          if (snapLatih.data!.length > 0) {
            return SliverList(
              delegate: SliverChildBuilderDelegate((context, i) {
                return Container(
                  margin: const EdgeInsets.fromLTRB(10, 5, 10, 7),
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
                          Expanded(
                            child: Text(
                              '${snapLatih.data![i].singkatan} ${snapLatih.data![i].angkatan}-${snapLatih.data![i].tahun}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Padding(padding: EdgeInsets.only(bottom: 5)),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              '${snapLatih.data![i].nama}',
                              style: const TextStyle(
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Padding(padding: EdgeInsets.only(bottom: 20)),
                      FutureBuilder<RekrutmenModel>(
                        future: _berandaBloc
                            .getRekrutmenId(snapLatih.data![i].kode),
                        builder: (context, snapRek) {
                          if (snapRek.hasData) {
                            return Column(
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: lebarA,
                                      child: const Text('Tanggal'),
                                    ),
                                    const Text(' : '),
                                    Expanded(
                                      child: Text(
                                        '${AFconvert.matDate(snapRek.data!.tglMulai)} s/d ${AFconvert.matDate(snapRek.data!.tglSelesai)}',
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
                                      child: const Text('Lokasi'),
                                    ),
                                    const Text(' : '),
                                    Expanded(
                                      child: Text(
                                        StringUtils.capitalize(
                                          '${snapRek.data!.provLabel}, ${snapRek.data!.kabLabel}, ${snapRek.data!.kecLabel}, ${snapRek.data!.kelLabel}.',
                                          allWords: true,
                                        ),
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
                                      child: const Text('Resume'),
                                    ),
                                    const Text(' : '),
                                    Expanded(
                                      child: Text(
                                        StringUtils.capitalize(
                                          '${snapRek.data!.resume}',
                                          allWords: true,
                                        ),
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
                                      child: const Text('Oleh'),
                                    ),
                                    const Text(' : '),
                                    Expanded(
                                      child: Text(
                                        '${snapRek.data!.resumeNama}',
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
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    const Padding(
                                        padding: EdgeInsets.only(left: 5)),
                                    ElevatedButton(
                                      child: Text('Resume'),
                                      onPressed: () async {
                                        await Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ResumeRekrutmen(
                                              team: widget.member,
                                              rekrutmen: snapRek.data!,
                                              pelatihanKode:
                                                  snapLatih.data![i].kode,
                                            ),
                                          ),
                                        );
                                        setState(() {});
                                      },
                                    ),
                                    const Padding(
                                        padding: EdgeInsets.only(left: 5)),
                                    ElevatedButton(
                                      child: Text('Lihat'),
                                      onPressed: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                TeamPelatihanPage(
                                              team: widget.member,
                                              pelatihan: snapLatih.data![i],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                    ],
                  ),
                );
              }, childCount: snapLatih.data!.length),
            );
          } else {
            return SliverToBoxAdapter(
              child: Text('Data tidak ditemukan'),
            );
          }
        } else {
          if (_listPelatihan.length < 1) {
            _listPelatihan = el;
            _berandaBloc.fetchPelatihanTeam(el);
          } else {
            _berandaBloc.fetchPelatihanTeam(_listPelatihan);
          }
          return SliverToBoxAdapter(
            child: Container(
              width: lebar,
              height: lebar * 1.2,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    spreadRadius: 0.5,
                    blurRadius: 1,
                    offset: const Offset(1, 1),
                  ),
                ],
              ),
              margin: const EdgeInsets.fromLTRB(15, 15, 15, 15),
              child: AFwidget.circularProgress(),
            ),
          );
        }
      },
    );
  }
}
