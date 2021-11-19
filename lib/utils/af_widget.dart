import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:cached_network_image/cached_network_image.dart';

abstract class AFwidget {
  static Widget circularProgress({
    double? nilai,
    Color? warna,
    String? keterangan,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Container(
            height: 45,
            width: 45,
            margin: const EdgeInsets.all(5),
            child: CircularProgressIndicator(
              value: nilai,
              strokeWidth: 3.7,
              color: warna,
            ),
          ),
        ),
        keterangan != null
            ? Container(
                padding: const EdgeInsets.all(8),
                child: Text(
                  keterangan,
                  style: TextStyle(color: warna),
                ),
              )
            : Container(),
      ],
    );
  }

  static Widget linearProgress({double? value}) {
    return (value != null)
        ? Container(
            height: 6,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: LinearProgressIndicator(
                value: value,
                backgroundColor: Colors.black,
              ),
            ),
          )
        : LinearProgressIndicator(
            minHeight: 8,
          );
  }

  static Future<dynamic> simpleDialog(BuildContext context, List<Widget> konten,
      {Widget? judul}) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: judul,
          children: konten,
        );
      },
    );
  }

  static Future<dynamic> alertDialog(
    BuildContext context,
    Widget konten, {
    Widget? tombol,
    Widget? judul,
    String labelClose = 'OK',
    double padding = 20,
    bool barrierDismissible = true,
  }) {
    Widget tom = (tombol != null) ? tombol : const Text('');
    return showGeneralDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.3),
      transitionDuration: const Duration(milliseconds: 200),
      barrierDismissible: barrierDismissible,
      barrierLabel: '',
      pageBuilder: (context, a1, a2) {
        return const Text('Alert Dialog');
      },
      transitionBuilder: (context, a1, a2, widgetA) {
        return Transform.scale(
          scale: a1.value,
          child: Opacity(
            opacity: a1.value,
            child: AlertDialog(
              title: judul,
              content: Container(
                padding: EdgeInsets.all(padding),
                child: konten,
              ),
              actions: [
                tom,
                ElevatedButton(
                  child: Text(labelClose),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Future<dynamic> circularDialog(BuildContext context) {
    return showDialog(
      barrierDismissible: false,
      barrierColor: Colors.grey.withOpacity(0.7),
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          content: circularProgress(
            keterangan: 'Mohon tunggu...',
            warna: Colors.green,
          ),
        );
      },
    );
  }

  static FutureOr<void> snack(BuildContext context, String pesan,
      {String label = '', Function? onAction}) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        content: Text(pesan),
        action: SnackBarAction(
          label: label,
          onPressed: () {
            if (onAction != null) onAction();
          },
        ),
      ),
    );
  }

  static Future<dynamic> modalBottom({
    required BuildContext context,
    required Widget konten,
    String judul = '',
    double? tinggi,
    bool isScrollControlled = true,
  }) {
    return showModalBottomSheet(
      constraints: BoxConstraints(
        maxHeight: tinggi ?? MediaQuery.of(context).size.height - 29,
      ),
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: isScrollControlled,
      builder: (context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            GestureDetector(
              child: Container(
                margin: const EdgeInsets.only(right: 15, bottom: 10),
                alignment: Alignment.center,
                height: 35,
                width: 35,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: const Icon(Icons.close),
              ),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(15, 15, 15, 10),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                child: Text(
                  judul,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                color: Colors.white,
                child: konten,
              ),
            ),
          ],
        );
      },
    );
  }

  static Widget boxKomen({
    String foto = '',
    required String nama,
    required String isi,
    required String tanggal,
  }) {
    ImageProvider vFoto = const AssetImage('images/employee-default.jpg');
    if (foto != '') vFoto = NetworkImage(foto);
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            child: Image(
              image: vFoto,
              width: 35,
              height: 35,
            ),
          ),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 30, 0),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(19),
                      bottomRight: Radius.circular(19),
                      bottomLeft: Radius.circular(19),
                    ),
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(15, 10, 35, 7),
                      color: Colors.grey.shade200,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            nama,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            isi,
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(29, 3, 43, 3),
                  child: Text(
                    tanggal,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget badge(int nilai, {double fontsize = 8}) {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.7),
        borderRadius: BorderRadius.circular(7),
      ),
      constraints: const BoxConstraints(
        minWidth: 10,
        minHeight: 10,
        maxWidth: 20,
        maxHeight: 20,
      ),
      child: Center(
        child: Text(
          '$nilai',
          style: TextStyle(
            color: Colors.white,
            fontSize: fontsize,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  static Widget networkImage(String url,
      {BoxFit? fit, double? width, double? height}) {
    return Image.network(
      url,
      fit: fit,
      width: width,
      height: height,
      loadingBuilder: (_, childA, loading) {
        if (loading == null) return childA;
        return circularProgress();
      },
      errorBuilder: (_, obj, stacktrace) {
        return const Text('broken image');
      },
    );
  }

  static Widget networkImageNonLoading(String url,
      {BoxFit? fit, double? width, double? height}) {
    return Image.network(
      url,
      fit: fit,
      width: width,
      height: height,
      errorBuilder: (_, obj, stacktrace) {
        return const Text('broken image');
      },
    );
  }

  static Widget cachedNetworkImage(
    String url, {
    BoxFit? fit,
    double? width,
    double? height,
  }) {
    return CachedNetworkImage(
      imageUrl: url,
      fit: fit,
      width: width,
      height: height,
      progressIndicatorBuilder: (context, url, downloadProgress) =>
          CircularProgressIndicator(value: downloadProgress.progress),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }

  static Widget textField({
    required BuildContext context,
    TextEditingController? kontroler,
    String? label,
    bool readonly = false,
    bool enabled = true,
    Widget? prefix,
    Widget? suffix,
    Function()? ontap,
    Function(String)? onchanged,
    Function()? oneditingComplete,
    TextInputType keyboard = TextInputType.text,
    List<TextInputFormatter>? inputformatters,
    bool obscuretext = false,
    FocusNode? focusNode,
    TextCapitalization textCapitalization = TextCapitalization.none,
    int maxLines = 1,
    int? minLines,
    int? maxLength,
    InputBorder? border,
    EdgeInsetsGeometry? padding,
  }) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 5),
      child: TextField(
        controller: kontroler,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: prefix,
          suffixIcon: suffix,
          border: border,
          // labelStyle: TextStyle(fontSize: 17),
          contentPadding: padding,
          isDense: true,
        ),
        readOnly: readonly,
        enabled: enabled,
        keyboardType: keyboard,
        inputFormatters: inputformatters,
        onTap: ontap,
        onChanged: onchanged,
        obscureText: obscuretext,
        focusNode: focusNode,
        onEditingComplete: oneditingComplete,
        textCapitalization: textCapitalization,
        maxLines: maxLines,
        minLines: minLines,
        maxLength: maxLength,
      ),
    );
  }

  static Widget belum({String ket = ''}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.all(10),
            child: Icon(Icons.build_circle_outlined, size: 33),
          ),
          Text('$ket dalam proses pengerjaan'),
        ],
      ),
    );
  }

  static Widget html(String data) {
    return Html(
      data: data,
      style: {
        "table": Style(
          border: const Border(
            top: BorderSide(color: Colors.black),
            right: BorderSide(color: Colors.black),
          ),
        ),
        "tr": Style(
          border: const Border(
            bottom: BorderSide(color: Colors.black),
            left: BorderSide(color: Colors.black),
          ),
        ),
        "th": Style(
          padding: const EdgeInsets.all(6),
        ),
        "td": Style(
          padding: const EdgeInsets.all(6),
        ),
        "blockquote": Style(color: Colors.blue, fontSize: const FontSize(17))
      },
      onLinkTap: (url, _, __, ___) {
        // if (url != null) launch(url);
      },
      onImageError: (exception, stackTrace) {
        // print(exception);
      },
      onCssParseError: (css, messages) {
        // print("css that errored: $css");
        // print("error messages:");
        // messages.forEach((element) {
        //   print(element);
        // });
      },
    );
  }
}

class SeparatorRibuanInputFormatter extends TextInputFormatter {
  static const separator = ','; // Change this to '.' for other locales

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Short-circuit if the new value is empty

    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // Handle "deletion" of separator character
    String oldValueText = oldValue.text.replaceAll(separator, '');
    String newValueText = newValue.text.replaceAll(separator, '');

    if (oldValue.text.endsWith(separator) &&
        oldValue.text.length == newValue.text.length + 1) {
      newValueText = newValueText.substring(0, newValueText.length - 1);
    }

    // Only process if the old value and new value are different
    if (oldValueText != newValueText) {
      int selectionIndex =
          newValue.text.length - newValue.selection.extentOffset;
      final chars = newValueText.split('');

      String newString = '';
      for (int i = chars.length - 1; i >= 0; i--) {
        if ((chars.length - 1 - i) % 3 == 0 && i != chars.length - 1) {
          newString = separator + newString;
        }
        newString = chars[i] + newString;
      }

      return TextEditingValue(
        text: newString.toString(),
        selection: TextSelection.collapsed(
          offset: newString.length - selectionIndex,
        ),
      );
    }

    // If the new value and old value are the same, just return as-is
    return newValue;
  }
}
