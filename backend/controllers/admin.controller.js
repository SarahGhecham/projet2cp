const Validator=require('fastest-validator');
const models=require('../models');
function save(req,res){
     const admin={
        NomAdmin:req.body.NomAdmin,
        PrenomAdmin:req.body.PrenomAdmin
     }
     models.Admin.create(admin).then(result=>{
         res.status(201).json({
            message:"admin created",
            admin:result
         })
     }).catch(error=>{
        res.status(500).json({
            message:"admin not created",
            error:error
         })
     })
}

function show(req,res){
    const id=req.params.id;
    models.Admin.findByPk(id).then(result=>{
        if(result)
           res.status(201).json(result)
        else
            res.status(404).json({
          message:"admin not found"
        })
    }).catch(error=>{
        res.status(500).json({
            message:"something went wrong"
        })
    })
}

function destroy(req,res){
    const id=req.params.id;
    models.Admin.destroy({where:{id:id}}).then(result=>{
        res.status(201).json({
            message:"deleted succesfully"
        })
    }).catch(error=>{
        res.status(500).json({
            message:"something went wrong"
        })
        
    })
}

module.exports={
    save:save,
    show:show,
    destroy:destroy
}