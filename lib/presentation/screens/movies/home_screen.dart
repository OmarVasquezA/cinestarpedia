import 'package:flutter/material.dart';

import '../../views/views.dart';

class HomeScreen extends StatelessWidget {
  static const name = "home-screen";

  const HomeScreen({super.key});

  final viewRoutes = const <Widget>[HomeView(), SizedBox(), FavoritesView()];

  @override
  Widget build(BuildContext context) {
    return  Scaffold(body: IndexedStack(children: viewRoutes,));
  }
}
