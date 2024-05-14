const Validator=require('fastest-validator');
const models=require('../models');
const { Op } = require('sequelize');
const bcrypt = require('bcrypt');
const joursFeries = [
    new Date('2024-01-01'), // Jour de l'an
    new Date('2024-05-01'), // Fête du Travail
    new Date('2024-07-05'), // Fête de l'Indépendance
    new Date('2024-01-12'), //Yennayer
    new Date('2024-06-16'), //Aid El-Adha
    new Date('2024-07-07'), //Moharam
    new Date('2024-07-17'), //Achoura
    new Date('2024-09-15'), //Mouloud


  ];
  async function getArtisanRdvs(req, res) {
    const artisanId = req.userId;

    try {
        // Find the records in ArtisanDemandes where ArtisanId is the provided ID and accepte and confirme are true
        const artisanDemandes = await models.ArtisanDemande.findAll({
            where: { ArtisanId: artisanId, accepte: true, confirme: true }
        });

        // If no ArtisanDemandes are found, return an empty array
        if (!artisanDemandes || artisanDemandes.length === 0) {
            return res.status(200).json([]);
        }

        // Array to store DateDebut of rdvs
        const rdvDates = [];

        // Iterate over each ArtisanDemande
        for (const artisanDemande of artisanDemandes) {
            // Find the associated demande
            const demande = await models.Demande.findByPk(artisanDemande.DemandeId);

            // If the demande is not found, skip to the next one
            if (!demande) {
                continue;
            }

            // Find the rdv that has the demande's ID as DemandeId
            const rdv = await models.RDV.findOne({
                where: { DemandeId: demande.id }
            });

            // If the rdv is found, push its DateDebut to the rdvDates array
            if (rdv && rdv.DateDebut) {
                rdvDates.push(rdv.DateDebut);
            }
        }

        // Return the rdvDates array containing only the DateDebut of each rdv
        return res.status(200).json(rdvDates);
    } catch (error) {
        console.error('Error retrieving rdvs for artisan:', error);
        return res.status(500).json({ message: 'Internal server error' });
    }
}


async function consulterdemandes(req, res) {
    const artisanId = req.userId;

    console.log('Artisan ID:', artisanId);

    try {
        // Find all ArtisanDemandes where accepte and refuse are null for the given artisanId
        const artisanDemandes = await models.ArtisanDemande.findAll({
            where: { ArtisanId: artisanId, accepte: 0, refuse: 0 }
        });

        console.log('ArtisanDemandes:', artisanDemandes);

        // If no ArtisanDemandes are found, return a 404 response
        if (!artisanDemandes || artisanDemandes.length === 0) {
            console.log(`No demands found for artisan with ID ${artisanId}.`);
            return res.status(404).json({ message: `No demands found for artisan with ID ${artisanId}.` });
        }

        // Array to store demands with details
        const demandsWithDetails = [];

        // Iterate over each ArtisanDemande
        for (const artisanDemande of artisanDemandes) {
            console.log('ArtisanDemande:', artisanDemande);

            // Find the associated Demande
            const demande = await models.Demande.findByPk(artisanDemande.DemandeId, {
                include: [models.Client, models.Prestation]
            });

            console.log('Demande:', demande);

            // If the demande is not found, skip to the next one
            if (!demande) {
                console.log('Demande not found.');
                continue;
            }

            // Extract necessary information about client and prestation
            const clientInfo = {
                id: demande.Client.id,
                emailClient: demande.Client.EmailClient,
                username: demande.Client.Username
            };

            const prestationInfo = {
                id: demande.Prestation.id,
                nomPrestation: demande.Prestation.NomPrestation,
                Ecologique: demande.Prestation.Ecologique
            };
            const rdv = await models.RDV.findOne({
                where: { DemandeId: demande.id }
            });
            // Push the demande with client and prestation details to the array
            demandsWithDetails.push({
                id: demande.id,
                Description:demande.Description ,
                Urgente: demande.Urgente,
                client: clientInfo,
                prestation: prestationInfo,
                rdvId: rdv.id
            });
        }

        // Log the demands with details
        console.log('Demands with details:', demandsWithDetails);

        // Return the demands with details
        return res.status(200).json(demandsWithDetails);
    } catch (error) {
        console.error('Error retrieving demands for artisan:', error);
        return res.status(500).json({ message: 'Internal server error' });
    }
}
function AfficherProfil(req, res) {
    const id = req.userId;
    models.Artisan.findByPk(id, {
        include: [{
            model: models.Prestation,
            include: models.Domaine
        }]
    })
        .then(result => {
            if (result) {
                let domaine = null; // Domaine par défaut
                if (result.Prestations.length > 0 && result.Prestations[0].Domaine) {
                    domaine = result.Prestations[0].Domaine.NomDomaine; // Premier domaine rencontré
                }
                const artisanInfo = {
                    NomArtisan: result.NomArtisan,
                    PrenomArtisan: result.PrenomArtisan,
                    EmailArtisan: result.EmailArtisan,
                    AdresseArtisan: result.AdresseArtisan,
                    NumeroTelArtisan: result.NumeroTelArtisan,
                    Disponibilite: result.Disponibilite,
                    photo: result.photo,
                    Note: result.Note,
                    RayonKm:result.RayonKm ,
                    id:result.id,
                    Domaine: domaine, // Afficher le domaine
                    Prestations: result.Prestations.map(prestation => prestation.NomPrestation) // Afficher seulement les noms des prestations
                };
                res.status(200).json(artisanInfo);
            } else {
                res.status(404).json({ message: "Artisan not found" });
            }
        })
        .catch(error => {
            console.error("Error fetching artisan profile:", error);
            res.status(500).json({ message: "Something went wrong", error: error });
        });
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

async function updateartisan(req, res) {
    const id = req.userId;

    


    const updatedArtisan = {

        AdresseArtisan: req.body.AdresseArtisan,
        NumeroTelArtisan: req.body.NumeroTelArtisan,
        Disponibilite: req.body.Disponibilite,
        RayonKm:req.body.RayonKm,

    };

    // Update the Artisan model with the updated data
    models.Artisan.update(updatedArtisan, { where: { id: id } })
        .then(result => {
            if (result[0] === 1) {
                res.status(201).json({
                    message: "Artisan updated successfully",
                    artisan: updatedArtisan
                });
            } else {
                res.status(404).json({ message: "Artisan not found" });
            }
        })
        .catch(error => {
            res.status(500).json({
                message: "Something went wrong",
                error: error
            });
        });
}


function updateArtisanImage(req, res) {
    const id = req.userId;

    // Check if a file is uploaded
    if (!req.file) {
        return res.status(400).json({ success: false, message: "Please upload an image." });
    }

    // Construct the image URL for the artisan
    const imageURL = `http://192.168.100.7:3000/imageArtisan/${req.file.filename}`;

    // Update the artisan's photo URL in the database
    models.Artisan.findByPk(id)
        .then(artisan => {
            if (!artisan) {
                return res.status(404).json({ message: 'Artisan not found' });
            }

            // Update the artisan's photo URL
            artisan.photo = imageURL;

            // Saving the updated artisan
            return artisan.save();
        })
        .then(updatedArtisan => {
            // Success message and the updated artisan object
            res.status(200).json({
                success: true,
                message: 'Artisan image updated successfully',
                artisan: updatedArtisan,
                imageURL: imageURL
            });
        })
        .catch(error => {
            res.status(500).json({ success: false, message: 'Something went wrong', error: error });
        });
}



async function accepterRDV(req, res) {
    const demandeId = req.body.demandeId;
    const artisanId = req.userId;

    try {
        let artisandemande = await models.ArtisanDemande.findOne({ where: { DemandeId: demandeId, ArtisanId: artisanId } });

        if (!artisandemande) {
            return res.status(404).json({ message: `La relation artisan-demande pour la demande avec l'ID ${demandeId} et l'artisan avec l'ID ${artisanId} n'existe pas.` });
        }

        artisandemande.accepte = true;
        await artisandemande.save();
        await artisandemande.reload();

        return res.status(200).json({ message: `La demande avec l'ID ${demandeId} a été acceptée avec succès.` });
    } catch (error) {
        console.error("Erreur lors de l'acceptation de la demande :", error);
        return res.status(500).json({ message: 'Une erreur s\'est produite lors du traitement de votre demande.' });
    }
}


async function refuserRDV(req, res) {
    const demandeId = req.body.demandeId;
    const artisanId = req.userId;

    try {
        let artisandemande = await models.ArtisanDemande.findOne({ where: { DemandeId: demandeId, ArtisanId: artisanId } });

        if (!artisandemande) {
            return res.status(404).json({ message: `La relation artisan-demande pour la demande avec l'ID ${demandeId} et l'artisan avec l'ID ${artisanId} n'existe pas.` });
        }

        artisandemande.refuse = true;
        await artisandemande.save();
        await artisandemande.reload();

        return res.status(200).json({ message: `La demande avec l'ID ${demandeId} a été refusee avec succès.` });
    } catch (error) {
        console.error("Erreur lors du refus de la demande :", error);
        return res.status(500).json({ message: 'Une erreur s\'est produite lors du traitement de votre demande.' });
    }
}




async function associerDemandeArtisan(req, res) {
    const artisanId = req.body.artisanId;
    const demandeId = req.body.demandeId;

    try {
        // Vérifier si l'artisan existe
        const artisan = await models.Artisan.findByPk(artisanId);
        if (!artisan) {
            return res.status(404).json({ message: `L'artisan avec l'ID ${artisanId} n'existe pas.` });
        }

        // Vérifier si la demande existe
        const demande = await models.Demande.findByPk(demandeId);
        if (!demande) {
            return res.status(404).json({ message: `La demande avec l'ID ${demandeId} n'existe pas.` });
        }

        // Associer la demande à l'artisan
        const association = await models.ArtisanDemande.create({
            ArtisanId: artisanId,
            DemandeId: demandeId
        });

        return res.status(201).json({ message: `La demande avec l'ID ${demandeId} a été associée à l'artisan avec l'ID ${artisanId}.` });
    } catch (error) {
        console.error('Une erreur s\'est produite lors de l\'association de la demande à l\'artisan :', error);
        return res.status(500).json({ message: 'Une erreur s\'est produite lors du traitement de votre demande.' });
    }
}
/*async function AfficherEvaluations(req, res) {
    const artisanId = req.userId; // Supposons que l'ID de l'artisan soit passé dans les paramètres de l'URL

    try {
        // Recherchez les IDs des demandes associées à l'artisan dans la table de liaison ArtisanDemande
        const artisanDemandes = await models.ArtisanDemande.findAll({
            where: { ArtisanId: artisanId }
        });

        // Récupérez les IDs des demandes associées à l'artisan
        const demandeIds = artisanDemandes.map(ad => ad.DemandeId);

        // Récupérez tous les rendez-vous associés aux demandes
        const rdvs = await models.RDV.findAll({
            where: { DemandeId: demandeIds },
            attributes: ['id'] // Sélectionnez seulement l'attribut ID du rendez-vous
        });

        // Récupérez les IDs de tous les rendez-vous
        const rendezVousIds = rdvs.map(rdv => rdv.id);

        // Récupérez tous les IDs des évaluations associées aux rendez-vous
        const evaluations = await models.Evaluation.findAll({
            where: { RDVId: rendezVousIds },
            attributes: ['id'] // Sélectionnez seulement l'attribut ID de l'évaluation
        });

        // Récupérez les détails de chaque évaluation à partir de son ID
        const evaluationsDetails = await Promise.all(evaluations.map(async (evaluation) => {
            const evaluationDetails = await models.Evaluation.findByPk(evaluation.id, {
                include: [{
                    model: models.RDV,
                include: [
                    {
                        model: models.Demande,
                        include: [
                            {
                                model: models.Client,
                                model: models.Prestation // Inclure le modèle Client associé à la demande
                            }
                        ]
                    }
                ]// Inclure les détails de la demande associée au rendez-vous
                }]
            });
            return evaluationDetails;
        }));

        // Envoyez les détails des évaluations en réponse
        return res.status(200).json(evaluationsDetails);
    } catch (error) {
        console.error('Une erreur s\'est produite lors de la récupération des demandes :', error);
        return res.status(500).json({ message: 'Une erreur s\'est produite lors du traitement de votre demande.' });
    }
}
async function HistoriqueInterventions(req, res) {
    const artisanId = req.userId; // Supposons que l'ID de l'artisan soit passé dans les paramètres de l'URL

    try {
        // Recherchez les IDs des demandes associées à l'artisan dans la table de liaison ArtisanDemande
        const artisanDemandes = await models.ArtisanDemande.findAll({
            where: { ArtisanId: artisanId }
        });

        // Récupérez les IDs des demandes associées à l'artisan
        const demandeIds = artisanDemandes.map(ad => ad.DemandeId);

        // Récupérez les IDs des rendez-vous associés aux demandes
        const rendezVousIds = await models.RDV.findAll({
            where: { DemandeId: demandeIds }
        });
        

        // Récupérez les IDs des évaluations associées aux rendez-vous
        const evaluationIds = await models.Evaluation.findAll({
            where: { RDVId: rendezVousIds.map(rv => rv.id) }
        });
        // Filtrer uniquement les IDs des demandes qui ont un rendez-vous avec une évaluation associée
        const demandesAvecEvaluationIds = rendezVousIds
            .filter(rv => evaluationIds.some(e => e.RDVId === rv.id))
            .map(rv => rv.DemandeId);

        // Récupérez les détails de chaque demande à partir de la table Demande
        const demandesAvecEvaluation = await models.Demande.findAll({
            where: { id: demandesAvecEvaluationIds} // Utilisez les IDs des demandes avec rendez-vous avec évaluation
        });

        return res.status(200).json(demandesAvecEvaluation);
    } catch (error) {
        console.error('Une erreur s\'est produite lors de la récupération des demandes :', error);
        return res.status(500).json({ message: 'Une erreur s\'est produite lors du traitement de votre demande.' });
    }
}*/
async function Activiteterminee(req, res) {
    const artisanId = req.userId; 

    try {
        const maintenant = new Date();

        const artisanDemandes = await models.ArtisanDemande.findAll({
            where: { 
                ArtisanId: artisanId,
                accepte: true, 
                confirme: true,  
            }
        });

        const demandeIds = artisanDemandes.map(ad => ad.DemandeId);

        const rendezVousIds = await models.RDV.findAll({
            where: { DemandeId: demandeIds }
        });

        const demandesAvecEvaluationIds = [];

        for (const rendezVous of rendezVousIds) {
            const rdvDateFin = new Date(rendezVous.DateFin);
            const rdvHeureFin = new Date(`${rendezVous.DateFin}T${rendezVous.HeureFin}`);

            if (rdvDateFin < maintenant || (rdvDateFin.getTime() === maintenant.getTime() && rdvHeureFin < maintenant)) {
                demandesAvecEvaluationIds.push(rendezVous.DemandeId);
            }
        }

        const demandesAvecEvaluation = await models.Demande.findAll({
            where: { id: { [Op.in]: demandesAvecEvaluationIds } },
            include: [
                
                {
                    model: models.Prestation, 
                    attributes: ['nomPrestation', 'imagePrestation']
                },
                {
                    model: models.RDV, 
                    attributes: ['id','DateFin', 'HeureFin'],
                    where: { 
                        annule: false
                    }
                }
            ],
            attributes: { exclude: ['Description', 'PrestationId', 'ClientId', 'Urgente', 'createdAt', 'updatedAt'] }
            
        });

        // Assurez-vous que les données sont filtrées correctement et ne contiennent pas de valeurs nulles
        const filteredDemandesAvecEvaluation = demandesAvecEvaluation.filter(item => item !== null);

        return res.status(200).json(filteredDemandesAvecEvaluation);

    } catch (error) {
        console.error('Une erreur s\'est produite lors de la récupération des demandes :', error);
        return res.status(500).json({ message: 'Une erreur s\'est produite lors du traitement de votre demande.' });
    }
}

async function ActiviteEncours(req, res) {
    const artisanId = req.userId;
  
    try {
      const maintenant = new Date();
  
      // Recherche initiale dans la table ArtisanDemande
      const artisanDemandes = await models.ArtisanDemande.findAll({
        where: {
          ArtisanId: artisanId,
          accepte: true,
          // confirme: true, // Vous avez commenté cette ligne pour ne pas filtrer par "confirme"
        }
      });
  
      const demandeIds = artisanDemandes.map(ad => ad.DemandeId);
  
      // Recherche dans la table RDV avec les IDs de demande filtrés
      const rendezVousIds = await models.RDV.findAll({
        where: { DemandeId: demandeIds },
        attributes: ['id', 'DemandeId', 'annule', 'DateFin', 'HeureFin']
      });
  
      // Filtrer les rendez-vous en cours en fonction des conditions spécifiées
      const rendezVousEnCours = await Promise.all(rendezVousIds.map(async (rdv) => {
        const rdvDateFin = new Date(rdv.DateFin);
        const rdvHeureFin = new Date(`${rdv.DateFin}T${rdv.HeureFin}`);
  
        if (rdv.annule) {
          return null;
        }
  
        if (rdvDateFin > maintenant || (rdvDateFin.getTime() === maintenant.getTime() && rdvHeureFin > maintenant)) {
          const artisandemande = await models.ArtisanDemande.findOne({ where: { DemandeId: rdv.DemandeId } });
          if (!artisandemande) {
            return null;
          }
          return { rdv, artisandemande };
        } else {
          return null;
        }
      }));
  
      // Obtenir les détails des rendez-vous avec les demandes associées et la confirmation
      const rendezVousDetails = await Promise.all(rendezVousEnCours.map(async (rdvArtisan) => {
        if (!rdvArtisan) {
          return null;
        }
  
        const demande = await models.Demande.findByPk(rdvArtisan.rdv.DemandeId, {
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
  
        return { demande, rdv: rdvArtisan.rdv, confirme: rdvArtisan.artisandemande.confirme };
      }));
  
      // Filtrer les rendez-vous nulls
      const filteredRendezVousDetails = rendezVousDetails.filter(item => item !== null);
  
      return res.status(200).json(filteredRendezVousDetails);
    } catch (error) {
      console.error('Une erreur s\'est produite lors de la récupération des rendez-vous en cours :', error);
      return res.status(500).json({ message: 'Une erreur s\'est produite lors du traitement de votre demande.' });
    }
  }
  
  
async function DetailsDemandeConfirmee(req, res) {
    const artisanId = req.userId;
    const rdvId = req.params.rdvId;

    try {
        const rdv = await models.RDV.findByPk(rdvId, {
            include: [
                { model: models.Demande, 
                    include: [
                        {
                          model: models.Prestation,
                          include: [models.Tarif] 
                        }
                      ],
                    attributes: ['Description','Localisation','Urgente']
                 }
            ]
        });

        if (!rdv) {
            return res.status(404).json({ message: `Le RDV avec l'ID ${rdvId} n'existe pas.` });
        }

        if (rdv.annule) {
            return res.status(400).json({ message: `Le RDV avec l'ID ${rdvId} a été annulé.` });
        }

        const artisanDemande = await models.ArtisanDemande.findOne({
            where: {
                DemandeId: rdv.DemandeId,
                ArtisanId: artisanId
            }
        });

        if (!artisanDemande) {
            return res.status(404).json({ message: `Aucune demande n'est associée à cet artisan pour le RDV avec l'ID ${rdvId}.` });
        }

        const clientDemande = await models.Demande.findOne({
            where: { Id: rdv.DemandeId }
        });

        if (!clientDemande) {
            return res.status(404).json({ message: `Aucun client n'est associé à la demande de RDV avec l'ID ${rdvId}.` });
        }

        const client = await models.Client.findByPk(clientDemande.ClientId, {
            attributes: ['Username','photo','NumeroTelClient']
        });

        const rdvAffich = {
            DateDebut: rdv.DateDebut,
            HeureDebut: rdv.HeureDebut
        };
        const demandeAffich ={
            Description: rdv.Demande.Description,
            Localisation: rdv.Demande.Localisation,
            Urgente: rdv.Demande.Urgente
        }
        let tarifJourMin = rdv.Demande.Prestation.Tarif.TarifJourMin;
    let tarifJourMax = rdv.Demande.Prestation.Tarif.TarifJourMax;

    const rdvHeureDebut = new Date(rdv.HeureDebut);
    const isNight = rdvHeureDebut.getHours() >= 21;

    const rdvDateDebut = new Date(rdv.DateDebut);
    const isWeekend = rdvDateDebut.getDay() === 5 || rdvDateDebut.getDay() === 6;
    
    const isJourFerie = joursFeries.some(jourFerie => {
        return (
          jourFerie.getDate() === rdvDateDebut.getDate() &&
          jourFerie.getMonth() === rdvDateDebut.getMonth() &&
          jourFerie.getFullYear() === rdvDateDebut.getFullYear()
        );
      });
  
    if (isNight) {
        tarifJourMin *= (1 + (rdv.Demande.Prestation.Tarif.PourcentageNuit / 100));
        tarifJourMax *= (1 + (rdv.Demande.Prestation.Tarif.PourcentageNuit / 100));
    }
    
    if (isWeekend) {
        tarifJourMin *= (1 + (rdv.Demande.Prestation.Tarif.PourcentageWeekend / 100));
        tarifJourMax *= (1 + (rdv.Demande.Prestation.Tarif.PourcentageJourWeekend / 100));
    }
    
    if (isJourFerie) {
        tarifJourMin *= (1 + (rdv.Demande.Prestation.Tarif.PourcentageJourFérié / 100));
        tarifJourMax *= (1 + (rdv.Demande.Prestation.Tarif.PourcentageJourFérié / 100));
      }
    const clientScore = await models.Client.findByPk(clientDemande.ClientId);
    const reductionPercentage = clientScore.Points > 10 ? 0.1 : 0;

    
    
    // Remise à zéro des points du client
    if (client.Points > 10) {
        
    tarifJourMin *= (1 + (reductionPercentage / 100));
    tarifJourMax *= (1 + (reductionPercentage / 100));
      client.Points = 0;
      await client.save();
    }

    const prestation = {
      Nom: rdv.Demande.Prestation.NomPrestation,
      Materiel: rdv.Demande.Prestation.Matériel,
      Image: rdv.Demande.Prestation.imagePrestation,
      DureeMax: rdv.Demande.Prestation.DuréeMax,
      DureeMin: rdv.Demande.Prestation.DuréeMin,
      Ecologique: rdv.Demande.Prestation.Ecologique,
      TarifJourMin: tarifJourMin,
      TarifJourMax: tarifJourMax,
    };
        return res.status(200).json({ client,rdvAffich, prestation, demandeAffich });
    } catch (error) {
        console.error("Erreur lors de la récupération des détails de la demande confirmée :", error);
        return res.status(500).json({ message: 'Une erreur s\'est produite lors du traitement de votre demande.' });
    }
}


async function DetailsDemande(req, res) {
    const artisanId = req.userId;
    const demandeId = req.params.demandeId;

    try {
        const artisanDemande = await models.ArtisanDemande.findOne({
            where: { 
                DemandeId: demandeId,
                ArtisanId: artisanId
            }
        });

        if (!artisanDemande) {
            return res.status(404).json({ message: `Aucune demande n'est associée à cet artisan pour la Demande avec l'ID ${demandeId}.` });
        }

        const rdv = await models.RDV.findOne({
            where: { 
                DemandeId: demandeId,
                annule: false
            },
            include: [{
                model: models.Demande,
                include: [
                    { 
                      model: models.Prestation,
                      include: [models.Tarif] // Ajouter l'inclusion du modèle Tarif ici
                    }
                  ],
                attributes: ['Description','Localisation','Urgente','ClientId']  
            }]
        });

        if (!rdv) {
            return res.status(404).json({ message: `Le RDV pour la Demande avec l'ID ${demandeId} n'existe pas.` });
        }
        console.log(rdv.Demande.ClientId);
        const client = await models.Client.findByPk(rdv.Demande.ClientId, {
            attributes: ['Username','NumeroTelClient','photo','Points']
        });

        const rdvAffich = {
            DateDebut: rdv.DateDebut,
            HeureDebut: rdv.HeureDebut
        };

        const demandeAffich ={
            Description: rdv.Demande.Description,
            Localisation: rdv.Demande.Localisation,
            Urgente: rdv.Demande.Urgente
        };

        const rdvDate = new Date(rdv.DateDebut);
        const isWeekend = rdvDate.getDay() === 6 || rdvDate.getDay() === 5; // 6 pour samedi, 5 pour vendredi
        console.log(isWeekend);
    
        // Vérifier si l'heure du rendez-vous est la nuit (à partir de 21h)
        const rdvHeure = new Date(rdv.HeureDebut).getHours();
        const isNight = rdvHeure >= 21;
        console.log(isNight);
    
        const isHoliday =
          (rdvDate.getMonth() === 0 && rdvDate.getDate() === 1) || // Jour de l'an
          (rdvDate.getMonth() === 4 && rdvDate.getDate() === 1) ||
          (rdvDate.getMonth() === 6 && rdvDate.getDate() === 5) ||
          (rdvDate.getMonth() === 10 && rdvDate.getDate() === 1);   
        console.log(isHoliday);

        const Reduction=client.Points>10;
        console.log(Reduction);

        let tarifJourMin = rdv.Demande.Prestation.Tarif.TarifJourMin;
        let tarifJourMax = rdv.Demande.Prestation.Tarif.TarifJourMax;
        console.log(tarifJourMin);
                if (Reduction) {
                    tarifJourMin *= (0.95);
                    tarifJourMax *= (0.95);
                    }

                // Vérifier si c'est un jour férié et appliquer le pourcentage correspondant
                if (isHoliday) {
                tarifJourMin *= (1 + (rdv.Demande.Prestation.Tarif.PourcentageJourFérié / 100));
                tarifJourMax *= (1 + (rdv.Demande.Prestation.Tarif.PourcentageJourFérié / 100));
                }

                // Vérifier si c'est la nuit et appliquer le pourcentage correspondant
                if (isNight) {
                tarifJourMin *= (1 + (rdv.Demande.Prestation.Tarif.PourcentageNuit / 100));
                tarifJourMax *= (1 + (rdv.Demande.Prestation.Tarif.PourcentageJourFérié / 100));
                }

                // Vérifier si c'est un weekend et appliquer le pourcentage correspondant
                if (isWeekend) {
                tarifJourMin *= (1 + (rdv.Demande.Prestation.Tarif.PourcentageWeekend / 100));
                tarifJourMax *= (1 + (rdv.Demande.Prestation.Tarif.PourcentageJourFérié / 100));
                }

        const prestation = {
            Nom: rdv.Demande.Prestation.NomPrestation,
            Image: rdv.Demande.Prestation.imagePrestation,
            Materiel: rdv.Demande.Prestation.Maéeriel,
            DureeMax: rdv.Demande.Prestation.DuréeMax,
            DureeMin: rdv.Demande.Prestation.DuréeMin,
            Ecologique: rdv.Demande.Prestation.Ecologique,
            TarifJourMin: tarifJourMin,
            TarifJourMax: tarifJourMax
        };
        // Vérifier si la date du rendez-vous est un weekend
   
    
        return res.status(200).json({ client, rdvAffich, prestation, demandeAffich });
    } catch (error) {
        console.error("Erreur lors de la récupération des détails de la demande :", error);
        return res.status(500).json({ message: 'Une erreur s\'est produite lors du traitement de votre demande.' });
    }
}


async function DetailsRDVTermine(req, res) {
    const artisanId = req.userId;
    const rdvId = req.params.rdvId;

    try {
        const rdv = await models.RDV.findByPk(rdvId, {
            include: [
                { model: models.Demande, 
                    include: [
                        {
                          model: models.Prestation,
                          include: [models.Tarif] 
                        }
                      ],
                    attributes: ['Description','Localisation','Urgente']
                }
            ]
        });

        if (!rdv) {
            return res.status(404).json({ message: `Le RDV avec l'ID ${rdvId} n'existe pas.` });
        }

        if (rdv.annule) {
            return res.status(400).json({ message: `Le RDV avec l'ID ${rdvId} a été annulé.` });
        }

        const now = new Date();
        const rdvDateFin = new Date(rdv.DateFin);
        const rdvHeureFin = new Date(`${rdv.DateFin}T${rdv.HeureFin}`);

        if (rdvDateFin > now || (rdvDateFin.getTime() === now.getTime() && rdvHeureFin.getTime() > now.getTime())) {
            return res.status(400).json({ message: `Le RDV avec l'ID ${rdvId} n'est pas encore terminé.` });
        }

        const artisanDemande = await models.ArtisanDemande.findOne({
            where: {
                DemandeId: rdv.DemandeId,
                ArtisanId: artisanId
            }
        });

        if (!artisanDemande) {
            return res.status(404).json({ message: `Aucune demande n'est associée à cet artisan pour le RDV avec l'ID ${rdvId}.` });
        }

        if (!artisanDemande.confirme) {
            return res.status(404).json({ message: `Le RDV avec l'ID ${rdvId} n'a pas été confirmé.` });
        }

        const clientDemande = await models.Demande.findOne({
            where: { Id: rdv.DemandeId }
        });

        if (!clientDemande) {
            return res.status(404).json({ message: `Aucun client n'est associé à la demande de RDV avec l'ID ${rdvId}.` });
        }

        const client = await models.Client.findByPk(clientDemande.ClientId, {
            attributes: ['Username','photo','NumeroTelClient']
        });

        const rdvAffich = {
            DateDebut: rdv.DateDebut,
            HeureDebut: rdv.HeureDebut,
            DateFin: rdv.DateFin,
            HeureFin: rdv.HeureFin
        };
        const demandeAffich ={
            Description: rdv.Demande.Description,
            Localisation: rdv.Demande.Localisation,
            Urgente: rdv.Demande.Urgente
        }
        let tarifJourMin = rdv.Demande.Prestation.Tarif.TarifJourMin;
    let tarifJourMax = rdv.Demande.Prestation.Tarif.TarifJourMax;

    const rdvHeureDebut = new Date(rdv.HeureDebut);
    const isNight = rdvHeureDebut.getHours() >= 21;

    const rdvDateDebut = new Date(rdv.DateDebut);
    const isWeekend = rdvDateDebut.getDay() === 5 || rdvDateDebut.getDay() === 6;

    const isJourFerie = joursFeries.some(jourFerie => {
        return (
          jourFerie.getDate() === rdvDateDebut.getDate() &&
          jourFerie.getMonth() === rdvDateDebut.getMonth() &&
          jourFerie.getFullYear() === rdvDateDebut.getFullYear()
        );
      });
  
    if (isNight) {
      tarifJourMin += tarifJourMin * rdv.Demande.Prestation.Tarif.PourcentageNuit;
      tarifJourMax += tarifJourMax * rdv.Demande.Prestation.Tarif.PourcentageNuit;
    }
    
    if (isWeekend) {
      tarifJourMin += tarifJourMin * rdv.Demande.Prestation.Tarif.PourcentageWeekend;
      tarifJourMax += tarifJourMax * rdv.Demande.Prestation.Tarif.PourcentageWeekend;
    }

    if (isJourFerie) {
        tarifJourMin *= (1 + (rdv.Demande.Prestation.Tarif.PourcentageJourFérié / 100));
        tarifJourMax *= (1 + (rdv.Demande.Prestation.Tarif.PourcentageJourFérié / 100));
      }
    const clientScore = await models.Client.findByPk(clientDemande.ClientId);
    const reductionPercentage = clientScore.Points > 10 ? 0.1 : 0;

   
    
    // Remise à zéro des points du client
    if (client.Points > 10) {
        
    tarifJourMin *= (1 + (reductionPercentage / 100));
    tarifJourMax *= (1 + (reductionPercentage / 100));
      client.Points = 0;
      await client.save();
    }

    const prestation = {
      Nom: rdv.Demande.Prestation.NomPrestation,
      Materiel: rdv.Demande.Prestation.Matériel,
      Image: rdv.Demande.Prestation.imagePrestation,
      DureeMax: rdv.Demande.Prestation.DuréeMax,
      DureeMin: rdv.Demande.Prestation.DuréeMin,
      Ecologique: rdv.Demande.Prestation.Ecologique,
      TarifJourMin: tarifJourMin,
      TarifJourMax: tarifJourMax,
    };

        return res.status(200).json({ client,rdvAffich, prestation, demandeAffich });
    } catch (error) {
        console.error("Erreur lors de la récupération des détails du RDV terminé :", error);
        return res.status(500).json({ message: 'Une erreur s\'est produite lors du traitement de votre demande.' });
    }
}

async function getCommentaires(req, res) {
    const artisanId = req.userId;
    try {
        
        const demandesIds = await models.ArtisanDemande.findAll({ where: { ArtisanId: artisanId }, attributes: ['DemandeId'] });

       
        const demandes = await models.Demande.findAll({ where: { id: demandesIds.map(d => d.DemandeId) }, include: [models.Client, models.Prestation] });
        console.log(demandes);

        
        const commentaires = await Promise.all(demandes.map(async (demande) => {
            const rdv = await models.RDV.findOne({ where: { DemandeId: demande.id } });
            console.log(rdv);
            if (!rdv) return null; 
            const evaluation = await models.Evaluation.findOne({ where: { RDVId: rdv.id } });
            console.log(evaluation);
            if (!evaluation) return null; // Si aucune évaluation n'est associée au RDV, passer à la suivante
            return {
                commentaire: evaluation.Commentaire,
                note: evaluation.Note,
                client: {
                    id: demande.Client.id,
                    username: demande.Client.Username,
                    photo:demande.Client.photo
                   
                },
                prestation: {
                    id: demande.Prestation.id,
                    NomPrestation:demande.Prestation.NomPrestation,
                    Ecologique:demande.Prestation.Ecologique
                }
            };
        }));

        // Filtrer les commentaires nuls (pour les demandes sans RDV ou sans évaluation)
        const commentairesFiltres = commentaires.filter(commentaire => commentaire !== null);

        res.status(200).json({ commentaires: commentairesFiltres });
    } catch (error) {
        res.status(500).json({ message: "Une erreur s'est produite lors de la récupération des commentaires : " + error.message });
    }
}




  
  
module.exports = {
    updateartisan:updateartisan,
    updateArtisanImage: updateArtisanImage,
    getCommentaires,
    accepterRDV:accepterRDV,
    refuserRDV:refuserRDV,
    //HistoriqueInterventions,
    associerDemandeArtisan,
    //AfficherEvaluations,
    AfficherProfil,
    Activiteterminee,
    ActiviteEncours,
    DetailsDemandeConfirmee,
    DetailsRDVTermine,
    consulterdemandes,
    updateArtisanImage ,
    getArtisanRdvs,
    DetailsDemande
}
