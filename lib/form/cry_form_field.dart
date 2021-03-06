import 'package:cry/utils/adaptive_util.dart';
import 'package:flutter/material.dart';

class CryFormField extends StatefulWidget {
  final String label;
  final double width;
  final double labelWidth;
  final Function builder;
  final double padding;
  final bool border; // 是否有边框

  CryFormField({
    Key key,
    this.label,
    this.builder,
    this.width,
    this.labelWidth,
    this.padding,
    this.border,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => CryFormFieldState();
}

class CryFormFieldState extends State<CryFormField> {
  didChange() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var displayDesktop = isDisplayDesktop(context);
    if (!displayDesktop || widget.width == null || widget.width == 0) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        child: Row(
          children: <Widget>[
            widget.label != null && widget.label.length > 0
                ? SizedBox(
                    width: widget.labelWidth ?? 100,
                    child: Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: Align(
                        child: Text(widget.label),
                        alignment: Alignment.centerRight,
                      ),
                    ),
                  )
                : Container(),
            Expanded(
              child: widget.builder(this),
            )
          ],
        ),
      );
    } else {
      double boxWidth = (widget.width ?? 300) - (widget.labelWidth ?? 100);
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: UnconstrainedBox(
          child: Row(
            children: <Widget>[
              SizedBox(
                width: widget.labelWidth ?? 100,
                child: Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: Align(
                    child: Text(widget.label),
                    alignment: Alignment.centerRight,
                  ),
                ),
              ),
              SizedBox(
                width: boxWidth,
                child: widget.builder(this),
              ),
            ],
          ),
        ),
      );
    }
  }
}
