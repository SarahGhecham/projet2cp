const express = require('express');
const clientController = require('../controllers/client.controller');

const router = express.Router();
router.post('/sign-up',clientController.signUp);

module.exports = router;