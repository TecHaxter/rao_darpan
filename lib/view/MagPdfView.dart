import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:rao_darpan/utils/size_config.dart';

class MagPdfView extends StatefulWidget {
  final String url;
  MagPdfView({this.url});
  @override
  _MagPdfViewState createState() => _MagPdfViewState();
}

class _MagPdfViewState extends State<MagPdfView> {
  final _formKey = GlobalKey<FormState>();
  PDFViewController pdfViewController;
  int totalPages = 0;
  int currentPage = 0;

  bool errorOccured = false;
  bool pageError = false;

  // String _validatePageNumber(String input) {
  //   if(input.ca)
  // }

  _showDialog() async {
    await showDialog<String>(
        context: context,
        builder: (context) => new AlertDialog(
              contentPadding: const EdgeInsets.all(16.0),
              content: Form(
                key: _formKey,
                child: new Row(
                  children: <Widget>[
                    new Expanded(
                      child: new TextFormField(
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter a page number';
                          }
                          int input = int.parse(value);
                          if (input <= 0 || input > totalPages) {
                            return 'Please enter a valid page number';
                          }
                          return null;
                        },
                        autofocus: true,
                        onSaved: (value) {
                          int pageNumber = int.parse(value) - 1;
                          pdfViewController.setPage(pageNumber);
                        },
                        decoration: new InputDecoration(
                            labelText: 'Page No.', hintText: 'eg. 5'),
                      ),
                    )
                  ],
                ),
              ),
              actions: <Widget>[
                new FlatButton(
                    child: const Text('CANCEL'),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                new FlatButton(
                    child: const Text('OPEN'),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        Navigator.pop(context);
                      }
                    })
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
          child: Column(
        children: [
          Container(
              width: double.maxFinite,
              height: SizeConfig.screenHeight * 0.8,
              alignment: Alignment.center,
              child: PDF(
                onPageChanged: (_currentPage, _totalPages) {
                  setState(() {
                    this.currentPage = _currentPage + 1;
                  });
                },
                swipeHorizontal: true,
                onError: (error) {
                  setState(() {
                    this.errorOccured = true;
                  });
                },
                onPageError: (page, error) {
                  setState(() {
                    this.pageError = true;
                  });
                },
                onRender: (pageCount) {
                  setState(() {
                    this.totalPages = pageCount;
                  });
                },
                onViewCreated: (controller) {
                  this.pdfViewController = controller;
                },
              ).cachedFromUrl(widget.url,
                  maxAgeCacheObject: Duration(days: 1),
                  maxNrOfCacheObjects: 12,
                  placeholder: (double progress) =>
                      Center(child: Text('$progress %')),
                  errorWidget: (dynamic error) {
                    if (errorOccured)
                      return Text(
                          "Sorry, There is an Error in Loading this file");
                    if (pageError)
                      return Text(
                          "Sorry, There is an Error in Loading this page");
                    return Center(child: Text(error.toString()));
                  })
              //     : Text("Sorry, There is an Error in Loading this Page")
              // : Text("Sorry, There is an Error in Loading this file"),
              ),
          Container(
            width: double.maxFinite,
            height: SizeConfig.screenHeight * 0.09,
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.blockSizeHorizontal * 2.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FlatButton(
                    onPressed: () {
                      if (currentPage != 1) {
                        print("Back");
                        int setPage = currentPage - 2;
                        pdfViewController.setPage(setPage);
                      }
                    },
                    child: Text("Back")),
                FlatButton(
                  onPressed: () {
                    _showDialog();
                  },
                  child: Text(this.currentPage.toString() +
                      " / " +
                      this.totalPages.toString()),
                ),
                FlatButton(
                    onPressed: () {
                      if (currentPage != totalPages) {
                        print("Next");
                        int setPage = currentPage;
                        pdfViewController.setPage(setPage);
                      }
                    },
                    child: Text("Next"))
              ],
            ),
          )
        ],
      )),
    );
  }
}
