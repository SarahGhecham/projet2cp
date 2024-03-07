const Validator=require('fastest-validator');
const models = require('../models');
const bcryptjs = require('bcryptjs');
const jwt = require('jsonwebtoken');

//Inscription du client
function signUp(req,res){
    const client ={
         NomClient: req.body.NomClient,
         PrenomClient: req.body.PrenomClient,
         MotdepasseClient: req.body.MotdepasseClient,
         EmailClient: req.body.EmailClient,
         AdresseClient: req.body.AdresseClient,
         NumeroTelClient: req.body.NumeroTelClient
    }
    models.Client.create(client).then(result =>{
        res.status(201).json({
            message:"Inscription client réussite",
            client:result

        });
            
    }).catch(error =>{
        res.status(500).json({
            message:"Something went wrong",
            error:error
        });
        
    });


}

module.exports={
   signUp: signUp
}