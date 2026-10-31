# E-SHOP — Flutter E-Commerce App
🔗 **[Live Demo](https://basmla-ali.github.io/E-Shop/)**

A mobile shopping app built with Flutter. Users can sign up, browse products fetched from a REST API, save favorites, and manage a shopping cart with a live order summary.

## Features

- **Authentication:** email/password sign-up, login, and logout with Firebase Authentication. The app checks the current session on launch and goes straight to the home screen if the user is already signed in.
- **Products:** product list loaded from [Fake Store API](https://fakestoreapi.com/products) with Dio and shown in a grid.
- **State management:** `Cubit` (`flutter_bloc`) with sealed states (initial, loading, success, error) and `BlocBuilder` to update the UI.
- **Favorites and cart:** stored locally with Hive so they persist between app launches.
- **Cart summary:** item quantities, subtotal, shipping, tax, and total.
- **Profile screen** and bottom navigation between Home, Favorites, Cart, and Profile.

## Tech Stack

| Area | Tools |
|------|-------|
| Framework | Flutter, Dart |
| State management | flutter_bloc (Cubit) |
| Networking | Dio |
| Authentication | Firebase Auth |
| Local storage | Hive |

## Project Structure

```
lib/
├── cuibt/      # ProductCubit and ProductState
├── model/      # Product model
├── service/    # API calls (Dio)
├── padges/     # Screens: splash, login, sign up, home, favorites, cart, profile
├── view/       # Main app shell with bottom navigation
├── widgets/    # Reusable widgets (product card)
├── firebase_options.dart
└── main.dart
```

## Getting Started

1. Install [Flutter](https://docs.flutter.dev/get-started/install).
2. Clone the repository:
   ```bash
   git clone https://github.com/<your-username>/E-Shop.git
   cd E-Shop
   ```
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Run the app:
   ```bash
   flutter run
   ```

> Firebase is already configured through `firebase_options.dart`. To use your own Firebase project, run `flutterfire configure`.

## Author

**Basmala Ali** — Computer Science student and aspiring Flutter developer.
