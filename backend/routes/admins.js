const express=require('express');
const adminControllers=require('../controllers/admin.controller');
const { auth } = require('../middleware/check-auth');
const imageUploader = require("../helpers/image_uploader");

const router=express.Router();

router.post("/creeradmin",adminControllers.Creeradmin);
router.post("/creerartisan",adminControllers.CreerArtisan);
router.get("/:id",adminControllers.show);
router.get("/Afficher/Artisans",adminControllers.AfficherArtisans);
router.get("/Afficher/Clients",adminControllers.AfficherClients);
router.patch("/Desactiver/Client",adminControllers.DesactiverClient);
router.patch("/Desactiver/Artisan",adminControllers.DesactiverArtisan);
router.delete("/:id",adminControllers.destroy);
router.post("/AjouterDomaine",auth(),imageUploader.upload.single('imageDomaine'),adminControllers.AjouterDomaine);
router.post("/CreerTarif",adminControllers.CreerTarif);
router.post("/CreerPrestation",adminControllers.CreerPrestation);
router.post("/AjouterPrestation",auth(), adminControllers.AjouterPrestation);


module.exports=router;
