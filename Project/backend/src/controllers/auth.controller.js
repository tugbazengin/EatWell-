const User = require('../models/user.model'); //şifreleme işlemi için kullanılır
const APIError = require('../utils/errors'); // hata mesajı döndürmek için kullanılır API ile ilgili bir hata oluştuğunda kullanılır
const Response = require('../utils/response'); //özel hata mesajı döndürmek için kullanılır 
const bcrypt = require('bcryptjs');
const { createToken,createTemporaryToken,decodedTemporaryToken } = require('../middlewares/auth');
const sendEmail = require('../utils/sendMail');
const moment = require('moment');
const crypto = require('crypto');
const { decode } = require('punycode');

const login = async (req, res, next) => {
    try {
        console.log("login")
        const { email, password } = req.body; // gelen veriler destructure edilir

        const userInfo = await User.findOne({ email }); // e-posta adresine göre kullanıcıyı bulma işlemi
        console.log("user:", userInfo);
        
        if (!userInfo) {
            throw new APIError("Kullanıcı Bulunamadı", 401); // Kullanıcı bulunamazsa hata fırlat
        }
        
        // Şifre karşılaştırması
        const passwordCheck = await bcrypt.compare(password, userInfo.password);
        if (!passwordCheck) {
            throw new APIError("Şifre Hatalı", 401);
        }
        
        // Şifre doğruysa token oluştur
        return await createToken(userInfo, res);
    } catch (err) {
        console.error("Login Error:", err);
        next(err); // Hata yönetim middleware'ine hatayı ilet
    }
};

const register = async (req, res, next) => {
    try {
        console.log("🚀 Register başladı");
        console.log("📧 Gelen body:", req.body);
        
        const { name, lastname, email, password, phone, birthDate, age, height, weight, targetWeight } = req.body;

        console.log("🔍 Destructured data:", { name, lastname, email, password: password ? "***" : "null", phone, birthDate, age, height, weight, targetWeight });

        // Zorunlu alanları kontrol et
        if (!name || !lastname || !email || !password) {
            console.log("❌ Zorunlu alanlar eksik");
            throw new APIError("Tüm alanlar zorunludur: name, lastname, email, password", 400);
        }

        console.log("✅ Zorunlu alanlar tamam");

        // E-posta adresinin daha önce kullanılıp kullanılmadığını kontrol et
        console.log("🔍 Email kontrolü yapılıyor:", email);
        const existingUser = await User.findOne({ email });
        console.log("👤 Mevcut kullanıcı:", existingUser);
        
        if (existingUser) {
            console.log("❌ Email zaten kayıtlı");
            throw new APIError("Bu e-posta adresi zaten kayıtlı", 400);
        }
        
        console.log("✅ Email müsait");

        // Şifreyi hashle
        console.log("🔐 Şifre hashleniyor");
        const hashedPassword = await bcrypt.hash(password, 10);
        console.log("✅ Şifre hashlendi");
        
        // Yeni kullanıcıyı oluştur
        console.log("💾 Kullanıcı oluşturuluyor");
        const newUser = await User.create({
            name,
            lastname,
            email,
            password: hashedPassword,
            phone: phone || null,
            birthDate: birthDate || null,
            age: age || null,
            height: height || null,
            weight: weight || null,
            targetWeight: targetWeight || null
        });
        
        console.log("✅ Yeni kullanıcı kaydedildi:", newUser);
        
        // Token oluştur ve döndür
        console.log("🔑 Token oluşturuluyor...");
        return await createToken(newUser, res);
    } catch (err) {
        console.error("💥 Register Error:", err);
        next(err);
    }
}
const me = async (req, res, next) => {
    try {
        if (!req.user) {
            throw new APIError("Kullanıcı bulunamadı", 401);
        }
        
        return new Response(req.user, "Kullanıcı bilgileri", 200).success(res);
    } catch (err) {
        console.error("Me Error:", err);
        next(err);
    }
};


const forgetPassword = async (req, res, next) => {
    try {
        const { email } = req.body;
        
        if (!email) {
            throw new APIError("Email adresi zorunludur", 400);
        }
       
        const userInfo = await User.findOne({ email }).select("name lastname email"); // sadece name, lastname ve email alanlarını seç
        if (!userInfo) {
            throw new APIError("Kullanıcı bulunamadı", 404);
        }
        
        // Environment değişkenlerini kontrol et
        if (!process.env.EMAIL_USER || !process.env.EMAIL_PASS) {
            console.error("❌ E-posta gönderimi için gerekli environment değişkenleri eksik:");
            console.error("EMAIL_USER:", process.env.EMAIL_USER ? "✅ Tanımlı" : "❌ Tanımlı değil");
            console.error("EMAIL_PASS:", process.env.EMAIL_PASS ? "✅ Tanımlı" : "❌ Tanımlı değil");
            throw new APIError("E-posta servisi yapılandırılmamış. Lütfen sistem yöneticisi ile iletişime geçin.", 500);
        }
        
        const resetCode = crypto.randomBytes(3).toString("hex");
        const resetTime = moment(new Date()).add(10, "minutes").toDate();
        
        console.log("📧 E-posta gönderme işlemi başlıyor...");
        console.log("📧 Alıcı:", userInfo.email);
        console.log("📧 Reset kodu:", resetCode);
        
        // Email gönderme işlemi
        const emailResult = await sendEmail({
            from: process.env.EMAIL_USER,
            to: userInfo.email,
            subject: "Şifre Sıfırlama",
            text: `Merhaba ${userInfo.name} ${userInfo.lastname},\n\nŞifrenizi sıfırlamak için aşağıdaki kodu kullanabilirsiniz:\n\n${resetCode}\n\nBu kod 10 dakika geçerlidir.\n\nTeşekkürler`
        });
        
        if (!emailResult) {
            throw new APIError("E-posta gönderilemedi. Lütfen daha sonra tekrar deneyin.", 500);
        }
        
        // Kullanıcı reset kodunu ve süresini güncelle
        await User.updateOne({ email }, {
            resetCode: resetCode,
            resetTime: resetTime
        });
        
        console.log("✅ Şifre sıfırlama kodu başarıyla gönderildi:", userInfo.email);
        
        return new Response(true, "Şifre sıfırlama kodu e-posta adresinize gönderildi", 200).success(res);
    } catch (err) {
        console.error("❌ Forget Password Error:", err);
        next(err); // Hata yönetim middleware'ine hatayı ilet
    }
};

const resetCodeCheck = async (req, res, next) => {
    try {
        console.log("🔍 Reset Code Check başlıyor...");
        const { email, code } = req.body;
        console.log("📧 Gelen data:", { email, code });

        console.log("🔍 Kullanıcı aranıyor...");
        const userInfo = await User.findOne({ email }).select("_id name lastname email resetCode resetTime");
        console.log("👤 Bulunan kullanıcı:", userInfo);
        
        if (!userInfo) {
            throw new APIError("Kullanıcı bulunamadı", 401);
        }

        console.log("🔍 Reset kodu kontrol ediliyor...");
        if (!userInfo.resetCode || !userInfo.resetTime) {
            throw new APIError("Şifre sıfırlama kodu bulunamadı", 401);
        }

        console.log("⏰ Zaman kontrolü yapılıyor...");
        const dbTime = moment(userInfo.resetTime);
        const nowTime = moment(new Date());
        const timeDiff = nowTime.diff(dbTime, "minutes");

        console.log("timeDiff", timeDiff);
        console.log("DB Time:", dbTime.format());
        console.log("Now Time:", nowTime.format());

        if (timeDiff > 10) { // 10 dakika geçtiyse
            throw new APIError("Kod süresi dolmuş", 401);
        }

        console.log("🔑 Kod karşılaştırması yapılıyor...");
        console.log("DB Code:", userInfo.resetCode);
        console.log("Gelen Code:", code);
        
        if (userInfo.resetCode !== code) {
            throw new APIError("Kod geçersiz", 401);
        }

        console.log("🎟️ Temporary token oluşturuluyor...");
        const temporaryToken = await createTemporaryToken(userInfo._id, userInfo.email);
        console.log("✅ Token oluşturuldu");

        return new Response({temporaryToken}, "Kod doğrulandı", 200).success(res);
    } catch (err) {
        console.error("❌ Reset Code Check Error:", err);
        next(err); // Hata yönetim middleware'ine hatayı ilet
    }
};

const resetPassword= async (req, res) => {
    const {password,temporaryToken} = req.body;
    const decodedToken = await decodedTemporaryToken(temporaryToken);
    const hashPassword=await bcrypt.hash(password, 10);

    await User.findByIdAndUpdate({_id:decodedToken._id}, 
        {
            reset:{
                code: null,
                time: null
            },
            password: hashPassword,
        
    });
    return new Response(decodedToken,"Şifre Sıfırlama Başarılı").success(res);

}

const updateProfile = async (req, res, next) => {
    try {
        if (!req.user) {
            throw new APIError("Kullanıcı bulunamadı", 401);
        }

        const { name, lastname, phone, age, height, weight, targetWeight } = req.body;
        const updateData = {};

        // Sadece gönderilen alanları güncelle
        if (name !== undefined) updateData.name = name;
        if (lastname !== undefined) updateData.lastname = lastname;
        if (phone !== undefined) updateData.phone = phone;
        if (age !== undefined) updateData.age = age;
        if (height !== undefined) updateData.height = height;
        if (weight !== undefined) updateData.weight = weight;
        if (targetWeight !== undefined) updateData.targetWeight = targetWeight;

        // Kullanıcıyı güncelle
        const updatedUser = await User.findByIdAndUpdate(
            req.user._id,
            updateData,
            { new: true, runValidators: true }
        ).select('-password -resetCode -resetTime');

        if (!updatedUser) {
            throw new APIError("Kullanıcı güncellenemedi", 400);
        }

        return new Response(updatedUser, "Profil başarıyla güncellendi", 200).success(res);
    } catch (err) {
        console.error("Update Profile Error:", err);
        next(err);
    }
};

const deleteAccount = async (req, res, next) => {
    try {
        if (!req.user) {
            throw new APIError("Kullanıcı bulunamadı", 401);
        }

        // Kullanıcıyı sil
        const deletedUser = await User.findByIdAndDelete(req.user._id);
        
        if (!deletedUser) {
            throw new APIError("Kullanıcı silinemedi", 400);
        }

        return new Response(null, "Hesap başarıyla silindi", 200).success(res);
    } catch (err) {
        console.error("Delete Account Error:", err);
        next(err);
    }
};

module.exports = {
    login,
    register,
    me,
    forgetPassword,
    resetCodeCheck,
    resetPassword,
    updateProfile,
    deleteAccount
};
