const express=require('express');
const bodyParser=require('body-parser');
const app=express();

const adminRoute=require('./routes/admins');

app.use(bodyParser.json());
app.use("/admins",adminRoute);

module.exports=app;