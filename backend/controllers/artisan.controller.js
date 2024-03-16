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
function AjouterPrestation(req, res) {
   
    try {
        const artisanId = req.user.id;

        const { prestationName } = req.body;

        models.Prestation.findOne({ where: { NomPrestation: prestationName } }).then(prestation => {
            if (!prestation) {
                return res.status(404).json({ message: "La prestation spécifiée n'existe pas." });
            }

            // Vérifiez si la prestation a été trouvée avec succès
            if (prestation && prestation.id) {
                // Créez une entrée dans la table ArtisanPrestation
                models.ArtisanPrestation.create({
                    ArtisanId: artisanId,
                    PrestationId: prestation.id 
                }).then(() => {
                    return res.status(200).json({ message: "Prestation ajoutée avec succès à l'artisan." });
                }).catch(error => {
                    console.error("Une erreur s'est produite lors de l'ajout de la prestation à l'artisan:", error);
                    return res.status(500).json({ message: "Une erreur s'est produite lors de l'ajout de la prestation à l'artisan." });
                });
            } else {
                return res.status(404).json({ message: "La prestation spécifiée n'a pas d'identifiant valide." });
            }
        });
    } catch (error) {
        console.error("Une erreur s'est produite lors de l'ajout de la prestation à l'artisan:", error);
        return res.status(500).json({ message: "Une erreur s'est produite lors de l'ajout de la prestation à l'artisan." });
    }
}



module.exports = {
    updateartisan:updateartisan,
    AjouterPrestation:AjouterPrestation,
}