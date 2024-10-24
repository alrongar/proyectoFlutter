import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String routeName;
  final String buttonText;

  const CustomButton(
      {required this.routeName,
      super.key,
      required this.buttonText,
      required Null Function() onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        assert(
          _routeExists(context, routeName),
          'La ruta $routeName no se encuentra en el Navigator.',
        );
        Navigator.pushNamed(context, routeName);
      },
      child: Text(buttonText),
    );
  }

  bool _routeExists(BuildContext context, String routeName) {
    final routes =
        Navigator.of(context).widget.pages.map((page) => page.name).toList();
    return routes.contains(routeName);
  }
}
