const Validator=require('fastest-validator');
const models=require('../models');

function updateartisan(req, res) {
    const id = req.params.id;
    const updatedArtisan = {
        NomArtisan: req.body.NomArtisan,
        PrenomArtisan: req.body.PrenomArtisan,
        MotdepasseArtisan: req.body.MotdepasseArtisan,
        EmailArtisan: req.body.EmailArtisan,
        AdresseArtisan: req.body.AdresseArtisan,
        NumeroTelArtisan: req.body.NumeroTelArtisan,
        disponibilite: req.body.disponibilite // the 'disponibilite' attribute to the updatedArtisan object
    };

    // Check if file exists in the request
    if (req.files && req.files.photo) {
        const photoData = req.files.photo.data; // Access the binary data of the uploaded file
        updatedArtisan.photo = photoData;
    }

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


module.exports = {
    updateartisan:updateartisan,
}