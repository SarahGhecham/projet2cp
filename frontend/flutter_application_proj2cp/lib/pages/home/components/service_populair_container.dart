import 'package:flutter/material.dart';

class ServiceOffreContainer extends StatelessWidget {
  final String image;

  const ServiceOffreContainer({
    super.key,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {}, //afficher service populair
      child: Padding(
        padding: const EdgeInsets.all(9.0),
        child: SizedBox(
            width: 210,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment
                    .start, // Align children to the start of the column
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        Image.asset(
                          image,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
