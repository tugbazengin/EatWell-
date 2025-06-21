const whitelist = [
    'http://localhost:5002',        // Doğru port!
    'http://192.168.1.101:5002',    // IP + doğru port
    'http://192.168.172.217:5002',  // Yeni IP
    'http://10.0.2.2:5002',         // Android emulator
    'http://172.16.4.65:5002',
    'http://localhost:19006',        // Expo web
    'http://localhost:19000',        // Expo
]

const corsOptions = (req, callback) => {
    let corsOptions;
    
    // React Native'den gelen isteklerde Origin header olmayabilir
    const origin = req.header('Origin');
    
    // Origin yoksa (React Native) veya whitelist'te varsa kabul et
    if (!origin || whitelist.indexOf(origin) !== -1) {
        corsOptions = { 
            origin: true,
            credentials: true,
            optionsSuccessStatus: 200 // some legacy browsers (IE11, various SmartTVs) choke on 204
        } 
    } else {
        corsOptions = { origin: false } 
    }
    callback(null, corsOptions)
}

module.exports = corsOptions