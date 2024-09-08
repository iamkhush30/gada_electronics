import 'package:flutter/material.dart';

enum ButtonState { init , loading , result }

class SubmitButton extends StatefulWidget {
  const SubmitButton({super.key,this.label,required this.function(),this.resultOutput});
  final label;
  final Function function;
  final bool? resultOutput;

  @override
  State<SubmitButton> createState() => _SubmitButtonState();
}

class _SubmitButtonState extends State<SubmitButton> {
  bool isAnimating = true;
  double? width;
  ButtonState state = ButtonState.init;
  @override
  Widget build(BuildContext context) {
    final widthSize = MediaQuery.of(context).size;
    bool isResult = state == ButtonState.result;
    bool isStreched  = isAnimating || state == ButtonState.init;
    print(width);
    return AnimatedContainer(
        duration: Duration(milliseconds: 1000),
        curve: Curves.easeIn,
        width: width = state == ButtonState.init ?  360 : 50 ,
        height: 50 ,
        onEnd: () { setState(() { isAnimating = !isAnimating; }); },
        child: Container(
          width: width,
          child: isStreched ?  buildButton() : buildSmallButton(isResult),
        ),
    );
  }
  Widget buildButton () => OutlinedButton(
    onPressed: () async{
      await Future.delayed(Duration(seconds: 1));
      setState(() => state = ButtonState.loading);
      await Future.delayed(Duration(seconds: 2));
      await widget.function();
      setState(() => state = ButtonState.result);
      await Future.delayed(Duration(seconds: 2));
      setState(() => state = ButtonState.init);
    },
    child: FittedBox(
      child: Text(
        widget.label,
        style: TextStyle(
          fontSize: 20,
          color: Colors.white,
          letterSpacing: 1.5,
          fontWeight: FontWeight.w600,
        )
      ),
    ),
    style: OutlinedButton.styleFrom(
      shape: StadiumBorder(),
      side: BorderSide(width: 2,color: Colors.orange),
      elevation: 3,
      shadowColor: Colors.purple,
      padding: const EdgeInsets.all(12.0),
      backgroundColor: Colors.orange,
    ),
  );

  Widget buildSmallButton(bool isResult){
    final color = isResult ? (widget.resultOutput! ? Colors.green : Colors.redAccent) : Colors.orange;

    return Container(
      decoration: BoxDecoration(shape: BoxShape.circle,color: color),
      child: isResult ? Icon(widget.resultOutput! ? Icons.done : Icons.close,size: 50,color: Colors.white,)
      : SizedBox(
        child: FittedBox(
            child: CircularProgressIndicator(
                color: Colors.white,
                strokeAlign: -2
            ),
            fit: BoxFit.contain
        ),
        height: 50,
        width: 50,),
    );
  }
}
