const Validator=require('fastest-validator');
const models=require('../models');
const bcryptjs=require('bcryptjs');
//const upload = require('../helpers/image_uploader');
const imageUploader = require('../helpers/image_uploader');
const axios = require('axios');


function Creeradmin(req,res){
 bcryptjs.genSalt(10, function (err, salt) {
        bcryptjs.hash(req.body.MotdepasseAdmin, salt, function (err, hash) {
            const admin = {
                NomAdmin: req.body.NomAdmin,
                PrenomAdmin: req.body.PrenomAdmin,
                MotdepasseAdmin: hash,
                EmailAdmin: req.body.EmailAdmin,
                ActifAdmin: 1
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

async function CreerArtisan(req, res) {
    const Cleapi = 'AIzaSyDRCkJohH9RkmMIgpoNB2KBlLF6YMOOmmk';
        const address = req.body.AdresseArtisan;
        const isAddressValid = await validateAddress(address, Cleapi);

        if (!isAddressValid) {
            return res.status(400).json({ message: "L'adresse saisie est invalide" });
        }
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
                            NumeroTelArtisan: req.body.NumeroTelArtisan,
                            Disponibilite:req.body.Disponibilite ,
                            photo:req.body.photo
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
async function validateAddress(address, Cleapi) {
    try {
        const encodedAddress = encodeURIComponent(address);
        const response = await axios.get(`https://maps.googleapis.com/maps/api/geocode/json?address=${encodedAddress}&key=${Cleapi}`);

        return response.data.results.length > 0;
    } catch (error) {
        console.error("Une erreur s'est produite lors de la validation de l'adresse :", error);
        throw error;
    }
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
    const { NomDomaine } = req.body; 

    if (!req.file) {
        return res.status(400).json({ success: false, message: "Veuillez télécharger une image pour le domaine." });
    }

   
    const imageURL = `http://localhost:3000/imageDomaine/${req.file.filename}`; 
    const imageDomaine = imageURL; 
    
    models.Domaine.create({ 
        NomDomaine,
        imageDomaine
    }).then(nouveauDomaine => {
        res.status(201).json({ success: true, domaine: nouveauDomaine, imageURL: imageURL });
    }).catch(error => {
        res.status(500).json({ success: false, message: "Une erreur s'est produite lors de l'ajout du domaine." });
    });
}
function CreerTarif(req, res) {
    const {
        TarifJourMin,
        TarifJourMax,
        PourcentageNuit,
        PourcentageJourFérié,
        PourcentageWeekend,
        Unité
    } = req.body;


    models.Tarif.create({
        TarifJourMin,
        TarifJourMax,
        PourcentageNuit,
        PourcentageJourFérié,
        PourcentageWeekend,
        Unité
    }).then(() => {
        return res.status(200).json({ message: "Tarif créé avec succès." });
    }).catch(error => {
        console.error("Une erreur s'est produite lors de la création du tarif:", error);
        return res.status(500).json({ message: "Une erreur s'est produite lors de la création du tarif." });
    });
}
function CreerPrestation(req, res) {
   
    const {
        NomPrestation,
        Materiel,
        DureeMin,
        DureeMax,
        TarifId,
        DomaineId,
        Ecologique
    } = req.body;
    if (!req.file) {
        return res.status(400).json({ success: false, message: "Veuillez télécharger une image pour le domaine." });
    }
    const imageURL = `http://localhost:3000/imagePrestation/${req.file.filename}`; 
    const imagePrestation = imageURL; 
    // Création de la prestation dans la base de données
     models.Prestation.create({
        NomPrestation,
        Matériel:Materiel,
        DuréeMin:DureeMin,
        DuréeMax:DureeMax,
        TarifId,
        DomaineId,
        Ecologique,
        imagePrestation
    }).then(() => {
        return res.status(200).json({ message: "Prestation créée avec succès." ,imageURL: imageURL});
    }).catch(error => {
        console.error("Une erreur s'est produite lors de la création de la prestation:", error);
        return res.status(500).json({ message: "Une erreur s'est produite lors de la création de la prestation." });
    });
}
async function AjouterPrestation(req, res) {
    try {
        artisanId = req.params.id;
        const { prestationName } = req.body;

        const prestation = await models.Prestation.findOne({ where: { NomPrestation: prestationName } });

        if (!prestation) {
            return res.status(404).json({ message: "La prestation spécifiée n'existe pas." });
        }

        if (!prestation.id) {
            return res.status(404).json({ message: "La prestation spécifiée n'a pas d'identifiant valide." });
        }

        await models.ArtisanPrestation.create({
            ArtisanId: artisanId,
            PrestationId: prestation.id
        });

        return res.status(200).json({ message: "Prestation ajoutée avec succès à l'artisan." });
    } catch (error) {
        console.error("Une erreur s'est produite lors de l'ajout de la prestation à l'artisan:", error);
        return res.status(500).json({ message: "Une erreur s'est produite lors de l'ajout de la prestation à l'artisan." });
    }
}

function obtenirStatistiques(req, res) {
    Promise.all([
        models.Client.count(), 
        models.Artisan.count(),
        models.Demande.count() 
    ])
    .then(([nombreClients, nombreArtisans, nombreDemandes]) => {
        res.status(200).json({
            nombreClients: nombreClients,
            nombreArtisans: nombreArtisans,
            nombreDemandes: nombreDemandes
        });
    })
    .catch(error => {
        res.status(500).json({
            message: "Une erreur s'est produite lors de la récupération des statistiques.",
            error: error
        });
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
    CreerTarif:CreerTarif,
    CreerPrestation:CreerPrestation,
    AjouterPrestation:AjouterPrestation,
    obtenirStatistiques:obtenirStatistiques

}