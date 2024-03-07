const express=require('express');
const bodyParser=require('body-parser');
const app=express();

const adminRoute=require('./routes/admins');
const clientRoute=require('./routes/client');


app.use(bodyParser.json());
app.use("/admins",adminRoute);
app.use("/client",clientRoute);

module.exports=app;
