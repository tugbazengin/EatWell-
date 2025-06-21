const mongoose = require('mongoose');

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

// İndeksler
mealSchema.index({ name: 'text', description: 'text' });
mealSchema.index({ category: 1 });
mealSchema.index({ calories: 1 });

module.exports = mongoose.model('Meal', mealSchema); 