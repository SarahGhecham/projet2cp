const models = require('../models');
const { Sequelize } = require('sequelize');

function AfficherDomaines(req, res) {
  models.Domaine.findAll()
    .then((result) => {
      if (result) res.status(200).json(result);
      else
        res.status(404).json({
          message: 'pas de domaines',
        });
    })
    .catch((error) => {
      res.status(500).json({
        message: 'something went wrong',
        error: error,
      });
    });
}
function AfficherToutesPrestation(req, res) {
  models.Prestation.findAll()
    .then((result) => {
      if (result) res.status(200).json(result);
      else
        res.status(404).json({
          message: 'pas de prestations',
        });
    })
    .catch((error) => {
      res.status(500).json({
        message: 'something went wrong',
        error: error,
      });
    });
}

function AfficherServicesEco(req, res) {
  models.Prestation.findAll({
    where: { Ecologique: true },
    include: [{ 
      
      model: models.Tarif, // Inclure le modèle Tarif
      attributes: ['id', 'TarifJourMin','TarifJourMax','Unité']// Remplacez 'attribut1', 'attribut2', ... par les attributs que vous voulez récupérer
  }
  ],
  })
    .then((result) => {
      if (result.length > 0) {
        res.status(200).json(result);
      } else {
        res.status(404).json({
          message: 'Aucune prestation écologique trouvée.',
        });
      }
    })
    .catch((error) => {
      console.error(
        'Erreur lors de la récupération des prestations écologiques :',
        error
      );
      res.status(500).json({
        message:
          "Une erreur s'est produite lors de la récupération des prestations écologiques.",
      });
    });
}

async function AfficherTopPrestations(req, res) {
  try {
    const topPrestations = await models.Prestation.findAll({
      attributes: [
        'id',
        'NomPrestation',
        'Matériel',
        'DuréeMax',
        'DuréeMin',
        'TarifId',
        'DomaineId',
        'Ecologique',
        'imagePrestation',
        'Description',
        
        [
          Sequelize.literal(
            '(SELECT COUNT(*) FROM Demandes WHERE Demandes.PrestationId = Prestation.id)'
          ),
          'nombreDemandes',
        ],
      ],
      order: [[Sequelize.literal('nombreDemandes'), 'DESC']],
      limit: 5, //nombre de prestations populaires a afficher
      include: [{ model: models.Demande, attributes: [] ,
      
        model: models.Tarif, // Inclure le modèle Tarif
        attributes: ['id', 'TarifJourMin','TarifJourMax','Unité']// Remplacez 'attribut1', 'attribut2', ... par les attributs que vous voulez récupérer
    }
    ],
    });

    if (topPrestations.length > 0) {
      res.status(200).json(topPrestations);
    } else {
      res.status(404).json({
        message: 'Aucune prestation trouvée.',
      });
    }
  } catch (error) {
    console.error('Erreur lors de la récupération des prestations:', error);
    res.status(500).json({
      message:
        "Une erreur s'est produite lors de la récupération des prestations.",
    });
  }
}

module.exports = {
  AfficherDomaines,
  AfficherToutesPrestation,
  AfficherServicesEco,
  AfficherTopPrestations,
};
