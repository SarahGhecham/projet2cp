const express=require('express');
const adminControllers=require('../controllers/admin.controller');
const { auth } = require('../middleware/check-auth');
const imageUploader = require("../helpers/image_uploader");

const router=express.Router();

router.post("/creeradmin",adminControllers.Creeradmin);
router.post("/creerartisan",adminControllers.CreerArtisan);
router.get("/",auth(),adminControllers.show);
router.get("/Afficher/Artisans",adminControllers.AfficherArtisans);
router.get("/Afficher/Clients",adminControllers.AfficherClients);
router.get("/Afficher/Tous",adminControllers.AfficherArtisansEtClients);
router.patch("/Desactiver/Client",adminControllers.DesactiverClient);
router.patch("/Desactiver/Artisan",adminControllers.DesactiverArtisan);
router.delete("/:id",adminControllers.destroy);
router.post("/AjouterDomaine",imageUploader.upload.single('imageDomaine'),adminControllers.AjouterDomaine);
router.post("/CreerTarif",adminControllers.CreerTarif);
router.post("/CreerPrestation",imageUploader.upload.single('imagePrestation'),adminControllers.CreerPrestation);
router.patch("/modifierPrestation",imageUploader.upload.single('imagePrestation'),adminControllers.ModifierPrestation);
router.post("/AjouterPrestation/:id",auth(), adminControllers.AjouterPrestation);
router.get("/Obtenir/Statistiques",adminControllers.obtenirStatistiques);
router.get("/AfficherPrestationsByDomaine/:domaineId",adminControllers.AfficherPrestationsByDomaine);


module.exports=router;
