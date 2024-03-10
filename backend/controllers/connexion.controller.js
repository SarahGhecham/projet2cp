const Validator = require('fastest-validator');
const models = require('../models');
const bcryptjs = require('bcryptjs');
const jwt = require('jsonwebtoken');


function login(req, res) {
    const email = req.body.Email;
    const password = req.body.Motdepasse;

    // Fonction connexion client
    function clientLogin() {
        models.Client.findOne({
            where: { EmailClient: email }
        }).then(client => {
            if (client === null) {
                artisanLogin(); // Si le client n'est pas trouvé, essayer artisan login
            } else {

                comparePasswordAndRespond(client.MotdepasseClient, client.IdClient,client.ActifClient);
            }
        }).catch(error => {
            respondWithError(error);
        });
    }

    // Fonction connexion artisan 
    function artisanLogin() {
        models.Artisan.findOne({
            where: { EmailArtisan: email }
        }).then(artisan => {
            if (artisan === null) {
                adminLogin(); // Si artisan n'est pas trouvé, essayer admin login
            } else {
                comparePasswordAndRespond(artisan.MotdepasseArtisan, artisan.IArtisan,artisan.ActifArtisan);
            }
        }).catch(error => {
            respondWithError(error);
        });
    }

    // Fonction connexion admin 
    function adminLogin() {
        models.Admin.findOne({
            where: { EmailAdmin: email }
        }).then(admin => {
            if (admin === null) {
                respondWithInvalidCredentials();
            } else {
                comparePasswordAndRespond(admin.MotdepasseAdmin, admin.IdAdmin, 1);
            }
        }).catch(error => {
            respondWithError(error);
        });
    }


    // Function to compare password and respond accordingly
function comparePasswordAndRespond(storedPassword, userId, isActive) {
    bcryptjs.compare(password, storedPassword, function (err, result) {
        if (err) {
            respondWithError(err);
        } else {
            if (result) {
                if (isActive) {
                    const token = jwt.sign({
                        Email: email,
                        UserId: userId
                    }, 'secret', function (err, token) {
                        if (err) {
                            respondWithError(err);
                        } else {
                            res.status(200).json({
                                message: "Authentification réussie",
                                token: token
                            });
                        }
                    });
                } else {
                    res.status(401).json({
                        message: "Compte désactivé"
                    });
                }
            } else {
                respondWithInvalidCredentials();
            }
        }
    });
}


    // Fonction réponse avec des informations d'identification invalides
    function respondWithInvalidCredentials() {
        res.status(401).json({
            message: "Informations d'identification invalides"
        });
    }

    // Function réponse avec erruer
    function respondWithError(error) {
        res.status(500).json({
            message: "Something went wrong",
            error: error
        });
    }

    // Démarrez le processus de connexion en vérifiant la table client
    clientLogin();
   
}

module.exports = {
    login: login
};






