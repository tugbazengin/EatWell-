const APIError = require('../utils/errors') // hata mesajı döndürmek için kullanılır API ile ilgili bir hata oluştuğunda kullanılır
const errorHandler = (err, req, res, next) => {
    console.error('🔴 Error Handler:');
    console.error('🔴 Stack:', err.stack);
    console.error('🔴 Message:', err.message);
    console.error('🔴 URL:', req.url);
    console.error('🔴 Method:', req.method);
    console.error('🔴 Headers:', req.headers);
    
    if (err instanceof APIError) { // error API sınıfdan türetilmişse
        return res.status(err.statusCode || 400).json({
            success: false,
            message: err.message,
        })
    }

    return res.status(err.statusCode || 500).json({
        success: false,
        message: err.message || "Lütfen API nizi kontrol edin",
        error: process.env.NODE_ENV === 'development' ? err.stack : {}
    });
};

module.exports = errorHandler;