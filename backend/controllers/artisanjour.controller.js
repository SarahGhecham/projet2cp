const models = require('../models');

async function addJourToArtisan(req, res) {
    try {
        // Extract the artisan ID and jour data from the request body
        const artisanId = req.params.artisanId;
        const jourData = {
            jour: req.body.jour, 
            heureDebut: req.body.heureDebut,
            heureFin: req.body.heureFin
           
        };

        // Find the artisan by ID
        const artisan = await models.Artisan.findByPk(artisanId);

        // Check if the artisan exists
        if (!artisan) {
            return res.status(404).json({ message: `Artisan with ID ${artisanId} not found.` });
        }

        // Create the jour and associate it with the artisan
        const jour = await models.Jour.create(jourData);
        await artisan.addJour(jour);

        // Respond with success message and the created jour
        return res.status(201).json({ message: 'Jour added to artisan successfully.', jour });
    } catch (error) {
        // Handle any errors that occur during the process
        console.error('Error adding jour to artisan:', error);
        return res.status(500).json({ message: 'Failed to add jour to artisan. Please try again later.' });
    }
}

async function deleteJourFromArtisan(req, res) {
    const artisanId = req.params.artisanId;
    const jourId = req.params.jourId;

    try {
        // Find the artisan
        const artisan = await models.Artisan.findByPk(artisanId);

        if (!artisan) {
            return res.status(404).json({ message: `Artisan with ID ${artisanId} not found` });
        }

        // Find the jour
        const jour = await models.Jour.findByPk(jourId);

        if (!jour) {
            return res.status(404).json({ message: `Jour with ID ${jourId} not found` });
        }

        // Remove the association between artisan and jour
        await artisan.removeJour(jour);

        return res.status(200).json({ message: `Jour with ID ${jourId} successfully removed from artisan with ID ${artisanId}` });
    } catch (error) {
        console.error('Error deleting jour from artisan:', error);
        return res.status(500).json({ message: 'Internal server error' });
    }
}
async function displayplanningofArtisan(req, res) {
    try {
        const artisanId = req.params.artisanId;

        // Find the artisan by ID
        const artisan = await models.Artisan.findByPk(artisanId);

        // Check if the artisan exists
        if (!artisan) {
            return res.status(404).json({ message: `Artisan with ID ${artisanId} not found.` });
        }

        // Retrieve all jourethorraires associated with the artisan
        const jourethorraires = await artisan.getJours();

        // Format the data as needed before sending the response
        let formattedJourethorraires = [];
        jourethorraires.forEach(jour => {
            // Get the horaires for the current jour
            const horaires = `${jour.heureDebut} à ${jour.heureFin}`;

            // Check if the jour already exists in formattedJourethorraires
            const existingJour = formattedJourethorraires.find(item => item.jour === jour.jour);

            // If the jour exists, check if the horaires already exist, if not, append
            if (existingJour) {
                if (!existingJour.horaires.includes(horaires)) {
                    existingJour.horaires += `, ${horaires}`;
                }
            } else {
                // If the jour doesn't exist, create a new item
                formattedJourethorraires.push({
                    jour: jour.jour,
                    horaires: horaires
                });
            }
        });

        // Respond with the formatted jourethorraires
        return res.status(200).json(formattedJourethorraires);
    } catch (error) {
        console.error('Error fetching jourethorraires for artisan:', error);
        return res.status(500).json({ message: 'Internal server error' });
    }
}



module.exports = {
    addJourToArtisan,
    deleteJourFromArtisan,
    displayplanningofArtisan
};

