const Meal = require('../models/meal.model');
const response = require('../utils/response');
const fs = require('fs');
const path = require('path');

// Test için JSON dosyasından veri oku
const getTestMealsData = () => {
    try {
        const dataPath = path.join(__dirname, '../../data/meals.json');
        console.log('📁 Dosya yolu:', dataPath);
        console.log('📋 Dosya var mı?', fs.existsSync(dataPath));
        
        const mealsData = JSON.parse(fs.readFileSync(dataPath, 'utf8'));
        console.log('✅ JSON başarıyla okundu, yemek sayısı:', mealsData.length);
        
        // Her meal'e _id ekle (Swift modeli _id bekliyor)
        const mealsWithId = mealsData.map((meal, index) => ({
            _id: `test_meal_${index + 1}`,
            ...meal,
            createdAt: new Date().toISOString(),
            updatedAt: new Date().toISOString()
        }));
        
        console.log('✅ IDler eklendi, ornek meal:', mealsWithId[0]);
        return mealsWithId;
    } catch (error) {
        console.error('❌ Test data okuma hatası:', error);
        console.error('❌ Hata detayı:', error.message);
        return [];
    }
};

// Test API - MongoDB olmadan da çalışır
const getTestMeals = async (req, res) => {
    try {
        console.log('🔍 getTestMeals çağrıldı, query:', req.query);
        const { category, search, limit = 50, page = 1 } = req.query;
        let mealsData = getTestMealsData();
        
        console.log('📊 Toplam yemek sayısı:', mealsData.length);
        
        // Kategori filtresi
        if (category) {
            mealsData = mealsData.filter(meal => meal.category === category);
            console.log(`🔥 Kategori "${category}" filtrelendi, kalan:`, mealsData.length);
        }
        
        // Arama filtresi
        if (search) {
            const searchLower = search.toLowerCase();
            mealsData = mealsData.filter(meal => 
                meal.name.toLowerCase().includes(searchLower) ||
                meal.description.toLowerCase().includes(searchLower) ||
                meal.ingredients.some(ingredient => ingredient.toLowerCase().includes(searchLower))
            );
            console.log(`🔍 Arama "${search}" filtrelendi, kalan:`, mealsData.length);
        }
        
        // Sayfalama
        const startIndex = (page - 1) * limit;
        const endIndex = startIndex + parseInt(limit);
        const paginatedMeals = mealsData.slice(startIndex, endIndex);
        
        console.log('📄 Sayfalama:', { page, limit, startIndex, endIndex, sonuç: paginatedMeals.length });
        
        return new response({
            meals: paginatedMeals,
            pagination: {
                current: parseInt(page),
                total: Math.ceil(mealsData.length / limit),
                count: paginatedMeals.length,
                totalItems: mealsData.length
            }
        }, 'Test yemekleri başarıyla getirildi', 200).success(res);
        
    } catch (error) {
        console.error('❌ getTestMeals error:', error);
        return new response(null, 'Test yemekleri getirilirken hata oluştu: ' + error.message, 500).errror500(res);
    }
};

// Test - Kategorilere göre yemekleri getir
const getTestMealsByCategory = async (req, res) => {
    try {
        const categories = ['Kahvaltı', 'Öğle Yemeği', 'Akşam Yemeği', 'Atıştırmalık', 'Çorba', 'Tatlı'];
        const mealsData = getTestMealsData();
        
        const mealsByCategory = {};
        
        categories.forEach(category => {
            const categoryMeals = mealsData
                .filter(meal => meal.category === category)
                .slice(0, 10)
                .sort((a, b) => a.calories - b.calories);
            mealsByCategory[category] = categoryMeals;
        });
        
        return new response(mealsByCategory, 'Test kategoriye göre yemekler getirildi', 200).success(res);
        
    } catch (error) {
        console.error('getTestMealsByCategory error:', error);
        return new response(null, 'Test kategoriye göre yemekler getirilirken hata oluştu', 500).errror500(res);
    }
};

// Test - Rastgele yemek getir
const getTestRandomMeals = async (req, res) => {
    try {
        const { count = 6, category } = req.query;
        let mealsData = getTestMealsData();
        
        if (category) {
            mealsData = mealsData.filter(meal => meal.category === category);
        }
        
        // Rastgele karıştır ve seç
        const shuffled = mealsData.sort(() => 0.5 - Math.random());
        const randomMeals = shuffled.slice(0, parseInt(count));
        
        return new response(randomMeals, 'Test rastgele yemekler getirildi', 200).success(res);
        
    } catch (error) {
        console.error('getTestRandomMeals error:', error);
        return new response(null, 'Test rastgele yemekler getirilirken hata oluştu', 500).errror500(res);
    }
};

// Tüm yemekleri getir
const getAllMeals = async (req, res) => {
    try {
        const { category, search, limit = 50, page = 1 } = req.query;
        
        let query = {};
        
        // Kategori filtresi
        if (category) {
            query.category = category;
        }
        
        // Arama filtresi
        if (search) {
            query.$or = [
                { name: { $regex: search, $options: 'i' } },
                { description: { $regex: search, $options: 'i' } },
                { ingredients: { $in: [new RegExp(search, 'i')] } }
            ];
        }
        
        const skip = (page - 1) * limit;
        
        const meals = await Meal.find(query)
            .limit(parseInt(limit))
            .skip(skip)
            .sort({ name: 1 });
            
        const total = await Meal.countDocuments(query);
        
        return new response({
            meals,
            pagination: {
                current: parseInt(page),
                total: Math.ceil(total / limit),
                count: meals.length,
                totalItems: total
            }
        }, 'Yemekler başarıyla getirildi', 200).success(res);
        
    } catch (error) {
        console.error('getAllMeals error:', error);
        return new response(null, 'Yemekler getirilirken hata oluştu: ' + error.message, 500).errror500(res);
    }
};

// Kategorilere göre yemekleri getir
const getMealsByCategory = async (req, res) => {
    try {
        const categories = ['Kahvaltı', 'Öğle Yemeği', 'Akşam Yemeği', 'Atıştırmalık', 'Çorba', 'Tatlı'];
        
        const mealsByCategory = {};
        
        for (const category of categories) {
            const meals = await Meal.find({ category })
                .limit(10)
                .sort({ calories: 1 });
            mealsByCategory[category] = meals;
        }
        
        return new response(mealsByCategory, 'Kategoriye göre yemekler getirildi', 200).success(res);
        
    } catch (error) {
        console.error('getMealsByCategory error:', error);
        return new response(null, 'Kategoriye göre yemekler getirilirken hata oluştu: ' + error.message, 500).errror500(res);
    }
};

// Belirli bir yemeği getir
const getMealById = async (req, res) => {
    try {
        const { id } = req.params;
        
        const meal = await Meal.findById(id);
        
        if (!meal) {
            return new response(null, 'Yemek bulunamadı', 404).errror404(res);
        }
        
        return new response(meal, 'Yemek başarıyla getirildi', 200).success(res);
        
    } catch (error) {
        console.error('getMealById error:', error);
        return new response(null, 'Yemek getirilirken hata oluştu: ' + error.message, 500).errror500(res);
    }
};

// Kalori aralığına göre yemek öner
const suggestMeals = async (req, res) => {
    try {
        const { targetCalories, category, excludeIds = [] } = req.query;
        
        if (!targetCalories) {
            return new response(null, 'Hedef kalori belirtilmeli', 400).errror400(res);
        }
        
        const calories = parseInt(targetCalories);
        const calorieRange = calories * 0.1; // %10 tolerans
        
        let query = {
            calories: {
                $gte: calories - calorieRange,
                $lte: calories + calorieRange
            }
        };
        
        if (category) {
            query.category = category;
        }
        
        if (excludeIds.length > 0) {
            query._id = { $nin: excludeIds.map(id => id) };
        }
        
        const suggestions = await Meal.find(query)
            .limit(5)
            .sort({ calories: 1 });
        
        return new response(suggestions, 'Yemek önerileri getirildi', 200).success(res);
        
    } catch (error) {
        console.error('suggestMeals error:', error);
        return new response(null, 'Yemek önerileri getirilirken hata oluştu: ' + error.message, 500).errror500(res);
    }
};

// Rastgele yemek getir
const getRandomMeals = async (req, res) => {
    try {
        const { count = 6, category } = req.query;
        
        let matchQuery = {};
        if (category) {
            matchQuery.category = category;
        }
        
        const randomMeals = await Meal.aggregate([
            { $match: matchQuery },
            { $sample: { size: parseInt(count) } }
        ]);
        
        return new response(randomMeals, 'Rastgele yemekler getirildi', 200).success(res);
        
    } catch (error) {
        console.error('getRandomMeals error:', error);
        return new response(null, 'Rastgele yemekler getirilirken hata oluştu: ' + error.message, 500).errror500(res);
    }
};

// Besin değeri hesaplama
const calculateNutrition = async (req, res) => {
    try {
        const { mealIds } = req.body; // Array of meal IDs with quantities
        
        if (!mealIds || !Array.isArray(mealIds)) {
            return new response(null, 'Yemek ID\'leri gerekli', 400).errror400(res);
        }
        
        let totalNutrition = {
            calories: 0,
            protein: 0,
            carbs: 0,
            fat: 0,
            preparationTime: 0
        };
        
        const mealsWithQuantity = [];
        
        for (const item of mealIds) {
            const meal = await Meal.findById(item.mealId);
            if (meal) {
                const quantity = item.quantity || 1;
                totalNutrition.calories += meal.calories * quantity;
                totalNutrition.protein += meal.protein * quantity;
                totalNutrition.carbs += meal.carbs * quantity;
                totalNutrition.fat += meal.fat * quantity;
                totalNutrition.preparationTime += meal.preparationTime;
                
                mealsWithQuantity.push({
                    ...meal.toObject(),
                    quantity
                });
            }
        }
        
        return new response({
            meals: mealsWithQuantity,
            totalNutrition: {
                ...totalNutrition,
                calories: Math.round(totalNutrition.calories),
                protein: Math.round(totalNutrition.protein * 10) / 10,
                carbs: Math.round(totalNutrition.carbs * 10) / 10,
                fat: Math.round(totalNutrition.fat * 10) / 10
            }
        }, 'Besin değeri hesaplandı', 200).success(res);
        
    } catch (error) {
        console.error('calculateNutrition error:', error);
        return new response(null, 'Besin değeri hesaplanırken hata oluştu: ' + error.message, 500).errror500(res);
    }
};

module.exports = {
    getAllMeals,
    getMealsByCategory,
    getMealById,
    suggestMeals,
    getRandomMeals,
    calculateNutrition,
    getTestMeals,
    getTestMealsByCategory,
    getTestRandomMeals
}; 