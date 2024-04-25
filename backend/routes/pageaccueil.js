const express=require('express');
const pageControllers=require('../controllers/pagedaccueil.controller');
const { auth } = require('../middleware/check-auth');

const router=express.Router();

router.get("/AfficherDomaines",auth(),pageControllers.AfficherDomaines);
router.get("/AfficherPrestationsEco",pageControllers.AfficherServicesEco);
router.get("/AfficherPrestationsTop",pageControllers.AfficherTopPrestations);
module.exports=router;