const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
    name: {
        type: String,  //tip belittirimi
        required: true, // zorunlu alan
        trim: true  // boşlukları temizle
    },
    lastname: {
        type: String,
        required: true,
        trim: true
    },
    email: {
        type: String,
        required: true,
        unique: true, // e-posta adresinin benzersiz olmasını sağlar
        trim: true,
    },
    password: {
        type: String,
        required: true, 
        trim: true
    },
    phone: {
        type: String,
        required: false,
        trim: true,
        default: null
    },
    profileImage: {
        type: String,
        required: false,
        default: null
    },
    address: {
        type: String,
        required: false,
        trim: true,
        default: null
    },
    birthDate: {
        type: Date,
        required: false,
        default: null
    },
    gender: {
        type: String,
        required: false,
        enum: ['male', 'female', 'other', null],
        default: null
    },
    resetCode: {  // Reset kodu
        type: String,
        required: false,
        default: null
    },
    resetTime: {  // Reset kodunun geçerlilik süresi
        type: Date,
        required: false,
        default: null
    },
    age: {
        type: Number,
        required: false,
        min: 0,
        max: 120,
        default: null
    },
    height: {
        type: Number, // cm
        required: false,
        min: 30,
        max: 300,
        default: null
    },
    weight: {
        type: Number, // kg
        required: false,
        min: 1,
        max: 500,
        default: null
    },
    targetWeight: {
        type: Number, // kg
        required: false,
        min: 1,
        max: 500,
        default: null
    }
},{collection: 'users', timestamps: true}); // collection: veritabanında hangi koleksiyonda saklanacağını belirtir tarih ve saat bilgisi ekler

const User = mongoose.model('User', userSchema); // model: veritabanında hangi koleksiyonda saklanacağını belirtir     

module.exports = User; // dışarıya aktarma işlemi