import 'package:flutter/material.dart';
import 'package:frontend_helpdesk/constants/Theme.dart';

class CardCategory extends StatelessWidget {
  const CardCategory({
    Key? key,
    this.title = "Placeholder Title",
    this.img = "https://via.placeholder.com/250",
    this.tap,
  }) : super(key: key);

  final String img;
  final VoidCallback? tap; // Use VoidCallback for better type safety
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 252,
      width: double.infinity, // Use double.infinity for full width
      child: GestureDetector(
        onTap: tap ?? () => print("The function works!"), // Default function
        child: Card(
          elevation: 0.4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(6.0)),
          ),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(6.0)),
                  image: DecorationImage(
                    image: NetworkImage(img),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.all(Radius.circular(6.0)),
                ),
              ),
              Center(
                child: Text(
                  title,
                  style: TextStyle(
                    color: ArgonColors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 18.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
