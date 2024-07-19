import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomBottonNavigationBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  const CustomBottonNavigationBar({super.key, required this.navigationShell});

  void onItemTapped(index) {
    navigationShell.goBranch(index,
        initialLocation: index == navigationShell.currentIndex);
  }
  

  @override
  Widget build(BuildContext context) {

    final colors = Theme.of(context).colorScheme;

    return Scaffold(
        body: navigationShell,
        bottomNavigationBar: BottomNavigationBar(
          elevation: 0,
          selectedItemColor: colors.primary,
          currentIndex: navigationShell.currentIndex,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_max), label: 'Inicio'),
            BottomNavigationBarItem(
                icon: Icon(Icons.thumbs_up_down_outlined), label: 'Populares'),
            BottomNavigationBarItem(
                icon: Icon(Icons.favorite_outline), label: 'Favoritos')
          ],
          onTap: onItemTapped,
        ));
  }
}
