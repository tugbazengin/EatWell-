const mongoose = require('mongoose');
const fs = require('fs');
const path = require('path');

// MongoDB bağlantısı
const connectDB = async () => {
    try {
        // .env dosyasından bağlantı string'ini al
        const DB_URI = process.env.MONGODB_URI || process.env.DB_URI || 'mongodb://localhost:27017/eatwell';
        await mongoose.connect(DB_URI);
        console.log('✅ MongoDB bağlantısı başarılı');
    } catch (error) {
        console.error('❌ MongoDB bağlantı hatası:', error);
        process.exit(1);
    }
};

// Meal şeması
const mealSchema = new mongoose.Schema({
    name: {
        type: String,
        required: true,
        trim: true
    },
    category: {
        type: String,
        required: true,
        enum: ['Kahvaltı', 'Öğle Yemeği', 'Akşam Yemeği', 'Atıştırmalık', 'Çorba', 'Tatlı']
    },
    calories: {
        type: Number,
        required: true,
        min: 0
    },
    protein: {
        type: Number,
        required: true,
        min: 0
    },
    carbs: {
        type: Number,
        required: true,
        min: 0
    },
    fat: {
        type: Number,
        required: true,
        min: 0
    },
    description: {
        type: String,
        required: true
    },
    ingredients: [{
        type: String,
        required: true
    }],
    preparationTime: {
        type: Number,
        required: true,
        min: 0 // dakika cinsinden
    }
}, {
    timestamps: true
});

// Meal modelini oluştur
const Meal = mongoose.model('Meal', mealSchema);

// JSON dosyasını oku ve verileri import et
const importMeals = async () => {
    try {
        // JSON dosyasını oku
        const dataPath = path.join(__dirname, '../data/meals.json');
        const mealsData = JSON.parse(fs.readFileSync(dataPath, 'utf8'));
        
        console.log(`📊 ${mealsData.length} yemek verisi bulundu`);
        
        // Mevcut verileri temizle (isteğe bağlı)
        console.log('🧹 Mevcut meal verilerini temizleniyor...');
        await Meal.deleteMany({});
        
        // Yeni verileri ekle
        console.log('📥 Yeni veriler ekleniyor...');
        const importedMeals = await Meal.insertMany(mealsData);
        
        console.log(`✅ ${importedMeals.length} yemek başarıyla eklendi!`);
        
        // Kategorilere göre özet
        const categories = await Meal.aggregate([
            {
                $group: {
                    _id: "$category",
                    count: { $sum: 1 },
                    avgCalories: { $avg: "$calories" },
                    avgProtein: { $avg: "$protein" }
                }
            },
            {
                $sort: { count: -1 }
            }
        ]);
        
        console.log('\n📊 Kategori Özeti:');
        categories.forEach(cat => {
            console.log(`${cat._id}: ${cat.count} yemek (Ort. ${Math.round(cat.avgCalories)} kalori, ${Math.round(cat.avgProtein)}g protein)`);
        });
        
    } catch (error) {
        console.error('❌ Import hatası:', error);
    } finally {
        mongoose.connection.close();
        console.log('\n🔒 MongoDB bağlantısı kapatıldı');
    }
};

// Ana fonksiyon
const main = async () => {
    console.log('🚀 Yemek verileri MongoDB\'ye aktarılıyor...\n');
    
    await connectDB();
    await importMeals();
    
    process.exit(0);
};

// Script'i çalıştır
if (require.main === module) {
    // .env dosyasını yükle
    require('dotenv').config({ path: path.join(__dirname, '../.env') });
    main();
}

module.exports = { Meal }; 