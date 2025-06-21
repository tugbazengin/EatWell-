const router = require('express').Router();
const auth=require('./auth.routes');
const multer = require('multer');
const APIError = require('../utils/errors');
const Response = require('../utils/response');
const { upload } = require('../middlewares/lib/upload');
const appointment = require('./appointment.routes');
const meal = require('./meal.routes');


router.use('/auth', auth);
router.use('/appointment', appointment);
router.use('/meals', meal);


router.post("/upload", (req, res, next) => {
   upload(req, res, function(err) {
      
          if (err instanceof multer.MulterError) {
              throw new APIError("Multer Error", 500);
          } else if (err) {
              throw new APIError("Upload Error: " + err.message, 500);
          }
          
          return new Response(req.savedImages, "Başarıyla yüklendi", 200).success(res);
       
        
      
   });
});

module.exports = router;


