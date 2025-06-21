const mongoose = require('mongoose');

const appointmentSchema = new mongoose.Schema({
    user: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
    dietitian: { type: String, required: true }, // Diyetisyen adı
    date: { type: Date, required: true },
    time: { type: String, required: true }, // Örn: '09:00'
    status: { type: String, enum: ['pending', 'approved', 'cancelled'], default: 'pending' }
}, { timestamps: true });

module.exports = mongoose.model('Appointment', appointmentSchema); 