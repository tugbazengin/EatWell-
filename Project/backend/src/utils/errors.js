class APIError extends Error {
  constructor(message, statusCode) { // APIError sınıfı oluşturuluyor
    super(message); // Error sınıfının constructor'ını çağırıyor
    this.statusCode = statusCode || 400; // Hata kodu atanıyor, eğer yoksa 400 atanıyor
  }
}

module.exports = APIError;