import 'package:flutter/material.dart';

class Service {
  final String image;
  Service({required this.image});
}

class ServiceOffreContainer extends StatefulWidget {
  final Service service;

  const ServiceOffreContainer({
    Key? key,
    required this.service,
  }) : super(key: key);


  @override
  State<ServiceOffreContainer> createState() => _ServiceOffreContainerState();
}

class _ServiceOffreContainerState extends State<ServiceOffreContainer> {
  @override
  Widget build(BuildContext context) {
    //print('Image URL: ${widget.service.image}');
    return GestureDetector(
      onTap: () => {}, //afficher service populair
      child: Padding(
        padding: const EdgeInsets.all(9.0),
        child: SizedBox(
            width: 210,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment
                  .start, // Align children to the start of the column
              children: [
                Expanded(
                  child: AspectRatio(
                    aspectRatio: 16 / 9, // Adjust aspect ratio as needed
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        widget.service.image,
                        fit: BoxFit
                            .cover, // Maintain aspect ratio within the container
                        width:
                            double.infinity, // Expand to fill container width
                      ),
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
