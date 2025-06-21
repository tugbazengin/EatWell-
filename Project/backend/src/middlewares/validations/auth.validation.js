const joi = require('joi');

class AuthValidation {
  constructor() {}

  static register = async (req, res, next) => {
    try {
      const schema = joi.object({
        name: joi.string().trim().min(3).max(30).required().messages({
          "string.base": "İsim Alanı Normal Metin Olmalıdır",
          "string.empty": "İsim Alanı Boş Geçilemez",
          "string.min": "İsim Alanı En Az 3 Karakter Olmalıdır",
          "string.max": "İsim Alanı En Fazla 30 Karakter Olmalıdır",
          "any.required": "İsim Alanı Zorunludur"
        }),
        lastname: joi.string().trim().min(3).max(30).required().messages({
          "string.base": "Soyad Alanı Normal Metin Olmalıdır",
          "string.empty": "Soyad Alanı Boş Geçilemez",
          "string.min": "Soyad Alanı En Az 3 Karakter Olmalıdır",
          "string.max": "Soyad Alanı En Fazla 30 Karakter Olmalıdır",
          "any.required": "Soyad Alanı Zorunludur"
        }),
        email: joi.string().email().trim().min(3).max(50).required().messages({
          "string.base": "Email Alanı Normal Metin Olmalıdır",
          "string.empty": "Email Alanı Boş Geçilemez",
          "string.min": "Email Alanı En Az 3 Karakter Olmalıdır",
          "string.email": "Email Alanı Geçerli Bir Email Olmalıdır",
          "string.max": "Email Alanı En Fazla 50 Karakter Olmalıdır",
          "any.required": "Email Alanı Zorunludur"
        }),
        password: joi.string().trim().min(6).max(36).required().messages({
          "string.base": "Şifre Alanı Normal Metin Olmalıdır",
          "string.empty": "Şifre Alanı Boş Geçilemez",
          "string.min": "Şifre Alanı En Az 6 Karakter Olmalıdır",
          "string.max": "Şifre Alanı En Fazla 36 Karakter Olmalıdır",
          "any.required": "Şifre Alanı Zorunludur"
        }),
        phone: joi.string().trim().pattern(/^[0-9+\-\s()]+$/).max(20).optional().allow('', null).messages({
          "string.base": "Telefon Alanı Normal Metin Olmalıdır",
          "string.pattern.base": "Geçerli bir telefon numarası giriniz",
          "string.max": "Telefon Alanı En Fazla 20 Karakter Olmalıdır"
        }),
        birthDate: joi.date().max('now').optional().allow(null).messages({
          "date.base": "Geçerli bir tarih giriniz",
          "date.max": "Doğum tarihi gelecek bir tarih olamaz"
        }),
        age: joi.number().integer().min(0).max(120).optional().allow(null).messages({
          "number.base": "Yaş sayısal olmalıdır",
          "number.min": "Yaş 0'dan küçük olamaz",
          "number.max": "Yaş 120'den büyük olamaz"
        }),
        height: joi.number().min(30).max(300).optional().allow(null).messages({
          "number.base": "Boy sayısal olmalıdır",
          "number.min": "Boy 30 cm'den küçük olamaz",
          "number.max": "Boy 300 cm'den büyük olamaz"
        }),
        weight: joi.number().min(1).max(500).optional().allow(null).messages({
          "number.base": "Kilo sayısal olmalıdır",
          "number.min": "Kilo 1 kg'dan küçük olamaz",
          "number.max": "Kilo 500 kg'dan büyük olamaz"
        }),
        targetWeight: joi.number().min(1).max(500).optional().allow(null).messages({
          "number.base": "Hedef kilo sayısal olmalıdır",
          "number.min": "Hedef kilo 1 kg'dan küçük olamaz",
          "number.max": "Hedef kilo 500 kg'dan büyük olamaz"
        })
      }).options({ allowUnknown: false, stripUnknown: true });

      await schema.validateAsync(req.body);
      next();

    } catch (error) {
      console.log(error);
      return res.status(400).json({ message: error.message });
    }

    
};

static login = async (req, res, next) => {
    try {
      const schema = joi.object({
        email: joi.string().email().trim().min(3).max(50).required().messages({
          "string.base": "Email Alanı Normal Metin Olmalıdır",
          "string.empty": "Email Alanı Boş Geçilemez",
          "string.min": "Email Alanı En Az 3 Karakter Olmalıdır",
          "string.email": "Email Alanı Geçerli Bir Email Olmalıdır",
          "string.max": "Email Alanı En Fazla 50 Karakter Olmalıdır",
          "any.required": "Email Alanı Zorunludur"
        }),
        password: joi.string().trim().min(6).max(36).required().messages({
          "string.base": "Şifre Alanı Normal Metin Olmalıdır",
          "string.empty": "Şifre Alanı Boş Geçilemez",
          "string.min": "Şifre Alanı En Az 6 Karakter Olmalıdır",
          "string.max": "Şifre Alanı En Fazla 36 Karakter Olmalıdır",
          "any.required": "Şifre Alanı Zorunludur"
        })
      }).options({ allowUnknown: false, stripUnknown: true });

      await schema.validateAsync(req.body);
      next();

    } catch (error) {
      console.log(error);
      return res.status(400).json({ message: error.message });
    }
  };

static updateProfile = async (req, res, next) => {
    try {
      const schema = joi.object({
        name: joi.string().trim().min(2).max(30).optional().messages({
          "string.base": "İsim Alanı Normal Metin Olmalıdır",
          "string.empty": "İsim Alanı Boş Geçilemez",
          "string.min": "İsim Alanı En Az 2 Karakter Olmalıdır",
          "string.max": "İsim Alanı En Fazla 30 Karakter Olmalıdır"
        }),
        lastname: joi.string().trim().min(2).max(30).optional().messages({
          "string.base": "Soyad Alanı Normal Metin Olmalıdır",
          "string.empty": "Soyad Alanı Boş Geçilemez",
          "string.min": "Soyad Alanı En Az 2 Karakter Olmalıdır",
          "string.max": "Soyad Alanı En Fazla 30 Karakter Olmalıdır"
        }),
        phone: joi.string().trim().pattern(/^[0-9+\-\s()]+$/).max(20).optional().allow('', null).messages({
          "string.base": "Telefon Alanı Normal Metin Olmalıdır",
          "string.pattern.base": "Geçerli bir telefon numarası giriniz",
          "string.max": "Telefon Alanı En Fazla 20 Karakter Olmalıdır"
        }),
        age: joi.number().integer().min(1).max(120).optional().allow(null).messages({
          "number.base": "Yaş Alanı Sayı Olmalıdır",
          "number.min": "Yaş 1'den küçük olamaz",
          "number.max": "Yaş 120'den büyük olamaz"
        }),
        height: joi.number().min(30).max(300).optional().allow(null).messages({
          "number.base": "Boy Alanı Sayı Olmalıdır",
          "number.min": "Boy 30 cm'den küçük olamaz",
          "number.max": "Boy 300 cm'den büyük olamaz"
        }),
        weight: joi.number().min(1).max(500).optional().allow(null).messages({
          "number.base": "Kilo Alanı Sayı Olmalıdır",
          "number.min": "Kilo 1 kg'dan küçük olamaz",
          "number.max": "Kilo 500 kg'dan büyük olamaz"
        }),
        targetWeight: joi.number().min(1).max(500).optional().allow(null).messages({
          "number.base": "Hedef Kilo Alanı Sayı Olmalıdır",
          "number.min": "Hedef Kilo 1 kg'dan küçük olamaz",
          "number.max": "Hedef Kilo 500 kg'dan büyük olamaz"
        })
      }).options({ allowUnknown: false, stripUnknown: true });

      await schema.validateAsync(req.body);
      next();

    } catch (error) {
      console.log(error);
      return res.status(400).json({ message: error.message });
    }
  };

}

module.exports = AuthValidation;
