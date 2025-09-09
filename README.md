# admin_vitaring

# 🎛️ VitaRing Admin Panel

## 📖 Overview
VitaRing Admin Panel adalah aplikasi web admin yang komprehensif untuk mengelola platform VitaRing. Dibangun dengan Flutter Web dan Firebase, aplikasi ini menyediakan interface yang modern dan responsif untuk mengelola pengguna, berita, forum, dan data kesehatan.

## ✨ Features

### 🔐 Authentication
- **Admin Login**: Sistem login yang aman dengan Firebase Authentication
- **Demo Credentials**: 
  - Email: `admin@vitaring.com`
  - Password: `password`

### 📊 Dashboard
- **Real-time Statistics**: Data pengguna, berita, dan forum yang update secara real-time
- **Interactive Cards**: Navigasi mudah ke setiap modul manajemen
- **Responsive Design**: Optimal untuk desktop dan mobile

### 👥 User Management
- **CRUD Operations**: Create, Read, Update, Delete pengguna
- **Role Management**: Admin, Moderator, User roles
- **Status Control**: Aktivasi/deaktivasi akun pengguna
- **Real-time Data**: Stream data langsung dari Firestore

### 📰 News & Articles Management
- **Article Management**: Kelola berita dan artikel dengan lengkap
- **Like System**: Sistem like interaktif dengan statistik
- **Publication Control**: Publish/unpublish artikel
- **Detail View**: Halaman detail dengan analytics lengkap
- **Category Management**: Teknologi, Kesehatan, Olahraga, dll.

### 💬 Forum Management
- **Discussion Posts**: Kelola post diskusi forum
- **Category System**: Organisasi post berdasarkan kategori
- **Moderation Tools**: Tools moderasi untuk admin

### 🏥 Health Monitoring
- **Real-time Health Data**: Monitor data kesehatan pengguna
- **Health Statistics**: Dashboard kesehatan dengan visualisasi
- **User Health Profiles**: Profil kesehatan per pengguna
- **Alert System**: Sistem peringatan untuk kondisi kesehatan

## 🛠️ Tech Stack

### Frontend
- **Flutter Web**: Framework utama untuk UI
- **Material Design**: Design system dengan neuromorphic theme
- **Responsive Layout**: MediaQuery untuk adaptasi layar

### Backend & Database
- **Firebase Firestore**: NoSQL database untuk data real-time
- **Firebase Authentication**: Sistem autentikasi
- **Firebase Hosting**: Platform hosting web

### State Management
- **StatefulWidget**: Local state management
- **StreamBuilder**: Real-time data binding
- **FutureBuilder**: Async data handling

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)
- Firebase CLI
- Git

### Installation

1. **Clone Repository**
   ```bash
   git clone https://github.com/thohahaha/admin-vitaringg.git
   cd admin-vitaringg
   ```

2. **Install Dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Setup**
   - Create Firebase project
   - Enable Firestore Database
   - Enable Authentication
   - Update `firebase_options.dart` with your config

4. **Run Application**
   ```bash
   flutter run -d chrome
   ```

### Demo Data
Aplikasi menyediakan fitur seeding data untuk testing:
- Klik tombol "Tambah Data Demo" di setiap halaman manajemen
- Data dummy akan otomatis ditambahkan ke Firestore

## 📱 Usage

### Login
1. Buka aplikasi di browser
2. Gunakan credentials demo:
   - Email: `admin@vitaring.com`
   - Password: `password`

### Navigation
- **Dashboard**: Overview statistik dan navigasi cepat
- **Sidebar Menu**: Akses ke semua modul manajemen
- **Responsive Menu**: Hamburger menu untuk mobile

### Features Demo
1. **User Management**: Kelola pengguna dengan operasi CRUD lengkap
2. **News Management**: Buat, edit, dan kelola artikel dengan sistem like
3. **Forum Management**: Moderasi diskusi dan post forum
4. **Health Monitoring**: Monitor data kesehatan real-time

## 🎨 UI/UX Features

### Design System
- **Neuromorphic Theme**: Modern soft UI design
- **Color Scheme**: Orange primary dengan nuansa warm
- **Typography**: Material Design typography scale
- **Spacing**: Consistent spacing system

### Responsive Design
- **Mobile First**: Optimized untuk penggunaan mobile
- **Breakpoints**: Adaptive layout untuk berbagai ukuran layar
- **Touch Friendly**: Interaction yang mudah di touchscreen

### Animations
- **Smooth Transitions**: Animasi transisi yang halus
- **Loading States**: Indicator loading yang informatif
- **Interactive Feedback**: Visual feedback untuk user actions

## 🗃️ Database Structure

### Collections
```
users/
├── id (string)
├── name (string)
├── email (string)
├── role (string)
├── isActive (boolean)
└── createdAt (timestamp)

news/
├── id (string)
├── title (string)
├── content (string)
├── excerpt (string)
├── category (string)
├── authorName (string)
├── isPublished (boolean)
└── createdAt (timestamp)

forum_posts/
├── id (string)
├── title (string)
├── content (string)
├── category (string)
├── authorName (string)
└── createdAt (timestamp)
```

## 🔐 Security

### Firestore Rules
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Allow read/write access for development
    match /{document=**} {
      allow read, write: if true;
    }
  }
}
```

### Authentication
- Firebase Authentication integration
- Role-based access control
- Secure admin panel access

## 🧪 Testing

### Manual Testing
- User CRUD operations
- Real-time data updates
- Responsive design testing
- Cross-browser compatibility

### Test Coverage
- Widget tests untuk UI components
- Integration tests untuk user flows
- Firebase emulator untuk database testing

## 📊 Performance

### Optimization
- **Lazy Loading**: Components dimuat sesuai kebutuhan
- **Efficient Queries**: Optimized Firestore queries
- **Caching**: Local caching untuk data yang sering diakses
- **Bundle Splitting**: Code splitting untuk web performance

### Monitoring
- Firebase Performance Monitoring
- Real-time error tracking
- User analytics dan usage patterns

## 🤝 Contributing

### Development Workflow
1. Fork repository
2. Create feature branch
3. Make changes
4. Test thoroughly
5. Submit pull request

### Code Standards
- Follow Dart/Flutter conventions
- Use meaningful variable names
- Add comments untuk complex logic
- Maintain consistent formatting

## 📄 License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📞 Support
- **Issues**: Report bugs di GitHub Issues
- **Feature Requests**: Submit via GitHub Issues
- **Documentation**: Check Wiki untuk dokumentasi lengkap

## 🚧 Roadmap

### Upcoming Features
- [ ] Advanced analytics dashboard
- [ ] Bulk operations untuk user management
- [ ] Rich text editor untuk news
- [ ] Real-time notifications
- [ ] Export/Import functionality
- [ ] Multi-language support
- [ ] Dark mode theme
- [ ] Advanced filtering dan searching

### Performance Improvements
- [ ] Pagination untuk large datasets
- [ ] Image optimization dan lazy loading
- [ ] Progressive Web App (PWA) features
- [ ] Offline functionality

---

## 🎯 Demo
**Live Demo**: [VitaRing Admin Panel](https://admin-vitaringg.web.app)

**Login Credentials**:
- Email: `admin@vitaring.com`
- Password: `password`

---

*Built with ❤️ using Flutter & Firebase*

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
