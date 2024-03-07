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

//Se connecter
function login(req,res){
    models.Client.findOne({
        where: { EmailClient: req.body.EmailClient }
    }).then(client=>{
        if(client === null){
            res.status(401).json({
                message: "Informations d'identification invalides",
                error: error
            });

        }else{
            bcryptjs.compare(req.body.MotdepasseClient,client.MotdepasseClient,function(err,result){
                if(result){
                    const token = jwt.sign({
                        EmailClient : client.EmailClient,
                        IdClient : client.IdClient
                    },'secret',function(err,token){
                        res.status(200).json({
                            message: "Authentification réussite",
                            token: token
                        });
                    });
                }else{
                    res.status(401).json({
                        message: "Informations d'identification invalides",
                        
                    });
                }
            })
        }

    }).catch(error=>{
        res.status(500).json({
            message: "Something went wrong",
            error: error
        });
    })

}
module.exports = {
    signUp: signUp,
    login: login
}
