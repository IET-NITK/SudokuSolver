import 'package:flutter/material.dart';

class InstructionsPage extends StatefulWidget {
  const InstructionsPage({Key? key}) : super(key: key);

  @override
  _InstructionsPageState createState() => _InstructionsPageState();
}

class _InstructionsPageState extends State<InstructionsPage> {
  ScrollController controller = ScrollController();

  Widget image(String s) {
    return GestureDetector(
      onTap: () => showImage(context, "$s"),
      child: Hero(
        tag: 'hero-tag',
        child: Container(
          height: 250,
          decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("$s"),
                fit: BoxFit.fitHeight,
              )),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Instructions",
            style: TextStyle(
              fontFamily: "Serif",
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: Colors.indigo,
        ),
        body: Stack(
          children: [
            Image.asset(
              "assets/background.png",
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
            /*
          Scrollbar(
            child:

              Markdown(
                controller: controller,
                selectable: true,
                data: str,
                extensionSet: md.ExtensionSet(
                  md.ExtensionSet.gitHubFlavored.blockSyntaxes,
                  [md.EmojiSyntax(), ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes],
                ),
              )
            ,
          ),*/
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView(children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Instructions on how to use the App",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: MediaQuery.of(context).size.width * 0.05,
                      ),
                    ),
                  ),
                ),
                Text(
                  "1st Tab (Scan/Upload)",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: MediaQuery.of(context).size.width * 0.04,
                    fontWeight:FontWeight.w600,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "1) Click the camera icon to take the photo of the sudoku puzzle and click the photo icon to upload the photo of the sudoku puzzle",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () =>
                      showImage(context, "assets/App_images/1stTab_1.jpeg"),
                  child: Hero(
                    tag: 'hero-tag',
                    child: Container(
                      height: 250,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/App_images/1stTab_1.jpeg"),
                            fit: BoxFit.fitHeight,
                          )),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "2) After that crop out only the sudoku puzzle from the image",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Correct cropping:",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                image("assets/App_images/Correct_crop_1.jpeg"),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Wrong cropping: ",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(children: [
                  Expanded(child: image("assets/App_images/Wrong_crop_1.jpeg")),
                  Expanded(child: image("assets/App_images/Wrong_crop_2.jpeg")),
                ]),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "3) Once the cropped sudoku puzzle is obtained click 'Save' and then 'Ok'",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(children: [
                  Expanded(child: image("assets/App_images/Crop_1.jpeg")),
                  Expanded(child: image("assets/App_images/1stTab_2.jpeg")),
                ]),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "4) The numbers are scanned and the filled sudoku is displayed on the next tab",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 30,),
                Container(
                  height: 2,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  " 2nd Tab (Fill)",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: MediaQuery.of(context).size.width * 0.04,
                    fontWeight:FontWeight.w600,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "1) Necessary changes can be made in the sudoku if the wrong numbers are scanned and displayed",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                image("assets/App_images/Fill_1.jpeg"),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "2) After cross verifying the numbers displayed and the sudoku in the image click the 'Submit' button",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                image("assets/App_images/Fill_2.jpeg"),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "3) The solved sudoku gets dsplayed after a few seconds",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                image("assets/App_images/Fill_3.jpeg"),
                SizedBox(height: 50,)
              ]),
            )
          ],
        ));
  }
}

void showImage(BuildContext context, String s) {
  Navigator.of(context).push(MaterialPageRoute(
      builder: (ctx) => Scaffold(
          body: Center(
              child: Hero(
                tag: 'hero-tag',
                child: Image.asset("$s", width: 300),
              )))));
}