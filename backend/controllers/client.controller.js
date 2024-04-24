const Validator = require('fastest-validator');
const models = require('../models');
const { RDV, Demande } = require('../models');
const { Prestation } = require('../models');
const bcryptjs = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { Op } = require('sequelize');
const moment = require('moment');
const bcrypt = require('bcryptjs');
const axios = require('axios');
const nodemailer = require('nodemailer');
const { geocode, calculateRouteDistance } = require('./maps');

async function signUp(req, res) {
  try {
    const requiredFields = [
      'Username',
      'MotdepasseClient',
      'EmailClient',
      'AdresseClient',
      'NumeroTelClient',
    ];
    for (const field of requiredFields) {
      if (!req.body[field]) {
        return res
          .status(400)
          .json({ message: `Le champ '${field}' n'est pas rempli!` });
      }
    }
    const phonePattern = /^[0-9]{10}$/;
    if (!phonePattern.test(req.body.NumeroTelClient)) {
      return res
        .status(400)
        .json({ message: "Le numéro de téléphone n'a pas le bon format" });
    }

    const Cleapi = 'AIzaSyDRCkJohH9RkmMIgpoNB2KBlLF6YMOOmmk';
    const address = req.body.AdresseClient;

    const isAddressValid = await validateAddress(address, Cleapi);

    if (!isAddressValid) {
      return res.status(400).json({ message: "L'adresse saisie est invalide" });
    }
    // const apiKey = '2859b334b5cf4296976a534dbe5e69a7';
    const email = req.body.EmailClient;

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
                    req.body.MotdepasseClient,
                    salt,
                    function (err, hash) {
                      const client = {
                        Username: req.body.Username,
                        MotdepasseClient: hash,
                        EmailClient: email,
                        AdresseClient: req.body.AdresseClient,
                        NumeroTelClient: req.body.NumeroTelClient,
                      };
                      models.Client.create(client)
                        .then((result) => {
                          const token = jwt.sign(
                            { UserId: result.id, username: result.Username },
                            'secret'
                          );

                          const transporter = nodemailer.createTransport({
                            service: 'gmail',
                            auth: {
                              user: 'beaverappservices@gmail.com',
                              pass: 'rucn vtaq cmxq dcwe',
                            },
                          });

                          const mailOptions = {
                            from: 'Beaver',
                            to: email,
                            subject: "Confirmation d'inscription",
                            text: `Bonjour ${req.body.Username},

Nous sommes ravis de vous accueillir chez Beaver ! Vous avez maintenant accès à notre plateforme et à tous nos services.

N'hésitez pas à explorer notre plateforme et à profiter de toutes les fonctionnalités que nous offrons. Si vous avez des questions ou avez besoin d'aide, n'hésitez pas à nous contacter.

Nous vous remercions de votre confiance et sommes impatients de vous voir profiter pleinement de votre expérience avec Beaver !

Cordialement,
L'équipe Beaver`,
                          };

                          transporter.sendMail(
                            mailOptions,
                            function (error, info) {
                              if (error) {
                                console.error(
                                  "Erreur lors de l'envoi de l'email de confirmation :",
                                  error
                                );
                              } else {
                                console.log(
                                  'Email de confirmation envoyé : ' +
                                    info.response
                                );
                              }
                            }
                          );

                          res
                            .status(201)
                            .json({
                              message: 'Inscription client réussie',
                              client: result,
                              token,
                            });
                        })
                        .catch((error) => {
                          res
                            .status(500)
                            .json({
                              message:
                                "Une erreur s'est produite lors de la création du client",
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
    res
      .status(500)
      .json({
        message: "Erreur lors de la validation de l'e-mail",
        error: error,
      });
  }
}

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

async function updateClient(req, res) {
  const id = req.userId;

  // Hash the new password if provided
  let hashedPassword = null;
  if (req.body.MotdepasseClient) {
    hashedPassword = await bcrypt.hash(req.body.MotdepasseClient, 10);
  }

  const updatedClient = {
    Username: req.body.Username,
    MotdepasseClient: hashedPassword, // Hashed password
    EmailClient: req.body.EmailClient,
    AdresseClient: req.body.AdresseClient,
    NumeroTelClient: req.body.NumeroTelClient,

    //  any other client attributes you want to update
  };
  const fs = require('fs');

  // Update the Client model with the updated data
  models.Client.update(updatedClient, { where: { id: id } })
    .then((result) => {
      if (result[0] === 1) {
        res.status(200).json({
          message: 'Client updated successfully',
          client: updatedClient,
        });
      } else {
        res.status(404).json({ message: 'Client not found' });
      }
    })
    .catch((error) => {
      res.status(500).json({
        message: 'Something went wrong',
        error: error,
      });
    });
}

function updateClientImage(req, res) {
  const id = req.userId; // Extract client ID from request parameters

  // Check if a file is uploaded
  if (!req.file) {
    return res
      .status(400)
      .json({ success: false, message: 'You must upload an image.' });
  }

  if (req.file.mimetype == 'image/jpeg') {
    return res
      .status(400)
      .json({ success: false, message: 'Only JPEG images are supported.' });
  }

  // Construct the image URL for the client
  const imageURL = `http://localhost:3000/imageClient/${req.file.filename}`; // changer avec votre adressse ip/10.0.2.2(emulateur)

  // Update the client's photo URL in the database
  models.Client.findByPk(id)
    .then((client) => {
      if (!client) {
        return res.status(404).json({ message: 'Client not found' });
      }

      // Update the client's photo URL
      client.photo = imageURL;

      // Save the updated client
      return client.save();
    })
    .then((updatedClient) => {
      // Return success message and the updated client object
      res.status(200).json({
        success: true,
        message: 'Client image updated successfully',
        client: updatedClient,
        imageURL: imageURL,
      });
    })
    .catch((error) => {
      res
        .status(500)
        .json({
          success: false,
          message: 'Something went wrong',
          error: error,
        });
    });
}
async function creerEvaluation(req, res) {
  const evaluation = {
    Note: req.body.Note,
    Commentaire: req.body.Commentaire,
    RDVId: req.body.RDVId,
  };
  const Note = req.body.Note;
  const RDVId = req.body.RDVId;
  try {
    const RDV = await models.RDV.findByPk(RDVId);
    if (!RDV) {
      return res
        .status(404)
        .json({ message: `Le rendez-vous avec l'ID ${RDVId} n'existe pas.` });
    }
    if (RDV.annule) {
      return res
        .status(400)
        .json({ message: `Le rendez-vous avec l'ID ${RDVId} a été annulé.` });
    }
    if (!RDV.confirme) {
      return res
        .status(400)
        .json({
          message: `Le rendez-vous avec l'ID ${RDVId} n'est pas confirmé.`,
        });
    }
    const now = new Date();
    const rdvDateFin = new Date(RDV.DateFin);
    // Comparaison de la date actuelle avec la date de fin du RDV
    if (now < rdvDateFin) {
      return res
        .status(400)
        .json({
          message: `La date actuelle est antérieure à la fin du rendez-vous.`,
        });
    }
    // Comparaison de la date et l'heure actuelles avec la date et l'heure de fin du RDV
    const maintenant = moment();
    const rdvHeureFin = moment(RDV.HeureFin, 'HH:mm');
    // Créer un objet de date et heure pour la date et l'heure actuelles
    const nowDateTime = moment(
      `${maintenant.format('YYYY-MM-DD')} ${maintenant.format('HH:mm')}`,
      'YYYY-MM-DD HH:mm'
    );
    // Comparer maintenant avec l'heure de fin du rendez-vous
    if (now == rdvDateFin) {
      if (nowDateTime.isBefore(rdvHeureFin)) {
        return res
          .status(400)
          .json({
            message: `L'heure actuelle est antérieure à la fin du rendez-vous.`,
          });
      }
    }
    if (isNaN(Note) || Note < 0 || Note > 5) {
      return res
        .status(400)
        .json({
          message: 'La notation doit être un nombre décimal entre 0 et 5.',
        });
    }
    const result = await models.Evaluation.create(evaluation);
    return res.status(201).json({
      message: 'Réussite',
      evaluation: result,
    });
  } catch (error) {
    console.error(
      "Une erreur s'est produite lors de la création de l'évaluation :",
      error
    );
    return res
      .status(500)
      .json({
        message:
          "Une erreur s'est produite lors du traitement de votre demande.",
      });
  }
}

/*async function lancerdemande(req, res) {
    const clientId = req.userId;
    const demandeNom = req.body.nom;
    const prestationId = req.body.prestationId;

    try {
        // Vérifier si la prestation existe
        const prestation = await models.Prestation.findByPk(prestationId);
        if (!prestation) {
            return res.status(404).json({ message: `La prestation avec l'ID ${prestationId} n'existe pas.` });
        }

        // Créer la demande avec le nom fourni
        const nouvelleDemande = await models.Demande.create(
            { nom: demandeNom,
             PrestationId : prestationId,
             ClientId : clientId
            });

        // Trouver le client
        const client = await models.Client.findByPk(clientId);
        if (!client) {
            return res.status(404).json({ message: `Le client avec l'ID ${clientId} n'existe pas.` });
        }

        // Associer la demande au client
        await nouvelleDemande.update({ ClientId: clientId });
        // Associer la demande à la prestation
        await nouvelleDemande.update({ PrestationId: prestationId });
        console.log(nouvelleDemande.PrestationId);
        console.log(nouvelleDemande.ClientId);

        return res.status(201).json({ message: `La demande a été créée avec succès et associée au client et à la prestation.` });
    } catch (error) {
        console.error('Une erreur s\'est produite lors de la création de la demande :', error);
        return res.status(500).json({ message: 'Une erreur s\'est produite lors du traitement de votre demande.' });
    }
}*/

async function lancerdemande(req, res) {
  // Attributs de la demande
  const description = req.body.description;
  const clientId = req.userId; // Supposons que req.userId contient l'ID du client
  const nomPrestation = req.body.nomPrestation;
  const urgente = req.body.urgente;

  // Vérifier si clientId est défini
  if (!clientId) {
    return res
      .status(400)
      .json({ message: `L'ID du client n'est pas défini.` });
  }

  try {
    // Vérifier si la prestation existe
    //const prestation = await models.Prestation.findOne({ where: { NomPrestation: nomPrestation } });
    const prestation = await models.Prestation.findOne({
      where: { NomPrestation: nomPrestation },
      attributes: ['id', 'NomPrestation', 'Ecologique'], // Ajoutez 'Ecologique' à la liste des attributs à inclure
    });
    //console.log(prestation.Ecologique);
    if (prestation.Ecologique) {
      // Accéder au client avec clientId
      const client = await models.Client.findByPk(clientId);

      // Vérifier si le client existe
      if (!client) {
        return res
          .status(404)
          .json({ message: `Le client avec l'ID ${clientId} n'existe pas.` });
      }

      // Incrémenter l'attribut "Point" du client
      client.Points += 1; // Incrémentez selon vos règles métier

      // Enregistrer les modifications du client dans la base de données
      await client.save();
    }
    if (!prestation) {
      return res
        .status(404)
        .json({
          message: `La prestation avec le nom '${nomPrestation}' n'existe pas.`,
        });
    }

    // Créer la demande avec le nom fourni
    const nouvelleDemande = await models.Demande.create({
      Description: description,
      PrestationId: prestation.id,
      ClientId: clientId,
      Urgente: urgente,
    });

    // Vérifier si la demande a été créée avec succès
    if (!nouvelleDemande) {
      return res
        .status(500)
        .json({ message: `Impossible de créer la demande.` });
    }
    // Trouver tous les couples (PrestationId, ArtisanId) associés
    const artisansAssocies = await models.ArtisanPrestation.findAll({
      where: { PrestationId: prestation.id },
    });

    // Vérifier si des couples sont associés à la prestation
    if (!artisansAssocies || artisansAssocies.length === 0) {
      return res
        .status(404)
        .json({
          message: `Aucun artisan n'est associé à la prestation '${nomPrestation}'.`,
        });
    }

    const idsArtisansAssocies = artisansAssocies.map(
      (assoc) => assoc.ArtisanId
    );

    // Récupérer les détails de chaque artisan associé
    const artisansIds = [];
    for (const artisanId of idsArtisansAssocies) {
      const artisan = await models.Artisan.findByPk(artisanId);
      if (artisan && (artisan.Disponibilite || !urgente)) {
        //console.log("eho",artisan.Disponibilite);
        const AdresseArtisan = artisan.AdresseArtisan; // Supposons que l'attribut s'appelle 'adresse'
        console.log(AdresseArtisan);
        const clientCoords = await geocode('ESI,oued smar');
        const artisanCoords = await geocode(AdresseArtisan);

        // Afficher les coordonnées du client et de l'artisan
        console.log('Client coordinates:', clientCoords);
        console.log('Artisan coordinates:', artisanCoords);

        // Calculer la distance routière entre le client et l'artisan
        const routeDistance = await calculateRouteDistance(
          clientCoords,
          artisanCoords
        );
        console.log(
          'Route distance between client and artisan:',
          routeDistance.toFixed(2),
          'km'
        );
        await artisan.update({ RayonKm: 19.4 });
        if (artisan.RayonKm < routeDistance) {
          artisansIds.push(artisan.id);
          try {
            const association = await models.ArtisanDemande.create({
              ArtisanId: artisan.id,
              DemandeId: nouvelleDemande.id,
            });
          } catch {
            console.error(
              "Une erreur s'est produite lors de lassociation de la demande et lartisan:",
              error
            );
          }
        }
      }
    }
    return res.status(201).json({
      message: `La demande a été créée avec succès et associée au client et à la prestation.`,
      demande: nouvelleDemande,
      artisansIds,
    });
  } catch (error) {
    console.error(
      "Une erreur s'est produite lors de la création de la demande :",
      error
    );
    return res
      .status(500)
      .json({
        message:
          "Une erreur s'est produite lors du traitement de votre demande.",
      });
  }
}

function AfficherArtisan(req, res) {
  const id = req.params.id;
  models.Artisan.findByPk(id)
    .then((result) => {
      if (result) {
        const artisanInfo = {
          NomArtisan: result.NomArtisan,
          PrenomArtisan: result.PrenomArtisan,
          NumeroTelArtisan: result.NumeroTelArtisan,
          AdresseArtisan: result.AdresseArtisan,
          Disponnibilite: result.Disponnibilite,
          Points: result.Points,
          Service_account: result.Service_account,
        };
        res.status(201).json(artisanInfo);
      } else
        res.status(404).json({
          message: 'artisan not found',
        });
    })
    .catch((error) => {
      res.status(500).json({
        message: 'something went wrong',
        error: error,
      });
    });
}

function AfficherProfil(req, res) {
  const id = req.userId;
  models.Client.findByPk(id)
    .then((result) => {
      if (result) {
        const clientInfo = {
          Username: result.Username,
          EmailClient: result.EmailClient,
          AdresseClient: result.AdresseClient,
          NumeroTelClient: result.NumeroTelClient,
          Points: result.Points,
          Service_account: result.Service_account,
          photo: result.photo,
        };
        res.status(200).json(clientInfo);
      } else
        res.status(404).json({
          message: 'client not found',
        });
    })
    .catch((error) => {
      res.status(500).json({
        message: 'something went wrong',
        error: error,
      });
    });
}

function test(req, res) {
  const id = req.params.id;
  models.Demande.findByPk(id)
    .then((result) => {
      if (result) res.status(201).json(result);
      else
        res.status(404).json({
          message: 'demande not found',
        });
    })
    .catch((error) => {
      res.status(500).json({
        message: 'something went wrong',
      });
    });
}

async function creerRDV(req, res) {
  const demandeId = req.body.demandeId;
  const dateDebutString = req.body.dateDebut;
  const heureDebutString = req.body.heureDebut;
  const dureeString = req.body.duree; // La durée entrée par le client est en heures

  // Convertir la chaîne de caractères de la date en un objet Date valide
  const dateDebut = new Date(dateDebutString);
  // Extraire les heures et les minutes de l'heure de début
  const [heureDebutHours, heureDebutMinutes] = heureDebutString.split(':');

  // Créer un objet Date avec l'heure de début
  const heureDebut = new Date(dateDebut);
  heureDebut.setHours(heureDebutHours);
  heureDebut.setMinutes(heureDebutMinutes);

  try {
    const demande = await models.Demande.findByPk(demandeId, {
      include: [{ model: models.Client }, { model: models.Prestation }],
    });

    if (!demande) {
      return res
        .status(404)
        .json({ message: `La demande avec l'ID ${demandeId} n'existe pas.` });
    }

    const clientId = demande.ClientId;
    const prestationId = demande.PrestationId;

    // Convertir la durée en heures en un nombre entier
    const duree = parseInt(dureeString);

    // Calculer l'heure de fin en ajoutant la durée à l'heure de début
    const heureFin = new Date(heureDebut.getTime() + duree * 60 * 60 * 1000);

    // Formater l'heure de fin en hh:mm
    const optionsHeure = { hour: '2-digit', minute: '2-digit' };
    const heureFinFormatee = heureFin.toLocaleTimeString('fr-FR', optionsHeure);

    // Créer le RDV
    const rdv = await models.RDV.create({
      DateDebut: dateDebut,
      DateFin: dateDebut, // La date de fin est la même que la date de début
      HeureDebut: heureDebut,
      HeureFin: heureFinFormatee,
      accepte: false,
      confirme: false,
      annule: false,
      DemandeId: demandeId,
    });

    return res.status(201).json({ message: 'RDV créé avec succès', rdv });
  } catch (error) {
    console.error('Erreur lors de la création du RDV :', error);
    return res
      .status(500)
      .json({
        message:
          "Une erreur s'est produite lors du traitement de votre demande.",
      });
  }
}

async function confirmerRDV(req, res) {
  const rdvId = req.body.rdvId;

  try {
    const rdv = await models.RDV.findByPk(rdvId);
    if (!rdv) {
      return res
        .status(404)
        .json({ message: `Le RDV avec l'ID ${rdvId} n'existe pas.` });
    }

    if (!rdv.accepte) {
      return res
        .status(400)
        .json({ message: `Le RDV avec l'ID ${rdvId} n'a pas été accepté.` });
    }

    rdv.confirme = true;
    await rdv.save();
    return res
      .status(200)
      .json({
        message: `Le RDV avec l'ID ${rdvId} a été confirmé avec succès.`,
        rdv,
      });
  } catch (error) {
    console.error('Erreur lors de la confirmation du RDV :', error);
    return res
      .status(500)
      .json({
        message:
          "Une erreur s'est produite lors du traitement de votre demande.",
      });
  }
}

async function annulerRDV(req, res) {
  const rdvId = req.body.rdvId;

  try {
    const rdv = await models.RDV.findByPk(rdvId);
    if (!rdv) {
      return res
        .status(404)
        .json({ message: `Le RDV avec l'ID ${rdvId} n'existe pas.` });
    }

    rdv.annule = true;
    await rdv.save();
    return res
      .status(200)
      .json({
        message: `Le RDV avec l'ID ${rdvId} a été annulé avec succès.`,
        rdv,
      });
  } catch (error) {
    console.error("Erreur lors de l'annulation du RDV :", error);
    return res
      .status(500)
      .json({
        message:
          "Une erreur s'est produite lors du traitement de votre demande.",
      });
  }
}

async function ActiviteEncours(req, res) {
    const clientId = req.params.id;

    try {
        const maintenant = new Date();

        const demandes = await models.Demande.findAll({
            where: { ClientId: clientId }
        });

        const demandeIds = demandes.map(demande => demande.id);

        const rdvs = await models.RDV.findAll({
            where: { DemandeId: demandeIds },
            attributes: ['id', 'DemandeId', 'annule', 'DateFin', 'HeureFin']
        });

        const rendezVousEnCours = await Promise.all(rdvs.map(async (rdv) => {
            const rdvDateFin = new Date(rdv.DateFin);
            const rdvHeureFin = new Date(`${rdv.DateFin}T${rdv.HeureFin}`);
        
            if (rdv.annule) {
                return null;
            }
        
            if (rdvDateFin > maintenant || (rdvDateFin.getTime() === maintenant.getTime() && rdvHeureFin > maintenant)) {
                const artisandemande = await models.ArtisanDemande.findOne({ where: { DemandeId: rdv.DemandeId } });
                if (!artisandemande || !artisandemande.accepte || !artisandemande.confirme) {
                    return null;
                }
                
                return rdv;
            } else {
                return null;
            }
            

        }));
        

        const rendezVousDetails = await Promise.all(rendezVousEnCours.map(async (rdv) => {
            if (!rdv) {
                return null; 
            }

            const demande = await models.Demande.findByPk(rdv.DemandeId, {
                attributes: ['id',
                    [models.sequelize.literal("DATE_FORMAT(`Demande`.`createdAt`, '%Y-%m-%d')"), 'date'], 
            [models.sequelize.literal("DATE_FORMAT(`Demande`.`createdAt`, '%H:%i:%s')"), 'heure'] 
                ],
                include: [
                    {
                        model: models.Prestation,
                        attributes: ['nomPrestation', 'imagePrestation'] 
                    }
                ]
            });
            return { demande, rdv };
        }));

        const filteredRendezVousDetails = rendezVousDetails.filter(item => item !== null);

        return res.status(200).json(filteredRendezVousDetails);
    } catch (error) {
        console.error('Une erreur s\'est produite lors de la récupération des rendez-vous en cours :', error);
        return res.status(500).json({ message: 'Une erreur s\'est produite lors du traitement de votre demande.' });
    }
}


async function ActiviteTerminee(req, res) {
  const clientId = req.params.id;

  try {
    const maintenant = new Date();

    const demandes = await models.Demande.findAll({
      where: { ClientId: clientId },
    });

    const demandeIds = demandes.map((demande) => demande.id);

    const rdvs = await models.RDV.findAll({
      where: { DemandeId: demandeIds },
      attributes: ['id', 'DemandeId', 'annule', 'DateFin', 'HeureFin'],
    });

    const rendezVousEnCours = await Promise.all(
      rdvs.map(async (rdv) => {
        const rdvDateFin = new Date(rdv.DateFin);
        const rdvHeureFin = new Date(`${rdv.DateFin}T${rdv.HeureFin}`);

        if (rdv.annule) {
          return null;
        }

        if (
          rdvDateFin < maintenant ||
          (rdvDateFin.getTime() === maintenant.getTime() &&
            rdvHeureFin < maintenant)
        ) {
          const artisandemande = await models.ArtisanDemande.findOne({
            where: { DemandeId: rdv.DemandeId },
          });
          if (
            !artisandemande ||
            !artisandemande.accepte ||
            !artisandemande.confirme
          ) {
            return null;
          }

          return rdv;
        } else {
          return null;
        }
      })
    );

    const rendezVousDetails = await Promise.all(
      rendezVousEnCours.map(async (rdv) => {
        if (!rdv) {
          return null;
        }

        const demande = await models.Demande.findByPk(rdv.DemandeId, {
          attributes: ['id'],
          include: [
            {
              model: models.Prestation,
              attributes: ['nomPrestation', 'imagePrestation'],
            },
            {
              model: models.Artisan, // Inclure les détails de l'artisan
              attributes: ['id', 'NomArtisan', 'PrenomArtisan', 'Note'],
              through: { attributes: [] },
            },
          ],
        });

        // Ajoutez les détails de l'artisan à la demande
        const artisan = demande.Artisan;
        return { demande, rdv };
      })
    );

    const filteredRendezVousDetails = rendezVousDetails.filter(
      (item) => item !== null
    );

    return res.status(200).json(filteredRendezVousDetails);
  } catch (error) {
    console.error(
      "Une erreur s'est produite lors de la récupération des rendez-vous en cours :",
      error
    );
    return res
      .status(500)
      .json({
        message:
          "Une erreur s'est produite lors du traitement de votre demande.",
      });
  }
}

function AfficherPrestations(req, res) {
  const domaineId = req.body.domaineId; // Supposons que vous récupériez l'ID du domaine depuis les paramètres de l'URL

  models.Prestation.findAll({
    where: { DomaineId: domaineId },
    include: [
      {
        model: models.Tarif, // Inclure le modèle Tarif associé à chaque prestation
      },
    ],
  })
    .then((result) => {
      if (result.length > 0) {
        res.status(200).json(result);
      } else {
        res
          .status(404)
          .json({ message: 'Aucune prestation trouvée pour ce domaine.' });
      }
    })
    .catch((error) => {
      res
        .status(500)
        .json({
          message:
            "Une erreur s'est produite lors de la récupération des prestations.",
          error: error,
        });
    });
}

async function DetailsDemandeConfirmee(req, res) {
  const clientId = req.userId;
  const rdvId = req.body.rdvId;

  try {
    const rdv = await models.RDV.findByPk(rdvId, {
      include: [{ model: models.Demande, include: [models.Prestation] }],
    });

    if (!rdv) {
      return res
        .status(404)
        .json({ message: `Le RDV avec l'ID ${rdvId} n'existe pas.` });
    }

    if (rdv.annule) {
      return res
        .status(400)
        .json({ message: `Le RDV avec l'ID ${rdvId} a été annulé.` });
    }

    if (!rdv.confirme) {
      return res
        .status(400)
        .json({ message: `Le RDV avec l'ID ${rdvId} n'a pas été confirmé.` });
    }

    const artisanDemande = await models.ArtisanDemande.findOne({
      where: { DemandeId: rdv.DemandeId },
    });

    if (!artisanDemande) {
      return res
        .status(404)
        .json({
          message: `Aucun artisan n'est associé à la demande de RDV avec l'ID ${rdvId}.`,
        });
    }

    const artisan = await models.Artisan.findByPk(artisanDemande.ArtisanId, {
      attributes: ['NomArtisan', 'PrenomArtisan'],
    });

    const rdvAffich = {
      DateDebut: rdv.DateDebut,
      HeureDebut: rdv.HeureDebut,
    };
    const prestation = {
      Nom: rdv.Demande.Prestation.NomPrestation,
      Materiel: rdv.Demande.Prestation.Maéeriel,
      DureeMax: rdv.Demande.Prestation.DuréeMax,
      DurreMin: rdv.Demande.Prestation.DuréeMin,
      Ecologique: rdv.Demande.Prestation.Ecologique,
    };
    return res.status(200).json({ artisan, rdv: rdvAffich, prestation });
  } catch (error) {
    console.error(
      'Erreur lors de la récupération des détails de la demande confirmée :',
      error
    );
    return res
      .status(500)
      .json({
        message:
          "Une erreur s'est produite lors du traitement de votre demande.",
      });
  }
}
async function DetailsRDVTermine(req, res) {
  const clientId = req.userId;
  const rdvId = req.body.rdvId;

  try {
    const rdv = await models.RDV.findByPk(rdvId, {
      include: [{ model: models.Demande, include: [models.Prestation] }],
    });

    if (!rdv) {
      return res
        .status(404)
        .json({ message: `Le RDV avec l'ID ${rdvId} n'existe pas.` });
    }

    if (rdv.annule) {
      return res
        .status(400)
        .json({ message: `Le RDV avec l'ID ${rdvId} a été annulé.` });
    }

    if (!rdv.confirme) {
      return res
        .status(400)
        .json({ message: `Le RDV avec l'ID ${rdvId} n'a pas été confirmé.` });
    }

    const now = new Date();
    const rdvDateFin = new Date(rdv.DateFin);
    const rdvHeureFin = new Date(rdv.HeureFin);

    if (
      rdvDateFin > now ||
      (rdvDateFin.getTime() === now.getTime() &&
        rdvHeureFin.getTime() > now.getTime())
    ) {
      return res
        .status(400)
        .json({
          message: `Le RDV avec l'ID ${rdvId} n'est pas encore terminé.`,
        });
    }

    const artisanDemande = await models.ArtisanDemande.findOne({
      where: { DemandeId: rdv.DemandeId },
    });

    if (!artisanDemande) {
      return res
        .status(404)
        .json({
          message: `Aucun artisan n'est associé à la demande de RDV avec l'ID ${rdvId}.`,
        });
    }

    const artisan = await models.Artisan.findByPk(artisanDemande.ArtisanId, {
      attributes: ['NomArtisan', 'PrenomArtisan'],
    });

    const rdvAffich = {
      DateDebut: rdv.DateDebut,
      HeureDebut: rdv.HeureDebut,
      DateFin: rdv.DateFin,
      HeureFin: rdv.HeureFin,
    };

    const prestation = {
      Nom: rdv.Demande.Prestation.NomPrestation,
      Materiel: rdv.Demande.Prestation.Matériel,
      DureeMax: rdv.Demande.Prestation.DuréeMax,
      DureeMin: rdv.Demande.Prestation.DuréeMin,
      Ecologique: rdv.Demande.Prestation.Ecologique,
    };

    return res.status(200).json({ artisan, rdv: rdvAffich, prestation });
  } catch (error) {
    console.error(
      'Erreur lors de la récupération des détails du RDV terminé :',
      error
    );
    return res
      .status(500)
      .json({
        message:
          "Une erreur s'est produite lors du traitement de votre demande.",
      });
  }
}

module.exports = {
  signUp: signUp,
  updateClient: updateClient,
  lancerdemande: lancerdemande,
  creerRDV: creerRDV,
  confirmerRDV: confirmerRDV,
  annulerRDV: annulerRDV,
  AfficherArtisan: AfficherArtisan,
  creerEvaluation: creerEvaluation,
  test,
  ActiviteTerminee,
  ActiviteEncours,
  AfficherPrestations,
  AfficherProfil,
  DetailsDemandeConfirmee,
  DetailsRDVTermine,
  updateClientImage,
};
