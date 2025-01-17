# Galerio

Galerio is a photo gallery app built using Flutter.

## Overview

- Fetch and display photos from the gallery without using third-party plugins.
- Follows the **BLoC** (Business Logic Component) pattern for state management.
- Implements **MVVM** (Model-View-ViewModel) architecture for clean separation of concerns.
- Dependency injection using **Get_it** and **Injectable**.
- Production-level **GitFlow** for feature development and version control.

## Getting Started

### Prerequisites

Make sure to have the following installed:

- Flutter SDK: [Flutter Installation Guide](https://flutter.dev/docs/get-started/install)
- Dart SDK: [Dart Installation Guide](https://dart.dev/get-dart)

### Running the Project

1. Clone the repository:
   ```bash
   git clone https://github.com/mohd-asfaq-e-azam-rifat/galerio.git
   ```
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Generate code for injectable:
   ```bash
   flutter dart run build_runner build -d
   ```
4. Run the app:
   ```bash
   flutter run
   ```

## Workflow

Galerio follows the **GitFlow** branching model:

- **main**: Contains production-ready code.
- **development**: All feature branches are merged here before merging into `main`.
- **feature/xyz**: Used for developing individual features before merging into `development`.

## Contributing

Contributions are welcome! Feel free to submit a pull request or open an issue if you have
suggestions for improvement.

---

Made with ❤️ using Flutter