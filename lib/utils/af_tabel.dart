import 'package:flutter/material.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';

class AFtabelFixedScroll extends StatefulWidget {
  final List<String> kolom;
  final List<double> lebar;
  final double tinggi;
  final List<List<String>> data;
  final double? tinggiTabel;

  AFtabelFixedScroll({
    required this.kolom,
    required this.lebar,
    required this.tinggi,
    required this.data,
    this.tinggiTabel,
    Key? key,
  }) : super(key: key);

  @override
  _AFtabelFixedScrollState createState() => _AFtabelFixedScrollState();
}

class _AFtabelFixedScrollState extends State<AFtabelFixedScroll> {
  late LinkedScrollControllerGroup _controllers;
  late ScrollController _headController;
  late ScrollController _bodyController;
  late ScrollController _firstColumnController;
  late ScrollController _restColumnsController;
  @override
  void initState() {
    super.initState();
    _controllers = LinkedScrollControllerGroup();
    _headController = _controllers.addAndGet();
    _bodyController = _controllers.addAndGet();
    _firstColumnController = _controllers.addAndGet();
    _restColumnsController = _controllers.addAndGet();
  }

  @override
  void dispose() {
    _headController.dispose();
    _bodyController.dispose();
    _firstColumnController.dispose();
    _restColumnsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.tinggiTabel != null
          ? widget.tinggiTabel
          : MediaQuery.of(context).size.height,
      child: Column(
        children: [
          TabelKepala(
            scrollController: _headController,
            kolom: widget.kolom,
            lebar: widget.lebar,
            tinggi: widget.tinggi,
          ),
          Expanded(
            child: TabelTubuh(
              scrollController: _bodyController,
              kolom: widget.kolom,
              lebar: widget.lebar,
              tinggi: widget.tinggi,
              data: widget.data,
            ),
          ),
        ],
      ),
    );
  }
}

class TabelSel extends StatelessWidget {
  final String value;
  final Color? color;
  final double width;
  final double height;
  final AlignmentGeometry? align;

  const TabelSel({
    required this.value,
    required this.width,
    required this.height,
    this.color,
    this.align,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: color,
        border: Border.all(
          color: Colors.black12,
          width: 1.0,
        ),
      ),
      alignment: align,
      child: Text(
        value,
      ),
    );
  }
}

class TabelKepala extends StatelessWidget {
  final ScrollController scrollController;
  final List<String> kolom;
  final List<double> lebar;
  final double tinggi;

  const TabelKepala({
    required this.scrollController,
    required this.kolom,
    required this.lebar,
    required this.tinggi,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: tinggi,
      child: Row(
        children: [
          TabelSel(
            color: Colors.green.withOpacity(0.3),
            value: 'No.',
            width: 40,
            height: tinggi,
            align: Alignment.center,
          ),
          Expanded(
            child: ListView(
              controller: scrollController,
              physics: ClampingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              children: List.generate(kolom.length, (i) {
                return TabelSel(
                  color: Colors.green.withOpacity(0.3),
                  value: kolom[i],
                  width: lebar[i],
                  height: tinggi,
                  align: Alignment.center,
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class TabelTubuh extends StatefulWidget {
  final ScrollController scrollController;
  final List<String> kolom;
  final List<double> lebar;
  final double tinggi;
  final List<List<String>> data;

  const TabelTubuh({
    required this.scrollController,
    required this.kolom,
    required this.lebar,
    required this.tinggi,
    required this.data,
    Key? key,
  }) : super(key: key);

  @override
  _TabelTubuhState createState() => _TabelTubuhState();
}

class _TabelTubuhState extends State<TabelTubuh> {
  late LinkedScrollControllerGroup _controllers;
  late ScrollController _firstColumnController;
  late ScrollController _restColumnsController;

  @override
  void initState() {
    super.initState();
    _controllers = LinkedScrollControllerGroup();
    _firstColumnController = _controllers.addAndGet();
    _restColumnsController = _controllers.addAndGet();
  }

  @override
  void dispose() {
    _firstColumnController.dispose();
    _restColumnsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double totalLebar = 0;
    widget.lebar.forEach((el) => totalLebar += el);
    return Row(
      children: [
        SizedBox(
          width: 40,
          child: ListView(
            controller: _firstColumnController,
            physics: ClampingScrollPhysics(),
            children: List.generate(widget.data.length, (index) {
              return TabelSel(
                color: Colors.green.withOpacity(0.3),
                value: (index + 1).toString(),
                width: 40,
                height: widget.tinggi,
                align: Alignment.center,
              );
            }),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            controller: widget.scrollController,
            scrollDirection: Axis.horizontal,
            physics: const ClampingScrollPhysics(),
            child: SizedBox(
              width: totalLebar,
              child: ListView(
                controller: _restColumnsController,
                physics: const ClampingScrollPhysics(),
                children: List.generate(widget.data.length, (y) {
                  return Row(
                    children: List.generate(widget.kolom.length, (x) {
                      return TabelSel(
                        value: widget.data[y][x],
                        color: Colors.white,
                        width: widget.lebar[x],
                        height: widget.tinggi,
                        align: Alignment.centerLeft,
                      );
                    }),
                  );
                }),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
