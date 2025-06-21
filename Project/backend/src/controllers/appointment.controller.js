const Appointment = require('../models/appointment.model');
const User = require('../models/user.model');
const moment = require('moment');

// Diyetisyen listesi (statik)
const DIETITIANS = [
  { id: 1, name: 'Dr. Ayşe Kaya', specialty: 'Spor Diyetisyeni', experience: '8 yıl', image: 'doctor1' },
  { id: 2, name: 'Dr. Mehmet Yılmaz', specialty: 'Klinik Diyetisyen', experience: '12 yıl', image: 'doctor2' },
  { id: 3, name: 'Dr. Zeynep Demir', specialty: 'Pediatrik Diyetisyen', experience: '6 yıl', image: 'doctor3' },
  { id: 4, name: 'Dr. Ali Özkan', specialty: 'Obezite Uzmanı', experience: '10 yıl', image: 'doctor4' }
];

// Belirli bir gün ve diyetisyen için mevcut saatler
const AVAILABLE_HOURS = ['09:00', '10:00', '11:00', '13:00', '14:00', '16:00'];

// Diyetisyen listesini getir
exports.getDietitians = async (req, res) => {
  try {
    res.json({ dietitians: DIETITIANS });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

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
    
    if (!dietitian || !date || !time) {
      return res.status(400).json({ message: 'Tüm alanlar zorunlu.' });
    }
    
    // Tarihi kontrol et - sadece gelecek tarihler
    const appointmentDate = moment(date);
    const today = moment().startOf('day');
    
    if (appointmentDate.isBefore(today)) {
      return res.status(400).json({ message: 'Geçmiş tarihler için randevu alınamaz.' });
    }
    
    // Aynı saatte başka randevu var mı?
    const exists = await Appointment.findOne({ 
      dietitian, 
      date: appointmentDate.toDate(), 
      time, 
      status: { $ne: 'cancelled' } 
    });
    
    if (exists) {
      return res.status(400).json({ message: 'Bu saat dolu.' });
    }
    
    const appointment = await Appointment.create({ 
      user, 
      dietitian, 
      date: appointmentDate.toDate(), 
      time,
      status: 'approved' // Onay kısmını kaldırıyoruz, direkt onaylı olacak
    });
    
    res.status(201).json({ 
      success: true,
      message: 'Randevu başarıyla oluşturuldu.',
      appointment 
    });
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