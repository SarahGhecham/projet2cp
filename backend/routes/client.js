const express = require('express');
const clientController = require('../controllers/client.controller');
const { auth } = require('../middleware/check-auth');
const CheckAuthMiddleWare = require('../middleware/check-auth');
const imageUploader = require("../helpers/image_uploader");

const router = express.Router();
router.post('/sign-up',clientController.signUp);
router.post('/creerEvaluation',auth(),clientController.creerEvaluation);
router.patch('/updateClient',auth(),clientController.updateClient);
router.post('/updateClientImage' ,auth(),imageUploader.upload.single('image'), clientController.updateClientImage);
router.post('/lancerdemande',auth(),clientController.lancerdemande);
router.post('/creerRDV',auth(),clientController.creerRDV);
router.post('/confirmerRDV',auth(),clientController.confirmerRDV);
router.post('/annulerRDV',auth(),clientController.annulerRDV);
router.post('/annulerDemande',auth(),clientController.annulerDemande);
router.get('/AfficherArtisan/:id',auth(),clientController.AfficherArtisan);
router.get('/Affichermonprofil',auth(),clientController.AfficherProfil)
//router.get('/test',clientController.test);
router.get('/AfficherActiviteTerminee',auth(),clientController.ActiviteTerminee);
router.get('/AfficherActiviteTermineeNonEvaluee',auth(),clientController.ActiviteTermineeNonEvaluee);
router.get('/AfficherActiviteEncours',auth(),clientController.ActiviteEncours);
router.get('/AfficherPrestations/:id',clientController.AfficherPrestations);
router.get('/DetailsDemandeConfirmee/:rdvId',auth(),clientController.DetailsDemandeConfirmee);
router.get('/DetailsRDVTermine/:rdvId',auth(),clientController.DetailsRDVTermine);
//router.get('/demandes/:demandeId/artisans', clientController.getArtisansForDemand);
router.get('/demandes/:demandeId/artisans', clientController.rechercherDemandeParId);
router.get('/ConsulterCommentaires/:ArtisanId',clientController.getCommentaires);



module.exports = router;
