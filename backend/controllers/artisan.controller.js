const Validator=require('fastest-validator');
const models=require('../models');
const { Op } = require('sequelize');

function AfficherProfil(req,res){
    const id=req.userId;
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

function updateartisan(req, res) {
    const id = req.userId;
    const updatedArtisan = {
        NomArtisan: req.body.NomArtisan,
        PrenomArtisan:req.body.PrenomArtisan,
        MotdepasseArtisan: req.body.MotdepasseArtisan,
        EmailArtisan: req.body.EmailArtisan,
        AdresseArtisan: req.body.AdresseArtisan,
        NumeroTelArtisan: req.body.NumeroTelArtisan,
        Disponnibilite: req.body.Disponnibilite
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
async function associerDemandeArtisan(req, res) {
    const artisanId = req.body.artisanId;
    const demandeId = req.body.demandeId;

    try {
        // Vérifier si l'artisan existe
        const artisan = await models.Artisan.findByPk(artisanId);
        if (!artisan) {
            return res.status(404).json({ message: `L'artisan avec l'ID ${artisanId} n'existe pas.` });
        }

        // Vérifier si la demande existe
        const demande = await models.Demande.findByPk(demandeId);
        if (!demande) {
            return res.status(404).json({ message: `La demande avec l'ID ${demandeId} n'existe pas.` });
        }

        // Associer la demande à l'artisan
        const association = await models.ArtisanDemande.create({
            ArtisanId: artisanId,
            DemandeId: demandeId
        });

        return res.status(201).json({ message: `La demande avec l'ID ${demandeId} a été associée à l'artisan avec l'ID ${artisanId}.` });
    } catch (error) {
        console.error('Une erreur s\'est produite lors de l\'association de la demande à l\'artisan :', error);
        return res.status(500).json({ message: 'Une erreur s\'est produite lors du traitement de votre demande.' });
    }
}
/*async function AfficherEvaluations(req, res) {
    const artisanId = req.userId; // Supposons que l'ID de l'artisan soit passé dans les paramètres de l'URL

    try {
        // Recherchez les IDs des demandes associées à l'artisan dans la table de liaison ArtisanDemande
        const artisanDemandes = await models.ArtisanDemande.findAll({
            where: { ArtisanId: artisanId }
        });

        // Récupérez les IDs des demandes associées à l'artisan
        const demandeIds = artisanDemandes.map(ad => ad.DemandeId);

        // Récupérez tous les rendez-vous associés aux demandes
        const rdvs = await models.RDV.findAll({
            where: { DemandeId: demandeIds },
            attributes: ['id'] // Sélectionnez seulement l'attribut ID du rendez-vous
        });

        // Récupérez les IDs de tous les rendez-vous
        const rendezVousIds = rdvs.map(rdv => rdv.id);

        // Récupérez tous les IDs des évaluations associées aux rendez-vous
        const evaluations = await models.Evaluation.findAll({
            where: { RDVId: rendezVousIds },
            attributes: ['id'] // Sélectionnez seulement l'attribut ID de l'évaluation
        });

        // Récupérez les détails de chaque évaluation à partir de son ID
        const evaluationsDetails = await Promise.all(evaluations.map(async (evaluation) => {
            const evaluationDetails = await models.Evaluation.findByPk(evaluation.id, {
                include: [{
                    model: models.RDV,
                include: [
                    {
                        model: models.Demande,
                        include: [
                            {
                                model: models.Client,
                                model: models.Prestation // Inclure le modèle Client associé à la demande
                            }
                        ]
                    }
                ]// Inclure les détails de la demande associée au rendez-vous
                }]
            });
            return evaluationDetails;
        }));

        // Envoyez les détails des évaluations en réponse
        return res.status(200).json(evaluationsDetails);
    } catch (error) {
        console.error('Une erreur s\'est produite lors de la récupération des demandes :', error);
        return res.status(500).json({ message: 'Une erreur s\'est produite lors du traitement de votre demande.' });
    }
}
async function HistoriqueInterventions(req, res) {
    const artisanId = req.userId; // Supposons que l'ID de l'artisan soit passé dans les paramètres de l'URL

    try {
        // Recherchez les IDs des demandes associées à l'artisan dans la table de liaison ArtisanDemande
        const artisanDemandes = await models.ArtisanDemande.findAll({
            where: { ArtisanId: artisanId }
        });

        // Récupérez les IDs des demandes associées à l'artisan
        const demandeIds = artisanDemandes.map(ad => ad.DemandeId);

        // Récupérez les IDs des rendez-vous associés aux demandes
        const rendezVousIds = await models.RDV.findAll({
            where: { DemandeId: demandeIds }
        });
        

        // Récupérez les IDs des évaluations associées aux rendez-vous
        const evaluationIds = await models.Evaluation.findAll({
            where: { RDVId: rendezVousIds.map(rv => rv.id) }
        });
        // Filtrer uniquement les IDs des demandes qui ont un rendez-vous avec une évaluation associée
        const demandesAvecEvaluationIds = rendezVousIds
            .filter(rv => evaluationIds.some(e => e.RDVId === rv.id))
            .map(rv => rv.DemandeId);

        // Récupérez les détails de chaque demande à partir de la table Demande
        const demandesAvecEvaluation = await models.Demande.findAll({
            where: { id: demandesAvecEvaluationIds} // Utilisez les IDs des demandes avec rendez-vous avec évaluation
        });

        return res.status(200).json(demandesAvecEvaluation);
    } catch (error) {
        console.error('Une erreur s\'est produite lors de la récupération des demandes :', error);
        return res.status(500).json({ message: 'Une erreur s\'est produite lors du traitement de votre demande.' });
    }
}*/
async function Activiteterminee(req, res) {
    const artisanId = req.userId; 

    try {
        const artisanDemandes = await models.ArtisanDemande.findAll({
            where: { ArtisanId: artisanId }
        });

        const demandeIds = artisanDemandes.map(ad => ad.DemandeId);

        const rendezVousIds = await models.RDV.findAll({
            where: { DemandeId: demandeIds }
        });
        

        const evaluationIds = await models.Evaluation.findAll({
            where: { RDVId: rendezVousIds.map(rv => rv.id) }
        });
        const demandesAvecEvaluationIds = rendezVousIds
            .filter(rv => evaluationIds.some(e => e.RDVId === rv.id))
            .map(rv => rv.DemandeId);

        const demandesAvecEvaluation = await models.Demande.findAll({
            where: { id:{[Op.in]: demandesAvecEvaluationIds}},
            include: [
                {
                    model: models.Client 
                },
                {
                    model: models.Prestation 
                },
                {
                    model: models.RDV, 
                    include: [
                        {
                            model: models.Evaluation 
                        }
                    ]
                }
            ] // Utilisez les IDs des demandes avec rendez-vous avec évaluation
        });

        return res.status(200).json(demandesAvecEvaluation);
    } catch (error) {
        console.error('Une erreur s\'est produite lors de la récupération des demandes :', error);
        return res.status(500).json({ message: 'Une erreur s\'est produite lors du traitement de votre demande.' });
    }
}
async function ActiviteEncours(req, res) {
    const artisanId = req.userId; 

    try {
        // Rechercher les IDs des demandes associées à l'artisan
        const artisanDemandes = await models.ArtisanDemande.findAll({
            where: { ArtisanId: artisanId }
        });

        // Récupérer les IDs des demandes associées à l'artisan
        const demandeIds = artisanDemandes.map(ad => ad.DemandeId);

        const rdvs = await models.RDV.findAll({
            where: { 
                DemandeId: demandeIds,
                annule: false, 
                accepte: true, 
                confirme: false 
                
            },
            attributes: ['id', 'DemandeId'] 
        });

        const rdvEnCoursIds = rdvs.map(rdv => rdv.id);

        const rendezVousEnCours = await models.RDV.findAll({
            where: { id: rdvEnCoursIds },
            include: [
                {
                    model: models.Demande,
                    include: [
                        { model: models.Client }, 
                        { model: models.Prestation }
                    ]
                }
            ]
        });

     
        return res.status(200).json(rendezVousEnCours);
    } catch (error) {
        console.error('Une erreur s\'est produite lors de la récupération des rendez-vous en cours :', error);
        return res.status(500).json({ message: 'Une erreur s\'est produite lors du traitement de votre demande.' });
    } 
}
async function DetailsRDVTermine(req, res) {
    const artisanId = req.userId;
    const rdvId = req.body.rdvId;

    try {
        // Récupérer les détails du rendez-vous
        const rdv = await models.RDV.findByPk(rdvId, {
            include: [
                { model: models.Demande, include: [models.Prestation] }
            ]
        });

        if (!rdv) {
            return res.status(404).json({ message: `Le RDV avec l'ID ${rdvId} n'existe pas.` });
        }
         // Vérifier si le rendez-vous a été annulé
         if (rdv.annule) {
            return res.status(400).json({ message: `Le RDV avec l'ID ${rdvId} a été annulé.` });
        }

        // Vérifier si le rendez-vous a été confirmé
        if (!rdv.confirme) {
            return res.status(400).json({ message: `Le RDV avec l'ID ${rdvId} n'a pas été confirmé.` });
        }

        // Récupérer les détails de le client
        const clientDemande = await models.Demande.findOne({
            where: { Id: rdv.DemandeId }
        })

        if (!clientDemande) {
            return res.status(404).json({ message: `Aucun client n'est associé à la demande de RDV avec l'ID ${rdvId}.` });
        }

        const client = await models.Client.findByPk(clientDemande.ClientId, {
            attributes: ['NomClient', 'PrenomClient']
        });
        // Retourner les détails de l'artisan, du rendez-vous et de la prestation
        return res.status(200).json({ client, rdv, prestation: rdv.Demande.Prestation });
    } catch (error) {
        console.error("Erreur lors de la récupération des détails de la demande confirmée :", error);
        return res.status(500).json({ message: 'Une erreur s\'est produite lors du traitement de votre demande.' });
    }
}

module.exports = {
    updateartisan:updateartisan,
    accepterRDV:accepterRDV,
    annulerRDV:annulerRDV,
    //HistoriqueInterventions,
    associerDemandeArtisan,
    //AfficherEvaluations,
    AfficherProfil,
    Activiteterminee,
    ActiviteEncours,
    DetailsRDVTermine,
}