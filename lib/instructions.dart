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
  String str='''
  # __Instructions on how to use the App__
  ## 1st Tab (Scan/Upload)
  1) You have the option to select the image of the sudoku or capture a photo
     
  2) ..
  ## 2nd Tab (Fill)
  
  
  ''';
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
          ),
        ],
      )
    );
  }
}
