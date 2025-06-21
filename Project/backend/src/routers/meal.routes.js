const express = require('express');
const router = express.Router();
const {
    getAllMeals,
    getMealsByCategory,
    getMealById,
    suggestMeals,
    getRandomMeals,
    calculateNutrition,
    getTestMeals,
    getTestMealsByCategory,
    getTestRandomMeals
} = require('../controllers/meal.controller');

// Public routes (kimlik doğrulama gerektirmez)

// Test routes (MongoDB olmadan çalışır)
// GET /api/meals/test - Test yemekleri getir
router.get('/test', getTestMeals);

// Debug endpoint
router.get('/debug', (req, res) => {
    res.json({ success: true, message: 'Meal routes çalışıyor', timestamp: new Date() });
});

// GET /api/meals/test/categories - Test kategorilere göre yemekler
router.get('/test/categories', getTestMealsByCategory);

// GET /api/meals/test/random - Test rastgele yemekler
router.get('/test/random', getTestRandomMeals);

// GET /api/meals - Tüm yemekleri getir (filtreleme ile)
router.get('/', getAllMeals);

// GET /api/meals/categories - Kategorilere göre yemekleri getir
router.get('/categories', getMealsByCategory);

// GET /api/meals/random - Rastgele yemekler getir
router.get('/random', getRandomMeals);

// GET /api/meals/suggest - Kalori hedefine göre yemek öner
router.get('/suggest', suggestMeals);

// GET /api/meals/:id - Belirli bir yemeği getir
router.get('/:id', getMealById);

// POST /api/meals/nutrition - Besin değeri hesapla
router.post('/nutrition', calculateNutrition);

module.exports = router; 