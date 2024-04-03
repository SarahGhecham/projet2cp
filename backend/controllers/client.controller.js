const Validator = require('fastest-validator');
const models = require('../models');
const { RDV, Demande} = require('../models');
const {Prestation} = require('../models');
const bcryptjs = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { Op } = require('sequelize');
const moment = require('moment');
const bcrypt = require('bcryptjs');
const axios = require('axios');
const nodemailer = require('nodemailer');

async function signUp(req, res) {
    try {
        const requiredFields = ['Username', 'MotdepasseClient', 'EmailClient', 'AdresseClient', 'NumeroTelClient'];
        for (const field of requiredFields) {
            if (!req.body[field]) {
                return res.status(400).json({ message: `Le champ '${field}' n'est pas rempli!` });
            }
        }
        const phonePattern = /^[0-9]{10}$/; 
        if (!phonePattern.test(req.body.NumeroTelClient)) {
            return res.status(400).json({ message: "Le numéro de téléphone n'a pas le bon format" });
        }

       // const apiKey = '2859b334b5cf4296976a534dbe5e69a7';
        const email = req.body.EmailClient;

        //const response = await axios.get(`https://api.zerobounce.net/v2/validate?api_key=${apiKey}&email=${email}`);

       // if (response.data.status === 'valid') {
            models.Client.findOne({ where: { EmailClient: email } })
                .then(result => {
                    if (result) {
                        res.status(409).json({ message: "Compte email déjà existant" });
                    } else {
                        models.Artisan.findOne({ where: { EmailArtisan: email } })
                            .then(result => {
                                if (result) {
                                    res.status(409).json({ message: "Compte email existant" });
                                } else {
                                    bcryptjs.genSalt(10, function (err, salt) {
                                        bcryptjs.hash(req.body.MotdepasseClient, salt, function (err, hash) {
                                            const client = {
                                                Username: req.body.Username,
                                                MotdepasseClient: hash,
                                                EmailClient: email,
                                                AdresseClient: req.body.AdresseClient,
                                                NumeroTelClient: req.body.NumeroTelClient
                                            };
                                            models.Client.create(client)
                                                .then(result => {
                                                    const token = jwt.sign({ userId: result.id, username: result.Username }, 'secret');

                                                    const transporter = nodemailer.createTransport({
                                                        service: 'gmail',
                                                        auth: {
                                                            user: 'beaverappservices@gmail.com',
                                                            pass: 'rucn vtaq cmxq dcwe'
                                                        }
                                                    });

                                                    const mailOptions = {
                                                        from: 'Beaver',
                                                        to: email,
                                                        subject: 'Confirmation d\'inscription',
                                                        text: `Bonjour ${req.body.Username},

Nous sommes ravis de vous accueillir chez Beaver ! Vous avez maintenant accès à notre plateforme et à tous nos services.

N'hésitez pas à explorer notre plateforme et à profiter de toutes les fonctionnalités que nous offrons. Si vous avez des questions ou avez besoin d'aide, n'hésitez pas à nous contacter.

Nous vous remercions de votre confiance et sommes impatients de vous voir profiter pleinement de votre expérience avec Beaver !

Cordialement,
L'équipe Beaver`
                                                    };

                                                    transporter.sendMail(mailOptions, function (error, info) {
                                                        if (error) {
                                                            console.error("Erreur lors de l'envoi de l'email de confirmation :", error);
                                                        } else {
                                                            console.log('Email de confirmation envoyé : ' + info.response);
                                                        }
                                                    });

                                                    res.status(201).json({ message: "Inscription client réussie", client: result, token });
                                                })
                                                .catch(error => {
                                                    res.status(500).json({ message: "Une erreur s'est produite lors de la création du client", error: error });
                                                });
                                        });
                                    });
                                }
                            })
                            .catch(error => {
                                res.status(500).json({ message: "Something went wrong", error: error });
                            });
                    }
                })
                .catch(error => {
                    res.status(500).json({ message: "Something went wrong", error: error });
                });
       // } else {
            //res.status(400).json({ message: "Email invalide" });
       // }
    } catch (error) {
        console.error("Erreur lors de la validation de l'e-mail :", error);
        res.status(500).json({ message: "Erreur lors de la validation de l'e-mail", error: error });
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
        NomClient: req.body.NomClient,
        PrenomClient: req.body.PrenomClient,
        MotdepasseClient: hashedPassword, // Hashed password
        EmailClient: req.body.EmailClient,
        AdresseClient: req.body.AdresseClient,
        NumeroTelClient: req.body.NumeroTelClient,
        //  any other client attributes you want to update
    }
   const fs = require('fs')

    // Update the Client model with the updated data
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

async function creerEvaluation(req, res) {
    const evaluation = {
        Note: req.body.Note,
        Commentaire: req.body.Commentaire,
        RDVId: req.body.RDVId
    };
    const Note = req.body.Note;
    const RDVId = req.body.RDVId;
    try {
        const RDV = await models.RDV.findByPk(RDVId);
        if (!RDV) {
            return res.status(404).json({ message: `Le rendez-vous avec l'ID ${RDVId} n'existe pas.` });
        }
        if (RDV.annule) {
            return res.status(400).json({ message: `Le rendez-vous avec l'ID ${RDVId} a été annulé.` });
        }
        if (!RDV.confirme) {
            return res.status(400).json({ message: `Le rendez-vous avec l'ID ${RDVId} n'est pas confirmé.` });
        }
        const now = new Date();
        const rdvDateFin = new Date(RDV.DateFin);
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
        if (now == rdvDateFin) {
        if (nowDateTime.isBefore(rdvHeureFin)) {
            return res.status(400).json({ message: `L'heure actuelle est antérieure à la fin du rendez-vous.` });
        }
    }
        if (isNaN(Note) || Note < 0 || Note > 5) {
            return res.status(400).json({ message: "La notation doit être un nombre décimal entre 0 et 5." });
        }
        const result = await models.Evaluation.create(evaluation);
        return res.status(201).json({
            message: "Réussite",
            evaluation: result,
        });
    } catch (error) {
        console.error("Une erreur s'est produite lors de la création de l'évaluation :", error);
        return res.status(500).json({ message: 'Une erreur s\'est produite lors du traitement de votre demande.' });
    }
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
                Service_account: result.Service_account ,
                photo: result.photo
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
        const maintenant = new Date();

        const demandes = await models.Demande.findAll({
            where: { ClientId: clientId }
        });

        const demandeIds = demandes.map(demande => demande.id);

        const rdvs = await models.RDV.findAll({
            where: { DemandeId: demandeIds },
            attributes: ['id', 'DemandeId', 'accepte', 'confirme', 'annule', 'DateFin', 'HeureFin'] // Sélectionner également les attributs d'acceptation, de confirmation, d'annulation, de date et d'heure de fin
        });

        const rendezVousEnCours = rdvs.filter(rdv => {
            const rdvDateFin = new Date(rdv.DateFin);
            const rdvHeureFin = new Date(`${rdv.DateFin}T${rdv.HeureFin}`);
            return (!rdv.annule && !rdv.accepte) || (!rdv.annule && rdv.accepte && !rdv.confirme) || (!rdv.annule && rdv.accepte && rdv.confirme && (rdvDateFin > maintenant || (rdvDateFin.getTime() === maintenant.getTime() && rdvHeureFin > maintenant)));
        });

        const rendezVousDetails = await Promise.all(rendezVousEnCours.map(async (rdv) => {
            const demande = await models.Demande.findByPk(rdv.DemandeId, {
                include: [
                    { model: models.Client },
                    { model: models.Prestation }
                ]
            });
            return { rdv, demande };
        }));

        return res.status(200).json(rendezVousDetails);
    } catch (error) {
        console.error('Une erreur s\'est produite lors de la récupération des rendez-vous en cours :', error);
        return res.status(500).json({ message: 'Une erreur s\'est produite lors du traitement de votre demande.' });
    }
}



async function Activiteterminee(req, res) {
    const clientId = req.userId; 

    try {
        // Récupérer la date et l'heure actuelles
        const maintenant = new Date();

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
                        annule: false, // Rendez-vous non annulé
                        [Op.and]: [
                            { DateFin: { [Op.lt]: maintenant } }, // Date de fin du RDV inférieure à maintenant
                            { HeureFin: { [Op.lt]: maintenant.getHours() + ":" + maintenant.getMinutes() } } // Heure de fin du RDV inférieure à maintenant
                        ]
                    }
                }
            ]
        });

        // Si aucune demande n'est trouvée, renvoyer une réponse appropriée
        if (demandesAvecDetails.length === 0) {
            return res.status(404).json({ message: "Aucune demande terminée trouvée pour ce client." });
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
        const rdv = await models.RDV.findByPk(rdvId, {
            include: [
                { model: models.Demande, include: [models.Prestation],
                 }
            ]
        });

        if (!rdv) {
            return res.status(404).json({ message: `Le RDV avec l'ID ${rdvId} n'existe pas.` });
        }
       
        if (rdv.annule) {
            return res.status(400).json({ message: `Le RDV avec l'ID ${rdvId} a été annulé.` });
        }
        
        if (!rdv.confirme) {
            return res.status(400).json({ message: `Le RDV avec l'ID ${rdvId} n'a pas été confirmé.` });
        }

        const artisanDemande = await models.ArtisanDemande.findOne({
            where: { DemandeId: rdv.DemandeId }
        });

        if (!artisanDemande) {
            return res.status(404).json({ message: `Aucun artisan n'est associé à la demande de RDV avec l'ID ${rdvId}.` });
        }

        const artisan = await models.Artisan.findByPk(artisanDemande.ArtisanId, {
            attributes: ['NomArtisan', 'PrenomArtisan']
        });

        const rdvAffich = {
            DateDebut: rdv.DateDebut,
            HeureDebut: rdv.HeureDebut
        };
        const prestation={
            Nom: rdv.Demande.Prestation.NomPrestation,
            Materiel: rdv.Demande.Prestation.Maéeriel,
            DureeMax: rdv.Demande.Prestation.DuréeMax,
            DurreMin: rdv.Demande.Prestation.DuréeMin,
            Ecologique: rdv.Demande.Prestation.Ecologique
        }
        return res.status(200).json({ artisan, rdv: rdvAffich, prestation });
    } catch (error) {
        console.error("Erreur lors de la récupération des détails de la demande confirmée :", error);
        return res.status(500).json({ message: 'Une erreur s\'est produite lors du traitement de votre demande.' });
    }
}
async function DetailsRDVTermine(req, res) {
    const clientId = req.userId;
    const rdvId = req.body.rdvId;

    try {
        const rdv = await models.RDV.findByPk(rdvId, {
            include: [
                { model: models.Demande, include: [models.Prestation] }
            ]
        });

        if (!rdv) {
            return res.status(404).json({ message: `Le RDV avec l'ID ${rdvId} n'existe pas.` });
        }
       
        if (rdv.annule) {
            return res.status(400).json({ message: `Le RDV avec l'ID ${rdvId} a été annulé.` });
        }
        
        if (!rdv.confirme) {
            return res.status(400).json({ message: `Le RDV avec l'ID ${rdvId} n'a pas été confirmé.` });
        }

        const now = new Date();
        const rdvDateFin = new Date(rdv.DateFin);
        const rdvHeureFin = new Date(rdv.HeureFin);

        if (rdvDateFin > now || (rdvDateFin.getTime() === now.getTime() && rdvHeureFin.getTime() > now.getTime())) {
            return res.status(400).json({ message: `Le RDV avec l'ID ${rdvId} n'est pas encore terminé.` });
        }

        const artisanDemande = await models.ArtisanDemande.findOne({
            where: { DemandeId: rdv.DemandeId }
        });

        if (!artisanDemande) {
            return res.status(404).json({ message: `Aucun artisan n'est associé à la demande de RDV avec l'ID ${rdvId}.` });
        }

        const artisan = await models.Artisan.findByPk(artisanDemande.ArtisanId, {
            attributes: ['NomArtisan', 'PrenomArtisan']
        });

        const rdvAffich = {
            DateDebut: rdv.DateDebut,
            HeureDebut: rdv.HeureDebut,
            DateFin: rdv.DateFin,
            HeureFin: rdv.HeureFin
        };

        const prestation = {
            Nom: rdv.Demande.Prestation.NomPrestation,
            Materiel: rdv.Demande.Prestation.Matériel,
            DureeMax: rdv.Demande.Prestation.DuréeMax,
            DureeMin: rdv.Demande.Prestation.DuréeMin,
            Ecologique: rdv.Demande.Prestation.Ecologique
        };

        return res.status(200).json({ artisan, rdv: rdvAffich, prestation });
    } catch (error) {
        console.error("Erreur lors de la récupération des détails du RDV terminé :", error);
        return res.status(500).json({ message: 'Une erreur s\'est produite lors du traitement de votre demande.' });
    }
}


module.exports = {
    signUp: signUp,
    updateClient:updateClient,
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
    DetailsRDVTermine,
}