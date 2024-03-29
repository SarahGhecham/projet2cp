const express=require('express');
const adminControllers=require('../controllers/admin.controller');

const router=express.Router();

router.post("/creeradmin",adminControllers.Creeradmin);
router.post("/creerartisan",adminControllers.CreerArtisan);
router.get("/:id",adminControllers.show);
router.get("/Afficher/Artisans",adminControllers.AfficherArtisans);
router.get("/Afficher/Clients",adminControllers.AfficherClients);
router.patch("/Desactiver/Client",adminControllers.DesactiverClient);
router.patch("/Desactiver/Artisan",adminControllers.DesactiverArtisan);
router.delete("/:id",adminControllers.destroy);
module.exports=router; 