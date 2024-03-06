const express=require('express');
const adminControllers=require('../controllers/admin.controller');

const router=express.Router();

router.post("/",adminControllers.save);
router.get("/:id",adminControllers.show);
router.delete("/:id",adminControllers.destroy);
module.exports=router;