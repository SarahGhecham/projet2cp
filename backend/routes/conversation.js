const express = require('express');
const router = express.Router();
const conversationController = require('../controllers/conversation.controller');

router.post('/create', conversationController.createConversation);
router.put('/:conversationId/terminate', conversationController.terminateConversation);
router.get('/ongoing', conversationController.getOngoingConversations);
router.get('/terminated', conversationController.getTerminatedConversations);
router.delete('/:conversationId/delete', conversationController.deleteConversation);

module.exports = router;