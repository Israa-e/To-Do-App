# UpTodo - Flutter Task & To-Do App

UpTodo is a modernized task management application built with Flutter. It is designed to work seamlessly both offline and online, providing a robust solution for daily productivity.

## 🌟 Features

- **Offline-First Management**: Create, edit, and delete tasks even without an internet connection.
- **Real-Time Sync**: Automatically synchronizes your local data with Firebase Cloud Firestore when you're online.
- **Authentication**: Secure Login and Registration using Firebase Authentication.
- **Profile Management**: Customize your profile with a name and a profile picture (synced to Firebase Storage).
- **Categories**: Organize your tasks into custom categories (Home, Work, etc.).
- **Search & Filter**: Real-time task search and filtering by completion status or category.
- **Persistence**: Hybrid storage using SQLite (Local) and Firestore (Cloud).

## 🛠️ Technology Stack

- **Framework**: [Flutter](https://flutter.dev/)
- **Programming Language**: [Dart](https://dart.dev/)
- **Local Database**: [sqflite (SQLite)](https://pub.dev/packages/sqflite)
- **Backend/Auth**: [Firebase Authentication](https://firebase.google.com/docs/auth)
- **Cloud Database**: [Cloud Firestore](https://firebase.google.com/docs/firestore)
- **Cloud Storage**: [Firebase Storage](https://firebase.google.com/docs/storage)
- **Connectivity**: [connectivity_plus](https://pub.dev/packages/connectivity_plus)

## 📁 Project Structure

```text
lib/
├── core/           # Database helpers, Theme, Sync Logic
├── model/          # Data Models (Task, User, Category)
├── view/           # UI Screens (Auth, Home, Intro)
│   ├── auth/       # Login & Signup
│   ├── home/       # Home, Profile, Add Task, etc.
│   └── intro/      # Splash, Onboarding, Start
└── widget/         # Reusable Custom Widgets
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK installed.
- Firebase project configured (Android/iOS).

### Installation
1. Clone the repository:
   ```bash
   git clone <repository-url>
   ```
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run the application:
   ```bash
   flutter run
   ```

## 📜 Evaluation Compliance

This project was developed for the **Flutter Final Project** evaluation and meets the following mandatory criteria:
- [x] Firebase Authentication (Login/Register)
- [x] SQLite local database
- [x] Firebase cloud database
- [x] Minimum 5 screens (11 screens total)
- [x] English language only

