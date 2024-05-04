const express = require('express');
const artisanJourController = require('../controllers/artisanjour.controller');
const { auth } = require('../middleware/check-auth');

const router = express.Router();

//router.post('/addJourToArtisan/:id', artisanJourController.addJourToArtisan);
//router.patch('/modifyJour/:jourId', artisanJourController.modifyJour);
//router.delete('/deleteJourFromArtisan/:id/:jourId',artisanJourController.deleteJourFromArtisan);
router.get('/planning/:id',artisanJourController.displayplanningofArtisan);

router.post('/addHorrairesToArtisan/:artisanId', artisanJourController.addHorrairesToArtisan),
router.patch('/modifyJourHorraires/:artisanId', artisanJourController.modifyJourHorraires) ,
router.get('/HorairesJour',artisanJourController.getArtisanHorairesByJour),
router.delete('/deletehorairesFromArtisan/:artisanId',artisanJourController.deleteHorraires);


module.exports = router;
