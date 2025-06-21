const APIError = require('../utils/errors') // hata mesajı döndürmek için kullanılır API ile ilgili bir hata oluştuğunda kullanılır
const errorHandlerMiddleware = (err, req, res, next) => { // hata yakalama middleware
  if (err instanceof APIError) { // error API sınıfdan türetilmişse
    return res.status(err.statusCode||400).json({
      success: false,
      message: err.message,
    })
  }

  return res.status(500).json({
    success:false,
    message: "Lütfen API nizi kontrol edin",  // API ile ilgili bir hata oluştuğunda döndürülür
  });
};

module.exports = errorHandlerMiddleware;