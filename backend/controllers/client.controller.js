const Validator = require('fastest-validator');
const models = require('../models');
const { RDV, Demande} = require('../models');
const {Prestation} = require('../models');
const bcryptjs = require('bcryptjs');
const jwt = require('jsonwebtoken');

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
        Note:req.body.Note,
        Commentaire:req.body.Commentaire,
        RDVId: req.body.RDVId
    };
    const Note=req.body.Note;
    const RDVId=req.body.RDVId;
    const RDV =  models.RDV.findByPk(RDVId);
    if (!RDV) {
        return res.status(404).json({ message: `La demande avec l'ID ${RDVId} n'existe pas.` });
    }
    if (isNaN(Note) || Note < 0 || Note > 5) {
        return res.status(400).json({ message: "La notation doit être un nombre décimal entre 0 et 5." });
    }
    models.Evaluation.create(evaluation).then(result => {
        res.status(201).json({
            message: "réussite",
            evaluation: result,
        });
    }).catch(error => {
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
                AdresseArtisan: result.AdresseArtisan
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
    const heureDebutString = req.body.heureDebut; // Heure de début sous forme de chaîne

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
        console.log(clientId);
        const prestationId = demande.PrestationId;
        console.log("ID de prestation:", prestationId);

        // Récupérer la durée maximale de la prestation (en heures)
        const dureeMaxString = demande.Prestation.DuréeMax;
        const dureeMaxNumeric = parseInt(dureeMaxString);

        // Calculer l'heure de fin à partir de l'heure de début et de la durée maximale (en millisecondes)
        const dureeMaxMillisecondes = dureeMaxNumeric * 60 * 60 * 1000;
        const heureFin = new Date(heureDebut.getTime() + dureeMaxMillisecondes); // Ajout de la durée maximale à l'heure de début

        // Formater HeureFin en hh:mm
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

async function AfficherEvaluations(req, res) {
    const artisanId = req.params.artisanId; // Supposons que l'ID de l'artisan soit passé dans les paramètres de l'URL

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
                ]
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
    AfficherEvaluations,
    AfficherPrestations
}