const Validator=require('fastest-validator');
const models=require('../models');

const bcrypt = require('bcrypt');

async function updateartisan(req, res) {
    const id = req.params.id;

    // Hash the new password if provided
    let hashedPassword = null;
    if (req.body.MotdepasseArtisan) {
        hashedPassword = await bcrypt.hash(req.body.MotdepasseArtisan, 10);
    }

    const updatedArtisan = {
        NomArtisan: req.body.NomArtisan,
        PrenomArtisan: req.body.PrenomArtisan,
        MotdepasseArtisan: hashedPassword, // Hashed password
        EmailArtisan: req.body.EmailArtisan,
        AdresseArtisan: req.body.AdresseArtisan,
        NumeroTelArtisan: req.body.NumeroTelArtisan,
        disponibilite: req.body.disponibilite,
        photo: req.body.photo 
    };

    // Update the Artisan model with the updated data
    models.Artisan.update(updatedArtisan, { where: { id: id } })
        .then(result => {
            if (result[0] === 1) {
                res.status(201).json({
                    message: "Artisan updated successfully",
                    artisan: updatedArtisan
                });
            } else {
                res.status(404).json({ message: "Artisan not found" });
            }
        })
        .catch(error => {
            res.status(500).json({
                message: "Something went wrong",
                error: error
            });
        });
}


function AfficherProfil(req,res){
    const id=req.params.id;
    models.Artisan.findByPk(id).then(result=>{
        if(result){
            const artisanInfo = {
                NomArtisan: result.NomArtisan,
                PrenomArtisan: result.PrenomArtisan,
                EmailArtisan: result.EmailArtisan,
                AdresseArtisan: result.AdresseArtisan,
                NumeroTelArtisan: result.NumeroTelArtisan,
                Disponibilite: result.Disponibilite,
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
module.exports = {
    updateartisan:updateartisan , 
    AfficherProfil:AfficherProfil
}