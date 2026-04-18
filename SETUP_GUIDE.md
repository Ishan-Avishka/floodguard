# 🚀 FloodGuard Lanka - Complete Setup Guide

## Welcome! Follow this step-by-step guide to get your app ready for the App Store TODAY.

---

## 📝 **Table of Contents**
1. [Prerequisites](#prerequisites)
2. [Firebase Setup](#firebase-setup)
3. [Google Maps Configuration](#google-maps-api)
4. [Dependencies Installation](#dependencies)
5. [App Configuration](#app-configuration)
6. [Testing on iOS/Android](#testing)
7. [Deployment to App Store](#app-store)

---

## ✅ **Prerequisites**

Make sure you have:
- ✅ Xcode (for iOS) - Install from App Store
- ✅ Flutter SDK - `flutter --version` should show a version
- ✅ Git
- ✅ A Google account (for Firebase & Google Maps)
- ✅ An Apple Developer Account (to publish to App Store)

**Check Flutter Installation:**
```bash
flutter doctor
```
Should show:
```
✓ Flutter
✓ Android toolchain
✓ Xcode (for iOS)
✓ CocoaPods
```

If anything shows ✗, run:
```bash
flutter pub get
flutter pub upgrade
```

---

## 🔥 **Firebase Setup** (CRITICAL!)

### Step 1: Create Firebase Project

1. Go to [https://console.firebase.google.com](https://console.firebase.google.com)
2. Click **"Create a project"**
3. Enter project name: `floodguard-Lanka` (or any name)
4. Click **Continue**
5. Enable Google Analytics (optional), click **Create project**

### Step 2: Register Android App

1. From Firebase console, click **Add app** → **Android**
2. Fill in:
   - Package name: `com.floodguard.app`
   - App nickname: `FloodGuard Android`
3. Click **Register app**
4. Download `google-services.json`
5. Place it at: `android/app/google-services.json`

### Step 3: Register iOS App

1. Click **Add app** → **iOS**
2. Fill in:
   - iOS bundle ID: `com.floodguard.app`
   - App nickname: `FloodGuard iOS`
3. Click **Register app**
4. Download `GoogleService-Info.plist`
5. Place it at: `ios/Runner/GoogleService-Info.plist`
6. Follow the instructions to add it to Xcode (they give you steps)

### Step 4: Enable Authentication

1. In Firebase, go to **Authentication** → **Get Started**
2. Click **Email/Password** → Enable it
3. Click **Save**

###  Step 5: Create Firestore Database

1. Go to **Firestore Database** → **Create Database**
2. Start in **Test mode** (for development)
3. Choose **asia-southeast1** (Singapore - closest to Sri Lanka)
4. Click **Create**

### Step 6: Setup Storage for Image Uploads

1. Go to **Storage** → **Get Started**
2. Click **Next** on the rule dialog
3. It creates a default bucket - perfect!

### Step 7: Setup Cloud Messaging (for Notifications)

1. Go to **Cloud Messaging**
2. Note down your **Server API Key** (you'll need this later)
3. Go to **Project Settings** (gear icon top right)
4. Go to **Cloud Messaging** tab
5. Copy the `Sender ID` and `Server API Key`

---

## 🗺️ **Google Maps API Setup** (IMPORTANT!)

### Step 1: Create Google Cloud Project

1. Go to [https://console.cloud.google.com](https://console.cloud.google.com)
2. Create new project: `FloodGuard Maps`
3. Wait for it to be created

### Step 2: Enable Maps API

1. Go to **APIs & Services** → **Library**
2. Search for `Maps SDK for Android`
3. Click it → **ENABLE**
4. Search for `Maps SDK for iOS`
5. Click it → **ENABLE**

### Step 3: Create API Key

1. Go to **APIs & Services** → **Credentials**
2. Click **Create Credentials** → **API Key**
3. Copy the key - this is your **GOOGLE_MAPS_API_KEY**

### Step 4: Add API Key to your App

**For Android:**
1. Open `android/app/src/main/AndroidManifest.xml`
2. Find this line:
   ```xml
   <meta-data
     android:name="com.google.android.geo.API_KEY"
     android:value="YOUR_GOOGLE_MAPS_API_KEY"/>
   ```
3. Replace `YOUR_GOOGLE_MAPS_API_KEY` with your actual key

**For iOS:**
1. Open Xcode: `open ios/Runner.xcworkspace`
2. In Xcode, select **Runner** → **Build Phases**
3. Under **Link Binary With Libraries**, add `CoreLocation.framework`
4. Go to **Info.plist**, add these keys:
   ```
   NSLocationWhenInUseUsageDescription: "We need your location for flood alerts"
   NSLocationAlwaysAndWhenInUseUsageDescription: "We need your location for flood alerts"
   ```

---

## 📦 **Dependencies Installation**

### Step 1: Get Flutter Packages

```bash
cd /Users/ishanavishka/Documents/myWork/floodguard
flutter pub get
```

Wait for it to complete. You'll see lots of packages installing.

### Step 2: Update Firebase Options

Edit `lib/firebase_options.dart` and replace with your Firebase credentials:

1. For **Android**, go to Firebase Console:
   - Project Settings → Your Android app
   - Copy the credentials and replace in `firebase_options.dart`

2. For **iOS**, go to Firebase Console:
   - Project Settings → Your iOS app
   - Copy the credentials

---

## 🔧 **App Configuration**

### Step 1: Update App Name & Bundle ID

**For Android:**
1. Open `android/app/build.gradle.kts`
2. Find `applicationId` and make sure it's `com.floodguard.app`

**For iOS:**
1. Open `ios/Runner.xcworkspace` in Xcode
2. Select Runner → Runner (under TARGETS)
3. Go to **General** tab
4. Change **Bundle Identifier** to `com.floodguard.app`

### Step 2: Setup Location Permissions

**For Android:**
Already added to manifest. ✅

**For iOS:**
1. Open Xcode: `open ios/Runner.xcworkspace`
2. Go to Info.plist
3. Add these keys:
   ```
   NSLocationWhenInUseUsageDescription: "FloodGuard needs your location to show flood alerts near you"
   NSLocationAlwaysAndWhenInUseUsageDescription: "FloodGuard needs your location at all times to send you alerts"
   ```

### Step 3: Camera Permission

**For iOS:**
In `ios/Runner/Info.plist`, add:
```xml
<key>NSCameraUsageDescription</key>
<string>FloodGuard needs camera access to take photos of flood problems</string>

<key>NSPhotoLibraryUsageDescription</key>
<string>FloodGuard needs access to your photos to report flood issues</string>
```

---

## 🧪 **Testing on iOS/Android**

### Test on iPhone/iPad Simulator

```bash
# Open simulator
open -a Simulator

# Run the app
flutter run -d simulator
```

### Test on Physical iPhone

1. Connect your iPhone with USB cable
2. Trust the device (tap Trust on your phone)
3. Run:
   ```bash
   flutter run -d <device_id>
   ```
4. Get device ID: `flutter devices`

### Test on Android Device

1. Enable Developer Mode: Settings → About Phone → tap Build Number 7 times
2. Enable USB Debugging: Settings → Developer Options → USB Debugging
3. Connect with USB cable
4. Run:
   ```bash
   flutter run
   ```

---

## 📱 **Deployment to App Store (iOS)**

### Prerequisites
- Apple Developer Account ($99/year)
- Xcode and Certificate

### Step 1: Create App ID in Apple Developer

1. Go to [https://developer.apple.com/account](https://developer.apple.com/account)
2. Sign in with your Apple ID
3. Go to **Certificates, IDs & Profiles** → **Identifiers**
4. Click **+**
5. Select **App IDs**
6. Choose **App**
7. Bundle ID: `com.floodguard.app` (must match!)
8. Description: `FloodGuard Lanka`
9. Click **Register**

### Step 2: Create Signing Certificate

1. In **Certificates**, click **+**
2. Choose **iOS App Development**
3. Request a certificate (follow the guide)
4. Download it and open it (installs to Keychain)

### Step 3: Create Provisioning Profile

1. Go to **Profiles** → **+**
2. Select **iOS App Development**
3. Select the App ID you created
4. Select your certificate
5. Select your device
6. Give it a name: `FloodGuard Development`
7. Download and open it

### Step 4: Build for App Store

```bash
# First, get a clean build
flutter clean
flutter pub get

# Build the iOS app
flutter build ios --release

# Or use Xcode
open ios/Runner.xcworkspace
```

Then in Xcode:
1. Select **Product** → **Archive**
2. Wait for it to complete
3. Click **Distribute App**
4. Select **App Store Connect**
5. Follow the steps to upload

### Step 5: Submit to App Store Connect

1. Go to [https://appstoreconnect.apple.com](https://appstoreconnect.apple.com)
2. Create new app
3. Select your app type: **iOS App**
4. Fill in:
   - Bundle ID: `com.floodguard.app`
   - SKU: `floodguard-1` (any unique ID)
   - Name: `FloodGuard Lanka`
5. Fill in app details, screenshots, description
6. Set pricing (free for now)
7. Submit for review!

---

## 🤖 **Deployment to Google Play (Android)**

### Prerequisites
- Google Play Developer Account ($25 one-time)

### Step 1: Create Keystore

```bash
keytool -genkey -v -keystore ~/.android/key.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias floodguard
```

Keep this file SAFE! You'll need it for updates.

### Step 2: Configure Signing

Create `android/key.properties`:
```properties
storePassword=<your_password>
keyPassword=<your_password>
keyAlias=floodguard
storeFile=~/.android/key.jks
```

(Replace with your actual passwords)

### Step 3: Build Release APK

```bash
flutter build apk --release
```

APK will be at: `build/app/release/app-release.apk`

### Step 4: Upload to Google Play

1. Go to [https://play.google.com/console](https://play.google.com/console)
2. Create new app
3. Fill in app details
4. Go to **Release** → **Production**
5. Click **Create new release**
6. Upload your APK
7. Add screenshots and description
8. Submit for review!

---

## ✅ **Checklist Before Publishing**

- [ ] All screens created and tested
- [ ] Firebase credentials added
- [ ] Google Maps API key added
- [ ] Location permissions configured
- [ ] Camera permissions configured
- [ ] App icons created (512x512px minimum)
- [ ] Screenshots for App Store (5+ required)
- [ ] Privacy policy written
- [ ] Terms & Conditions written
- [ ] Tested on real device
- [ ] No errors in logs
- [ ] All features working
- [ ] Ratings and reviews enabled
- [ ] Push notifications tested

---

## 🆘 **Common Issues & Solutions**

### "Cannot resolve com.google.android.maps"
→ Run: `flutter clean && flutter pub get`

### "Firebase initialization failed"
→ Check `firebase_options.dart` has correct credentials

### "Location permission denied"
→ Manual permission prompt didn't work
→ Solution: Restart app after first permission request

### "Google Maps not showing"
→ API key not added correctly
→ Check AndroidManifest.xml and iOS Info.plist

### "Build failed on iOS"
→ Run: `pod deintegrate && pod install` in ios/ folder

---

## 📞 **Need Help?**

1. Check Flutter docs: https://flutter.dev/docs
2. Firebase docs: https://firebase.flutter.dev
3. Google Maps docs: https://pub.dev/packages/google_maps_flutter

**Good luck! 🚀 You've got this!**

