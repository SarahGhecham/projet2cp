const express = require('express');
const artisanController = require('../controllers/artisan.controller');
const { auth } = require('../middleware/check-auth');
const clientController = require('../controllers/client.controller');
const imageUploader = require("../helpers/image_uploader");

const router = express.Router();

router.get('/Affichermonprofil',auth(), artisanController.AfficherProfil) ;
router.patch('/updateartisan',auth(),artisanController.updateartisan);
router.post('/accepterRDV',auth(),artisanController.accepterRDV);
router.post('/refuserRDV',auth(),artisanController.refuserRDV);
//router.get('/HistoriqueInterventions',auth(),artisanController.HistoriqueInterventions);
router.post('/test',artisanController.associerDemandeArtisan);
//router.get('/AfficherEvaluations',auth(),artisanController.AfficherEvaluations);
router.get('/AfficherActiviteTerminee',auth(),artisanController.Activiteterminee);
router.get('/AfficherActiviteEncours',auth(),artisanController.ActiviteEncours);
router.get('/DetailsRDVTermine/:rdvId',auth(),artisanController.DetailsRDVTermine);
router.get('/DetailsDemandeConfirmee/:rdvId',auth(),artisanController.DetailsDemandeConfirmee);
router.get('/DetailsDemande/:demandeId',auth(),artisanController.DetailsDemande);
router.get('/ConsulterDemandes',auth(),artisanController.consulterdemandes);
router.get('/ConsulterCommentaires',auth(),artisanController.getCommentaires);
router.post("/updateArtisanImage",auth(), imageUploader.upload.single('image'), artisanController.updateArtisanImage);
router.get('/Rdvpourartisan',auth(),artisanController.getArtisanRdvs);


module.exports = router;

