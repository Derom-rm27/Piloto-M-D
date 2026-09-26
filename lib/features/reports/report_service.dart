import 'dart:typed_data';
import 'package:excel/excel.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../core/domain/attendance.dart';
import '../../core/domain/production.dart';
import '../../core/data/app_store.dart';

const attendanceColumns = [
  '#',
  'Trabajador',
  'Días Laborados',
  'Turnos Día',
  'Turnos Noche',
  'Horas Totales',
];

class ReportService {
  static pw.ThemeData get pdfTheme =>
      pw.ThemeData.withFont(
        base: pw.Font.helvetica(),
        bold: pw.Font.helveticaBold(),
      ).copyWith(
        defaultTextStyle: const pw.TextStyle(
          color: PdfColors.black,
          fontSize: 9,
        ),
      );
  static Future<Uint8List> attendancePdf(
    List<AttendanceSummary> rows,
    String month,
  ) async {
    final doc = pw.Document(theme: pdfTheme);
    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(28),
        footer: (c) => pw.Align(
          alignment: pw.Alignment.centerRight,
          child: pw.Text('Página ${c.pageNumber} de ${c.pagesCount}'),
        ),
        build: (_) => [
          pw.Text(
            'M&D - INFORME DE ASISTENCIA',
            style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 8),
          pw.Text('Mes: $month'),
          pw.SizedBox(height: 14),
          pw.TableHelper.fromTextArray(
            headers: attendanceColumns,
            data: [for (var i = 0; i < rows.length; i++) rows[i].cells(i + 1)],
            headerStyle: pw.TextStyle(
              color: PdfColors.black,
              fontWeight: pw.FontWeight.bold,
              fontSize: 8,
            ),
            cellStyle: const pw.TextStyle(color: PdfColors.black, fontSize: 8),
            headerDecoration: const pw.BoxDecoration(color: PdfColors.white),
            columnWidths: {
              0: const pw.FixedColumnWidth(22),
              1: const pw.FlexColumnWidth(3),
            },
            cellPadding: const pw.EdgeInsets.all(5),
          ),
          pw.SizedBox(height: 12),
          pw.Text(
            'Total de horas: ${rows.fold<double>(0, (s, r) => s + r.hours).toStringAsFixed(2)}',
          ),
          if (rows.any((r) => r.sinSalida > 0))
            pw.Text(
              'Nota: Se computan ${rows.fold<int>(0, (s, r) => s + r.sinSalida)} jornada(s) con Entrada registrada en curso o pendiente de salida.',
            ),
          if (rows.any((r) => r.incomplete > 0))
            pw.Text(
              'Pendientes de revisión: ${rows.fold<int>(0, (s, r) => s + r.incomplete)} incidencias de marcación duplicada.',
            ),
        ],
      ),
    );
    return doc.save();
  }

  static Future<Uint8List> individualAttendancePdf(
    AttendanceSummary summary,
    DateTime month,
  ) async {
    final doc = pw.Document(theme: pdfTheme);
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    const monthNames = [
      'ENERO', 'FEBRERO', 'MARZO', 'ABRIL', 'MAYO', 'JUNIO',
      'JULIO', 'AGOSTO', 'SEPTIEMBRE', 'OCTUBRE', 'NOVIEMBRE', 'DICIEMBRE'
    ];
    const weekdays = [
      'Lunes', 'Martes', 'Miercoles', 'Jueves', 'Viernes', 'Sabado', 'Domingo'
    ];
    final monthName = '${monthNames[month.month - 1]} ${month.year}';

    // Indexar registros por fecha (yyyy-MM-dd)
    final recordMap = <String, AttendanceDayRecord>{};
    for (final r in summary.dailyRecords) {
      recordMap[r.date] = r;
    }

    final tableData = <List<String>>[];
    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(month.year, month.month, day);
      final dateStr =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      final dayOfWeek = weekdays[date.weekday - 1];
      final formattedDate =
          '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';

      final rec = recordMap[dateStr];
      if (rec != null) {
        tableData.add([
          '$day',
          dayOfWeek,
          formattedDate,
          'LABORADO',
          rec.turno.toUpperCase(),
          rec.linea,
          rec.entradaHora,
          rec.isEnPlanta ? 'En Planta' : (rec.salidaHora ?? '--:--'),
          '${rec.horas.toStringAsFixed(1)} hrs',
        ]);
      } else {
        tableData.add([
          '$day',
          dayOfWeek,
          formattedDate,
          'DESCANSO',
          '-',
          '-',
          '-',
          '-',
          '0.0 hrs',
        ]);
      }
    }

    final diasLaborados = summary.dates.length;
    final diasDescanso = daysInMonth - diasLaborados;

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),
        footer: (c) => pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              'Procesos M&D Planta - Reporte Oficial de Asistencia',
              style: const pw.TextStyle(color: PdfColors.grey700, fontSize: 8),
            ),
            pw.Text(
              'Pagina ${c.pageNumber} de ${c.pagesCount}',
              style: const pw.TextStyle(color: PdfColors.grey700, fontSize: 8),
            ),
          ],
        ),
        build: (_) => [
          // Cabecera Principal
          pw.Container(
            padding: const pw.EdgeInsets.all(10),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey400),
              borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'PROCESOS M&D - PLANTA INDUSTRIAL',
                      style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
                    ),
                    pw.SizedBox(height: 2),
                    pw.Text(
                      'FICHA INDIVIDUAL DE ASISTENCIA Y JORNADAS',
                      style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold, color: PdfColors.blueGrey800),
                    ),
                  ],
                ),
                pw.Container(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.grey400),
                    borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
                  ),
                  child: pw.Text(
                    monthName,
                    style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 10),

          // Datos del Trabajador
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: pw.BoxDecoration(
              color: PdfColors.grey100,
              border: pw.Border.all(color: PdfColors.grey300),
              borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
            ),
            child: pw.Row(
              children: [
                pw.Expanded(
                  flex: 3,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.RichText(
                        text: pw.TextSpan(
                          children: [
                            pw.TextSpan(text: 'Trabajador: ', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
                            pw.TextSpan(text: summary.name, style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
                          ],
                        ),
                      ),
                      pw.SizedBox(height: 3),
                      pw.RichText(
                        text: pw.TextSpan(
                          children: [
                            pw.TextSpan(text: 'Cargo: ', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9)),
                            pw.TextSpan(text: '${summary.person['cargo'] ?? 'Operario'}', style: const pw.TextStyle(fontSize: 9)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                pw.Expanded(
                  flex: 2,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.RichText(
                        text: pw.TextSpan(
                          children: [
                            pw.TextSpan(text: 'DNI: ', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9)),
                            pw.TextSpan(text: '${summary.person['dni'] ?? 'N/D'}', style: const pw.TextStyle(fontSize: 9)),
                          ],
                        ),
                      ),
                      pw.SizedBox(height: 3),
                      pw.RichText(
                        text: pw.TextSpan(
                          children: [
                            pw.TextSpan(text: 'Telefono: ', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9)),
                            pw.TextSpan(text: '${summary.person['telefono'] ?? '-'}', style: const pw.TextStyle(fontSize: 9)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 10),

          // Resumen Estadístico (KPIs)
          pw.Row(
            children: [
              _pdfKpiCard('Dias Laborados', '$diasLaborados de $daysInMonth', PdfColors.green900),
              pw.SizedBox(width: 8),
              _pdfKpiCard('Dias Descanso', '$diasDescanso', PdfColors.blueGrey800),
              pw.SizedBox(width: 8),
              _pdfKpiCard('Turnos Dia', '${summary.dayShifts.length}', PdfColors.amber800),
              pw.SizedBox(width: 8),
              _pdfKpiCard('Turnos Noche', '${summary.nightShifts.length}', PdfColors.indigo800),
              pw.SizedBox(width: 8),
              _pdfKpiCard('Total Horas', '${summary.hours.toStringAsFixed(1)} hrs', PdfColors.green900),
            ],
          ),
          pw.SizedBox(height: 12),

          // Título de la tabla
          pw.Text(
            'DETALLE DE ASISTENCIA Y JORNADAS DIA POR DIA ($monthName)',
            style: pw.TextStyle(fontSize: 9.5, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 5),

          // Tabla Día por Día
          pw.TableHelper.fromTextArray(
            headers: [
              'Dia',
              'Semana',
              'Fecha',
              'Estado',
              'Turno',
              'Linea',
              'Entrada',
              'Salida',
              'Horas',
            ],
            data: tableData,
            headerStyle: pw.TextStyle(
              color: PdfColors.white,
              fontWeight: pw.FontWeight.bold,
              fontSize: 7.5,
            ),
            headerDecoration: const pw.BoxDecoration(color: PdfColors.blueGrey900),
            cellStyle: const pw.TextStyle(fontSize: 7.5),
            cellPadding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 3),
            columnWidths: {
              0: const pw.FixedColumnWidth(22),
              1: const pw.FlexColumnWidth(1.2),
              2: const pw.FlexColumnWidth(1.2),
              3: const pw.FlexColumnWidth(1.4),
              4: const pw.FlexColumnWidth(1.0),
              5: const pw.FlexColumnWidth(1.2),
              6: const pw.FlexColumnWidth(1.0),
              7: const pw.FlexColumnWidth(1.0),
              8: const pw.FlexColumnWidth(1.1),
            },
          ),
          pw.SizedBox(height: 16),

          // Firmas de Conformidad
          pw.Container(
            padding: const pw.EdgeInsets.all(10),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey300),
              borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'DECLARACION Y CONFORMIDAD DE JORNADAS:',
                  style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 2),
                pw.Text(
                  'El suscrito declara su conformidad con los dias laborados, turnos y horas efectivas registradas en la presente ficha mensual.',
                  style: const pw.TextStyle(fontSize: 7.5, color: PdfColors.grey700),
                ),
                pw.SizedBox(height: 28),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                  children: [
                    pw.Column(
                      children: [
                        pw.Container(width: 170, height: 1, color: PdfColors.black),
                        pw.SizedBox(height: 4),
                        pw.Text('Firma del Trabajador', style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
                        pw.Text('DNI: ${summary.person['dni'] ?? '....................'}', style: const pw.TextStyle(fontSize: 7.5)),
                      ],
                    ),
                    pw.Column(
                      children: [
                        pw.Container(width: 170, height: 1, color: PdfColors.black),
                        pw.SizedBox(height: 4),
                        pw.Text('Supervision de Planta', style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
                        pw.Text('Vo.Bo. Control de Asistencia', style: const pw.TextStyle(fontSize: 7.5)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
    return doc.save();
  }

  static pw.Widget _pdfKpiCard(String label, String value, PdfColor color) {
    return pw.Expanded(
      child: pw.Container(
        padding: const pw.EdgeInsets.symmetric(vertical: 5, horizontal: 4),
        decoration: pw.BoxDecoration(
          border: pw.Border.all(color: PdfColors.grey300),
          borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
        ),
        child: pw.Column(
          children: [
            pw.Text(
              value,
              style: pw.TextStyle(fontSize: 8.5, fontWeight: pw.FontWeight.bold, color: color),
              maxLines: 1,
            ),
            pw.SizedBox(height: 2),
            pw.Text(
              label,
              style: const pw.TextStyle(fontSize: 6.5, color: PdfColors.grey700),
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }

  static Uint8List attendanceExcel(List<AttendanceSummary> rows, String month) {
    final book = Excel.createExcel();
    book.rename('Sheet1', 'Asistencia');
    final s = book['Asistencia'];
    s.appendRow([TextCellValue('INFORME DE ASISTENCIA - $month')]);
    s.merge(CellIndex.indexByString('A1'), CellIndex.indexByString('F1'));
    s.appendRow(attendanceColumns.map(TextCellValue.new).toList());
    for (var i = 0; i < rows.length; i++) {
      s.appendRow(rows[i].cells(i + 1).map(cellValue).toList());
    }
    s.appendRow([
      TextCellValue('Total horas'),
      null,
      null,
      null,
      null,
      DoubleCellValue(rows.fold<double>(0, (a, r) => a + r.hours)),
    ]);
    if (rows.any((r) => r.sinSalida > 0)) {
      s.appendRow([
        TextCellValue(
          'Nota: Se computan ${rows.fold<int>(0, (s, r) => s + r.sinSalida)} jornada(s) con Entrada registrada en curso o pendiente de salida.',
        ),
      ]);
    }
    if (rows.any((r) => r.incomplete > 0)) {
      s.appendRow([
        TextCellValue(
          'Hay marcaciones duplicadas o sin entrada pendientes de revisión.',
        ),
      ]);
    }
    s.setColumnWidth(0, 6);
    s.setColumnWidth(1, 46);
    for (var i = 2; i < 6; i++) {
      s.setColumnWidth(i, 19);
    }
    styleSheet(s, 6);
    return Uint8List.fromList(book.encode()!);
  }

  static CellValue cellValue(Object v) => v is int
      ? IntCellValue(v)
      : v is double
      ? DoubleCellValue(v)
      : TextCellValue('$v');
  static void styleSheet(Sheet s, int cols) {
    for (var r = 0; r < s.maxRows; r++) {
      for (var c = 0; c < cols; c++) {
        s
            .cell(CellIndex.indexByColumnRow(columnIndex: c, rowIndex: r))
            .cellStyle = CellStyle(
          fontFamily: 'Arial',
          fontSize: 10,
          fontColorHex: ExcelColor.black,
          bold: r < 2,
          verticalAlign: VerticalAlign.Center,
          textWrapping: TextWrapping.WrapText,
        );
      }
    }
    s.setRowHeight(0, 26);
    s.setRowHeight(1, 28);
  }

  static Future<Uint8List> productionPdf(
    List<Production> jornadas, {
    int formsPerPage = 2,
  }) async {
    final doc = pw.Document(theme: pdfTheme);
    final cards = <pw.Widget>[];
    for (final j in jornadas) {
      final lots = j.lots;
      if (lots.isEmpty) {
        throw StateError('La jornada ${j.row['fecha']} no tiene lotes.');
      }
      for (var i = 0; i < lots.length; i++) {
        final reels = i == 0 ? j.reels : <RowData>[];
        // Eleven reel rows per form; extra reels continue without repeating global values.
        final pages = reels.isEmpty ? 1 : (reels.length / 11).ceil();
        for (var p = 0; p < pages; p++) {
          cards.add(
            productionForm(
              j,
              lots[i],
              i == 0 && p == 0,
              reels.skip(p * 11).take(11).toList(),
              continuation: p > 0,
            ),
          );
        }
      }
    }
    for (var i = 0; i < cards.length; i += formsPerPage) {
      doc.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(24),
          build: (_) => pw.Column(
            children: [
              for (final card in cards.skip(i).take(formsPerPage)) ...[
                pw.SizedBox(height: formsPerPage == 2 ? 385 : 740, child: card),
                if (formsPerPage == 2) pw.SizedBox(height: 12),
              ],
            ],
          ),
        ),
      );
    }
    return doc.save();
  }

  static pw.Widget productionForm(
    Production j,
    RowData lot,
    bool globals,
    List<RowData> reels, {
    bool continuation = false,
  }) {
    String val(String k) => globals ? '${j.row[k] ?? ''}' : '';
    pw.Widget cell(String text, {bool bold = false}) => pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 3, vertical: 3),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 7,
          color: PdfColors.black,
          fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
      ),
    );
    pw.Widget table(
      List<List<String>> rows, {
      Map<int, pw.TableColumnWidth>? widths,
    }) => pw.Table(
      border: pw.TableBorder.all(color: PdfColors.black, width: .5),
      columnWidths: widths,
      children: rows
          .map((r) => pw.TableRow(children: r.map((s) => cell(s)).toList()))
          .toList(),
    );
    final left = j.isCookies
        ? <List<String>>[
            ['ÁREA DE CRUDO', ''],
            ['MERMA PISO CRUDO', val('merma_piso_crudo')],
            ['AMASADO', ''],
            ['N° BATCH', val('cant_batch')],
            ['MERMA MÁQUINA', val('merma_maquina')],
            ['ÁREA COCIDO / MERMAS', ''],
            ['QUEMADOS', val('quemados')],
            [
              'CAJA, BLANCOS Y ROTOS',
              globals
                  ? '${j.row['caja_blanco_rotos'] ?? j.row['caja'] ?? ''}'
                  : '',
            ],
            ['PISO', val('merma_piso_cocido')],
            ['CINTA EMBALAJE', val('cinta_embalaje')],
            ['TAMPÓN', val('tampon')],
            ['MERMA BOBINA', val('merma_bobinas')],
          ]
        : <List<String>>[
            ['JARABE', ''],
            ['N° BATCH', val('batch_jarabe')],
            ['DOSIMETRÍA MAYOR', ''],
            ['N° TINAS', val('cant_tinas')],
            ['SACOS EXTRUIDO TOLVA', val('cant_extruido_tolva')],
            ['SACOS POP QUINUA', val('pop_quinua_dosimetria')],
            ['MEZCLADO', ''],
            ['CAJAS PASAS UTILIZADAS', val('cajas_pasas')],
            ['SACOS POP KIWICHA', val('pop_kiwicha')],
            ['SACOS POP QUINUA', val('pop_quinua')],
            ['CINTA DE EMBALAJE', val('cinta_embalaje')],
            ['TAMPÓN', val('tampon')],
          ];
    final body = <List<String>>[];
    for (var r = 0; r < 12; r++) {
      final reel = r > 0 && r - 1 < reels.length ? reels[r - 1] : null;
      body.add([
        ...left[r],
        if (r == 0) ...[
          'PESO BRUTO',
          'PESO NETO',
          'TUCO + ENVOL',
          'SOBRA BOBINA',
        ] else ...[
          for (final k in [
            'peso_bruto',
            'peso_neto',
            'tuco_envoltorio',
            'sobra_bobina',
          ])
            '${reel?[k] ?? ''}',
        ],
      ]);
    }
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        table(
          [
            [
              'M&D',
              'INFORME DE PRODUCCIÓN',
              'LÍNEA ${j.isCookies ? 'GALLETERA' : 'DE BARRAS'}',
            ],
          ],
          widths: {
            0: const pw.FlexColumnWidth(1),
            1: const pw.FlexColumnWidth(3),
            2: const pw.FlexColumnWidth(2),
          },
        ),
        table(
          [
            ['INGENIERO A CARGO', j.supervisor],
            [
              'FECHA: ${j.row['fecha']}',
              'TURNO: ${j.row['turno']}${continuation ? ' - CONTINUACIÓN BOBINAS' : ''}',
            ],
          ],
          widths: {
            0: const pw.FlexColumnWidth(2),
            1: const pw.FlexColumnWidth(4),
          },
        ),
        pw.SizedBox(height: 5),
        table(
          [
            [
              'PRODUCTO',
              j.product(lot),
              'INICIO ENVASADO',
              val('hora_inicio_envasado'),
            ],
            ['LOTE', '${lot['numero_lote']}', 'PRODUCTO', j.product(lot)],
            [
              'PRESENTACIÓN',
              '${lot['presentacion'] ?? ''}',
              'PRESENTACIÓN',
              '${lot['presentacion'] ?? ''}',
            ],
            [
              'CANTIDAD DE CAJAS',
              continuation ? '' : '${lot['cantidad']}',
              'N° BOBINAS',
              globals ? '${j.reels.length}' : '',
            ],
          ],
          widths: {
            0: const pw.FlexColumnWidth(1.4),
            1: const pw.FlexColumnWidth(1.6),
            2: const pw.FlexColumnWidth(1.3),
            3: const pw.FlexColumnWidth(1.7),
          },
        ),
        pw.SizedBox(height: 5),
        table(
          body,
          widths: {
            0: const pw.FlexColumnWidth(2.3),
            1: const pw.FlexColumnWidth(.7),
            for (var i = 2; i < 6; i++) i: const pw.FlexColumnWidth(1),
          },
        ),
        if (!j.isCookies)
          table([
            [
              'MERMA BOBINAS',
              val('merma_bobinas'),
              'MERMA PISO',
              val('merma_piso'),
              'MERMA MÁQUINA',
              val('merma_maquina'),
            ],
          ]),
        pw.Expanded(
          child: pw.Container(
            decoration: pw.BoxDecoration(border: pw.Border.all(width: .5)),
            padding: const pw.EdgeInsets.all(4),
            child: pw.Text(
              'OBSERVACIONES: ${globals ? j.row['observaciones'] ?? '' : ''}',
              style: const pw.TextStyle(fontSize: 8),
            ),
          ),
        ),
      ],
    );
  }

  static Uint8List productionExcel(List<Production> jornadas) {
    final book = Excel.createExcel();
    book.rename('Sheet1', 'Jornadas');
    final s = book['Jornadas'];
    s.appendRow([TextCellValue('INFORME DE PRODUCCIÓN')]);
    final headers = [
      'Fecha',
      'Turno',
      'Línea',
      'Supervisor',
      'Lote',
      'Producto',
      'Presentación',
      'Cajas',
      'Batches jornada',
      'Merma alimentaria kg',
      'Merma bobinas kg',
      'Rendimiento %',
    ];
    s.appendRow(headers.map(TextCellValue.new).toList());
    for (final j in jornadas) {
      for (var i = 0; i < j.lots.length; i++) {
        final l = j.lots[i];
        s.appendRow([
          TextCellValue('${j.row['fecha']}'),
          TextCellValue('${j.row['turno']}'),
          TextCellValue('${j.row['tipo']}'),
          TextCellValue(j.supervisor),
          TextCellValue('${l['numero_lote']}'),
          TextCellValue(j.product(l)),
          TextCellValue('${l['presentacion']}'),
          IntCellValue(number(l['cantidad']).toInt()),
          i == 0 ? DoubleCellValue(number(j.row['cant_batch'])) : null,
          i == 0 ? DoubleCellValue(j.waste) : null,
          i == 0 ? DoubleCellValue(number(j.row['merma_bobinas'])) : null,
          i == 0 && j.yieldPercent != null
              ? DoubleCellValue(j.yieldPercent!)
              : null,
        ]);
      }
    }
    for (var i = 0; i < headers.length; i++) {
      s.setColumnWidth(i, i == 3 || i == 5 ? 35 : 20);
    }
    styleSheet(s, headers.length);
    return Uint8List.fromList(book.encode()!);
  }
}
