import 'dart:async';

import 'package:flutter/material.dart';
import 'package:testing_bloc_course/dialogs/loading_screen_controller.dart';

class LoadingScreen {
  // singleton pattern
  LoadingScreen._();
  static final LoadingScreen _instance = LoadingScreen._();
  factory LoadingScreen.instance() => _instance;

  LoadingScreenController? _controller;

  void show({required BuildContext context, required String text}) {
    var canShow = _controller == null || _controller?.update(text) == false;

    if(canShow) {
      _controller = _showOverlay(context: context, text: text);
    }
    else {
      return;
    }
  }

  void hide() {
    _controller?.close();
    _controller = null;
  }

  LoadingScreenController _showOverlay({required BuildContext context, required String text}) {
    final textStream = StreamController<String>();
    textStream.add(text);

    // get the screen size
    final state = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    final overlay = OverlayEntry(
      builder: (context) {
        return Material(
          color: Colors.black.withAlpha(150),
          child: Center(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: size.width * 0.8,
                maxHeight: size.height * 0.8,
                minWidth: size.width * 0.5,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0)
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),
                      const CircularProgressIndicator(),
                      const SizedBox(height: 20),
                      StreamBuilder<String>(
                        stream: textStream.stream,
                        builder: (context, snapshot) {
                          if(snapshot.hasData) {
                            return Text(snapshot.data!, textAlign: TextAlign.center);
                          }
                          else {
                            return Container();
                          }
                        }
                      )
                    ],
                  ),
                )
              ),
            )
          ),
        );
      }
    );

    state.insert(overlay);

    return LoadingScreenController(
      close: () {
        textStream.close();
        overlay.remove();

        return true;
      },
      update: (text) {
        textStream.add(text);

        return true;
      }
    );
  }
}