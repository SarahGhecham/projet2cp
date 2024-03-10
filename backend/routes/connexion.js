const express = require('express');
const connexionController = require('../controllers/connexion.controller');

const router = express.Router();

router.post('/login', connexionController.login);

module.exports = router;
