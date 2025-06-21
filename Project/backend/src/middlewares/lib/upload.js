const multer  = require('multer')
const path = require('path')
const fs = require('fs')


const fileFilter = (req, file, cb) => {
    const allowedTypes = ['image/jpeg', 'image/png', 'image/jpg', 'image/gif'];
    if (!allowedTypes.includes(file.mimetype)) {
        return cb(new Error('Bu dosya türüne izin verilmiyor'), false);
    }
    cb(null, true); 
}

const storage = multer.diskStorage({
    destination: function (req, file, cb)  {
        const rootDir = path.dirname(require.main.filename);
        
        fs.mkdirSync(path.join(rootDir, '/public/uploads'), { recursive: true });
        cb(null,path.join(rootDir, '/public/uploads'));
    },
    filename: function (req, file, cb)  {
        const extension = file.mimetype.split('/')[1];
        if(!req.savedImages) req.savedImages = [];
        
        const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
        
        let url=`image_${uniqueSuffix}.${extension}`;

        req.savedImages=[...req.savedImages, url];
        
        cb(null, url);
    }
});

// Çoklu dosya yükleme için
const upload = multer({storage, fileFilter}).array('images');

// Tek dosya yükleme için (profil resmi)
const uploadSingle = multer({storage, fileFilter}).single('profileImage');

module.exports = { upload, uploadSingle }; 