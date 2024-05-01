import 'package:flutter/material.dart';

class Demande {
  final String artisanName;
  final String messageTime;
  final String imageArtisan;
  final bool status;

  Demande({
    required this.artisanName,
    required this.messageTime,
    required this.imageArtisan,
    required this.status,
  });
}

class MessagerieEnCours extends StatefulWidget {
  @override
  _MessagerieEnCoursState createState() => _MessagerieEnCoursState();
}

class _MessagerieEnCoursState extends State<MessagerieEnCours> {
  bool _showOngoing = true;

  List<Demande> demandesEnCours = [
    Demande(
      artisanName: 'Artisan 1',
      messageTime: '2024-04-29, 10:30',
      imageArtisan: 'assets/artisan.jpg',
      status: true,
    ),
    Demande(
      artisanName: 'Artisan 2',
      messageTime: '2024-04-30, 11:45',
      imageArtisan: 'assets/artisan.jpg',
      status: false,
    ),
    // Ajoutez d'autres demandes ici...
  ];

  List<Demande> demandesTerminees = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Messagerie')),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(70.0),
          child: SizedBox(
            width: 270,
            height: 40,
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFFDCC8C5).withOpacity(0.22),
                border: Border.all(color: Color(0xFFDCC8C5), width: 1.5),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _showOngoing = true;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: _showOngoing
                            ? Color(0xFF05564B)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 35, vertical: 5),
                      child: Text(
                        'En cours',
                        style: TextStyle(
                          color: _showOngoing
                              ? Colors.white
                              : Color.fromARGB(255, 0, 0, 0).withOpacity(0.22),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _showOngoing = false;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: !_showOngoing
                            ? Color(0xFF05564B)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 35, vertical: 5),
                      child: Text(
                        'Terminées',
                        style: TextStyle(
                          color: !_showOngoing
                              ? Colors.white
                              : Color(0xFF000000).withOpacity(0.22),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! > 0 && !_showOngoing) {
            setState(() {
              // Archiver la première demande terminée
              if (demandesTerminees.isNotEmpty) {
                demandesEnCours.add(demandesTerminees.removeAt(0));
              }
            });
          }
        },
        child: _showOngoing
            ? RDVList(
                demandes: demandesEnCours,
                onArchive: archiveDemande,
              )
            : HorairesList(demandes: demandesTerminees),
      ),
    );
  }

  void archiveDemande(int index) {
    setState(() {
      demandesTerminees.add(demandesEnCours[index]);
      demandesEnCours.removeAt(index);
    });
  }
}

class RDVList extends StatelessWidget {
  final List<Demande> demandes;
  final Function(int) onArchive;

  const RDVList({Key? key, required this.demandes, required this.onArchive})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: demandes.length,
      itemBuilder: (context, index) {
        final demande = demandes[index];
        return Dismissible(
          key: Key(demande.messageTime), // Clé unique pour le Dismissible
          direction: DismissDirection.endToStart,
          background: Container(color: Color(0xffFF8787)),
          onDismissed: (direction) {
            if (direction == DismissDirection.endToStart) {
              onArchive(
                  index); // Archiver la demande si elle est glissée vers la gauche
            }
          },
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage(demande.imageArtisan),
            ),
            title: Text(demande.artisanName),
            subtitle: Text(demande.messageTime),
          ),
        );
      },
    );
  }
}

class HorairesList extends StatelessWidget {
  final List<Demande> demandes;

  const HorairesList({Key? key, required this.demandes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: demandes.length,
      itemBuilder: (context, index) {
        final demande = demandes[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: AssetImage(demande.imageArtisan),
          ),
          title: Text(demande.artisanName),
          subtitle: Text(demande.messageTime),
        );
      },
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: MessagerieEnCours(),
    debugShowCheckedModeBanner: false,
  ));
}
