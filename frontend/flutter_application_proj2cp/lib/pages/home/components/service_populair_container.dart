import 'package:flutter/material.dart';
import 'package:flutter_application_proj2cp/details_prestation.dart';

class Service {
  final String image;
  final int id;
  final String nomPrestation;
  final String materiel;
  final String dureeMax;
  final String dureeMin;
  final int tarifId;
  final int domaineId;
  final bool ecologique;
  final String Description;
  final String? tarifJourMin;
  final String? tarifJourMax;
  final String Unite;
  Service({
    required this.id,
    required this.Unite,
    required this.Description,
    required this.nomPrestation,
    required this.materiel,
    required this.dureeMax,
    required this.dureeMin,
    required this.tarifId,
    required this.domaineId,
    required this.ecologique,
    required this.image,
    required this.tarifJourMin,
    required this.tarifJourMax,
  });
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
      onTap: () => {
        print("ID de la prestation: ${widget.service.id}"),
        Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => details_prestationPage(id: widget.service.id,prst: widget.service.nomPrestation,avgtime:'${widget.service.dureeMin} - ${widget.service.dureeMax} ',avgprice:  '${widget.service.tarifJourMin.toString()} da - ${widget.service.tarifJourMin.toString()}',imagePrestation: widget.service.image,Description:widget.service.Description,Unite :widget.service.Unite),
        ),
      )
      }, //afficher service populair
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
