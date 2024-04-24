const express = require('express');
const bodyParser = require('body-parser');
const app = express();
const mysql = require('mysql2');

app.use(bodyParser.json());

const adminRoute = require('./routes/admins');
const clientRoute = require('./routes/client');
const connexionRoute = require('./routes/connexion');
const artisanRoute = require('./routes/artisan');
const jourRoutes = require('./routes/jour');
const artisanjourroute = require('./routes/artisanjour');
const pageaccueilRoute=require('./routes/pageaccueil');
const messagesRouter = require('./routes/messages');
const conversationRoutes = require('./routes/conversation');


app.use("/admins", adminRoute);
app.use("/client", clientRoute);
app.use('/connexion', connexionRoute);
app.use('/artisan', artisanRoute);
app.use('/jours', jourRoutes);
app.use('/artisanjour', artisanjourroute);
app.use('/pageaccueil',pageaccueilRoute);
app.use("/imageDomaine",express.static('uploads'));
app.use("/imageArtisan",express.static('uploads'));
app.use("/imageClient",express.static('uploads'));

app.use("/imagePrestation",express.static('uploads'));
app.use('/messages', messagesRouter);
app.use('/conversation', conversationRoutes);




module.exports = app;
