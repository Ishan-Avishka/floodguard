# FloodGuard Lanka - Mobile App
## 🌍 Real-time Flood Alert System for Sri Lanka 🏝️

### 📋 About This App

FloodGuard Lanka is a innovative mobile application designed to provide **real-time flood predictions and community reporting** for Sri Lanka. It combines cutting-edge technology with community participation to help people stay safe during floods.

### ✨ Key Features

✅ **Live Flood Map** - See real-time flood risk in your area
- 🔴 High-risk zones
- 🟡 Medium-risk zones
- 🟢 Safe zones

✅ **Instant Alerts** - Get push notifications about flood risks near you
- Fire notifications via Firebase Cloud Messaging
- Smart location-based alerts
- Multiple risk levels

✅ **Community Reports** - Report problems and help others
- 📸 Upload photos of issues
- 📍 GPS location tagging
- 🏷️ Report categories (blocked drains, rising water, etc.)
- 👍 Upvote system

✅ **Safe Route Navigation** - Find safe paths to your destination
- 🛣️ Avoid flooded roads
- ✅ Get recommended safe routes

✅ **User Profile** - Manage your account
- 🏠 Save home location
- 📱 Manage contact info
- 📊 View past reports

---

### 🛠️ Tech Stack

**Frontend:**
- 📱 Flutter (Dart)
- 🎨 Material Design 3

**Backend:**
- 🔥 Firebase (Authentication, Firestore, Storage, Cloud Messaging)
- 🗺️ Google Maps API

**Location Services:**
- 📍 Geolocator
- 🧭 Geocoding

**State Management:**
- 📦 Provider

**Additional:**
- 📷 Image Picker
- 📞 Permission Handler
- 🔔 Local Notifications

---

### 📖 Installation & Setup

See [SETUP_GUIDE.md](SETUP_GUIDE.md) for detailed step-by-step instructions!

**Quick Start:**
```bash
# 1. Clone/navigate to project
cd /Users/ishanavishka/Documents/myWork/floodguard

# 2. Get dependencies
flutter pub get

# 3. Configure Firebase (follow SETUP_GUIDE.md)
# 4. Configure Google Maps (follow SETUP_GUIDE.md)

# 5. Run the app
flutter run
```

---

### 🚀 Running the App

**On iOS Simulator:**
```bash
open -a Simulator
flutter run -d simulator
```

**On Physical iPhone:**
```bash
flutter run -d <device_id>
```

**On Android:**
```bash
flutter run
```

---

### 📱 Screen Flow

1. **Login/Register** → Create account or sign in
2. **Home (Map)** → View flood map with alerts and reports
3. **Report Screen** → Submit flood problems with photo
4. **Profile Screen** → Manage account and preferences

---

### 🔐 Security Features

✅ Firebase Authentication (email/password)
✅ Secure data storage in Firestore
✅ Image upload to Firebase Storage
✅ Permission handling for sensitive features
✅ HTTPS for all API calls

---

### 📊 Database Structure

**Firestore Collections:**
```
/users
  - uid
  - email
  - username
  - phone
  - homeLocation
  - createdAt

/reports
  - id
  - userId
  - reportType
  - description
  - latitude, longitude
  - imageUrl
  - upvotes
  - resolved
  - createdAt

/alerts
  - id
  - title
  - message
  - riskLevel
  - latitude, longitude
  - area
  - createdAt
  - expireAt
```

---

### 🎯 MVP Features (Phase 1)

- ✅ User authentication (Login/Register)
- ✅ Real-time map with location
- ✅ Report submission with photo & location
- ✅ View reports on map
- ✅ Push notifications for alerts
- ✅ User profile management

---

### 🚀 Future Enhancements

- 🤖 AI flood prediction model
- 🌐 Offline mode for critical areas
- 🗣️ Multi-language support (Sinhala + English)
- 🔊 Voice alerts
- 📊 Flood statistics and trends
- 👥 Community badges and achievements

---

### 📄 Project Structure

```
lib/
├── main.dart                 # App entry point
├── firebase_options.dart     # Firebase configuration
├── models/                   # Data models
│   ├── user_model.dart
│   ├── report_model.dart
│   └── alert_model.dart
├── screens/                  # App screens
│   ├── login_screen.dart
│   ├── register_screen.dart
│   ├── home_screen.dart
│   ├── report_screen.dart
│   ├── profile_screen.dart
│   └── main_app.dart
├── services/                 # Backend services
│   ├── auth_service.dart
│   ├── firestore_service.dart
│   ├── location_service.dart
│   └── notification_service.dart
├── providers/                # State management
│   ├── auth_provider.dart
│   ├── location_provider.dart
│   ├── report_provider.dart
│   └── alert_provider.dart
├── widgets/                  # Reusable UI components
│   └── custom_widgets.dart
└── utils/                    # Utilities
    └── constants.dart
```

---

### 🧪 Testing

All screens have been built with proper error handling:
- ✅ Form validation
- ✅ Network error handling
- ✅ Permission handling
- ✅ Loading states
- ✅ Success/Error notifications

---

### 📝 License

This project is developed for educational and humanitarian purposes.

---

### 🤝 Contributing

Contributions are welcome! Please follow these steps:
1. Create a feature branch
2. Make your changes
3. Test thoroughly
4. Submit a PR

---

### 📞 Support

For issues or questions:
1. Check [SETUP_GUIDE.md](SETUP_GUIDE.md)
2. Review the code comments
3. Check Flutter/Firebase documentation

---

### 🙏 Acknowledgments

Built with Flutter, Firebase, and Google Maps to help keep Sri Lanka safe from floods.

**Stay Safe! 📱🚨**

