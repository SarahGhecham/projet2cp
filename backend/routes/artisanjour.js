const express = require('express');
const artisanJourController = require('../controllers/artisanjour.controller');
const { auth } = require('../middleware/check-auth');

const router = express.Router();

//router.post('/addJourToArtisan/:id', artisanJourController.addJourToArtisan);
//router.patch('/modifyJour/:jourId', artisanJourController.modifyJour);
//router.delete('/deleteJourFromArtisan/:id/:jourId',artisanJourController.deleteJourFromArtisan);
router.get('/planning',auth(),artisanJourController.displayplanningofArtisan);

router.post('/addHorrairesToArtisan',auth(), artisanJourController.addHorrairesToArtisan),
router.get('/HorairesJour/:jour',auth(),artisanJourController.getArtisanHorairesByJour),
router.delete('/deletehorairesFromArtisan',auth(),artisanJourController.deleteHorraires);
router.get('/HorairesJour2',auth(),artisanJourController.getArtisanHorairesByJour2);
module.exports = router;
