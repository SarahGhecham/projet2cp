const Validator=require('fastest-validator');
const models=require('../models');
const bcryptjs=require('bcryptjs');
function Creeradmin(req,res){
 bcryptjs.genSalt(10, function (err, salt) {
        bcryptjs.hash(req.body.MotdepasseAdmin, salt, function (err, hash) {
            const admin = {
                NomAdmin: req.body.NomAdmin,
                PrenomAdmin: req.body.PrenomAdmin,
                MotdepasseAdmin: hash,
                EmailAdmin: req.body.EmailAdmin,
            }
            models.Admin.create(admin).then(result => {
                res.status(201).json({
                    message: "Creation compte admin réussite",
                    admin: result
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
function CreerArtisan(req, res) {
    models.Client.findOne({
        where: { EmailClient: req.body.EmailArtisan }
    }).then(result => {
        if (result) {
            res.status(409).json({
                message: "Compte email existant"
            });
        } else {
            models.Artisan.findOne({
                where: {EmailArtisan:req.body.EmailArtisan }
            }).then(result=>{
                if (result) {
                    res.status(409).json({
                        message: "Compte email existant"
                    });
                }else{   bcryptjs.genSalt(10, function (err, salt) {
                    bcryptjs.hash(req.body.MotdepasseArtisan, salt, function (err, hash) {
                        const artisan = {
                            NomArtisan: req.body.NomArtisan,
                            PrenomArtisan: req.body.PrenomArtisan,
                            MotdepasseArtisan: hash,
                            EmailArtisan: req.body.EmailArtisan,
                            AdresseArtisan: req.body.AdresseArtisan,
                            NumeroTelArtisan: req.body.NumeroTelArtisan
                        }
                        models.Artisan.create(artisan).then(result => {
                            res.status(201).json({
                                message: "Creation compte artisan réussite",
                                artisan: result
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
    }).catch(error => {res.status(500).json({
        message: "Something went wrong",
        error: error
    });
});
}

function AfficherArtisans(req,res){
    models.Artisan.findAll().then(result=>{
        if(result)
          res.status(201).json(result)
        else
        res.status(404).json({
            message:"pas d'artisans"
          })
      }).catch(error=>{
          res.status(500).json({
              message:"something went wrong"
          })
      })
}

function AfficherClients(req,res){
    models.Client.findAll().then(result=>{
        if(result)
          res.status(201).json(result)
        else
        res.status(404).json({
            message:"pas de clients"
          })
      }).catch(error=>{
          res.status(500).json({
              message:"something went wrong",
              error : error
          })
      })
}

function DesactiverClient(req,res){
    const comptedesactive={
       EmailClient: req.body.EmailClient,
       ActifClient: false
    }
    models.Client.update(comptedesactive, { where: { EmailClient: req.body.EmailClient } })
    .then(result => {
        res.status(200).json({ message: "Client désactivé avec succès" });
    })
    .catch(error => {
        res.status(500).json({ message: "Erreur lors de la désactivation du client", error: error });
    });
}

function DesactiverArtisan(req,res){
    const comptedesactive={
       EmailArtisan: req.body.EmailArtisan,
       ActifArtisan: false
    }
    models.Artisan.update(comptedesactive, { where: { EmailArtisan: req.body.EmailArtisan } })
    .then(result => {
        res.status(200).json({ message: "Artisan désactivé avec succès" });
        
    })
    .catch(error => {
        res.status(500).json({ message: "Erreur lors de la désactivation de l'Artisan", error: error });
    });
}

function destroy(req,res){
    const id=req.params.id;
    models.Admin.destroy({where:{id:id}}).then(result=>{
        res.status(201).json({
            message:"deleted succesfully"
        })
    }).catch(error=>{
        res.status(500).json({
            message:"something went wrong"
        })
        
    })
}
function show(req,res){
    const id=req.params.id;
    models.Admin.findByPk(id).then(result=>{
        if(result)
           res.status(201).json(result)
        else
            res.status(404).json({
          message:"admin not found"
        })
    }).catch(error=>{
        res.status(500).json({
            message:"something went wrong"
        })
    })
}

function AjouterDomaine(req, res) {
    const { NomDomaine } = req.body; // Supposant que les données sont envoyées via le corps de la requête
    
    models.Domaine.create({  // Utilisation du modèle Domaine à partir du module models
        NomDomaine
    }).then(nouveauDomaine => {
        // Répondre avec le nouveau domaine créé
        res.status(201).json({ success: true, domaine: nouveauDomaine });
    }).catch(error => {
        // En cas d'erreur, répondre avec un message d'erreur
        res.status(500).json({ success: false, message: "Une erreur s'est produite lors de l'ajout du domaine." });
    });
}

module.exports={
    CreerArtisan:CreerArtisan,
    Creeradmin:Creeradmin,
    show:show,
    destroy:destroy,
    AfficherArtisans:AfficherArtisans,
    AfficherClients:AfficherClients,
    DesactiverClient:DesactiverClient,
    DesactiverArtisan:DesactiverArtisan,
    AjouterDomaine:AjouterDomaine,

}