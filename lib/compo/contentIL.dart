import 'package:flutter/material.dart';

class ContentLE extends StatelessWidget {
  ContentLE({
    super.key,
    required this.color,
    required this.icon,
    required this.string,
    required this.onpres,
    required this.colorvalue,
    required this.value,
  });

  final Color color;
  final Color colorvalue;
  final Icon icon;
  final String string;
  final dynamic value;
  final VoidCallback onpres;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        height: 100, // زيادة ارتفاع الكونتينر
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
            // الأيقونة والنصوص
            Row(
              children: [
                // أيقونة الفئة
                Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                  child: icon, // تأكد من أن الأيقونة ليست فارغة
                ),
                const SizedBox(width: 16),
                // النصوص (اسم الفئة والقيمة)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // اسم الفئة
                    Text(
                      string,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF264653),
                      ),
                    ),
                    const SizedBox(height: 4),
                    // القيمة
                    Text(
                      value.toString(), // تأكد من أن القيمة ليست فارغة
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: colorvalue,
                      ),
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
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: onpres,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
