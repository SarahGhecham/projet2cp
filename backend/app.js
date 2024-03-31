// app.js
const express=require('express');
const bodyParser=require('body-parser');
const app=express();

const adminRoute=require('./routes/admins');
const clientRoute=require('./routes/client');
const connexionRoute=require('./routes/connexion');
const artisanRoute=require('./routes/artisan');
const jourRoutes = require('./routes/jour');
const artisanjourroute=require('./routes/artisanjour')

app.use(bodyParser.json());
app.use("/admins",adminRoute);
app.use("/client",clientRoute);
app.use('/connexion', connexionRoute);
app.use('/artisan',artisanRoute);
app.use('/jours', jourRoutes);
app.use('/artisanjour',artisanjourroute);
module.exports=app;
