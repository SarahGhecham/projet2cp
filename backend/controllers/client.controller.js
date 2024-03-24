const Validator = require('fastest-validator');
const models = require('../models');
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
        Commentaire:req.body.Commentaire
    };
    const Note=req.body.Note;
    if (isNaN(Note) || Note < 0 || Note > 5) {
        return res.status(400).json({ message: "La notation doit être un nombre décimal entre 0 et 5." });
    }
    models.Evaluation.create(evaluation).then(result => {
        res.status(201).json({
            message: "réussite",
            evaluation: result
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
function AfficherArtisan(req,res){
    const id=req.params.id;
    models.Artisan.findByPk(id).then(result=>{
        if(result)
           res.status(201).json(result)
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


module.exports = {
    signUp: signUp,
    updateclient:updateclient,
    lancerdemande:lancerdemande,
    AfficherArtisan,
    creerEvaluation:creerEvaluation
    //login: login
}
