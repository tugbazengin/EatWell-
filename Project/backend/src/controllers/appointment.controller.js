const Appointment = require('../models/appointment.model');
const User = require('../models/user.model');
const moment = require('moment');

// Diyetisyen listesi (örnek)
const DIETITIANS = [
  'Dr. Tuğba Zengin',
  'Dr. Berke Baş',
  'Dr. Sıla Bıçakçı'
];

// Belirli bir gün ve diyetisyen için mevcut saatler
const AVAILABLE_HOURS = ['09:00', '10:00', '11:00', '13:00', '14:00', '16:00'];

// Kullanıcıya uygun randevu saatlerini getir
exports.getAvailableSlots = async (req, res) => {
  try {
    const { dietitian, date } = req.query;
    if (!dietitian || !date) return res.status(400).json({ message: 'Diyetisyen ve tarih zorunlu.' });
    const dayStart = moment(date).startOf('day');
    const dayEnd = moment(date).endOf('day');
    const taken = await Appointment.find({
      dietitian,
      date: { $gte: dayStart.toDate(), $lte: dayEnd.toDate() },
      status: { $ne: 'cancelled' }
    });
    const takenTimes = taken.map(a => a.time);
    const available = AVAILABLE_HOURS.filter(h => !takenTimes.includes(h));
    res.json({ available });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

// Randevu oluştur
exports.createAppointment = async (req, res) => {
  try {
    const { dietitian, date, time } = req.body;
    const user = req.user._id;
    if (!dietitian || !date || !time) return res.status(400).json({ message: 'Tüm alanlar zorunlu.' });
    // Aynı saatte başka randevu var mı?
    const exists = await Appointment.findOne({ dietitian, date: moment(date).toDate(), time, status: { $ne: 'cancelled' } });
    if (exists) return res.status(400).json({ message: 'Bu saat dolu.' });
    const appointment = await Appointment.create({ user, dietitian, date: moment(date).toDate(), time });
    res.status(201).json({ appointment });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

// Kullanıcının randevularını getir
exports.getUserAppointments = async (req, res) => {
  try {
    const user = req.user._id;
    const appointments = await Appointment.find({ user }).sort({ date: 1, time: 1 });
    res.json({ appointments });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

// Randevu iptal et
exports.cancelAppointment = async (req, res) => {
  try {
    const { id } = req.params;
    const user = req.user._id;
    const appointment = await Appointment.findOneAndUpdate({ _id: id, user }, { status: 'cancelled' }, { new: true });
    if (!appointment) return res.status(404).json({ message: 'Randevu bulunamadı.' });
    res.json({ message: 'Randevu iptal edildi.', appointment });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
}; 