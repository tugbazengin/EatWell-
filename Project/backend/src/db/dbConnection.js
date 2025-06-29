const mongoose = require('mongoose');

const connectDB = async () => {
  try {
    const mongoURI = process.env.MONGODB_URI || "mongodb://localhost:27017/";
    
    
    // Basit bağlantı ayarları
    const options = {
      serverSelectionTimeoutMS: 5000, // 5 saniye timeout
      connectTimeoutMS: 10000, // 10 saniye bağlantı timeout'u
    };
    
    await mongoose.connect(mongoURI, options);
    
    console.log('✅ MongoDB veritabanına başarıyla bağlandı');
    console.log('📍 Database:', mongoose.connection.name);
    console.log('🌐 Host:', mongoose.connection.host);
    
  } catch (error) {
    console.error('❌ MongoDB bağlantı hatası:', error.message);
    console.error('💡 Kontrol edilecekler:');
    console.error('   - MONGODB_URI .env dosyasında doğru tanımlı mı?');
    console.error('   - Internet bağlantısı var mı?');
    console.error('   - MongoDB Atlas IP whitelist kontrolü');
    
    // Tekrar deneme YOK - sadece hata ver ve devam et
    console.log('🛑 Uygulama MongoDB olmadan devam ediyor...');
  }
};

// Bağlantı olaylarını basit şekilde dinle
mongoose.connection.on('connected', () => {
  console.log('🔗 MongoDB bağlantısı kuruldu');
});

mongoose.connection.on('error', (err) => {
  console.error('❌ MongoDB hatası:', err.message);
});

mongoose.connection.on('disconnected', () => {
  console.log('🔌 MongoDB bağlantısı kesildi');
});

// Uygulama kapanırken bağlantıyı temizle
process.on('SIGINT', async () => {
  try {
    await mongoose.connection.close();
    console.log('👋 MongoDB bağlantısı kapatıldı');
  } catch (error) {
    console.error('❌ Bağlantı kapatılırken hata:', error.message);
  }
  process.exit(0);
});

// Bağlantıyı başlat
connectDB();
