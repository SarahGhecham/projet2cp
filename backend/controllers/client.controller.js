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
async function lancerdemande(req, res) {
    const clientId = req.userId;
    const demandeId = req.params.demandeId;

    try {
        // Vérifier si la demande existe
        const demande = await models.Demande.findByPk(demandeId);
        if (!demande) {
            return res.status(404).json({ message: `La demande avec l'ID ${demandeId} n'existe pas.` });
        }

        // Trouver le client
        const client = await models.Client.findByPk(clientId);
        if (!client) {
            return res.status(404).json({ message: `Le client avec l'ID ${clientId} n'existe pas.` });
        }

        // Ajouter la demande au client
        await demande.update({ ClientId: clientId }); // Mettre à jour la demande avec l'ID du client

        return res.status(201).json({ message: `La relation entre la demande avec l'ID ${demandeId} et le client avec l'ID ${clientId} a été ajoutée avec succès.` });
    } catch (error) {
        console.error('Une erreur s\'est produite lors de l\'ajout de la relation demande-client :', error);
        return res.status(500).json({ message: 'Une erreur s\'est produite lors du traitement de votre demande.' });
    }
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




module.exports = {
    signUp: signUp,
    updateclient:updateclient,
    lancerdemande:lancerdemande,
    creerRDV:creerRDV, 
    confirmerRDV:confirmerRDV,
    annulerRDV:annulerRDV

   
}
