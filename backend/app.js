const express=require('express');
const bodyParser=require('body-parser');
const app=express();
const mysql = require('mysql2');

// Création de la connexion à la base de données
const connection = mysql.createConnection({
    host: "bb3iqml8qb5lz0fvpovr-mysql.services.clever-cloud.com",
    user: "udg0ybq1kucxqztv",
    password: "ngZMvyI3omnAcWJIexrX",
    database: "bb3iqml8qb5lz0fvpovr",
    port: "3306"
});
connection.connect((err) => {
    if (err) {
      console.error('Erreur de connexion :', err);
      return;
    }
    console.log('Connecté à la base de données MySQL sur Clever Cloud !');
});

const adminRoute=require('./routes/admins');
const clientRoute=require('./routes/client');
const connexionRoute=require('./routes/connexion');
const artisanRoute=require('./routes/artisan');

app.use(bodyParser.json());
app.use("/admins",adminRoute);
app.use("/client",clientRoute);
app.use('/connexion', connexionRoute);
app.use('/artisan',artisanRoute);

module.exports=app;
