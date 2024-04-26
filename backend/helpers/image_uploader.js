const multer = require("multer");
const path = require("path");

const storage = multer.diskStorage({
    
    destination: function(req, file, cb){
            cb(null, './uploads');
    },
    filename: function(req, file, cb){
        cb(null, new Date().getTime() + path.extname(file.originalname));
    }
});

const fileFilter = (req, file, cb) => {
    console.log('Type MIME reçu:', file.mimetype); 
    if(file.mimetype === 'image/jpeg' || file.mimetype === 'image/png' || file.mimetype === 'application/pdf'|| file.mimetype === 'application/octet-stream'){
         cb(null, true);
    }else{
        cb(new Error('Fichiers insupportables'), false);
    }
};


const upload = multer({
    storage: storage,
    limits:{
        fileSize:1024*1024*1000
    },
    fileFilter: fileFilter

});

module.exports={
    upload:upload,
}