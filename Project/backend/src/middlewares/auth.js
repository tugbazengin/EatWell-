const jwt = require('jsonwebtoken');
const APIError = require('../utils/errors');
const User = require('../models/user.model');

const createToken = async (User, res) => {
    if (!process.env.JWT_SECRET_KEY) {
        throw new APIError("JWT_SECRET_KEY environment variable bulunamadı!", 500);
    }
    
    const payload = {
        sub: User._id,
        name: User.name,
        email: User.email
    }

    const token = await jwt.sign(payload, process.env.JWT_SECRET_KEY, {
        algorithm: "HS512",
        expiresIn: process.env.JWT_EXPIRATION_IN,
    })

    return res.status(201).json({
        success: true,
        message: "Token oluşturuldu",
        token: token,
        user: {
            _id: User._id,
            name: User.name,
            lastname: User.lastname,
            email: User.email,
            phone: User.phone,
            createdAt: User.createdAt
        }
    })
}

const tokenCheck = async (req, res, next) => {
    try {
        const headerToken = req.headers.authorization && req.headers.authorization.startsWith("Bearer ")

        if (!headerToken) {
            throw new APIError("Token bulunamadı", 401)
        }

        const token = req.headers.authorization.split(" ")[1]

        if (!process.env.JWT_SECRET_KEY) {
            throw new APIError("JWT_SECRET_KEY environment variable bulunamadı!", 500);
        }

        const decoded = await jwt.verify(token, process.env.JWT_SECRET_KEY);

        const userInfo = await User.findById(decoded.sub).select("_id name lastname email phone");

        if (!userInfo) {
            throw new APIError("Kullanıcı bulunamadı", 401)
        }

        req.user = userInfo;
        next();
    } catch (err) {
        next(err);
    }
}

const createTemporaryToken = async (userId, email) => {
    if (!process.env.JWT_TEMPORARY_KEY) {
        throw new APIError("JWT_TEMPORARY_KEY environment variable bulunamadı!", 500);
    }

    const payload = {
        sub: userId,
        email: email
    }
    
    const token = await jwt.sign(payload, process.env.JWT_TEMPORARY_KEY, {
        algorithm: "HS512",
        expiresIn: process.env.JWT_TEMPORARY_EXPIRES_IN || "15m",
    })
    return "Bearer " + token
}

const decodedTemporaryToken = async (temporaryToken) => {
    const token = temporaryToken.split(" ")[1];

    if (!process.env.JWT_TEMPORARY_KEY) {
        throw new APIError("JWT_TEMPORARY_KEY environment variable bulunamadı!", 500);
    }

    const decoded = await new Promise((resolve, reject) => {
        jwt.verify(token, process.env.JWT_TEMPORARY_KEY, (err, decoded) => {
            if (err) return reject(new APIError("Token geçersiz", 401));
            resolve(decoded);
        });
    });

    const userInfo = await User.findById(decoded.sub).select("_id name lastname email");

    if (!userInfo) {
        throw new APIError("Kullanıcı bulunamadı", 401);
    }

    return userInfo;
};

module.exports = {
    createToken,
    tokenCheck,
    createTemporaryToken,
    decodedTemporaryToken
}