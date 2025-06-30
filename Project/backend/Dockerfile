# Node.js 18 base image kullan
FROM node:18-alpine

# Çalışma dizinini ayarla
WORKDIR /app

# Package dosyalarını kopyala
COPY package*.json ./

# Dependencies'leri yükle
RUN npm ci --only=production

# Uygulama kodunu kopyala
COPY . .

# Port'u expose et
EXPOSE 5002

# Uygulamayı başlat
CMD ["npm", "start"] 