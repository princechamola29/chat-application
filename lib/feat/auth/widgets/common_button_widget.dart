import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CommonButtonWidget extends StatelessWidget {
  final String title;
  final VoidCallback onTab;
  final bool isLoading;

  const CommonButtonWidget({
    super.key,
    required this.onTab,
    required this.title,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
        onPressed: onTab,
        child:
            isLoading
                ? SizedBox(
                  height: 15,
                  width: 15,
                  child: CircularProgressIndicator(color: Colors.white),
                )
                : Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
      ),
    );
  }
}
