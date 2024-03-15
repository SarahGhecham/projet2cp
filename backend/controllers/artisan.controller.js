const Validator=require('fastest-validator');
const models=require('../models');


function updateartisan(req, res) {
    const id = req.params.id;
    const updatedArtisan = {
        NomArtisan: req.body.NomArtisan,
        PrenomArtisan:req.body.PrenomArtisan,
        MotdepasseArtisan: req.body.MotdepasseArtisan,
        EmailArtisan: req.body.EmailArtisan,
        AdresseArtisan: req.body.AdresseArtisan,
        NumeroTelArtisan: req.body.NumeroTelArtisan
    };

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

module.exports = {
    updateartisan:updateartisan,
}