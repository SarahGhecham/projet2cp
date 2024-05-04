const models = require('../models');

async function getArtisanHorairesByJour(req, res) {
    try {
        const artisanId = req.body.id;
        let jourToFind = req.body.jour;

        // Convert jourToFind to lowercase for case-insensitive comparison
        jourToFind = jourToFind.toLowerCase();

        // Find the artisan by ID
        const artisan = await models.Artisan.findByPk(artisanId);

        if (!artisan) {
            return res.status(404).json({ message: `Artisan with ID ${artisanId} not found.` });
        }

        // Retrieve all jours associated with the artisan
        const jours = await artisan.getJours();

        // Initialize an empty array to store horaires
        const horaires = jours
            // Filter jours that match the given jour
            .filter(jour => jour.jour.toLowerCase() === jourToFind)
            // Map the filtered jours to extract heureDebut and heureFin
            .map(jour => ({ heureDebut: jour.HeureDebut, heureFin: jour.HeureFin }));

        // Respond with the list of horaires
        return res.status(200).json(horaires);
    } catch (error) {
        console.error('Error retrieving horaires by jour for artisan:', error);
        return res.status(500).json({ message: 'Failed to retrieve horaires by jour for artisan.' });
    }
}
async function addHorrairesToArtisan(req, res) {
    try {
        // Extract the artisan ID and jour data from the request body
        const artisanId = req.params.artisanId;
        const jourData = {
            jour: req.body.jour, 
            HeureDebut: req.body.HeureDebut,
            HeureFin: req.body.HeureFin
        };

        // Find the artisan by ID
        const artisan = await models.Artisan.findByPk(artisanId);

        // Check if the artisan exists
        if (!artisan) {
            return res.status(404).json({ message: `Artisan with ID ${artisanId} not found.` });
        }

        // Find the jour if it already exists for the artisan
        const existingJour = await models.Jour.findOne({
            where: jourData,
            include: [{
                model: models.Artisan,
                where: { id: artisanId }
            }]
        });

        // If the jour already exists for the artisan, display it in Postman
        if (existingJour) {
            return res.status(500).json({ message: `Jour with the same horaires already exists and is associated with artisan with ID ${artisanId}.`, jour: existingJour });
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


/*async function modifyJour(req, res) {
    try {
        // Extract the jour ID from the request parameters
        const jourId = req.params.jourId;

        // Find the jour by ID
        const jour = await models.Jour.findByPk(jourId);

        // Check if the jour exists
        if (!jour) {
            return res.status(404).json({ message: `Jour with ID ${jourId} not found.` });
        }

        // Extract the updated jour data from the request body
        const updatedJourData = {
            jour: req.body.jour, 
            HeureDebut: req.body.HeureDebut,
            HeureFin: req.body.HeureFin
        };

        // Update the jour with the new data
        await jour.update(updatedJourData);

        // Respond with success message and the updated jour
        return res.status(200).json({ message: `Jour with ID ${jourId} updated successfully.`, jour });
    } catch (error) {
        // Handle any errors that occur during the process
        console.error('Error modifying jour:', error);
        return res.status(500).json({ message: 'Failed to modify jour. Please try again later.' });
    }
}
*/
/*async function modifyJourHorraires(req, res) {
    try {
        const artisanId = req.params.artisanId;
        const { jour,HeureDebutC, HeureFinC ,HeureDebutM,HeureFinM} = req.body;

        // Find the artisan by ID
        const artisan = await models.Artisan.findByPk(artisanId);

        if (!artisan) {
            return res.status(404).json({ message: `Artisan with ID ${artisanId} not found.` });
        }

        // Check if the jour exists with the given jourData
        const jourData = {
            jour: jour,
            HeureDebut: HeureDebutC,
            HeureFin: HeureFinC
        };

        const existingJour = await models.Jour.findOne({
            where: jourData
        });

        if (!existingJour) {
            return res.status(404).json({ message: `Jour with ${jour} and current horaires ${JSON.stringify(currentHoraires)} not found.` });
        }

        // Check if the jour is associated with the artisan
        const association = await models.ArtisanJour.findOne({
            where: {
                artisanId: artisanId,
                jourId: existingJour.id
            }
        });

        if (!association) {
            return res.status(404).json({ message: `Jour with ${jour} and current horaires ${JSON.stringify(currentHoraires)} does not belong to artisan with ID ${artisanId}.` });
        }

        // Update the horaires of the jour
        const jourUpdate = {
            jour: jour,
            HeureDebut: HeureDebutM,
            HeureFin: HeureFinM
        };

        // Update the jour with the new data
        await existingJour.update(jourUpdate);

        return res.status(200).json({ message: `Horaires of jour ${jour} updated successfully.` });
    } catch (error) {
        console.error('Error modifying jour horaires:', error);
        return res.status(500).json({ message: 'Failed to modify jour horaires. Please try again later.' });
    }
}

async function modifyJour(req, res) {
    try {
        // Extract the jour ID from the request body
        const { jourId, jour, HeureDebut, HeureFin } = req.body;

        // Find the jour by ID
        const existingJour = await models.Jour.findByPk(jourId);

        // Check if the jour exists
        if (!existingJour) {
            return res.status(404).json({ message: `Jour with ID ${jourId} not found.` });
        }

        // Update the jour with the new data
        await existingJour.update({
            jour: jour,
            HeureDebut: HeureDebut,
            HeureFin: HeureFin
        });

        // Respond with success message and the updated jour
        return res.status(200).json({ message: `Jour with ID ${jourId} updated successfully.`, jour: existingJour });
    } catch (error) {
        // Handle any errors that occur during the process
        console.error('Error modifying jour:', error);
        return res.status(500).json({ message: 'Failed to modify jour. Please try again later.' });
    }
}


*/
const jourController = require('../controllers/jour.controller');

async function deleteHorraires(req, res) {
    try {
        const artisanId = req.params.artisanId;
        const { jour, HeureDebut, HeureFin } = req.body;

        // Find the jour by jour, HeureDebut, and HeureFin
        const existingJour = await models.Jour.findOne({
            where: {
                jour: jour,
                HeureDebut: HeureDebut,
                HeureFin: HeureFin
            }
        });

        // Check if the jour exists
        if (!existingJour) {
            return res.status(404).json({ message: `Jour with ${jour} and horaires ${JSON.stringify({ HeureDebut, HeureFin })} not found.` });
        }

        // Find the artisan by ID
        const artisan = await models.Artisan.findByPk(artisanId);

        // Check if the artisan exists
        if (!artisan) {
            return res.status(404).json({ message: `Artisan with ID ${artisanId} not found.` });
        }

        // Remove the association between artisan and jour
        await artisan.removeJour(existingJour);

        // Delete the jour using the deleteJour function from jour controller
        await jourController.deleteJour(existingJour.id, res); // Pass existingJour.id instead of req

        return res.status(200).json({ message: `Jour ${jour} with horaires ${JSON.stringify({ HeureDebut, HeureFin })} deleted successfully.` });
    } catch (error) {
        console.error('Error deleting jour and association:', error);
        return res.status(500).json({ message: 'Failed to delete jour and association. Please try again later.' });
    }
}





/*async function deleteJourFromArtisan(req, res) {
    const artisanId = req.params.id;
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

        // Store jour data before deletion
        const jourData = {
            id: jour.id,
            jour: jour.jour,
            HeureDebut: jour.HeureDebut,
            HeureFin: jour.HeureFin
        };

        // Remove the association between artisan and jour
        await artisan.removeJour(jour);

        return res.status(200).json({ 
            message: `Jour ${jourData.jour} (ID: ${jourData.id}) is successfully removed from artisan with ID ${artisanId}`,
            deletedJour: jourData
        });
    } catch (error) {
        console.error('Error deleting jour from artisan:', error);
        return res.status(500).json({ message: 'Internal server error' });
    }
}
*/
async function displayplanningofArtisan(req, res) {
    try {
        const artisanId = req.params.id;

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
            const horaires = `${jour.HeureDebut} à ${jour.HeureFin}`;

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
    //modifyJourHorraires ,
  /*  deleteJourFromArtisan,
    */displayplanningofArtisan,
  //  modifyJour, //
  addHorrairesToArtisan ,
    getArtisanHorairesByJour,
    deleteHorraires
};

