const jwt = require('jsonwebtoken');

module.exports.auth = () => async (req, res, next) => {
    try {
        const authorization = req.headers.authorization;
        console.log(authorization);
        if (!authorization) throw new Error("Accès refusé");
        if (!authorization.startsWith('Bearer ')) throw new Error("Autorisation invalide");
        const token = authorization.split(' ')[1];
        const decoded = jwt.verify(token, process.env.JWT_key);
        req.userId = decoded.UserId;
        next();
        

    } catch (e) {
        return res.status(401).json({
            'message':"Invalid or expired token provided",
            'error':e

    });
}
}