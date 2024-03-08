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
            bcryptjs.genSalt(10, function (err, salt) {
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
            });
        }
    }).catch(error => {
        res.status(500).json({
            message: "Something went wrong",
            error: error
        });
    });
}

module.exports = {
    signUp: signUp,
    //login: login
}
