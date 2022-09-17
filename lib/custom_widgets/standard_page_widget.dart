import 'package:flutter/material.dart';

import '../ui/ui_constants/ui_constants.dart';

class StandardPageWidget extends StatelessWidget {
  final Widget child;
  final bool showAppbar;
  final bool? willPop;
  final String? appBarTitle;
  final List<Widget>? appbarActions;
  final Function? onPop;
  final Drawer? drawer;

  const StandardPageWidget({
    Key? key,
    required this.child,
    this.showAppbar = true,
    this.willPop,
    this.appBarTitle,
    this.appbarActions,
    this.onPop,
    this.drawer,
  })  : _willPop = willPop ?? true,
        super(key: key);

  final bool _willPop;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (_willPop && Navigator.canPop(context)) {
          Navigator.pop(context);
        }
        onPop != null ? onPop!() : () {};
        return Future.value(false);
      },
      child: Scaffold(
        endDrawer: drawer,
        appBar: showAppbar
            ? AppBar(
                leading: (_willPop && Navigator.canPop(context))
                    ? GestureDetector(
                        child: const SizedBox(
                            height: UiConstantsSize.xlarge,
                            width: UiConstantsSize.xlarge,
                            child: Icon(Icons.arrow_back)),
                        onTap: () {
                          Navigator.pop(context);
                          onPop != null ? onPop!() : () {};
                        })
                    : Container(),
                title: appBarTitle != null
                    ? Text(
                        appBarTitle!,
                        style: Theme.of(context).textTheme.headline1?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary),
                      )
                    : null,
                actions: appbarActions,
              )
            : null,
        body: child,
      ),
    );
  }
}
