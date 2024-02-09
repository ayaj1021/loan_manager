import 'package:flutter/material.dart';
import 'package:loan_manager/styles/colors.dart';

class BusyOverlay extends StatelessWidget {
  const BusyOverlay({
    Key? key,
    this.child,
    this.title = 'Please wait...',
    this.show = false,
    this.height = 0,
    this.opacity = 0.7,
  }) : super(key: key);
  final Widget? child;
  final String title;
  final bool show;
  final int height;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: <Widget>[
          child!,
          IgnorePointer(
            ignoring: !show,
            child: Opacity(
              opacity: show ? 1.0 : 0.0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                alignment: Alignment.center,
                color: whiteColor.withOpacity(opacity),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const SizedBox(
                      height: 50,
                      width: 50,
                      child: CircularProgressIndicator(
                        color: greyColor,
                        backgroundColor: primaryColor,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(title,
                        style: const TextStyle(
                          color: primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        )),
                    SizedBox(
                      height: height.toDouble(),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
