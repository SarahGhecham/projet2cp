const Validator = require('fastest-validator');
const models = require('../models');
const { RDV, Demande} = require('../models');
const {Prestation} = require('../models');
const bcryptjs = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { Op } = require('sequelize');
const moment = require('moment');


// Inscription du client
function signUp(req, res) {
    models.Client.findOne({
        where: { EmailClient: req.body.EmailClient }
    }).then(result => {
        if (result) {
            res.status(409).json({
                message: "Compte email existant"
            });
        } else {
            models.Artisan.findOne({
                where: {EmailArtisan:req.body.EmailClient }
            }).then(result=>{
                if (result) {
                    res.status(409).json({
                        message: "Compte email existant"
                    });
                }else{   bcryptjs.genSalt(10, function (err, salt) {
                    bcryptjs.hash(req.body.MotdepasseClient, salt, function (err, hash) {
                        const client = {
                            NomClient: req.body.NomClient,
                            PrenomClient: req.body.PrenomClient,
                            MotdepasseClient: hash,
                            EmailClient: req.body.EmailClient,
                            AdresseClient: req.body.AdresseClient,
                            NumeroTelClient: req.body.NumeroTelClient
                        }
                        models.Client.create(client).then(result => {
                            res.status(201).json({
                                message: "Inscription client réussite",
                                client: result
                            });
                        }).catch(error => {
                            res.status(500).json({
                                message: "Something went wrong",
                                error: error
                            });
                        });
                    });
                });}
            }).catch(error => {
                res.status(500).json({
                    message: "Something went wrong",
                    error: error
                });
            });
         
        }
    }).catch(error => {
        res.status(500).json({
            message: "Something went wrong",
            error: error
        });
    });
}

function updateclient(req, res) {
    const id = req.params.id;
    const updatedClient = {
        NomClient: req.body.NomClient,
        PrenomClient:req.body.PrenomClient,
        MotdepasseClient: req.body.MotdepasseClient,
        EmailClient: req.body.EmailClient,
        AdresseClient: req.body.AdresseClient,
        NumeroTelClient: req.body.NumeroTelClient
    };

    models.Client.update(updatedClient, { where: { id: id } })
        .then(result => {
            if (result[0] === 1) {
                res.status(201).json({
                    message: "Client updated successfully",
                    client: updatedClient
                });
            } else {
                res.status(404).json({ message: "Client not found" });
            }
        })
        .catch(error => {
            res.status(500).json({
                message: "Something went wrong",
                error: error
            });
        });
}

function creerEvaluation(req, res) {
    const evaluation = {
        Note: req.body.Note,
        Commentaire: req.body.Commentaire,
        RDVId: req.body.RDVId
    };
    const Note = req.body.Note;
    const RDVId = req.body.RDVId;
    models.RDV.findByPk(RDVId)
        .then(RDV => {
            if (!RDV) {
                return res.status(404).json({ message: `La demande avec l'ID ${RDVId} n'existe pas.` });
            }
            if (RDV.annule) {
                return res.status(400).json({ message: `Le rendez-vous avec l'ID ${RDVId} a été annulé.` });
            }
            if (!RDV.confirme) {
                return res.status(400).json({ message: `Le rendez-vous avec l'ID ${RDVId} n'est pas confirmé.` });
            }
            const now = new Date();
            const rdvDateFin = new Date(RDV.DateFin);
            //const rdvHeureFin = new Date(RDV.HeureFin);
            // Comparaison de la date actuelle avec la date de fin du RDV
            if (now < rdvDateFin) {
                return res.status(400).json({ message: `La date actuelle est antérieure à la fin du rendez-vous.` });
            }
              
            // Comparaison de la date et l'heure actuelles avec la date et l'heure de fin du RDV
         const maintenant = moment();
         const rdvHeureFin = moment(RDV.HeureFin, 'HH:mm');

            // Créer un objet de date et heure pour la date et l'heure actuelles
        const nowDateTime = moment(`${maintenant.format('YYYY-MM-DD')} ${maintenant.format('HH:mm')}`, 'YYYY-MM-DD HH:mm');

           // Comparer maintenant avec l'heure de fin du rendez-vous
        if (nowDateTime.isBefore(rdvHeureFin)) {
            return res.status(400).json({ message: `L'heure actuelle est antérieure à la fin du rendez-vous.` });
          }
            if (isNaN(Note) || Note < 0 || Note > 5) {
                return res.status(400).json({ message: "La notation doit être un nombre décimal entre 0 et 5." });
            }
            return models.Evaluation.create(evaluation);
        })
        .then(result => {
            res.status(201).json({
                message: "Réussite",
                evaluation: result,
            });
        })
        .catch(error => {
            res.status(500).json({
                message: "Something went wrong",
                error: error
            });
        });
}



async function lancerdemande(req, res) {
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
}


function AfficherArtisan(req,res){
    const id=req.params.id;
    models.Artisan.findByPk(id).then(result=>{
        if(result){
            const artisanInfo = {
                NomArtisan: result.NomArtisan,
                PrenomArtisan: result.PrenomArtisan,
                NumeroTelArtisan: result.NumeroTelArtisan,
                AdresseArtisan: result.AdresseArtisan,
                Disponnibilite: result.Disponnibilite,
                Points: result.Points,
                Service_account: result.Service_account
            };
            res.status(201).json(artisanInfo);
        }
           
        else
            res.status(404).json({
          message:"artisan not found"
        })
    }).catch(error=>{
        res.status(500).json({
            message:"something went wrong",
            error : error
        })
    })
}

function AfficherProfil(req,res){
    const id=req.userId;
    models.Client.findByPk(id).then(result=>{
        if(result){
            const clientInfo = {
                NomClient: result.NomClient,
                PrenomClient: result.PrenomClient,
                EmailClient: result.EmailClient,
                AdresseClient: result.AdresseClient,
                NumeroTelClient: result.NumeroTelClient,
                Points: result.Points,
                Service_account: result.Service_account
            };
            res.status(201).json(clientInfo);
        }
           
        else
            res.status(404).json({
          message:"client not found"
        })
    }).catch(error=>{
        res.status(500).json({
            message:"something went wrong",
            error : error
        })
    })
}

function test(req,res){
    const id=req.params.id;
    models.Demande.findByPk(id).then(result=>{
        if(result)
           res.status(201).json(result)
        else
            res.status(404).json({
          message:"demande not found"
        })
    }).catch(error=>{
        res.status(500).json({
            message:"something went wrong"
        })
    })
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
            include: [
                { model: models.Client },
                { model: models.Prestation }
            ]
        });

        if (!demande) {
            return res.status(404).json({ message: `La demande avec l'ID ${demandeId} n'existe pas.` });
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
            DemandeId: demandeId
        });

        return res.status(201).json({ message: 'RDV créé avec succès', rdv });
    } catch (error) {
        console.error("Erreur lors de la création du RDV :", error);
        return res.status(500).json({ message: 'Une erreur s\'est produite lors du traitement de votre demande.' });
    }
}

async function confirmerRDV(req, res) {
    const rdvId = req.body.rdvId; 

    try {
        const rdv = await models.RDV.findByPk(rdvId);      
        if (!rdv) {
            return res.status(404).json({ message: `Le RDV avec l'ID ${rdvId} n'existe pas.` });
        }

        if (!rdv.accepte) {
            return res.status(400).json({ message: `Le RDV avec l'ID ${rdvId} n'a pas été accepté.` });
        }

        rdv.confirme = true;
        await rdv.save();
        return res.status(200).json({ message: `Le RDV avec l'ID ${rdvId} a été confirmé avec succès.`, rdv });
    } catch (error) {
        console.error("Erreur lors de la confirmation du RDV :", error);
        return res.status(500).json({ message: 'Une erreur s\'est produite lors du traitement de votre demande.' });
    }
}

async function annulerRDV(req, res) {
    const rdvId = req.body.rdvId; 

    try {
        const rdv = await models.RDV.findByPk(rdvId);
        if (!rdv) {
            return res.status(404).json({ message: `Le RDV avec l'ID ${rdvId} n'existe pas.` });
        }

       
        rdv.annule = true;
        await rdv.save();
        return res.status(200).json({ message: `Le RDV avec l'ID ${rdvId} a été annulé avec succès.`, rdv });
    } catch (error) {
        console.error("Erreur lors de l'annulation du RDV :", error);
        return res.status(500).json({ message: 'Une erreur s\'est produite lors du traitement de votre demande.' });
    }
}



async function ActiviteEncours(req, res) {
    const clientId = req.userId; 

    try {
        // Rechercher les IDs des demandes associées au client
        const demandes = await models.Demande.findAll({
            where: { ClientId: clientId }
        });

        // Récupérer les IDs des demandes associées au client
        const demandeIds = demandes.map(demande => demande.id);

        // Rechercher tous les rendez-vous associés aux demandes
        const rdvs = await models.RDV.findAll({
            where: { DemandeId: demandeIds },
            attributes: ['id', 'DemandeId', 'accepte', 'confirme', 'annule'] // Sélectionner également les attributs d'acceptation, de confirmation et d'annulation
        });

        // Filtrer les rendez-vous non acceptés, non confirmés et non annulés
        const rdvEnCoursIds = rdvs.filter(rdv => !rdv.annule && (!rdv.accepte || !rdv.confirme)).map(rdv => rdv.id);

        // Rechercher les détails de chaque rendez-vous en cours à partir de son ID
        const rendezVousEnCours = await models.RDV.findAll({
            where: { id: rdvEnCoursIds },
            include: [
                {
                    model: models.Demande,
                    include: [
                        { model: models.Client }, // Inclure le modèle Client associé à la demande
                        { model: models.Prestation } // Inclure le modèle Prestation associé à la demande
                    ]
                }
            ]
        });

        // Envoyer les détails des rendez-vous en cours en réponse
        return res.status(200).json(rendezVousEnCours);
    } catch (error) {
        console.error('Une erreur s\'est produite lors de la récupération des rendez-vous en cours :', error);
        return res.status(500).json({ message: 'Une erreur s\'est produite lors du traitement de votre demande.' });
    } 
}
async function Activiteterminee(req, res) {
    const clientId = req.userId; 

    try {
        // Recherchez les demandes du client avec leurs détails associés
        const demandesAvecDetails = await models.Demande.findAll({
            where: { ClientId: clientId },
            include: [
                {
                    model: models.Client // Inclure les détails du client
                },
                {
                    model: models.Prestation // Inclure les détails de la prestation
                },
                {
                    model: models.RDV, // Inclure les détails du rendez-vous
                    where: { 
                        accepte: true, // Rendez-vous accepté
                        confirme: true, // Rendez-vous confirmé
                        annule: false // Rendez-vous non annulé
                    }
                }
            ]
        });

        // Si aucune demande n'est trouvée, renvoyer une réponse appropriée
        if (demandesAvecDetails.length === 0) {
            return res.status(404).json({ message: "Aucune demande trouvée pour ce client." });
        }

        // Récupérer les détails des artisans pour chaque demande
        await Promise.all(demandesAvecDetails.map(async (demande) => {
            // Récupérer les détails de l'artisan associé à la demande
            const artisanDemande = await models.ArtisanDemande.findOne({
                where: { DemandeId: demande.id }
            });
            const artisan = await models.Artisan.findByPk(artisanDemande.ArtisanId, {
                attributes: ['NomArtisan', 'PrenomArtisan']
            });

            // Ajouter les détails de l'artisan à la demande
            demande.dataValues.Artisan = artisan;
        }));

        // Envoyer les détails des demandes avec leurs détails associés et les artisans associés en réponse
        return res.status(200).json(demandesAvecDetails);
    } catch (error) {
        console.error("Une erreur s'est produite lors de la récupération des demandes avec les détails associés :", error);
        return res.status(500).json({ message: "Une erreur s'est produite lors du traitement de votre demande." });
    }
}





function AfficherPrestations(req, res) {
    const domaineId = req.body.domaineId; // Supposons que vous récupériez l'ID du domaine depuis les paramètres de l'URL

    models.Prestation.findAll({
        where: { DomaineId: domaineId },
        include: [{
            model: models.Tarif // Inclure le modèle Tarif associé à chaque prestation
        }]
    }).then(result => {
        if (result.length > 0) {
            res.status(200).json(result);
        } else {
            res.status(404).json({ message: "Aucune prestation trouvée pour ce domaine." });
        }
    }).catch(error => {
        res.status(500).json({ message: "Une erreur s'est produite lors de la récupération des prestations.", error: error });
    });
}
async function DetailsDemandeConfirmee(req, res) {
    const clientId = req.userId;
    const rdvId = req.body.rdvId;

    try {
        // Récupérer les détails du rendez-vous
        const rdv = await models.RDV.findByPk(rdvId, {
            include: [
                { model: models.Demande, include: [models.Prestation] }
            ]
        });

        if (!rdv) {
            return res.status(404).json({ message: `Le RDV avec l'ID ${rdvId} n'existe pas.` });
        }

        // Vérifier si le rendez-vous a été confirmé
        if (!rdv.confirme) {
            return res.status(400).json({ message: `Le RDV avec l'ID ${rdvId} n'a pas été confirmé.` });
        }

        // Récupérer les détails de l'artisan associé à la demande
        const artisanDemande = await models.ArtisanDemande.findOne({
            where: { DemandeId: rdv.DemandeId }
        });

        if (!artisanDemande) {
            return res.status(404).json({ message: `Aucun artisan n'est associé à la demande de RDV avec l'ID ${rdvId}.` });
        }

        const artisan = await models.Artisan.findByPk(artisanDemande.ArtisanId, {
            attributes: ['NomArtisan', 'PrenomArtisan']
        });
        // Retourner les détails de l'artisan, du rendez-vous et de la prestation
        return res.status(200).json({ artisan, rdv, prestation: rdv.Demande.Prestation });
    } catch (error) {
        console.error("Erreur lors de la récupération des détails de la demande confirmée :", error);
        return res.status(500).json({ message: 'Une erreur s\'est produite lors du traitement de votre demande.' });
    }
}


module.exports = {
    signUp: signUp,
    updateclient:updateclient,
    lancerdemande:lancerdemande,
    creerRDV:creerRDV, 
    confirmerRDV:confirmerRDV,
    annulerRDV:annulerRDV,
    AfficherArtisan:AfficherArtisan,
    creerEvaluation:creerEvaluation,
    test,
    Activiteterminee,
    ActiviteEncours,
    AfficherPrestations,
    AfficherProfil,
    DetailsDemandeConfirmee,
}