import 'package:febno_pulse/screens/employees_screen.dart';
import 'package:febno_pulse/screens/home_screen.dart';
import 'package:febno_pulse/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNavBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final items =const [
            (Icons.home_rounded, 'Home'),
            (Icons.calendar_month_outlined, 'Attendance'),
            (Icons.person_outline, 'Profile'),
          ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      child: Container(
        height: 72,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(
            items.length,
            (index) => _NavItem(
              icon: items[index].$1,
              title: items[index].$2,
              selected: currentIndex == index,
              onTap: () => _navigate(context, index),
              primaryColor: cs.primary,
            ),
          ),
        ),
      ),
    );
  }

  void _navigate(BuildContext context, int index) {
    if (index == currentIndex) return;


    Widget screen;

 
      switch (index) {
        case 0:
          screen =  HomeScreen();
          break;
        case 1:
       
          screen =  AttendanceScreen();
          break;
      
        case 2:
          screen =  ProfileScreen();
          break;
        default:
          return;
      }
    

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool selected;
  final VoidCallback onTap;
  final Color primaryColor;

  const _NavItem({
    required this.icon,
    required this.title,
    required this.selected,
    required this.onTap,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: selected
                  ? Theme.of(context).colorScheme.primary
                  : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: selected ? Colors.white : Colors.grey),
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: selected ? primaryColor : Colors.grey,
              fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
