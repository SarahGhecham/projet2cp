const express = require('express');
const clientController = require('../controllers/client.controller');

const router = express.Router();
router.post('/sign-up',clientController.signUp);
//router.post('/login',clientController.login);

module.exports = router;