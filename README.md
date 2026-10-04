# Tasks App

A full-stack task management application built with Flutter and Laravel, following a separated frontend and backend architecture.

## Overview

Tasks App consists of two independent applications working together through a REST API:

- **Flutter Mobile App** — The client-side application responsible for the user interface and user interactions.
- **Laravel REST API** — The backend responsible for authentication, business logic, API endpoints, and database operations.

The project was built as a practical experience in developing and connecting a mobile application with a backend API.

## Architecture

```text
                    Tasks App
                        |
          +-------------+-------------+
          |                           |
          v                           v
   Flutter Mobile App          Laravel REST API
   Tasks_App_Front              Tasks_App_Back
          |                           |
          |       REST API            |
          +-------------------------->|
                                      |
                                      v
                                   Database
```

## Main Features

- User authentication
- Task management
- Dashboard
- User profile
- REST API communication
- Token-based authentication
- Local authentication state
- Mobile and backend separation

## Technologies

### Frontend
- Flutter
- Dart
- Provider
- Riverpod
- HTTP / Dio
- SharedPreferences

### Backend
- Laravel
- PHP
- Laravel Sanctum
- MySQL
- Eloquent ORM
- REST API

## Repositories

The project is divided into two repositories/directories, and each part has its own detailed README.

### Frontend

**Tasks_App_Front**

Flutter mobile application containing the user interface, application state, API integration, and mobile-side functionality.

[View Frontend Repository](./Tasks_App_Front)

[Frontend README](./Tasks_App_Front/README.md)

### Backend

**Tasks_App_Back**

Laravel REST API responsible for authentication, backend logic, API endpoints, and database operations.

[View Backend Repository](./Tasks_App_Back)

[Backend README](./Tasks_App_Back/README.md)

## Project Structure

```text
Tasks_App/
│
├── Tasks_App_Front/
│   └── Flutter Mobile Application
│       └── README.md
│
├── Tasks_App_Back/
│   └── Laravel REST API
│       └── README.md
│
└── README.md
```

## Development Focus

The project focuses on understanding the complete flow of a full-stack mobile application:

```text
User
 ↓
Flutter UI
 ↓
State Management
 ↓
API Request
 ↓
Laravel REST API
 ↓
Business Logic
 ↓
Database
 ↓
API Response
 ↓
Flutter UI
```

## Key Learning Outcomes

Through this project, I practiced:

- Building a Flutter mobile application
- Developing REST APIs with Laravel
- Connecting Flutter with Laravel
- Authentication and token management
- API integration
- State management
- Local data persistence
- Client-server architecture
- Separating frontend and backend responsibilities

## Author

Ahmed Ezzat
