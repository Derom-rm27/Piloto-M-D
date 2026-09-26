import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:file_selector/file_selector.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import '../../shared/widgets.dart';

Future<void> saveBytes(Uint8List bytes, String name, String mime) async {
  final file = XFile.fromData(bytes, name: name, mimeType: mime);
  if (kIsWeb) {
    await file.saveTo(name);
    return;
  }
  if (defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS) {
    await shareExport(bytes, name, mime);
    return;
  }
  final location = await getSaveLocation(suggestedName: name);
  if (location != null) await file.saveTo(location.path);
}

Future<void> shareExport(Uint8List bytes, String name, String mime) async {
  // Native share sheet handles both documents and spreadsheets.
  await nativeShare(bytes, name, mime);
}

Future<void> nativeShare(Uint8List bytes, String name, String mime) async {
  await SharePlus.instance.share(
    ShareParams(
      files: [XFile.fromData(bytes, mimeType: mime, name: name)],
      fileNameOverrides: [name],
      sharePositionOrigin: const Rect.fromLTWH(0, 0, 100, 100),
    ),
  );
}

class ExportButtons extends StatelessWidget {
  const ExportButtons({
    super.key,
    required this.name,
    required this.pdf,
    required this.excel,
    this.enabled = true,
  });
  final String name;
  final Future<Uint8List> Function() pdf;
  final Uint8List Function() excel;
  final bool enabled;
  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 8,
    runSpacing: 8,
    children: [
      OutlinedButton.icon(
        onPressed: enabled
            ? () => guarded(context, () async {
                await saveBytes(
                  excel(),
                  '$name.xlsx',
                  'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
                );
              })
            : null,
        icon: const Icon(Icons.table_view_outlined),
        label: const Text('Excel'),
      ),
      FilledButton.icon(
        onPressed: enabled
            ? () => guarded(context, () async {
                final bytes = await pdf();
                if (!context.mounted) return;
                await Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => Scaffold(
                      appBar: AppBar(
                        title: Text(name),
                        actions: [
                          IconButton(
                            tooltip: 'Guardar PDF',
                            onPressed: () => guarded(
                              context,
                              () => saveBytes(
                                bytes,
                                '$name.pdf',
                                'application/pdf',
                              ),
                            ),
                            icon: const Icon(Icons.download),
                          ),
                        ],
                      ),
                      body: PdfPreview(
                        build: (_) => bytes,
                        pdfFileName: '$name.pdf',
                        allowPrinting: true,
                        allowSharing: true,
                        canChangePageFormat: false,
                        canChangeOrientation: false,
                        canDebug: false,
                      ),
                    ),
                  ),
                );
              })
            : null,
        icon: const Icon(Icons.picture_as_pdf_outlined),
        label: const Text('PDF / Imprimir'),
      ),
    ],
  );
}
