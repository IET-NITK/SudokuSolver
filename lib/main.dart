// @dart=2.9

import 'dart:io';
import 'package:document_scanner_flutter/configs/configs.dart';
import 'package:document_scanner_flutter/document_scanner_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_ml_vision/google_ml_vision.dart';
import 'package:sudoku/about_us.dart';
import 'package:sudoku/instructions.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sudoku App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: "Serif",
      ),
      home: const MyHomePage(title: 'Sudoku Solver'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({
    key,
    this.title,
  }) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

//current index in the home page. 0 indicates the 1st tab(Camera). 1 indicates the 2nd tab(Fill)
int current_index = 0;

//list to indicate which cell in sudoku is currently selected
List l = List.generate(9, (i) => List.generate(9, (i) => 0));
//list to store elements of sudoku puzzle. 0 indicates empty cell
List l1 = List.generate(9, (i) => List.generate(9, (i) => 0));

// function to check if the given input sudoku is a valid sudoku or not
bool isValidSudoku(board) {
  List rows = [[], [], [], [], [], [], [], [], []];
  List cols = [[], [], [], [], [], [], [], [], []];
  List blocks = [[], [], [], [], [], [], [], [], []];

  for (int i = 0; i < 9; i++) {
    for (int j = 0; j < 9; j++) {
      if (board[i][j] == 0) continue;

      int curr = board[i][j];

      if (rows[i].contains(curr) ||
          cols[j].contains(curr) ||
          blocks[((i ~/ 3) * 3 + j ~/ 3).round()].contains(curr)) return false;

      rows[i].add(curr);
      cols[j].add(curr);
      blocks[((i ~/ 3) * 3 + j ~/ 3).round()].add(curr);
    }
  }

  return true;
}

//function to check if the value is valid at position i,j
bool isValid(board, int i, int j, int val) {
  int row = i - i % 3, column = j - j % 3;
  for (int x = 0; x < 9; x++) if (board[x][j] == val) return false;
  for (int y = 0; y < 9; y++) if (board[i][y] == val) return false;
  for (int x = 0; x < 3; x++)
    for (int y = 0; y < 3; y++)
      if (board[row + x][column + y] == val) return false;
  return true;
}

//function to solve the sudoku puzzle
bool solveSudoku(board, int i, int j) {
  if (i == 9) return true;
  if (j == 9) return solveSudoku(board, i + 1, 0);
  if (board[i][j] != 0) return solveSudoku(board, i, j + 1);

  for (int c = 1; c <= 9; c++) {
    if (isValid(board, i, j, c)) {
      board[i][j] = c;
      l1[i][j] = c;
      if (solveSudoku(board, i, j + 1)) {
        return true;
      }
      board[i][j] = 0;
    }
  }

  return false;
}

class _MyHomePageState extends State<MyHomePage> {
  Widget w1 = Text(
      ""); //widget used to show loading text when google ml vision is in use
  Widget w2 = Text("1");
  Widget w3=Text("123");
  List index = [];
  int in1 = -1, in2 = -1;
  String image_text = "";
  int st = 0;
  File _imageFile;

  //function to pick an image from gallery
  Future<void> fromGallery() async {
    try {
      File scannedDoc = await DocumentScannerFlutter.launch(
        context,
        source: ScannerFileSource.GALLERY,
      );
      // `scannedDoc` will be the image file scanned from scanner
      if (scannedDoc != null) {
        setState(() {
          this._imageFile = scannedDoc;
        });
      }
    } on PlatformException {
      // 'Failed to get document path or operation cancelled!';
    }
  }

  //function to pick an image from camera
  Future<void> fromCamera() async {
    try {
      File scannedDoc = await DocumentScannerFlutter.launch(
        context,
        source: ScannerFileSource.CAMERA,
      );
      // `scannedDoc` will be the image file scanned from scanner
      if (scannedDoc != null) {
        setState(() {
          this._imageFile = scannedDoc;
        });
      }
    } on PlatformException {
      // 'Failed to get document path or operation cancelled!';
    }
  }

  @override
  void initState() {
    super.initState();
  }

  double image_height;
  double image_width;

  @override
  Widget build(BuildContext context) {
    final TabPages = <Widget>[
      //Tab 1: Camera
      Container(
        child: ListView(
          children: [
            ButtonBar(children: [
              IconButton(
                icon: const Icon(Icons.photo_camera, color: Colors.white),
                onPressed: () async => fromCamera(),
              ),
              IconButton(
                icon: const Icon(Icons.photo, color: Colors.white),
                onPressed: () async => fromGallery(),
              )
            ]),
            if (this._imageFile == null)
              Container(
                  width: MediaQuery.of(context).size.width,
                  child: Image.asset("assets/default.jpg"))
            else
              Image.file(this._imageFile),
            ElevatedButton(
              onPressed: () async {
                w1 = Center(
                  child: CircularProgressIndicator(

                  )
                );
                setState(() {});
                if (_imageFile != null) {
                  try {
                    var d_image =
                        await decodeImageFromList(_imageFile.readAsBytesSync());
                    image_width = (d_image.width).toDouble();
                    image_height = (d_image.height).toDouble();

                    final GoogleVisionImage visionImage =
                        GoogleVisionImage.fromFile(_imageFile);
                    final TextRecognizer textRecognizer =
                        GoogleVision.instance.textRecognizer();
                    final VisionText visionText =
                        await textRecognizer.processImage(visionImage);
                    String text = visionText.text;
                    image_text = "";
                    l1 = List.generate(9, (i) => List.generate(9, (i) => 0));

                    for (TextBlock block in visionText.blocks) {
                      final Rect boundingBox = block.boundingBox;

                      final List<Offset> cornerPoints = block.cornerPoints;
                      final String text = block.text;
                      final List<RecognizedLanguage> languages =
                          block.recognizedLanguages;

                      for (TextLine line in block.lines) {
                        // Same getters as TextBlock

                        for (TextElement element in line.elements) {
                          // Same getters as TextBlock

                          image_text = image_text +
                              "| ${element.text} |" +
                              "@ ${element.boundingBox} "; //this line only for debug process
                          int i = 0;
                          int j = 0;
                          double ii = double.parse(
                              (element.boundingBox.right / image_width * 9)
                                  .toStringAsFixed(2));
                          double jj = double.parse(
                              (element.boundingBox.bottom / image_height * 9)
                                  .toStringAsFixed(2));
                          i = (element.boundingBox.right / image_width * 9)
                                  .round() -
                              1;
                          j = (element.boundingBox.bottom / image_height * 9)
                                  .round() -
                              1;
                          if (i < 0) i = 0;
                          if (j < 0) j = 0;
                          int e;
                          try {
                            e = int.parse(element.text.toString());
                            e=e%10;

                          } catch (e) {
                            image_text = image_text + "\n";
                            continue;
                          }
                          if (l1[j][i] == 0) {
                            l1[j][i] = e;
                            index.add(10 * (j + 1) + i + 1);
                          } else {
                            int t = l1[j][i];
                            l1[j][i] = e;
                            try {
                              l1[j][i - 1] = t;
                            }
                            catch(e)
                {

                }
                            index.add(10 * (j + 1) + i);
                          }
                          image_text = image_text + "  $ii  $jj\n";
                        }
                      }
                    }
                    image_text =
                        image_text + "$image_height  ,  $image_width  ";
                    //image_text=image_text+(l.toString());
                    textRecognizer.close();
                    current_index = 1;

                    setState(() {});
                  } catch (e) {
                    image_text = e.toString();
                    setState(() {});
                  }
                }
                setState(() {
                  w1 = Text("");
                });
              },
              child: Text("OK"),
            ),
            w1,
            //Text(image_text), //comment this line when building app. Only for debugging
          ],
        ),
      ),
      //Tab 2: Edit/Manual Input
      ListView(
          //crossAxisAlignment: CrossAxisAlignment.stretch,

          children: [
            SizedBox(height: 20),
            for (int j = 0; j < 9; j++)
              Container(
                height: MediaQuery.of(context).size.width / 10,
                child: Row(children: [
                  SizedBox(width: 10),
                  for (int i = 0; i < 9; i++)
                    Expanded(
                      child: Container(
                        padding: ((i + 1) % 3 == 0 && i != 8)
                            ? ((j + 1) % 3 == 0 && j != 8)
                                ? EdgeInsets.fromLTRB(0, 0, 2, 2)
                                : EdgeInsets.fromLTRB(0, 0, 2, 0)
                            : ((j + 1) % 3 == 0 && j != 8)
                                ? EdgeInsets.fromLTRB(0, 0, 0, 2)
                                : EdgeInsets.all(0),
                        color: Colors.transparent,
                        child: ElevatedButton(
                            autofocus: true,
                            child: Center(
                              child: (l1[j][i] != 0)
                                  ? (!index.contains((j + 1) * 10 + i + 1))
                                      ? Text("${l1[j][i]}",
                                          style: TextStyle(
                                            color: Colors.indigo,
                                            fontSize: 28,
                                          ))
                                      : Text("${l1[j][i]}",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 28,
                                          ))
                                  : Text(""),
                            ),
                            onPressed: (() {
                              setState(() {
                                int e = l[j][i];
                                l = List.generate(
                                    9, (i) => List.generate(9, (i) => 0));
                                (e == 0) ? l[j][i] = 1 : l[j][i] = 0;
                                if (l[j][i] == 1) {
                                  in1 = j;
                                  in2 = i;
                                } else {
                                  in1 = -1;
                                  in2 = -1;
                                }
                              });
                            }),
                            style: ElevatedButton.styleFrom(
                                side: BorderSide(color: Colors.black),
                                primary: (l[j][i] == 0)
                                    ? Colors.white
                                    : Colors.yellow,
                                shadowColor: Colors.black)),
                      ),
                    ),
                  SizedBox(width: 10),
                ]),
              ),
            SizedBox(height: 10),
            Container(
                height: MediaQuery.of(context).size.height / 13,
                child: Row(children: [
                  for (int k = 0; k < 9; k++)
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(2),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              if (in1 != -1 && in2 != -1) {
                                l1[in1][in2] = k + 1;
                                index.add(10 * (in1 + 1) + in2 + 1);
                                //in1=-1;
                                //in2=-1;
                              }
                            });
                          },
                          child: Text(
                            "${k + 1}",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    )
                ])),
            SizedBox(height: 5),
            Container(
              height: MediaQuery.of(context).size.height / 13,
              child: Row(children: [
                Expanded(
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
                      child: ElevatedButton(
                          child: Text("Submit"),
                          onPressed: () async {
                            w3= const Center(
                              child: Text(
                                "Loading...",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            );
                            setState(() {});


                            List l2 = l1;
                            //print(index);
                            print("BEFORE");
                            bool t1=await isValidSudoku(l2);
                            bool t2;
                            if(t1)
                             t2=await solveSudoku(l1, 0, 0);
                            else
                              t2=false;
                            print("AFTER");
                            w3 = Text("1");
                            setState(() {});
                            if (t1 & t2) {


                              st = 1;
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: Colors.green,
                                      content: const Text(
                                          "Sudoku successfully solved")));
                            } else {
                              st = -1;
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      backgroundColor: Colors.red,
                                      content: const Text(
                                          "Invalid Input. Failed to solve")));
                            }

                            setState(() {});
                          })),
                ),
                Expanded(
                    child: Padding(
                        padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
                        child: ElevatedButton(
                            child: Text("Clear cell"),
                            onPressed: () {
                              if (in1 != -1 && in2 != -1) {
                                l1[in1][in2] = 0;
                                index.remove(10 * (in1 + 1) + in2 + 1);
                              }
                              setState(() {});
                            }))),
                Expanded(
                    child: Padding(
                        padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
                        child: ElevatedButton(
                            child: Text("Reset"),
                            onPressed: () {
                              l1 = List.generate(
                                  9, (i) => List.generate(9, (i) => 0));
                              index = [];
                              setState(() {});
                            })))
              ]),

            ),

          ])
    ];

    final Tabs = <BottomNavigationBarItem>[
      BottomNavigationBarItem(icon: Icon(Icons.upload_file), label: "Scan/Upload"),
      BottomNavigationBarItem(icon: Icon(Icons.edit), label: "Fill"),
    ];

    final bottom_bar = BottomNavigationBar(
        backgroundColor: Colors.white,
        items: Tabs,
        currentIndex: current_index,
        onTap: (int i) {
          setState(() {
            current_index = i;
          });
        });
    return Stack(
      children: [
        Image.asset(
          "assets/background.png",
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            centerTitle: true ,
            actions:[

                IconButton(onPressed: (){
                     Navigator.push(context,MaterialPageRoute(builder:(context)=>InstructionsPage()));
                  }, icon:Icon(Icons.info)),

    ],
            title: Text(
              "SUDOKU SOLVER",
              style: TextStyle(
                fontFamily: "Serif",
                fontWeight: FontWeight.w600,
              ),
            ),
            backgroundColor: Colors.indigo,
          ),
          body: TabPages[current_index],
          bottomNavigationBar: bottom_bar,
        ),
      ],
    );
  }
}
