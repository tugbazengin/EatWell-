class Response{
    constructor(data=null, message=null, status){
        this.data = data;
        this.message = message;
        this.status = status;
    } // constructor // sınıfın yapıcı metodu// sınıfın nesnesi oluşturulduğunda çalışır

    success(res){
        return res.status(200).json({
            success: true,
            data: this.data,
            message: this.message ?? "İşlem Başarılı"     //
            
        })
    }
    created(res){
        return res.status(201).json({
            success: true,
            data: this.data,
            message: this.message ?? "Kayıt Başarılı"
        })
    }
    errror500(res){
        return res.status(500).json({
            success: false,
            data: this.data,
            message: this.message ?? "İç Sunucu Hatası"
        })
    }
    error400(res){
        return res.status(400).json({
            success: false,
            data: this.data,
            message: this.message ?? "İşlem Başarısız"
        })
    }
    error401(res){
        return res.status(401).json({
            success: false,
            data: this.data,
            message: this.message ?? "Lütfen Giriş Yapın"
        })
    }
    error404(res){
        return res.status(404).json({
            success: false,
            data: this.data,
            message: this.message ?? "Kayıt Bulunamadı"
        })
    }
    error429(res){
        return res.status(429).json({
            success: false,
            data: this.data,
            message: this.message ?? "Çok Fazla İstek"
        })
    }

}

module.exports = Response;
