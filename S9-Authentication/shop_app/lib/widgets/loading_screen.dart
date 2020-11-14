import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  final Scaffold child;
  final bool status;

  const LoadingScreen({
    @required this.child,
    @required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return status
        ? new AbsorbPointer(
            child: Stack(
              children: [
                new Opacity(
                  opacity: 0.5,
                  child: child,
                ),
                new Center(
                  child: new Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 72,
                      vertical: 56,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.85),
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(1, 1),
                          blurRadius: 2,
                          color: Colors.black54,
                          spreadRadius: 0,
                        )
                      ],
                    ),
                    child: SizedBox(
                      width: 48,
                      height: 48,
                      child: new CircularProgressIndicator(
                        strokeWidth: 5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        : child;
  }
}
