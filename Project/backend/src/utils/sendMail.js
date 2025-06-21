const nodemailer = require('nodemailer');

const sendEmail = async (mailOptions) => {
    try {
        console.log("📧 E-posta gönderme başlıyor...");
        console.log("📧 E-posta ayarları:", {
            to: mailOptions.to,
            subject: mailOptions.subject,
            from: process.env.EMAIL_USER
        });

        // Environment değişkenlerini kontrol et
        if (!process.env.EMAIL_USER || !process.env.EMAIL_PASS) {
            console.error("❌ E-posta gönderimi için gerekli environment değişkenleri eksik!");
            console.error("EMAIL_USER:", process.env.EMAIL_USER ? "✅ Tanımlı" : "❌ Tanımlı değil");
            console.error("EMAIL_PASS:", process.env.EMAIL_PASS ? "✅ Tanımlı" : "❌ Tanımlı değil");
            throw new Error("E-posta servisi yapılandırılmamış");
        }

        // SMTP yapılandırması
        const transporter = nodemailer.createTransport({
            host: "smtp.gmail.com",
            port: 587,
            secure: false, // true for 465, false for other ports
            auth: {
                user: process.env.EMAIL_USER,
                pass: process.env.EMAIL_PASS,
            },
        });

        console.log("📧 SMTP bağlantısı test ediliyor...");
        
        // SMTP bağlantısını test et
        await transporter.verify();
        console.log("✅ SMTP bağlantısı başarılı");

        const info = await transporter.sendMail({
            from: `"Şifre Sıfırlama" <${process.env.EMAIL_USER}>`,
            to: mailOptions.to,
            subject: mailOptions.subject,
            text: mailOptions.text,
            html: mailOptions.html,
        });

        console.log("✅ E-posta başarıyla gönderildi:", mailOptions.to);
        console.log("📧 Message ID:", info.messageId);
        
        return true;
    } catch (error) {
        console.error("❌ E-posta gönderme hatası:");
        console.error("Hata mesajı:", error.message);
        console.error("Hata kodu:", error.code);
        
        // Gmail özel hata kodları
        if (error.code === 'EAUTH') {
            console.error("🔐 Kimlik doğrulama hatası - Gmail App Password kullanmanız gerekiyor");
        } else if (error.code === 'ECONNECTION') {
            console.error("🌐 Bağlantı hatası - İnternet bağlantınızı kontrol edin");
        } else if (error.code === 'ETIMEDOUT') {
            console.error("⏰ Zaman aşımı hatası - SMTP sunucusu yanıt vermiyor");
        }
        
        console.error("Tam hata:", error);
        
        return false;
    }
};

module.exports = sendEmail;
