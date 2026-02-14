# Olater - Flutter & Node.js Application

Olater is a full-stack mobile application built with Flutter for the frontend and Node.js for the backend. It features Firebase authentication (including Google Sign-In) and MongoDB for data storage.

## 🚀 Tech Stack

### Frontend
- **Framework:** [Flutter](https://flutter.dev/)
- **State Management:** [Provider](https://pub.dev/packages/provider)
- **Maps:** [flutter_map](https://pub.dev/packages/flutter_map)
- **Location:** [geolocator](https://pub.dev/packages/geolocator)
- **Auth:** [firebase_auth](https://pub.dev/packages/firebase_auth) & [google_sign_in](https://pub.dev/packages/google_sign_in)

### Backend
- **Runtime:** [Node.js](https://nodejs.org/)
- **Framework:** [Express.js](https://expressjs.com/)
- **Database:** [MongoDB](https://www.mongodb.com/) (via Mongoose)
- **Admin SDK:** [Firebase Admin SDK](https://firebase.google.com/docs/admin/setup)

---

## 📂 Project Structure

```text
olater/
├── android/                # Android native project
├── ios/                    # iOS native project
├── lib/                    # Flutter source code
│   ├── core/               # App-wide constants, themes, utils
│   ├── features/           # Feature-based modules (auth, home, etc.)
│   └── main.dart           # App entry point
├── backend/                # Node.js backend
│   ├── controllers/        # Business logic
│   ├── models/             # Mongoose schemas
│   ├── routes/             # API endpoints
│   ├── server.js           # Server entry point
│   └── .env                # Environment variables (local only)
├── firebase.json           # Firebase configuration
└── pubspec.yaml            # Flutter dependencies
```

---

## 🛠️ Prerequisites

- **Flutter SDK:** ^3.10.3
- **Node.js:** Latest LTS version
- **MongoDB:** A running local instance or MongoDB Atlas cluster
- **Firebase Project:** Created in the [Firebase Console](https://console.firebase.google.com/)

---

## ⚙️ Setup Instructions

### 1. Backend Setup
1. Navigate to the backend folder:
   ```bash
   cd backend
   ```
2. Install dependencies:
   ```bash
   npm install
   ```
3. Create a `.env` file in the `backend/` directory (use `.env.example` as a template):
   ```env
   PORT=3000
   MONGO_URI=mongodb://localhost:27017/olater
   ```
4. **Firebase Admin Setup:**
   - Download your `serviceAccountKey.json` from the Firebase Console (Project Settings > Service Accounts).
   - Place it in the `backend/` folder.

### 2. Frontend Setup
1. From the root directory, install Flutter dependencies:
   ```bash
   flutter pub get
   ```
2. **Firebase Configuration:**
   - Run `flutterfire configure` (if you have FlutterFire CLI) or manually download:
     - `google-services.json` for Android (`android/app/`)
     - `GoogleService-Info.plist` for iOS (`ios/Runner/`)
   - Generate `lib/firebase_options.dart`. Use `lib/firebase_options.dart.example` as a template if needed.
3. **Backend API URL:**
   - Update the `baseUrl` in `lib/features/auth/presentation/provider/auth_provider.dart` to point to your machine's IP address (needed for physical device testing).

---

## 🏃 Running the Project

### Start the Backend
```bash
cd backend
node server.js
```

### Start the Flutter App
```bash
flutter run
```

---

## 🔒 Security Note
Sensitive files are ignored in Git to prevent leaks:
- `backend/.env`
- `backend/serviceAccountKey.json`
- `lib/firebase_options.dart`
- `**/google-services.json`
- `**/GoogleService-Info.plist`

Always use the provided `.example` files as templates when setting up the project on a new machine.
