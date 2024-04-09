const express = require('express');
const router = express.Router();
const messagesController = require('../controllers/messages');

router.post('/send', messagesController.sendMessage);

router.get('/history',messagesController.historyMessages );

router.get('/retrieve_msg_artisan',messagesController.retrieveMessagesofartisan );
router.get('/retrieve_msg_client',messagesController.retrieveMessagesofclient); 
router.get('/history',messagesController.historyMessages );

module.exports = router;

