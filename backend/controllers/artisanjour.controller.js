const models = require('../models');

async function addJourToArtisan(req, res) {
    const artisanId = req.params.artisanId;
    const jourId = req.params.jourId;

    try {
        // Check if the artisan and jour exist
        const artisan = await models.Artisan.findByPk(artisanId);
        const jour = await models.Jour.findByPk(jourId);

        if (!artisan) {
            return res.status(404).json({ message: `The artisan with ID ${artisanId} does not exist.` });
        }

        if (!jour) {
            return res.status(404).json({ message: `The jour with ID ${jourId} does not exist.` });
        }

        // Add the association in the junction table (ArtisanJour)
        await artisan.addJour(jour);

        return res.status(201).json({ message: `The association between the artisan with ID ${artisanId} and the jour with ID ${jourId} has been successfully added.` });
    } catch (error) {
        console.error('An error occurred while adding the artisan-jour association:', error);
        return res.status(500).json({ message: 'An error occurred while processing your request.' });
    }
}

module.exports = {
    addJourToArtisan,
};
