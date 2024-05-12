const Validator = require('fastest-validator');
const models = require('../models');
const bcryptjs = require('bcryptjs');
//const upload = require('../helpers/image_uploader');
const imageUploader = require('../helpers/image_uploader');
const axios = require('axios');
const jwt = require('jsonwebtoken');
const artisan = require('../models/artisan');

function Creeradmin(req, res) {
  bcryptjs.genSalt(10, function (err, salt) {
    bcryptjs.hash(req.body.MotdepasseAdmin, salt, function (err, hash) {
      const admin = {
        NomAdmin: req.body.NomAdmin,
        PrenomAdmin: req.body.PrenomAdmin,
        MotdepasseAdmin: hash,
        EmailAdmin: req.body.EmailAdmin,
        ActifAdmin: 1,
      };
      models.Admin.create(admin)
        .then((result) => {
          res.status(201).json({
            message: 'Creation compte admin réussite',
            admin: result,
          });
        })
        .catch((error) => {
          res.status(500).json({
            message: 'Something went wrong',
            error: error,
          });
        });
    });
  });
}

/*async function CreerArtisan(req, res) {
  const Cleapi = 'AIzaSyDRCkJohH9RkmMIgpoNB2KBlLF6YMOOmmk';
  const address = req.body.AdresseArtisan;
  const isAddressValid = await validateAddress(address, Cleapi);

  if (!isAddressValid) {
    return res.status(400).json({ message: "L'adresse saisie est invalide" });
  }
  models.Client.findOne({
    where: { EmailClient: req.body.EmailArtisan },
  })
    .then((result) => {
      if (result) {
        res.status(409).json({
          message: 'Compte email existant',
        });
      } else {
        models.Artisan.findOne({
          where: { EmailArtisan: req.body.EmailArtisan },
        })
          .then((result) => {
            if (result) {
              res.status(409).json({
                message: 'Compte email existant',
              });
            } else {
              bcryptjs.genSalt(10, function (err, salt) {
                bcryptjs.hash(
                  req.body.MotdepasseArtisan,
                  salt,
                  function (err, hash) {
                    if (!req.file) {
                      return res
                        .status(400)
                        .json({
                          success: false,
                          message:
                            "Veuillez télécharger une image de l'artisan.",
                        });
                    }

                    const imageURL = `http://localhost:3000/imageArtisan/${req.file.filename}`;
                    const photo = imageURL;
                    const artisan = {
                      NomArtisan: req.body.NomArtisan,
                      PrenomArtisan: req.body.PrenomArtisan,
                      MotdepasseArtisan: hash,
                      EmailArtisan: req.body.EmailArtisan,
                      AdresseArtisan: req.body.AdresseArtisan,
                      NumeroTelArtisan: req.body.NumeroTelArtisan,
                      Disponibilite: req.body.Disponibilite,
                      photo: photo,
                    };

                    models.Artisan.create(artisan)
                      .then((result) => {
                        res.status(201).json({
                          message: 'Creation compte artisan réussite',
                          artisan: result,
                        });
                      })
                      .catch((error) => {
                        res.status(500).json({
                          message: 'Something went wrong',
                          error: error,
                        });
                      });
                  }
                );
              });
            }
          })
          .catch((error) => {
            res.status(500).json({
              message: 'Something went wrong',
              error: error,
            });
          });
      }
    })
    .catch((error) => {
      res.status(500).json({
        message: 'Something went wrong',
        error: error,
      });
    });
}*/
async function validateAddress(address, Cleapi) {
  try {
    const encodedAddress = encodeURIComponent(address);
    const response = await axios.get(
      `https://maps.googleapis.com/maps/api/geocode/json?address=${encodedAddress}&key=${Cleapi}`
    );

    return response.data.results.length > 0;
  } catch (error) {
    console.error(
      "Une erreur s'est produite lors de la validation de l'adresse :",
      error
    );
    throw error;
  }
}

function AfficherArtisans(req, res) {
  models.Artisan.findAll()
    .then((result) => {
      if (result) res.status(200).json(result);
      else
        res.status(404).json({
          message: "pas d'artisans",
        });
    })
    .catch((error) => {
      res.status(500).json({
        message: 'something went wrong',
      });
    });
}

function AfficherClients(req, res) {
  models.Client.findAll()
    .then((result) => {
      if (result) res.status(200).json(result);
      else
        res.status(404).json({
          message: 'pas de clients',
        });
    })
    .catch((error) => {
      res.status(500).json({
        message: 'something went wrong',
        error: error,
      });
    });
}

function AfficherArtisansEtClients(req, res) {
  Promise.all([models.Artisan.findAll(), models.Client.findAll()])
    .then((results) => {
      const artisans = results[0];
      const clients = results[1];
      res.status(200).json({ artisans: artisans, clients: clients });
    })
    .catch((error) => {
      res.status(500).json({
        message: 'something went wrong',
        error: error,
      });
    });
}

function DesactiverClient(req, res) {
  const comptedesactive = {
    EmailClient: req.body.EmailClient,
    ActifClient: false,
  };
  models.Client.update(comptedesactive, {
    where: { EmailClient: req.body.EmailClient },
  })
    .then((result) => {
      res.status(200).json({ message: 'Client désactivé avec succès' });
    })
    .catch((error) => {
      res.status(500).json({
        message: 'Erreur lors de la désactivation du client',
        error: error,
      });
    });
}

function DesactiverArtisan(req, res) {
  const comptedesactive = {
    EmailArtisan: req.body.EmailArtisan,
    ActifArtisan: false,
  };
  models.Artisan.update(comptedesactive, {
    where: { EmailArtisan: req.body.EmailArtisan },
  })
    .then((result) => {
      res.status(200).json({ message: 'Artisan désactivé avec succès' });
    })
    .catch((error) => {
      res.status(500).json({
        message: "Erreur lors de la désactivation de l'Artisan",
        error: error,
      });
    });
}

function destroy(req, res) {
  const id = req.params.id;
  models.Admin.destroy({ where: { id: id } })
    .then((result) => {
      res.status(201).json({
        message: 'deleted succesfully',
      });
    })
    .catch((error) => {
      res.status(500).json({
        message: 'something went wrong',
      });
    });
}
function show(req, res) {
  const id = req.userId;
  console.log(id);
  models.Admin.findByPk(id)
    .then((result) => {
      if (result) res.status(200).json(result);
      else
        res.status(404).json({
          message: 'admin not found',
        });
    })
    .catch((error) => {
      res.status(500).json({
        message: 'something went wrong',
        error
      });
    });
}

function AjouterDomaine(req, res) {
  const { NomDomaine } = req.body;

  if (!req.file) {
    return res.status(400).json({
      success: false,
      message: 'Veuillez télécharger une image pour le domaine.',
    });
  }

  const imageURL = `http://localhost:3000/imageDomaine/${req.file.filename}`;
  const imageDomaine = imageURL;

  models.Domaine.create({
    NomDomaine,
    imageDomaine,
  })
    .then((nouveauDomaine) => {
      res
        .status(201)
        .json({ success: true, domaine: nouveauDomaine, imageURL: imageURL });
    })
    .catch((error) => {
      res.status(500).json({
        success: false,
        message: "Une erreur s'est produite lors de l'ajout du domaine.",
      });
    });
}
function CreerTarif(req, res) {
  const {
    TarifJourMin,
    TarifJourMax,
    PourcentageNuit,
    PourcentageJourFérié,
    PourcentageWeekend,
    Unité,
  } = req.body;

  models.Tarif.create({
    TarifJourMin,
    TarifJourMax,
    PourcentageNuit,
    PourcentageJourFérié,
    PourcentageWeekend,
    Unité,
  })
    .then(() => {
      return res.status(200).json({ message: 'Tarif créé avec succès.' });
    })
    .catch((error) => {
      console.error(
        "Une erreur s'est produite lors de la création du tarif:",
        error
      );
      return res.status(500).json({
        message: "Une erreur s'est produite lors de la création du tarif.",
      });
    });
}
function CreerPrestation(req, res) {
  const {
    NomPrestation,
    Materiel,
    DureeMin,
    DureeMax,
    TarifId,
    DomaineId,
    Ecologique,
    Description,
  } = req.body;
  if (!req.file) {
    return res.status(400).json({
      success: false,
      message: 'Veuillez télécharger une image pour le domaine.',
    });
  }
  const imageURL = `http://localhost:3000/imagePrestation/${req.file.filename}`;
  const imagePrestation = imageURL;
  models.Prestation.create({
    NomPrestation,
    Matériel: Materiel,
    DuréeMin: DureeMin,
    DuréeMax: DureeMax,
    TarifId,
    DomaineId,
    Description,
    Ecologique,
    imagePrestation,
  })
    .then(() => {
      return res
        .status(200)
        .json({ message: 'Prestation créée avec succès.', imageURL: imageURL });
    })
    .catch((error) => {
      console.error(
        "Une erreur s'est produite lors de la création de la prestation:",
        error
      );
      return res.status(500).json({
        message:
          "Une erreur s'est produite lors de la création de la prestation.",
      });
    });
}
function ModifierPrestation(req, res) {
  const { PrestationId, Description, NomPrestation } = req.body;

  // Vérifier si la prestation existe
  models.Prestation.findByPk(PrestationId)
    .then((prestation) => {
      if (!prestation) {
        return res
          .status(404)
          .json({ success: false, message: "La prestation n'existe pas." });
      }

      // Mettre à jour la description si elle est fournie
      if (Description) {
        prestation.Description = Description;
      }
      if (NomPrestation) {
        prestation.NomPrestation = NomPrestation;
      }

      // Mettre à jour l'image si elle est fournie
      if (req.file) {
        const imageURL = `http://localhost:3000/imagePrestation/${req.file.filename}`;
        prestation.imagePrestation = imageURL;
      }

      // Sauvegarder les modifications
      prestation
        .save()
        .then(() => {
          return res.status(200).json({
            success: true,
            message: 'Prestation modifiée avec succès.',
          });
        })
        .catch((error) => {
          console.error(
            "Une erreur s'est produite lors de la modification de la prestation:",
            error
          );
          return res.status(500).json({
            success: false,
            message:
              "Une erreur s'est produite lors de la modification de la prestation.",
          });
        });
    })
    .catch((error) => {
      console.error(
        "Une erreur s'est produite lors de la recherche de la prestation:",
        error
      );
      return res.status(500).json({
        success: false,
        message:
          "Une erreur s'est produite lors de la recherche de la prestation.",
      });
    });
}

async function AjouterPrestation(req, res) {
  try {
    artisanId = req.params.id;
    const { prestationName } = req.body;

    const prestation = await models.Prestation.findOne({
      where: { NomPrestation: prestationName },
    });

    if (!prestation) {
      return res
        .status(404)
        .json({ message: "La prestation spécifiée n'existe pas." });
    }

    if (!prestation.id) {
      return res.status(404).json({
        message: "La prestation spécifiée n'a pas d'identifiant valide.",
      });
    }

    await models.ArtisanPrestation.create({
      ArtisanId: artisanId,
      PrestationId: prestation.id,
    });

    return res
      .status(200)
      .json({ message: "Prestation ajoutée avec succès à l'artisan." });
  } catch (error) {
    console.error(
      "Une erreur s'est produite lors de l'ajout de la prestation à l'artisan:",
      error
    );
    return res.status(500).json({
      message:
        "Une erreur s'est produite lors de l'ajout de la prestation à l'artisan.",
    });
  }
}

function obtenirStatistiques(req, res) {
  Promise.all([
    models.Client.count(),
    models.Artisan.count(),
    models.Demande.count(),
  ])
    .then(([nombreClients, nombreArtisans, nombreDemandes]) => {
      res.status(200).json({
        nombreClients: nombreClients,
        nombreArtisans: nombreArtisans,
        nombreDemandes: nombreDemandes,
      });
    })
    .catch((error) => {
      res.status(500).json({
        message:
          "Une erreur s'est produite lors de la récupération des statistiques.",
        error: error,
      });
    });
}

async function AfficherPrestationsByDomaine(req, res) {
  const domaineId = req.params.domaineId;

  try {
    const prestations = await models.Prestation.findAll({
      where: { DomaineId: domaineId },
      attributes: ['NomPrestation', 'id'],
    });

    if (prestations.length > 0) {
      const nomPrestations = prestations.map((prestation) => ({
        NomPrestation: prestation.NomPrestation,
        id: prestation.id,
      }));
      res.status(200).json(nomPrestations);
    } else {
      res
        .status(404)
        .json({ message: 'Aucune prestation trouvée pour ce domaine.' });
    }
  } catch (error) {
    console.error(
      'Erreur lors de la récupération des noms de prestations pour ce domaine:',
      error
    );
    res.status(500).json({
      message:
        "Une erreur s'est produite lors de la récupération des noms de prestations pour ce domaine.",
    });
  }
}

async function CreerArtisan(req, res) {
  try {
    const requiredFields = [
      'NomArtisan',
      'PrenomArtisan',
      'MotdepasseArtisan',
      'EmailArtisan',
      'AdresseArtisan',
      'NumeroTelArtisan',
      'DomaineId',
      'prestationsIds',
    ];
    console.log('Requête reçue :', req.body);
    for (const field of requiredFields) {
      console.log(`Champ '${field}' :`, req.body[field]);
      if (!req.body[field]) {
        return res
          .status(400)
          .json({ message: `Le champ '${field}' n'est pas rempli!` });
      }
    }
    const phonePattern = /^[0-9]{10}$/;
    if (!phonePattern.test(req.body.NumeroTelArtisan)) {
      return res
        .status(400)
        .json({ message: "Le numéro de téléphone n'a pas le bon format" });
    }

    const Cleapi = 'AIzaSyBUoTHDCzxA7lix93aS8D5EuPa-VCuoAq0';
    const address = req.body.AdresseArtisan;

    const isAddressValid = await validateAddress(address, Cleapi);

    if (!isAddressValid) {
      return res.status(400).json({ message: "L'adresse saisie est invalide" });
    }
    console.log("Validation de l'adresse :", isAddressValid);
    // const apiKey = '2859b334b5cf4296976a534dbe5e69a7';
    const email = req.body.EmailArtisan;

    //const response = await axios.get(`https://api.zerobounce.net/v2/validate?api_key=${apiKey}&email=${email}`);

    // if (response.data.status === 'valid') {
    models.Client.findOne({ where: { EmailClient: email } })
      .then((result) => {
        if (result) {
          res.status(409).json({ message: 'Compte email déjà existant' });
        } else {
          models.Artisan.findOne({ where: { EmailArtisan: email } })
            .then((result) => {
              if (result) {
                res.status(409).json({ message: 'Compte email existant' });
              } else {
                bcryptjs.genSalt(10, function (err, salt) {
                  bcryptjs.hash(
                    req.body.MotdepasseArtisan,
                    salt,
                    function (err, hash) {
                      const Artisan = {
                        NomArtisan: req.body.NomArtisan,
                        PrenomArtisan: req.body.PrenomArtisan,
                        MotdepasseArtisan: hash,
                        EmailArtisan: email,
                        AdresseArtisan: req.body.AdresseArtisan,
                        NumeroTelArtisan: req.body.NumeroTelArtisan,
                        DomaineId: req.body.DomaineId,
                        photo:
                          'http://192.168.100.7:3000/imageClient/1714391607342.jpg',
                      };
                      models.Artisan.create(Artisan)
                        .then((result) => {
                          const artisanId = result.id; // Identifiant de l'artisan créé
                          console.log(artisanId);

                          // Parcourir la liste des prestations et associer chaque prestation à l'artisan
                          const prestationsIds = req.body.prestationsIds;

                          // Créer des entrées dans la table de jointure pour chaque prestation
                          const associations = prestationsIds.map(
                            (prestationId) => {
                              return {
                                ArtisanId: artisanId,
                                PrestationId: prestationId,
                              };
                            }
                          );

                          // Insérer les associations dans la table de jointure
                          models.ArtisanPrestation.bulkCreate(associations)
                            .then(() => {
                              // Envoyer la réponse une fois que toutes les associations ont été créées avec succès
                              res.status(201).json({
                                message:
                                  'Inscription artisan réussie et prestations associées',
                                Artisan: Artisan,
                                Prestations: prestationsIds,
                              });
                            })
                            .catch((error) => {
                              // Gérer les erreurs liées à la création des associations
                              res.status(500).json({
                                message:
                                  "Une erreur s'est produite lors de l'association des prestations à l'artisan",
                                error: error,
                              });
                            });
                        })

                        .catch((error) => {
                          res.status(500).json({
                            message:
                              "Une erreur s'est produite lors de la création de l'artisan",
                            error: error,
                          });
                        });
                    }
                  );
                });
              }
            })
            .catch((error) => {
              res
                .status(500)
                .json({ message: 'Something went wrong', error: error });
            });
        }
      })
      .catch((error) => {
        res.status(500).json({ message: 'Something went wrong', error: error });
      });
    // } else {
    //res.status(400).json({ message: "Email invalide" });
    // }
  } catch (error) {
    console.error("Erreur lors de la validation de l'e-mail :", error);
    res.status(500).json({
      message: "Erreur lors de la validation de l'e-mail",
      error: error,
    });
  }
}


module.exports = {
  CreerArtisan: CreerArtisan,
  Creeradmin: Creeradmin,
  show: show,
  destroy: destroy,
  AfficherArtisans: AfficherArtisans,
  AfficherClients: AfficherClients,
  DesactiverClient: DesactiverClient,
  DesactiverArtisan: DesactiverArtisan,
  AjouterDomaine: AjouterDomaine,
  CreerTarif: CreerTarif,
  CreerPrestation: CreerPrestation,
  AjouterPrestation: AjouterPrestation,
  obtenirStatistiques: obtenirStatistiques,
  ModifierPrestation,
  AfficherPrestationsByDomaine: AfficherPrestationsByDomaine,
  
  AfficherArtisansEtClients
};
