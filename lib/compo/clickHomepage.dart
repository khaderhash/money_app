import 'package:flutter/material.dart';

class ButtonHome extends StatelessWidget {
  const ButtonHome({
    super.key,
    required this.ontap,
    required this.name,
  });

  final VoidCallback ontap;
  final String name;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: ontap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.symmetric(vertical: 14),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.black,
            width: 2,
          ),
          gradient: const LinearGradient(
            colors: [Color(0xFF2e495e), Color(0xFF507da0)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF482F37),
              blurRadius: 3,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        width: screenWidth * 0.8,
        child: Text(
          name,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
