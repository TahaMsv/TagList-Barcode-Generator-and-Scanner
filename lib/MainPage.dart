import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class MainPage extends StatefulWidget {
  const MainPage({
    Key? key,
  }) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  var _scanResult;

  @override
  Widget build(BuildContext context) {
    return Center(
        child:
            // _pageIndex == 0 ?
            QRCodeScanner(scanResult: _scanResult)
        // : QRCodeGenerator(),
        );
  }
}

class QRCodeGenerator extends StatefulWidget {
  const QRCodeGenerator({
    Key? key,
  }) : super(key: key);

  @override
  State<QRCodeGenerator> createState() => _QRCodeGeneratorState();
}

class _QRCodeGeneratorState extends State<QRCodeGenerator> {
  String? data;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          children: [
            Container(
              height: 100,
              margin: EdgeInsets.symmetric(vertical: 30, horizontal: 5),
              decoration: BoxDecoration(border: Border.all(color: Colors.black54)),
              child: TextFormField(
                onChanged: (text) {
                  setState(() {
                    data = text;
                  });
                },
                maxLines: 100,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  hintText: 'Enter your code',
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            data == null
                ? Container()
                : QrImage(
                    data: data!,
                    version: QrVersions.auto,
                    size: 200.0,
                  ),
          ],
        ),
      ),
    );
  }
}

class QRCodeScanner extends StatelessWidget {
  const QRCodeScanner({
    Key? key,
    required String scanResult,
  })  : _scanResult = scanResult,
        super(key: key);

  final String _scanResult;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text(
          'You Barcode Contains the Text:',
        ),
        Text(
          _scanResult,
          style: Theme.of(context).textTheme.headline6,
        ),
      ],
    );
  }
}
