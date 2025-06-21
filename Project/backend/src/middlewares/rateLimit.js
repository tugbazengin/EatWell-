const rateLimit = require('express-rate-limit');

const apiLimiter = rateLimit({
    windowMs: 15 * 60 * 1000, // 15 dakika
    max: (req, res) => {
        console.log("api url : ", req.url);
        if (req.url == "/login" || req.url == "/register") {
            return 200; // 👈 100'den 5'e düşürdük
        } else if (req.url == "/forget-password") {
            return 300; // 👈 Şifre sıfırlama için 3
        } else {
            return 100; // 👈 100'den 10'a düşürdük
        }
    },
    message: {
        status: false,
        message: 'Çok fazla istek gönderdiniz. Lütfen 15 dakika sonra tekrar deneyin.',
    },
    standardHeaders: true, // Return rate limit info in the `RateLimit-*` headers
    legacyHeaders: false, // Disable the `X-RateLimit-*` headers
})

module.exports = apiLimiter