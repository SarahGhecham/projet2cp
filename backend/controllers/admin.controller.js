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
    }).catch(error => {
        res.status(500).json({
            message: "Something went wrong",
            error: error
        });
    });
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

module.exports={
    save:save,
    CreerArtisan:CreerArtisan,
    Creeradmin:Creeradmin,
    show:show,
    destroy:destroy,
    AfficherArtisans:AfficherArtisans,
    AfficherClients:AfficherClients

}