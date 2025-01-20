import 'dart:ffi';

import 'package:flutter/material.dart';

class CardGoal extends StatelessWidget {
  CardGoal(
      {super.key,
      required this.NAMEOFCATE,
      required this.Price,
      required this.progress});
  final String NAMEOFCATE;
  final String Price;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      child: Container(
        height: 100,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                // أيقونة الفئة
                Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                      Icons.gif_outlined), // تأكد من أن الأيقونة ليست فارغة
                ),
                const SizedBox(width: 16),
                // النصوص (اسم الفئة والقيمة)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // اسم الفئة
                    Text(
                      NAMEOFCATE,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF264653),
                      ),
                    ),
                    const SizedBox(height: 4),
                    // القيمة
                    Text(
                      Price,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.red,
                      ),
                    ),
                    LinearProgressIndicator(
                      value: progress,
                      backgroundColor: const Color(0xFFE5E5EA),
                      valueColor: AlwaysStoppedAnimation<Color>(
                          const Color(0xFF0A84FF)),
                    ),
                  ],
                ),
              ],
            ),
            // زر الحذف
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(Icons.search_sharp),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
