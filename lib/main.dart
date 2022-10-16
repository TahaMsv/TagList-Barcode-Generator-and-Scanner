import 'package:barcode_scanner/Login/Login.dart';
import 'package:flutter/material.dart';
import 'package:scan/scan.dart';
import 'MainPage.dart';
import 'controller.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      debugShowCheckedModeBanner: false,
      home: LoginDemo(),

      // const MyHomePage(title: 'Flutter Barcode Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ScanController controller = ScanController();
  var _scanResult = '';
  int _pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text(widget.title),
      ),
      body: MainPage(),

      // bottomNavigationBar: ConvexAppBar(
      //   backgroundColor: Colors.purple,
      //   items: [
      //     TabItem(icon: Icons.document_scanner, title: 'Scan'),
      //     // TabItem(icon: Icons.qr_code_2_outlined, title: 'Generate'),
      //   ],
      //   onTap: (int i) => setState(() {
      //     _pageIndex = i;
      //   }),
      // ),
      floatingActionButton: _pageIndex == 0
          ? FloatingActionButton(
              onPressed: _showBarcodeScanner,
              tooltip: 'Scan Barcode',
              backgroundColor: Colors.purple,
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
              child: const Icon(
                Icons.scanner,
                color: Colors.white,
              ))
          : null,
    );
  }

  _showBarcodeScanner() {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (builder) {
        return StatefulBuilder(builder: (BuildContext context, setState) {
          return SizedBox(
              height: MediaQuery.of(context).size.height * 0.95,
              child: Scaffold(
                appBar: _buildBarcodeScannerAppBar(),
                body: _buildBarcodeScannerBody(),
              ));
        });
      },
    );
  }

  AppBar _buildBarcodeScannerAppBar() {
    return AppBar(
      bottom: PreferredSize(
        child: Container(color: Colors.purpleAccent, height: 4.0),
        preferredSize: const Size.fromHeight(4.0),
      ),
      title: const Text('Scan Your Barcode'),
      elevation: 0.0,
      backgroundColor: const Color(0xFF333333),
      leading: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: const Center(
            child: Icon(
          Icons.cancel,
          color: Colors.white,
        )),
      ),
      actions: [
        Container(alignment: Alignment.center, padding: const EdgeInsets.only(right: 16.0), child: GestureDetector(onTap: () => controller.toggleTorchMode(), child: const Icon(Icons.flashlight_on))),
      ],
    );
  }

  Widget _buildBarcodeScannerBody() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.9,
      child: ScanView(
        controller: controller,
        scanAreaScale: .9,
        scanLineColor: Colors.purpleAccent,
        onCapture: (data) {
          setState(() {
            _scanResult = convertFormattedStringToJson(data);
            Navigator.of(context).pop();
          });
        },
      ),
    );
  }
}
