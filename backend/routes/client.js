const express = require('express');
const clientController = require('../controllers/client.controller');
const { auth } = require('../middleware/check-auth');

const router = express.Router();
router.post('/sign-up',clientController.signUp);
router.patch('/:id',clientController.updateclient);
router.post('/lancerdemande/:demandeId',auth(),clientController.lancerdemande);
router.get('/AfficherProfilArtisan/:id',clientController.AfficherArtisan);

module.exports = router;