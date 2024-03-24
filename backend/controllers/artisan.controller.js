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


async function accepterRDV(req, res) {
    const rdvId = req.body.rdvId; 

    try {
        const rdv = await models.RDV.findByPk(rdvId);
        if (!rdv) {
            return res.status(404).json({ message: `Le RDV avec l'ID ${rdvId} n'existe pas.` });
        }

        rdv.accepte = true;
        await rdv.save();
        return res.status(200).json({ message: `Le RDV avec l'ID ${rdvId} a été accepté avec succès.`, rdv });
    } catch (error) {
        console.error("Erreur lors de l'acceptation du RDV :", error);
        return res.status(500).json({ message: 'Une erreur s\'est produite lors du traitement de votre demande.' });
    }
}

async function annulerRDV(req, res) {
    const rdvId = req.body.rdvId; 

    try {
        const rdv = await models.RDV.findByPk(rdvId);
        if (!rdv) {
            return res.status(404).json({ message: `Le RDV avec l'ID ${rdvId} n'existe pas.` });
        }

        rdv.annule = true;
        await rdv.save();
        return res.status(200).json({ message: `Le RDV avec l'ID ${rdvId} a été annulé avec succès.`, rdv });
    } catch (error) {
        console.error("Erreur lors de l'annulation du RDV :", error);
        return res.status(500).json({ message: 'Une erreur s\'est produite lors du traitement de votre demande.' });
    }
}








module.exports = {
    updateartisan:updateartisan,
    accepterRDV:accepterRDV,
    annulerRDV:annulerRDV
}