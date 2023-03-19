import 'dart:async';

import 'dart:io';

import 'package:flutter_pos_printer_platform/flutter_pos_printer_platform.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';

class PrintLogic {
  // Printer Type [bluetooth, usb, network]
  var defaultPrinterType = PrinterType.usb;

  var printerManager = PrinterManager.instance;
  var devices = <BluetoothPrinter>[];

  List<int>? pendingTask;

  BluetoothPrinter? selectedPrinter;

  PrintLogic() {
    if (Platform.isWindows) defaultPrinterType = PrinterType.usb;

    selectedPrinter = BluetoothPrinter(
      deviceName: 'POS-80C',
      // address: 'YOUR_PRINTER_ADDRESS',
      typePrinter: PrinterType.usb,
      state: false,
    );
  }

  Future<void> testPrint() async {
    List<int> bytes = [];

    // Xprinter XP-N160I
    final profile = await CapabilityProfile.load(name: 'XP-N160I');
    // PaperSize.mm80 or PaperSize.mm58
    final generator = Generator(PaperSize.mm80, profile);
    bytes += generator.setGlobalCodeTable('CP1252');

    bytes += generator.text('Asha Medical Center',
        styles: const PosStyles(
            align: PosAlign.center, underline: true, bold: true));

    bytes += generator.text('Patient Name:  SAMIULLAH');
    bytes += generator.text('Gender:        Male');

    _printEscPos(bytes, generator);
  }
  Future<void> printReceipt(List<int> bytes, Generator generator) async {
  _printEscPos(bytes, generator);
}

  /// print ticket
  void _printEscPos(List<int> bytes, Generator generator) async {
    if (selectedPrinter == null) return;
    var bluetoothPrinter = selectedPrinter!;

    switch (bluetoothPrinter.typePrinter) {
      case PrinterType.usb:
        bytes += generator.feed(2);
        bytes += generator.cut();
        await printerManager.connect(
            type: bluetoothPrinter.typePrinter,
            model: UsbPrinterInput(
                name: bluetoothPrinter.deviceName,
                productId: bluetoothPrinter.productId,
                vendorId: bluetoothPrinter.vendorId));
        pendingTask = null;
        break;
      default:
    }

    printerManager.send(type: bluetoothPrinter.typePrinter, bytes: bytes);
  }

  void dispose() {
    printerManager.disconnect(type: selectedPrinter!.typePrinter);
  }
}

class BluetoothPrinter {
  int? id;
  String? deviceName;
  String? address;
  String? port;
  String? vendorId;
  String? productId;
  bool? isBle;

  PrinterType typePrinter;
  bool? state;

  BluetoothPrinter(
      {this.deviceName,
      this.address,
      this.port,
      this.state,
      this.vendorId,
      this.productId,
      this.typePrinter = PrinterType.bluetooth,
      this.isBle = false});
}
