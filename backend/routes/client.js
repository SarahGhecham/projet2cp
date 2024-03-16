const express = require('express');
const clientController = require('../controllers/client.controller');
const CheckAuthMiddleWare = require('../middleware/check-auth');

const router = express.Router();
router.post('/sign-up',clientController.signUp);
router.patch('/:id',clientController.updateclient);


module.exports = router;