const jwt = require('jsonwebtoken');

function CheckAuth(req,res,next){
    try{
         const token = req.headers.authorization.split(" ")[1];
         const decodedToken = jwt.verify(token,process.env.JWT_key);
         const userData = decodedToken;
         next();
    }catch(e){
          return res.status(401).json({
            'message':"Invalid or expired token provided",
            'error':e
                  });
    }
}

module.exports={
    CheckAuth:CheckAuth
}