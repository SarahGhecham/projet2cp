const express = require('express');
const artisanJourController = require('../controllers/artisanjour.controller');
const { auth } = require('../middleware/check-auth');

const router = express.Router();

router.post('/addJourToArtisan/:id', artisanJourController.addJourToArtisan);
router.patch('/modifyJour/:jourId', artisanJourController.modifyJour);
router.delete('/deleteJourFromArtisan/:jourId',auth(),artisanJourController.deleteJourFromArtisan);
router.get('/planning/:id',artisanJourController.displayplanningofArtisan);

module.exports = router;
