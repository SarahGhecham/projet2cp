const models=require('../models');

async function lancerdemande(req, res) {
    const { demandeId, clientId } = req.body;

    try {
        // Vérifier si la demande et le client existent
        const demande = await models.Demande.findByPk(demandeId);
        const client = await models.Client.findByPk(clientId);

        if (!demande) {
            return res.status(404).json({ message: `La demande avec l'ID ${demandeId} n'existe pas.` });
        }

        if (!client) {
            return res.status(404).json({ message: `Le client avec l'ID ${clientId} n'existe pas.` });
        }

        // Ajouter la relation dans la table de liaison
        await demande.addClient(client);

        return res.status(201).json({ message: `La relation entre la demande avec l'ID ${demandeId} et le client avec l'ID ${clientId} a été ajoutée avec succès.` });
    } catch (error) {
        console.error('Une erreur s\'est produite lors de l\'ajout de la relation demande-client :', error);
        return res.status(500).json({ message: 'Une erreur s\'est produite lors du traitement de votre demande.' });
    }
}

module.exports = {
    lancerdemande,
};