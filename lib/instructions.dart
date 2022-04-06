import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;
class InstructionsPage extends StatefulWidget {
  const InstructionsPage({Key? key}) : super(key: key);

  @override
  _InstructionsPageState createState() => _InstructionsPageState();
}

class _InstructionsPageState extends State<InstructionsPage> {
  ScrollController controller=ScrollController();

  Widget image(String s)
  {
    return GestureDetector(
      onTap:()=>showImage(context, "$s"),
      child: Hero(
        tag:'hero-tag',
        child: Container(

          height: 250,

          decoration: BoxDecoration(
              image:DecorationImage(
                image:AssetImage("$s"),
                fit:BoxFit.fitHeight,
              )
          ),

        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
          title: Text("Instructions",style: TextStyle(
            fontFamily: "Serif",
            fontWeight: FontWeight.w600,
          ),),
        backgroundColor: Colors.indigo,
      ),

      body:Stack(
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
          ListView(
            children:[
              Center(child: Text("Instructions on how to use the App")),
              Text("1st Tab (Scan/Upload)"),
              Text("1) Click the camera icon to take the photo of the sudoku puzzle and click the photo icon to upload the photo of the sudoku puzzle"),
              GestureDetector(
                onTap:()=>showImage(context, "assets/App_images/1stTab_1.jpeg"),
                child: Hero(
                  tag:'hero-tag',
                  child: Container(

                    height: 250,

                    decoration: BoxDecoration(
                      image:DecorationImage(
                        image:AssetImage("assets/App_images/1stTab_1.jpeg"),
                        fit:BoxFit.fitHeight,
                      )
                    ),

                  ),
                ),
              ),
              Text("2) After that crop out only the sudoku puzzle from the image"),
              Text("Correct cropping:"),
              image("assets/App_images/Correct_crop_1.jpeg"),
              Text("Wrong cropping: "),
              Row(
                children:[
                  Expanded(
                    child: image("assets/App_images/Wrong_crop_1.jpeg")
                  ),
                  Expanded(
                  child:image("assets/App_images/Wrong_crop_2.jpeg")
                  ),
                ]
              ),
              Text("3) Once the cropped sudoku puzzle is obtained click 'Save' and then 'Ok'"),
              Row(
                  children:[
                    Expanded(
                      child: image("assets/App_images/Crop_1.jpeg")
                    ),
                    Expanded(
                      child:image("assets/App_images/1stTab_2.jpeg")
                    ),
                  ]
              ),
              Text("4)The numbers are scanned and the filled sudoku is displayed on the next tab"),
              Text(" 2nd Tab (Fill)"),
              Text("1)Necessary changes can be made in the sudoku if the wrong numbers are scanned and displayed"),
              image("assets/App_images/Fill_1.jpeg"),
              Text("2)After cross verifying the numbers displayed and the sudoku in the image click the 'Submit' button"),
              image("assets/App_images/Fill_2.jpeg"),
              Text("3)The solved sudoku gets dsplayed after a few seconds"),
              image("assets/App_images/Fill_3.jpeg")



            ]
          )
        ],
      )
    );
  }
}
void showImage(BuildContext context,String s){
  Navigator.of(context).push(
    MaterialPageRoute(builder: (ctx)=>Scaffold(
      body:Center(
        child:Hero(
          tag: 'hero-tag',
          child: Image.asset("$s",width: 300),
        )
      )
    ))
  );
}
