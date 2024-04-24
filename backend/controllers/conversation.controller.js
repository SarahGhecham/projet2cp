const models = require('../models');
const { Client, Artisan, Message } = models;


async function createConversation(req, res) {
    try {
      const { clientId, artisanId } = req.body;
      
      // Check if there is an existing conversation between the same client and artisan
      const existingConversation = await models.Conversation.findOne({
        where: {
          clientId,
          artisanId,
          status: 'open' // Check only open conversations
        }
      });
  
      if (existingConversation) {
        return res.status(400).json({ message: 'Conversation already exists between this client and artisan' });
      }
  
      const conversation = await models.Conversation.create({
        clientId,
        artisanId,
        status: 'open'
      });
  
      res.status(201).json({ message: 'Conversation created successfully', data: conversation });
    } catch (error) {
      console.error('Error creating conversation:', error);
      res.status(500).json({ message: 'Failed to create conversation', error: error.message });
    }
  }
  
async function terminateConversation(req, res) {
  try {
    const { conversationId } = req.params;
    const conversation = await models.Conversation.findByPk(conversationId);
    if (!conversation) {
      return res.status(404).json({ message: `Conversation with ID ${conversationId} not found.` });
    }
    // Update conversation status to 'closed'
    await conversation.update({ status: 'closed' });
    res.status(200).json({ message: 'Conversation terminated successfully' });
  } catch (error) {
    console.error('Error terminating conversation:', error);
    res.status(500).json({ message: 'Failed to terminate conversation', error: error.message });
  }
}
async function getOngoingConversations(req, res) {
    try {
        const ongoingConversations = await models.Conversation.findAll({
            where: { status: 'open' },
            include: [
                {
                    model: Client,
                    attributes: ['Username']
                },
                {
                    model: Artisan,
                    attributes: ['NomArtisan', 'PrenomArtisan']
                },
                {
                    model: Message,
                    order: [['sentAt', 'DESC']], // Ordering messages by sent_at timestamp in descending order
                    limit: 1, // Get only the latest message
                    attributes: ['sentAt']
                }
            ]
        });
        
        res.status(200).json({ data: ongoingConversations });
    } catch (error) {
        console.error('Error retrieving ongoing conversations:', error);
        res.status(500).json({ message: 'Failed to retrieve ongoing conversations', error: error.message });
    }
}

async function getTerminatedConversations(req, res) {
    try {
        const ongoingConversations = await models.Conversation.findAll({
            where: { status: 'open' },
            include: [
                {
                    model: Client,
                    attributes: ['Username','photo']
                },
                {
                    model: Artisan,
                    attributes: ['NomArtisan', 'PrenomArtisan','photo']
                },
                {
                    model: Message,
                    order: [['sentAt', 'DESC']], // hnaya Ordering  les messages by sent_at timestamp in descending order
                    limit: 1, // we Get only the latest message according to front
                    attributes: ['sentAt']
                }
            ]
        });
        
        res.status(200).json({ data: ongoingConversations });
    } catch (error) {
        console.error('Error retrieving terminated conversations:', error);
        res.status(500).json({ message: 'Failed to retrieve terminated conversations', error: error.message });
    }
}
async function deleteConversation(req, res) {
    try {
        const { conversationId } = req.params;
        const conversation = await models.Conversation.findByPk(conversationId);
        if (!conversation) {
            return res.status(404).json({ message: `Conversation with ID ${conversationId} not found.` });
        }
        // Perform deletion operation
        await conversation.destroy();
        res.status(200).json({ message: 'Conversation deleted successfully' });
    } catch (error) {
        console.error('Error deleting conversation:', error);
        res.status(500).json({ message: 'Failed to delete conversation', error: error.message });
    }
}

module.exports = {
  createConversation,
  terminateConversation ,
  getOngoingConversations,
  getTerminatedConversations,
  deleteConversation
};
