# E-Commerce Application using Flutter and Django

## Overview

This repository contains the source code for a robust E-Commerce application built using Flutter for the front-end and Django for the backend. The application provides a comprehensive set of features, allowing users to seamlessly navigate through a diverse product catalog, manage their shopping carts, create wishlists, track orders, and make secure online payments using popular platforms such as e-sewa and Khalti. Additionally, the application supports a multi-vendor system with a dedicated dashboard for vendors to manage their products and track orders.

## Features

### User Authentication

- Users can create accounts, log in, and securely manage their profiles, providing a personalized shopping experience.

### Product Catalog

- The application offers a wide range of products with detailed information, enabling users to explore and find the items they desire.

### Shopping Cart

- Users can easily add items to the cart, adjust quantities, and proceed to checkout for a streamlined shopping experience.

### Wishlist

- The wishlist feature allows users to save their favorite items for later and seamlessly move them to the shopping cart.

### Order Tracking

- Real-time order tracking provides users with updates on the status of their orders, ensuring transparency throughout the purchasing process.

### Payment Options

- Secure online payments are supported through popular platforms such as e-sewa and Khalti. Additionally, users can choose the cash-on-delivery option at the time of delivery.

### Multi-Vendor Support

- Vendors can register and manage their products through a dedicated dashboard. The dashboard also provides tools to track orders efficiently.

## Tech Stack

### Frontend

- Flutter: A cross-platform framework for building mobile applications.
- Dart: The programming language used with Flutter.

### Backend

- Django: A high-level Python web framework.
- Django Rest Framework: A powerful and flexible toolkit for building Web APIs in Django.

### Database

- SQLite (for development)
- PostgreSQL (for production)

## Getting Started

1. **Clone the Repository**:

   ```bash
   git clone https://github.com/debaraj-stha/ecommerce-flutter-django.git
   cd ecommerce-flutter-app
   ```

2. **Setup Backend**:

   - Navigate to the `backend` directory.
   - Install dependencies: `pip install -r requirements.txt`.
   - Run migrations: `python manage.py migrate`.
   - Start the Django development server: `python manage.py runserver`.

3. **Setup Frontend**:

   - Navigate to the `frontend` directory.
   - Install dependencies: `flutter pub get`.
   - Run the app: `flutter run`.

4. **Configure Backend Settings**:

   - Update database settings in `backend/settings.py`.
   - Configure payment gateway settings.

5. **Run the App**:

   - Open the Flutter project in your preferred IDE (e.g., VSCode, Android Studio).
   - Run the app on an emulator or physical device.

## Contributing

If you'd like to contribute to the project, please follow the [contribution guidelines](CONTRIBUTING.md).

## License

This project is licensed under the [MIT License](LICENSE).

## Acknowledgments

Special thanks to the Flutter and Django communities for their fantastic frameworks and ongoing support.

Feel free to reach out with any questions or feedback. Happy coding!
