# EatWell 🍎
> Dijital Diyetisyen ve Beslenme Planlama Platformu

[![Backend CI/CD](https://github.com/tugbazengin/EatWell-/actions/workflows/backend-ci.yml/badge.svg)](https://github.com/tugbazengin/EatWell-/actions/workflows/backend-ci.yml)
[![iOS CI/CD](https://github.com/tugbazengin/EatWell-/actions/workflows/ios-ci.yml/badge.svg)](https://github.com/tugbazengin/EatWell-/actions/workflows/ios-ci.yml)
[![Main Pipeline](https://github.com/tugbazengin/EatWell-/actions/workflows/main.yml/badge.svg)](https://github.com/tugbazengin/EatWell-/actions/workflows/main.yml)
Proje Özeti:
NutriGuide, kişiye özel beslenme planları sunan, sağlıklı yaşamı destekleyen ve besin analizleri yapan bir platformdur. Kullanıcılar beslenme alışkanlıklarını takip edebilir, diyetisyenlerden öneriler alabilir ve sağlıklı tarifler keşfedebilir. Ayrıca, bireysel hedeflerine uygun besin takibi yaparak sağlıklı yaşam yolculuklarını yönetebilirler.


🔹 Platformun Temel Özellikleri
* Kişisel Beslenme Analizi ve Takip Sistemi
Kullanıcılar kişisel sağlık bilgilerini (yaş, kilo, boy, hastalık geçmişi vb.) sisteme ekleyebilir.
Günlük kalori ve makro besin alımı hesaplanarak grafiklerle sunulur.
Besin tüketim günlükleri oluşturularak diyet süreci takip edilir.
Kullanıcılar belirlenen hedeflere göre anlık bildirimlerle bilgilendirilir.
Kullanıcılar diyetisyenlerden online danışmanlık alabilir.
Randevu takvimi oluşturulabilir ve görüşmeler takip edilebilir.



Proje Kategorisi: Sağlık & Beslenme

Grup Adı: SoloDev

Proje Ekibi: Tuğba Zengin

1.[**Gereksinim Analizi**](https://github.com/tugbazengin/EatWell-/blob/main/GereksinimAnalizi)

2.[**Durum Diyagramı**](https://github.com/tugbazengin/EatWell-/blob/main/durum-diyagramı/Durum%20diyagramı.pdf)

3.[**Durum Senaryoları**](https://github.com/tugbazengin/EatWell-/blob/main/Durum%20Senaryoları/senaryolar.pdf)

## 🏗️ Teknoloji Stack

### Backend
- **Node.js & Express.js** - REST API
- **MongoDB Atlas** - Veritabanı
- **Docker** - Konteynerizasyon
- **JWT** - Kimlik doğrulama
- **Nodemailer** - E-posta servisleri

### Frontend (iOS)
- **Swift & SwiftUI** - Native iOS App
- **Xcode** - Development Environment

### DevOps & CI/CD
- **GitHub Actions** - CI/CD Pipeline
- **Docker Hub/GHCR** - Container Registry
- **ESLint & SwiftLint** - Code Quality

## 🚀 Hızlı Başlangıç

### Gereksinimler
- Node.js 18+
- Docker & Docker Compose
- Xcode 15+ (iOS development için)
- MongoDB Atlas hesabı

### Backend Kurulumu
```bash
# Repository'yi klonlayın
git clone https://github.com/tugbazengin/EatWell-.git
cd EatWell-/Project

# Environment dosyasını oluşturun
cp .env.example .env.production
# .env.production dosyasını MongoDB URI ile güncelleyin

# Docker ile başlatın
docker-compose up -d

# Backend API: http://localhost:5002
```

### iOS Kurulumu
```bash
# Xcode'da projeyi açın
open Project/EatWell.xcodeproj

# Simulatör veya fiziksel cihazda çalıştırın
```

## 🔄 CI/CD Pipeline

### Automated Workflows
- **Backend CI/CD**: Node.js test, Docker build, deployment
- **iOS CI/CD**: Xcode build, SwiftLint, archiving
- **Integration Tests**: API health checks, end-to-end testing

### Pipeline Triggers
- `main` branch push → Full deployment pipeline
- `develop` branch push → Development builds
- Pull requests → Validation tests

### Build Status
Pipeline durumunu yukarıdaki badges'lardan takip edebilirsiniz.

## 📦 Docker Deployment

```bash
# Production build
docker-compose -f docker-compose.yml up -d

# Development build
docker-compose -f docker-compose.dev.yml up -d

# Container logları
docker logs eatwell-backend -f
```

## 🔐 Environment Variables

Backend için gerekli environment değişkenleri:

```bash
NODE_ENV=production
PORT=5002
MONGODB_URI=mongodb+srv://...
JWT_SECRET_KEY=your-secret-key
EMAIL_USER=your-email@gmail.com
EMAIL_PASS=your-gmail-app-password
```

## 🤝 Katkıda Bulunma

1. Fork yapın
2. Feature branch oluşturun (`git checkout -b feature/amazing-feature`)
3. Değişikliklerinizi commit edin (`git commit -m 'Add amazing feature'`)
4. Branch'inizi push edin (`git push origin feature/amazing-feature`)
5. Pull Request oluşturun

## 📄 License

Bu proje MIT lisansı altında lisanslanmıştır.

---

**Geliştirici**: Tuğba Zengin | **Proje Kategorisi**: Sağlık & Beslenme | **Grup**: SoloDev