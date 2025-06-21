const router = require('express').Router();
const appointmentController = require('../controllers/appointment.controller');
const { tokenCheck } = require('../middlewares/auth');

// Uygun saatleri getir
router.get('/available', tokenCheck, appointmentController.getAvailableSlots);
// Randevu oluştur
router.post('/', tokenCheck, appointmentController.createAppointment);
// Kullanıcının randevularını getir
router.get('/my', tokenCheck, appointmentController.getUserAppointments);
// Randevu iptal et
router.delete('/:id', tokenCheck, appointmentController.cancelAppointment);

module.exports = router; 