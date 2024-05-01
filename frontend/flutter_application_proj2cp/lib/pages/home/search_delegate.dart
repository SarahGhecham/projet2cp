import 'package:flutter/material.dart';

class Prestation {
  final String nom;
  final String materiel;
  final String dureeMax;
  final String dureeMin;
  final int tarifId;
  final int domaineId;
  final bool ecologique;
  final String image;
  final String description;

  Prestation({
    required this.nom,
    required this.materiel,
    required this.dureeMax,
    required this.dureeMin,
    required this.tarifId,
    required this.domaineId,
    required this.ecologique,
    required this.image,
    required this.description,
  });
}

class DataSearch extends SearchDelegate<Prestation> {
  final List<Prestation> prestations;
  final List<Prestation> recentPrestations;

  DataSearch({
    required this.prestations,
    required this.recentPrestations,
  });

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        if (query.isEmpty) {
          // If the query is empty, close the search delegate without selecting any prestation
          Navigator.pop(context);
        } else {
          // Handle closing based on the search results
          final List<Prestation> suggestionList = prestations
              .where((prestation) =>
                  prestation.nom.toLowerCase().contains(query.toLowerCase()))
              .toList();

          if (suggestionList.isNotEmpty) {
            // If there are matching prestations, close with the first suggestion
            close(context, suggestionList.first);
          } else {
            // If no matching prestations, close with a default/fallback prestation
            close(
                context,
                Prestation(
                  nom: 'Default Prestation',
                  materiel: '',
                  dureeMax: '',
                  dureeMin: '',
                  tarifId: 0,
                  domaineId: 0,
                  ecologique: false,
                  image: '',
                  description: '',
                ));
          }
        }
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Implement search results based on the selected query
    final filteredPrestations = prestations
        .where((prestation) =>
            prestation.nom.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: filteredPrestations.length,
      itemBuilder: (context, index) {
        final prestation = filteredPrestations[index];
        return ListTile(
          title: Text(prestation.nom),
          onTap: () {
            // Handle selection of a prestation
            close(context, prestation);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<Prestation> suggestionList = query.isEmpty
        ? recentPrestations // Show recent prestations if query is empty
        : prestations
            .where((prestation) =>
                prestation.nom.toLowerCase().contains(query.toLowerCase()))
            .toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        final prestation = suggestionList[index];
        return ListTile(
          title: Text(prestation.nom),
          onTap: () {
            // Handle selection of a prestation
            close(context, prestation);
          },
        );
      },
    );
  }
}
