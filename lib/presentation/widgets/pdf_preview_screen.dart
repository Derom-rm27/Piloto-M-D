import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import '../../core/theme/app_colors.dart';
import '../../features/reports/export_actions.dart';

class PdfViewerScreen extends StatelessWidget {
  const PdfViewerScreen({
    super.key,
    required this.title,
    required this.fileName,
    required this.bytes,
    required this.colors,
  });

  final String title;
  final String fileName;
  final Uint8List bytes;
  final ThemeColors colors;

  static void open({
    required BuildContext context,
    required String title,
    required String fileName,
    required Uint8List bytes,
    required ThemeColors colors,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => PdfViewerScreen(
          title: title,
          fileName: fileName,
          bytes: bytes,
          colors: colors,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.surfaceCard,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: colors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: colors.borderSubtle, height: 1),
        ),
        actions: [
          IconButton(
            tooltip: 'Guardar / Compartir PDF',
            icon: Icon(Icons.download, color: colors.accentText),
            onPressed: () async {
              await saveBytes(bytes, '$fileName.pdf', 'application/pdf');
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Documento $fileName.pdf guardado / compartido.')),
                );
              }
            },
          ),
        ],
      ),
      body: PdfPreview(
        build: (_) => bytes,
        pdfFileName: '$fileName.pdf',
        allowPrinting: true,
        allowSharing: true,
        canChangePageFormat: false,
        canChangeOrientation: false,
        canDebug: false,
      ),
    );
  }
}
