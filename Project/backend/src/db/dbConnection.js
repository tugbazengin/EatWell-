const mongoose = require('mongoose');

const connectDB = async () => {
  try {
    const mongoURI = process.env.MONGODB_URI || 'mongodb://localhost:27017/safeway';
    
    await mongoose.connect(mongoURI);
    
    console.log('✅ MongoDB veritabanına başarıyla bağlandı');
    console.log('📍 Database:', mongoose.connection.name);
    console.log('🌐 Host:', mongoose.connection.host);
    console.log('🔌 Port:', mongoose.connection.port);
    
  } catch (error) {
    console.error('❌ MongoDB bağlantı hatası:', error.message);
    console.error('💡 Kontrol edilecekler:');
    console.error('   - MongoDB servisi çalışıyor mu?');
    console.error('   - MONGODB_URI .env dosyasında doğru tanımlı mı?');
    console.error('   - Ağ bağlantısı var mı?');
    
    // Geliştirme ortamında uygulamayı durdur
    if (process.env.NODE_ENV !== 'production') {
      process.exit(1);
    }
  }
};

// Bağlantı olaylarını dinle
mongoose.connection.on('connected', () => {
  console.log('🔗 Mongoose MongoDB\'ye bağlandı');
});

mongoose.connection.on('error', (err) => {
  console.error('❌ Mongoose bağlantı hatası:', err);
});

mongoose.connection.on('disconnected', () => {
  console.log('🔌 Mongoose MongoDB bağlantısı kesildi');
});

// Uygulama kapanırken bağlantıyı temizle
process.on('SIGINT', async () => {
  await mongoose.connection.close();
  console.log('👋 MongoDB bağlantısı kapatıldı');
  process.exit(0);
});

// Bağlantıyı başlat
connectDB();
