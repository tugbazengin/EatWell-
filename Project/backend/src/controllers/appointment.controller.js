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
const AVAILABLE_HOURS = [
  '09:00', '09:30', '10:00', '10:30', '11:00', '11:30',
  '12:00', '12:30', '13:00', '13:30', '14:00', '14:30',
  '15:00', '15:30', '16:00', '16:30', '17:00', '17:30'
];

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
    console.log(`📅 Available slots isteniyor - Diyetisyen: ${dietitian}, Tarih: ${date}`);
    
    if (!dietitian || !date) {
      console.log('❌ Eksik parametre: dietitian veya date');
      return res.status(400).json({ message: 'Diyetisyen ve tarih zorunlu.' });
    }
    
    const dayStart = moment(date).startOf('day');
    const dayEnd = moment(date).endOf('day');
    
    console.log(`🔍 Alınmış randevular aranıyor: ${dayStart.format()} - ${dayEnd.format()}`);
    
    const taken = await Appointment.find({
      dietitian,
      date: { $gte: dayStart.toDate(), $lte: dayEnd.toDate() },
      status: { $ne: 'cancelled' }
    });
    
    const takenTimes = taken.map(a => a.time);
    console.log(`⏰ Alınmış saatler: ${takenTimes.length > 0 ? takenTimes.join(', ') : 'Hiçbiri'}`);
    
    const available = AVAILABLE_HOURS.filter(h => !takenTimes.includes(h));
    console.log(`✅ Müsait saatler: ${available.length > 0 ? available.join(', ') : 'Hiçbiri'}`);
    
    res.json({ available });
  } catch (err) {
    console.log('❌ Available slots hatası:', err.message);
    res.status(500).json({ message: err.message });
  }
};

// Randevu oluştur
exports.createAppointment = async (req, res) => {
  try {
    const { dietitian, date, time } = req.body;
    const user = req.user._id;
    
    console.log(`🆕 Yeni randevu talebi - User: ${user}, Diyetisyen: ${dietitian}, Tarih: ${date}, Saat: ${time}`);
    
    if (!dietitian || !date || !time) {
      console.log('❌ Eksik parametre: dietitian, date veya time');
      return res.status(400).json({ message: 'Tüm alanlar zorunlu.' });
    }
    
    // Tarihi kontrol et - sadece gelecek tarihler
    const appointmentDate = moment(date);
    const today = moment().startOf('day');
    
    if (appointmentDate.isBefore(today)) {
      console.log('❌ Geçmiş tarih seçildi');
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
      console.log(`❌ Saat dolu - Mevcut randevu: ${exists._id}`);
      return res.status(400).json({ message: 'Bu saat dolu.' });
    }
    
    const appointment = await Appointment.create({ 
      user, 
      dietitian, 
      date: appointmentDate.toDate(), 
      time,
      status: 'approved' // Onay kısmını kaldırıyoruz, direkt onaylı olacak
    });
    
    console.log(`✅ Randevu oluşturuldu - ID: ${appointment._id}`);
    
    res.status(201).json({ 
      success: true,
      message: 'Randevu başarıyla oluşturuldu.',
      appointment 
    });
  } catch (err) {
    console.log('❌ Randevu oluşturma hatası:', err.message);
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