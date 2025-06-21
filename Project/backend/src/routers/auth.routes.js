const router = require('express').Router();
const { login, register,me,forgetPassword, resetCodeCheck,resetPassword, updateProfile, deleteAccount } = require('../controllers/auth.controller');
const authValidation = require('../middlewares/validations/auth.validation');
const {tokenCheck} = require('../middlewares/auth') // token kontrolü için kullanılan middleware

router.post("/login", login)
router.post("/register",authValidation.register,register)
router.get("/me", tokenCheck, me) // Doğru sıralama: önce token kontrolü, sonra kullanıcı bilgileri
router.post("/forget-password",forgetPassword)
router.post("/reset-code-check",resetCodeCheck)
router.post("/reset-password",resetPassword) // token kontrolü ve şifre sıfırlama işlemi
router.put("/update-profile", tokenCheck, authValidation.updateProfile, updateProfile) // Profil güncelleme
router.delete("/delete-account", tokenCheck, deleteAccount) // Hesap silme

// 🔍 GEÇICI: Kullanıcıları listele (test için)
router.get("/list-users", async (req, res) => {
    try {
        const User = require('../models/user.model');
        const users = await User.find({}).select('name lastname email createdAt');
        res.json({ users, count: users.length });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

module.exports = router;