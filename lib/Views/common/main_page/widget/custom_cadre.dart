import 'package:flutter/material.dart';

import '../../../../../widgets/customtext.dart';

class CustomCadre extends StatefulWidget {
  final String imagePath;
  final String titreCadre;
  final Function()? onTap;
  const CustomCadre(
      {Key? key, required this.imagePath, required this.titreCadre, required this.onTap})
      : super(key: key);

  @override
  State<CustomCadre> createState() => _CustomCadreState();
}

class _CustomCadreState extends State<CustomCadre> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      hoverColor:  Colors.transparent,
      onHover: (value) {
        setState(() {
          _hovered = value;
        });
      },
      onTap: widget.onTap,
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedCustomCadre(
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right:8.0,left:8.0,bottom: 12.0,top:3),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(200)),
                        padding: const EdgeInsets.only(right:8.0,left:8.0,bottom: 12.0,top:3),
                      child: AnimatedCrossFade(firstChild:ClipOval(
                        child: Image.asset(
                          widget.imagePath,
                          width: 155,
                          height: 155,
                          fit: BoxFit.cover,
                        ),
                      ), secondChild:Container(
                        height: 145,
                        width: 145,
                        decoration:BoxDecoration(
                          color:Colors.black54,
                          borderRadius: BorderRadius.circular(200)
                        ),
                        child:Center(
                          child:Text(
                            widget.titreCadre,style:TextStyle(
                            fontWeight: FontWeight.bold,fontSize:34,color:Colors.white
                          )
                          )
                        ),
                      ), crossFadeState:_hovered?CrossFadeState.showSecond:CrossFadeState.showFirst,
                          duration:Duration(milliseconds: 500))
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class OutlinedCustomCadre extends StatefulWidget {
  const OutlinedCustomCadre({
    Key? key,
    required this.child,
    this.clickable = true,
  }) : super(key: key);
  final Widget child;
  final bool clickable;
  @override
  State<OutlinedCustomCadre> createState() => _OutlinedCustomCadreState();
}

class _OutlinedCustomCadreState extends State<OutlinedCustomCadre> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(_hovered ? 150 : 8);
    const animationCurve = Curves.easeInOut;
    return MouseRegion(
      onEnter: (_) {
        if (!widget.clickable) return;
        setState(() {
          _hovered = true;
        });
      },
      onExit: (_) {
        if (!widget.clickable) return;
        setState(() {
          _hovered = false;
        });
      },
      cursor: widget.clickable
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      child: AnimatedContainer(
        duration: kThemeAnimationDuration,
        curve: animationCurve,
        decoration: BoxDecoration(
          border: Border.all(
            color: _hovered
                ? Theme.of(context).colorScheme.outline
                : Colors.transparent,
            width: 1,
          ),
          borderRadius: borderRadius,
        ),
        foregroundDecoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(
            _hovered ? 0.12 : 0,
          ),
          borderRadius: borderRadius,
        ),
        child: TweenAnimationBuilder<BorderRadius>(
          duration: kThemeAnimationDuration,
          curve: animationCurve,
          tween: Tween(begin: BorderRadius.zero, end: borderRadius),
          builder: (context, borderRadius, child) => ClipRRect(
            clipBehavior: Clip.antiAlias,
            borderRadius: borderRadius,
            child: child,
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
