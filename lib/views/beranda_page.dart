import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:simpel/blocs/beranda_bloc.dart';
import 'package:simpel/models/giat_model.dart';
import 'package:simpel/models/member_model.dart';
import 'package:simpel/models/pelatihan_model.dart';
import 'package:simpel/models/slide_model.dart';
import 'package:simpel/utils/af_sliver_subheader.dart';
import 'package:simpel/utils/af_widget.dart';
import 'package:simpel/views/team_pelatihan_page.dart';

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
                maxHeight: 50,
                minHeight: 50,
                color: Colors.transparent,
                child: Container(
                  height: 50,
                  margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                  padding: const EdgeInsets.all(10),
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
                  child: Text('Selamat Datang ${widget.member.nama},'),
                ),
              ),
              widget.member.kategori == 'team'
                  ? kontenPelatihan(_lebarMedia)
                  : kontenKegiatan(_lebarMedia),
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

  Widget kontenPelatihan(double _lebarMedia) {
    return FutureBuilder<List<PelatihanModel>>(
      future: _berandaBloc.getPelatihanTeam(widget.member.nik),
      builder: (context, snap) {
        double lebar = (_lebarMedia - 40) / 2;
        if (snap.hasData) {
          List<Widget> list = [];
          for (var i = 0; i < snap.data!.length; i++) {
            list.add(
              GestureDetector(
                child: Container(
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
                          _berandaBloc.dirImageGiat + snap.data![i].giatImage,
                          fit: BoxFit.fill,
                          width: lebar,
                          height: lebar / 1.5,
                        ),
                      ),
                      Expanded(
                        child: Container(
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
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(11, 5, 11, 11),
                          child: Text(
                            'Tahun : ${snap.data![i].tahun}',
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(11, 5, 11, 11),
                          child: Text(
                            'Angkatan : ${snap.data![i].angkatan}',
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => TeamPelatihanPage(
                        team: widget.member,
                        pelatihan: snap.data![i],
                      ),
                    ),
                  );
                },
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
}
