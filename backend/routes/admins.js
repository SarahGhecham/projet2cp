const express=require('express');
const adminControllers=require('../controllers/admin.controller');

const router=express.Router();

router.post("/",adminControllers.save);
router.post("/creerartisan",adminControllers.CreerArtisan);
router.get("/:id",adminControllers.show);
router.get("/Afficher/Artisans",adminControllers.AfficherArtisans);
router.get("/Afficher/Clients",adminControllers.AfficherClients);
router.delete("/:id",adminControllers.destroy);
module.exports=router;