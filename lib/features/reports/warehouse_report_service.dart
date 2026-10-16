import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../core/domain/production.dart';
import '../../domain/models/warehouse_model.dart';

class WarehouseReportService {
  static pw.ThemeData get pdfTheme => pw.ThemeData.withFont(
        base: pw.Font.helvetica(),
        bold: pw.Font.helveticaBold(),
      ).copyWith(
        defaultTextStyle: const pw.TextStyle(
          color: PdfColors.black,
          fontSize: 8.5,
        ),
      );

  static Future<pw.ImageProvider?> _loadLogo() async {
    try {
      final bytes = await rootBundle.load('assets/images/logo.png');
      return pw.MemoryImage(bytes.buffer.asUint8List());
    } catch (_) {
      try {
        final bytes = await rootBundle.load('assets/images/logo_app.png');
        return pw.MemoryImage(bytes.buffer.asUint8List());
      } catch (_) {
        return null;
      }
    }
  }

  /// 1. NOTA DE RECEPCIÓN / COMPROBANTE DE ENTRADA (1 PÁGINA EXACTA)
  static Future<Uint8List> generateNotaRecepcionPdf(
    MovimientoItem mov,
    LoteItem? lote,
    InsumoItem? ins,
  ) async {
    final doc = pw.Document(theme: pdfTheme);
    final logo = await _loadLogo();

    final pesoTotalKg = ins != null
        ? (mov.cant * ins.kgPorUnidad)
        : (mov.cant * 50.0);

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.symmetric(horizontal: 26, vertical: 24),
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.stretch,
          children: [
            // Cabecera Oficial con Logo M&D
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    if (logo != null)
                      pw.Container(
                        width: 110,
                        height: 38,
                        child: pw.Image(logo, fit: pw.BoxFit.contain),
                      )
                    else
                      pw.Text('PROCESOS M&D', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14)),
                    pw.SizedBox(width: 10),
                    pw.Container(
                      height: 30,
                      decoration: const pw.BoxDecoration(
                        border: pw.Border(left: pw.BorderSide(color: PdfColors.grey400, width: 1.5)),
                      ),
                      padding: const pw.EdgeInsets.only(left: 8),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        children: [
                          pw.Text('Planta Industrial Juliaca', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9)),
                          pw.Text('Control de Inocuidad & Almacén', style: const pw.TextStyle(color: PdfColors.grey700, fontSize: 8)),
                        ],
                      ),
                    ),
                  ],
                ),
                pw.Container(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: pw.BoxDecoration(
                    border: pw.TableBorder.all(color: PdfColors.grey600, width: 0.8),
                    color: PdfColors.grey100,
                    borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text('NOTA DE RECEPCIÓN', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8, color: PdfColors.grey800)),
                      pw.Text('REC-${mov.id.replaceAll(RegExp(r'[^0-9]'), '').padLeft(5, '0')}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12, color: PdfColors.black)),
                      pw.Text('Fecha: ${mov.fechaHora}', style: const pw.TextStyle(color: PdfColors.grey700, fontSize: 8)),
                    ],
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 12),
            pw.Divider(color: PdfColors.black, thickness: 1.5),
            pw.SizedBox(height: 8),

            // Título Central
            pw.Center(
              child: pw.Text(
                'RECEPCIÓN DE MATERIA PRIMA E INSUMOS',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11, letterSpacing: 0.5),
              ),
            ),
            pw.SizedBox(height: 12),

            // Tabla de Datos de la Recepción
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.grey400, width: 0.5),
              columnWidths: {
                0: const pw.FixedColumnWidth(80),
                1: const pw.FlexColumnWidth(2),
                2: const pw.FixedColumnWidth(80),
                3: const pw.FlexColumnWidth(2),
              },
              children: [
                pw.TableRow(children: [
                  _cell('Proveedor:', bold: true),
                  _cell(mov.proveedor ?? 'Molino del Sur S.A.'),
                  _cell('Guía / Factura:', bold: true),
                  _cell(mov.guia ?? 'GR-001-0842'),
                ]),
                pw.TableRow(children: [
                  _cell('Recibido por:', bold: true),
                  _cell(mov.operario),
                  _cell('Ubicación:', bold: true),
                  _cell(mov.destino),
                ]),
              ],
            ),
            pw.SizedBox(height: 14),

            // Tabla Principal de Insumo Ingresado
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.grey700, width: 0.8),
              columnWidths: {
                0: const pw.FlexColumnWidth(3),
                1: const pw.FlexColumnWidth(1.5),
                2: const pw.FlexColumnWidth(1.8),
                3: const pw.FlexColumnWidth(1.8),
                4: const pw.FlexColumnWidth(1.5),
              },
              children: [
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                  children: [
                    _cell('Insumo / Materia Prima', bold: true),
                    _cell('N° Lote', bold: true, align: pw.TextAlign.center),
                    _cell('Fecha Vencimiento', bold: true, align: pw.TextAlign.center),
                    _cell('Cantidad Ingresada', bold: true, align: pw.TextAlign.right),
                    _cell('Peso Total', bold: true, align: pw.TextAlign.right),
                  ],
                ),
                pw.TableRow(children: [
                  _cell(mov.prod, bold: true),
                  _cell(mov.lote, bold: true, align: pw.TextAlign.center),
                  _cell(lote?.fVence ?? 'No especificado', align: pw.TextAlign.center),
                  _cell('${mov.cant.toStringAsFixed(0)} ${mov.unidad}', bold: true, align: pw.TextAlign.right),
                  _cell('${pesoTotalKg.toStringAsFixed(1)} kg', align: pw.TextAlign.right),
                ]),
              ],
            ),
            pw.SizedBox(height: 8),

            pw.Text(
              'Registro oficial conforme a manual de BPM y directriz PEPS de rotación de lotes de planta.',
              style: const pw.TextStyle(color: PdfColors.grey600, fontSize: 8),
            ),
            pw.Spacer(),

            // Firmas Oficiales
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
              children: [
                pw.Container(
                  width: 170,
                  child: pw.Column(
                    children: [
                      pw.Container(decoration: const pw.BoxDecoration(border: pw.Border(top: pw.BorderSide(color: PdfColors.black, width: 1)))),
                      pw.SizedBox(height: 4),
                      pw.Text('Entregado Conforme', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8.5)),
                      pw.Text('Transportista / Proveedor', style: const pw.TextStyle(color: PdfColors.grey700, fontSize: 7.5)),
                    ],
                  ),
                ),
                pw.Container(
                  width: 170,
                  child: pw.Column(
                    children: [
                      pw.Container(decoration: const pw.BoxDecoration(border: pw.Border(top: pw.BorderSide(color: PdfColors.black, width: 1)))),
                      pw.SizedBox(height: 4),
                      pw.Text('Recibido Conforme', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8.5)),
                      pw.Text(mov.operario, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8)),
                      pw.Text('Almacén Planta M&D', style: const pw.TextStyle(color: PdfColors.grey700, fontSize: 7.5)),
                    ],
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 10),
          ],
        ),
      ),
    );

    return doc.save();
  }

  /// 2. REPORTE DE STOCK ACTUAL & EXISTENCIAS (1 PÁGINA EXACTA A4)
  static Future<Uint8List> generateStockActualPdf({
    required List<InsumoItem> insumos,
    required String fechaCorte,
    required int batchesPorTurno,
    required CoberturaTurno Function(InsumoItem) getCobertura,
    required LoteItem? Function(int) getLotePeps,
  }) async {
    final doc = pw.Document(theme: pdfTheme);
    final logo = await _loadLogo();

    int totalRojos = 0;
    for (final ins in insumos) {
      if (getCobertura(ins).esAlertaRoja) totalRojos++;
    }

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.symmetric(horizontal: 22, vertical: 18),
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.stretch,
          children: [
            // Cabecera Oficial
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    if (logo != null)
                      pw.Container(
                        width: 110,
                        height: 34,
                        child: pw.Image(logo, fit: pw.BoxFit.contain),
                      )
                    else
                      pw.Text('PROCESOS M&D', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 13)),
                    pw.SizedBox(width: 8),
                    pw.Container(
                      height: 28,
                      decoration: const pw.BoxDecoration(
                        border: pw.Border(left: pw.BorderSide(color: PdfColors.grey400, width: 1.5)),
                      ),
                      padding: const pw.EdgeInsets.only(left: 6),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        children: [
                          pw.Text('Planta Industrial Juliaca', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8.5)),
                          pw.Text('Existencias & Trazabilidad PEPS', style: const pw.TextStyle(color: PdfColors.grey700, fontSize: 7.5)),
                        ],
                      ),
                    ),
                  ],
                ),
                pw.Container(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: pw.BoxDecoration(
                    border: pw.TableBorder.all(color: PdfColors.grey600, width: 0.8),
                    color: PdfColors.grey100,
                    borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text('ESTADO DE EXISTENCIAS DE ALMACÉN', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8, color: PdfColors.black)),
                      pw.Text('Corte: $fechaCorte (Turno: $batchesPorTurno Batches)', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 7.5, color: PdfColors.grey800)),
                    ],
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 6),
            pw.Divider(color: PdfColors.black, thickness: 1.2),
            pw.SizedBox(height: 4),

            // Alerta en texto rojo limpio según Regla de Proyecto
            pw.Container(
              padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              child: totalRojos > 0
                  ? pw.Text(
                      'Alerta de Turno: $totalRojos insumo(s) con stock menor al requerimiento del turno ($batchesPorTurno batches). Requieren reposición urgente.',
                      style: pw.TextStyle(color: PdfColors.red700, fontWeight: pw.FontWeight.bold, fontSize: 7.8),
                    )
                  : pw.Text(
                      'Inventario óptimo: Todos los insumos cubren la programación del turno ($batchesPorTurno batches).',
                      style: const pw.TextStyle(color: PdfColors.grey800, fontSize: 7.8),
                    ),
            ),
            pw.SizedBox(height: 4),

            // Tabla Compacta de Existencias (Encaja exactamente en 1 página A4)
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.grey600, width: 0.5),
              columnWidths: {
                0: const pw.FixedColumnWidth(16),  // N°
                1: const pw.FlexColumnWidth(2.6), // Insumo
                2: const pw.FlexColumnWidth(1.8), // Presentación
                3: const pw.FixedColumnWidth(34),  // x Batch
                4: const pw.FixedColumnWidth(42),  // Req. Turno
                5: const pw.FixedColumnWidth(34),  // Stock Unid.
                6: const pw.FixedColumnWidth(44),  // Stock Kg
                7: const pw.FlexColumnWidth(2.2), // Estado
                8: const pw.FixedColumnWidth(36),  // Lote PEPS
                9: const pw.FixedColumnWidth(46),  // Vence
              },
              children: [
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                  children: [
                    _cellMini('N°', bold: true, align: pw.TextAlign.center),
                    _cellMini('Insumo / Materia Prima', bold: true),
                    _cellMini('Presentación', bold: true),
                    _cellMini('x Batch', bold: true, align: pw.TextAlign.right),
                    _cellMini('Req. Turno', bold: true, align: pw.TextAlign.right),
                    _cellMini('Stock Un.', bold: true, align: pw.TextAlign.right),
                    _cellMini('Stock Kg', bold: true, align: pw.TextAlign.right),
                    _cellMini('Estado de Turno', bold: true, align: pw.TextAlign.center),
                    _cellMini('Lote PEPS', bold: true, align: pw.TextAlign.center),
                    _cellMini('Vence', bold: true, align: pw.TextAlign.center),
                  ],
                ),
                for (var idx = 0; idx < insumos.length; idx++) ...[
                  () {
                    final ins = insumos[idx];
                    final cob = getCobertura(ins);
                    final lotePeps = getLotePeps(ins.id);

                    return pw.TableRow(
                      decoration: pw.BoxDecoration(
                        color: idx % 2 == 1 ? PdfColors.grey50 : PdfColors.white,
                      ),
                      children: [
                        _cellMini('${idx + 1}', align: pw.TextAlign.center),
                        _cellMini(ins.nombre, bold: true),
                        _cellMini(ins.unidad),
                        _cellMini('${ins.kgPorBatch.toStringAsFixed(2)} kg', align: pw.TextAlign.right),
                        _cellMini('${cob.kgNecesariosTurno.toStringAsFixed(1)} kg', align: pw.TextAlign.right),
                        _cellMini(
                          '${cob.stockUnidades.toStringAsFixed(0)}',
                          bold: true,
                          align: pw.TextAlign.right,
                          color: cob.esAlertaRoja ? PdfColors.red700 : PdfColors.black,
                        ),
                        _cellMini('${cob.stockKg.toStringAsFixed(1)} kg', align: pw.TextAlign.right),
                        _cellMini(
                          cob.esAlertaRoja
                              ? 'Urgente: Faltan ${cob.faltaParaTurnoUnidades}'
                              : 'Suficiente (${cob.turnosRinde} t.)',
                          bold: cob.esAlertaRoja,
                          align: pw.TextAlign.center,
                          color: cob.esAlertaRoja ? PdfColors.red700 : PdfColors.grey800,
                        ),
                        _cellMini(lotePeps?.nroLote ?? '-', align: pw.TextAlign.center, bold: true),
                        _cellMini(lotePeps?.fVence ?? '-', align: pw.TextAlign.center),
                      ],
                    );
                  }(),
                ],
              ],
            ),
            pw.Spacer(),

            // Firmas Oficiales (3 Firmas: Almacén, Calidad, Planta)
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
              children: [
                _signatureBox('Responsable de Almacén'),
                _signatureBox('Control de Calidad'),
                _signatureBox('Jefatura de Planta'),
              ],
            ),
            pw.SizedBox(height: 6),
          ],
        ),
      ),
    );

    return doc.save();
  }

  /// 3. PARTE DE TURNO Y CONSUMO PEPS (1 PÁGINA EXACTA)
  static Future<Uint8List> generateParteTurnoPdf({
    required Production jornada,
    required List<MovimientoItem> consumos,
  }) async {
    final doc = pw.Document(theme: pdfTheme);
    final logo = await _loadLogo();

    final batches = number(jornada.row['cant_batch']) > 0
        ? number(jornada.row['cant_batch']).toInt()
        : 16;
    final cajas = number(jornada.boxes) > 0 ? jornada.boxes : 64.0;
    final linea = jornada.isCookies ? 'Línea Galletas' : 'Línea Barras';
    final fecha = '${jornada.row['fecha']}';
    final turno = '${jornada.row['turno']}';

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.symmetric(horizontal: 26, vertical: 24),
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.stretch,
          children: [
            // Cabecera Oficial
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    if (logo != null)
                      pw.Container(
                        width: 110,
                        height: 38,
                        child: pw.Image(logo, fit: pw.BoxFit.contain),
                      )
                    else
                      pw.Text('PROCESOS M&D', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14)),
                    pw.SizedBox(width: 10),
                    pw.Container(
                      height: 30,
                      decoration: const pw.BoxDecoration(
                        border: pw.Border(left: pw.BorderSide(color: PdfColors.grey400, width: 1.5)),
                      ),
                      padding: const pw.EdgeInsets.only(left: 8),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        children: [
                          pw.Text('Planta Industrial Juliaca', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9)),
                          pw.Text('Producción & Trazabilidad de Planta', style: const pw.TextStyle(color: PdfColors.grey700, fontSize: 8)),
                        ],
                      ),
                    ),
                  ],
                ),
                pw.Container(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: pw.BoxDecoration(
                    border: pw.TableBorder.all(color: PdfColors.grey600, width: 0.8),
                    color: PdfColors.grey100,
                    borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text('PARTE DE PRODUCCIÓN', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8, color: PdfColors.grey800)),
                      pw.Text(jornada.id.length > 16 ? jornada.id.substring(0, 16) : jornada.id, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10, color: PdfColors.black)),
                      pw.Text('Fecha: $fecha', style: const pw.TextStyle(color: PdfColors.grey700, fontSize: 8)),
                    ],
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 10),
            pw.Divider(color: PdfColors.black, thickness: 1.5),
            pw.SizedBox(height: 8),

            // Título
            pw.Center(
              child: pw.Text(
                'INFORME OFICIAL DE PRODUCCIÓN DE TURNO',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11, letterSpacing: 0.5),
              ),
            ),
            pw.SizedBox(height: 10),

            // Datos del Turno
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.grey400, width: 0.5),
              columnWidths: {
                0: const pw.FixedColumnWidth(80),
                1: const pw.FlexColumnWidth(2),
                2: const pw.FixedColumnWidth(80),
                3: const pw.FlexColumnWidth(2),
              },
              children: [
                pw.TableRow(children: [
                  _cell('Línea:', bold: true),
                  _cell(linea),
                  _cell('Turno:', bold: true),
                  _cell(turno),
                ]),
                pw.TableRow(children: [
                  _cell('Batches:', bold: true),
                  _cell('$batches Batches', bold: true),
                  _cell('Cajas Producidas:', bold: true),
                  _cell('${cajas.toStringAsFixed(1)} Cajas', bold: true),
                ]),
              ],
            ),
            pw.SizedBox(height: 12),

            // Subtítulo
            pw.Text(
              'INSUMOS DESPACHADOS DE ALMACÉN (PEPS):',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9.5),
            ),
            pw.SizedBox(height: 6),

            // Tabla de Insumos Despachados
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.grey700, width: 0.8),
              columnWidths: {
                0: const pw.FlexColumnWidth(3),
                1: const pw.FlexColumnWidth(1.6),
                2: const pw.FlexColumnWidth(1.8),
                3: const pw.FlexColumnWidth(2.5),
              },
              children: [
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                  children: [
                    _cell('Insumo / Materia Prima', bold: true),
                    _cell('N° Lote Consumido', bold: true, align: pw.TextAlign.center),
                    _cell('Cantidad Retirada', bold: true, align: pw.TextAlign.right),
                    _cell('Operario que Despachó', bold: true),
                  ],
                ),
                if (consumos.isEmpty)
                  pw.TableRow(children: [
                    _cell('No hay registros de despacho vinculados directamente.', italic: true),
                    _cell('-', align: pw.TextAlign.center),
                    _cell('-', align: pw.TextAlign.right),
                    _cell('-'),
                  ])
                else
                  for (final c in consumos)
                    pw.TableRow(children: [
                      _cell(c.prod, bold: true),
                      _cell(c.lote, bold: true, align: pw.TextAlign.center),
                      _cell('${c.cant.toStringAsFixed(0)} ${c.unidad}', bold: true, align: pw.TextAlign.right),
                      _cell(c.operario),
                    ]),
              ],
            ),
            pw.Spacer(),

            // Firmas Oficiales
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
              children: [
                _signatureBox('Jefe de Turno / Producción'),
                _signatureBox('Despacho de Almacén'),
                _signatureBox('Control de Calidad'),
              ],
            ),
            pw.SizedBox(height: 10),
          ],
        ),
      ),
    );

    return doc.save();
  }

  // --- HELPERS DE CELDA ---
  static pw.Widget _cell(
    String text, {
    bool bold = false,
    bool italic = false,
    pw.TextAlign align = pw.TextAlign.left,
  }) =>
      pw.Padding(
        padding: const pw.EdgeInsets.symmetric(horizontal: 5, vertical: 3.5),
        child: pw.Text(
          text,
          textAlign: align,
          style: pw.TextStyle(
            fontSize: 8.5,
            fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
            fontStyle: italic ? pw.FontStyle.italic : pw.FontStyle.normal,
          ),
        ),
      );

  static pw.Widget _cellMini(
    String text, {
    bool bold = false,
    pw.TextAlign align = pw.TextAlign.left,
    PdfColor color = PdfColors.black,
  }) =>
      pw.Padding(
        padding: const pw.EdgeInsets.symmetric(horizontal: 3, vertical: 2.2),
        child: pw.Text(
          text,
          textAlign: align,
          style: pw.TextStyle(
            fontSize: 6.8,
            fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
            color: color,
          ),
        ),
      );

  static pw.Widget _signatureBox(String cargo) => pw.Container(
        width: 140,
        child: pw.Column(
          children: [
            pw.Container(decoration: const pw.BoxDecoration(border: pw.Border(top: pw.BorderSide(color: PdfColors.black, width: 0.8)))),
            pw.SizedBox(height: 3),
            pw.Text(cargo, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8)),
          ],
        ),
      );
}
