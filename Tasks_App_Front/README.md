# Tasks App - Flutter Mobile Application

## Overview

The frontend of Tasks App is a Flutter mobile application built to provide a simple and organized interface for managing daily tasks.

The application communicates with a Laravel REST API to handle authentication, retrieve user data, manage tasks, and display dashboard information.

This project was also a practical experience in connecting a Flutter application to a real backend API.

## Main Features

- User Registration
- User Login
- User Logout
- User Profile
- Dashboard
- View Tasks
- Create and Manage Tasks
- Task Status Management
- API Integration
- Authentication Token Management
- Local Token Storage
- State Management
- Loading and Error Handling

## Application Flow

The application follows a simple flow:

```text
Login / Register
       |
       v
Authentication
       |
       v
Dashboard
       |
       +----> My Tasks
       |
       +----> Task Details / Management
       |
       +----> Create Task
       |
       +----> Profile
```

## Authentication

The Flutter application connects to the Laravel authentication API.

After a successful login or registration, the authentication token returned by the backend is stored locally using SharedPreferences.

The stored token is then included in authenticated API requests.

```text
User Login
    |
    v
Laravel API
    |
    v
Authentication Token
    |
    v
SharedPreferences
    |
    v
Authenticated Requests
```

## API Integration

The mobile application communicates with the backend through REST API requests.

The API layer is responsible for operations such as:

- Register
- Login
- Logout
- Profile
- Dashboard
- Retrieving tasks
- Sending task data

HTTP requests and JSON responses are used for communication between Flutter and Laravel.

## State Management

The project includes state management to keep application logic separate from the UI.

The application uses:

- Provider
- Riverpod

State management is used for handling data such as:

- Authentication state
- Dashboard data
- Tasks
- Task creation
- Loading states
- API responses
- UI updates

## Local Storage

SharedPreferences is used to persist authentication-related information locally.

This allows the application to retrieve the authentication token and use it when communicating with protected backend endpoints.

## User Interface

The application is organized into multiple screens responsible for different parts of the user experience.

The interface includes authentication screens, dashboard content, task management, and profile-related functionality.

The UI is designed around reusable Flutter widgets to keep the application easier to maintain and extend.

## Models

Models are used to convert JSON data received from the Laravel API into structured Dart objects.

This keeps API data organized and makes it easier to work with inside the application.

Examples include user, task, and dashboard-related data.

## Services

The API service layer handles communication between the Flutter application and Laravel backend.

Instead of placing API requests directly inside UI widgets, networking logic is separated into dedicated services.

This improves code organization and separates responsibilities between:

```text
UI
 |
State Management
 |
Services
 |
REST API
```

## Technologies Used

| Technology | Purpose |
|---|---|
| Flutter | Mobile application framework |
| Dart | Programming language |
| REST API | Backend communication |
| HTTP | API requests |
| Dio | HTTP networking |
| SharedPreferences | Local token storage |
| Provider | State management |
| Riverpod | State management |
| JSON | Data exchange |
| Google Fonts | Typography |
| Flutter SVG | SVG assets |
| Intl | Formatting and localization utilities |

## Project Structure

The Flutter project is organized around separate responsibilities such as:

```text
lib/
├── models/
├── services/
├── providers/
├── screens/
├── widgets/
└── main.dart
```

The exact structure may vary between features, but the application separates UI, data models, API communication, and state management.

## Key Concepts Practiced

This project provided practical experience with:

- Flutter application development
- Connecting Flutter with Laravel
- REST API integration
- Asynchronous programming
- Future and async/await
- JSON serialization
- Authentication flows
- Token-based authentication
- Local storage
- State management
- Reusable widgets
- Separation of concerns
- Error and loading state handling

## Backend

The mobile application is connected to a separate Laravel backend included in the same repository:

`Tasks_App_Back`

## Author

Ahmed Ezzat

GitHub: https://github.com/AhmedEzzat17
