const express = require("express")
const app = express()

// ENV'yi doğru yükleyelim
const path = require("path")
require("dotenv").config({ path: path.join(__dirname, '.env') })

// 🔍 ENV TEST - detaylı
console.log("========================================");
console.log("🔍 ENVIRONMENT TEST:");
console.log("Working Directory:", __dirname);
console.log("ENV File Path:", path.join(__dirname, '.env'));
console.log("PORT:", process.env.PORT);
console.log("JWT_SECRET_KEY exists:", !!process.env.JWT_SECRET_KEY);
console.log("JWT_SECRET_KEY length:", process.env.JWT_SECRET_KEY ? process.env.JWT_SECRET_KEY.length : 0);
console.log("JWT_EXPIRATION_IN:", process.env.JWT_EXPIRATION_IN);
console.log("MONGODB_URI exists:", !!process.env.MONGODB_URI);
console.log("========================================");

require("./src/db/dbConnection")
const port = process.env.PORT || 5002
const router = require("./src/routers")
const errorHandlerMiddleware = require("./src/middlewares/errorHandler")
const cors = require("cors")
const corsOptions = require("./src/helpers/corsOptions")
const mongoSanitize = require('express-mongo-sanitize');
const apiLimiter = require("./src/middlewares/rateLimit")
const moment= require("moment-timezone")
moment.tz.setDefault("Europe/Istanbul")

// Middlewares
app.use(express.json({limit: "50mb"}))
app.use(express.urlencoded({limit: "50mb", extended: true, parameterLimit: 50000}))

app.use(express.static(path.join(__dirname, "public")))
app.use("/uploads", express.static(path.join(__dirname)))

app.use(cors(corsOptions))

// Rate limiter middleware - router'dan ÖNCE yerleştiriliyor
app.use("/api/auth", apiLimiter);  // Sadece auth endpoint'leri için uygula

// Debug logging middleware
app.use("/api", (req, res, next) => {
    console.log(`🔍 ${new Date().toISOString()} - ${req.method} ${req.url}`);
    next();
});

// API rotaları tanımla
app.use("/api", router)

app.get("/", (req, res) => {
    res.json({
        message: "Hoş Geldiniz"
    })
})

// hata yakalama
app.use(errorHandlerMiddleware)

app.listen(port, () => {
    console.log(`Server ${port} portundan çalışıyor ...`);
})