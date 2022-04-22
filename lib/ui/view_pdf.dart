
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ViewPdf extends StatefulWidget {
  String text;
  ViewPdf({required this.text});
  @override
  _ViewPdfState createState() => _ViewPdfState(this.text);
}

class _ViewPdfState extends State<ViewPdf> {
  String? docurl;
  _ViewPdfState(String text) {
    docurl = text;
  }
  bool _isLoading = true;
  PDFDocument document=PDFDocument();

  @override
  void initState() {
    super.initState();
    loadDocument();
  }

  loadDocument() async {
    document = await PDFDocument.fromURL(docurl!);
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[900],
      child: _isLoading
          ? Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.grey[800],
        ),
      )
          : PDFViewer(
        document: document,
        indicatorText: Colors.grey,
        pickerIconColor: Colors.teal,
        pickerButtonColor: Colors.grey[800],
        zoomSteps: 1,
      ),
    );
  }
}