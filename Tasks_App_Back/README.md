# Tasks App - Laravel REST API

## Overview

The backend of Tasks App is a Laravel REST API responsible for authentication, task management, user data, dashboard data, validation, and database communication.

It was developed as the server-side part of a full-stack task management application and is consumed by a Flutter mobile application.

## Main Responsibilities

The backend is responsible for:

- User Registration
- User Login
- User Logout
- User Profile
- Authentication
- Task Management
- Dashboard Data
- Request Validation
- Database Operations
- Protected API Routes
- JSON API Responses

## REST API

The backend exposes REST API endpoints that allow the Flutter application to communicate with the server.

The API handles requests from the mobile application and returns structured JSON responses.

```text
Flutter App
     |
     | HTTP Request
     v
Laravel API
     |
     | Validation / Business Logic
     v
Database
     |
     v
JSON Response
     |
     v
Flutter App
```

## Authentication

Authentication is implemented using Laravel Sanctum.

After successful registration or login, the backend can issue an authentication token to the user.

The Flutter application stores this token and sends it with requests to protected endpoints.

```text
Register / Login
       |
       v
Laravel Sanctum
       |
       v
API Token
       |
       v
Protected API Requests
```

## API Routes

The project uses Laravel API routes to separate backend endpoints from traditional web routes.

The API covers application functionality including:

- Authentication
- User information
- Dashboard
- Tasks

Protected routes require a valid authentication token.

## Task Management

Task-related functionality is handled by the Laravel backend.

The backend is responsible for receiving task requests, validating the submitted data, interacting with the database, and returning the appropriate API response.

This keeps task business logic on the server instead of inside the mobile application.

## Controllers

Controllers are responsible for processing incoming API requests.

They connect routes with application logic and return responses to the Flutter client.

The controller layer handles operations related to areas such as:

- Authentication
- Users
- Tasks
- Dashboard functionality

## Models

Laravel models represent application data and provide the connection between the application and database.

They are responsible for working with stored records and relationships through Laravel's Eloquent ORM.

## Database

The application uses a relational database to persist application data.

Laravel migrations are used to define and manage database structure.

The backend stores data related to application entities such as users and tasks.

## Validation

Incoming API data is validated before being processed.

Validation helps ensure that required fields and submitted values meet the application's expected rules.

When validation fails, the backend returns an appropriate response that can be handled by the Flutter application.

## API Responses

The backend communicates with the Flutter application using JSON.

Responses can contain:

- Requested data
- User information
- Task information
- Authentication information
- Validation errors
- Status messages
- Error responses

## Security

Protected API functionality uses Laravel Sanctum authentication.

Authenticated requests include the user's token in the request headers.

This prevents protected application data from being accessed without valid authentication.

## Technologies Used

| Technology | Purpose |
|---|---|
| Laravel | Backend framework |
| PHP | Backend programming language |
| Laravel Sanctum | API authentication |
| REST API | Communication architecture |
| MySQL | Relational database |
| Eloquent ORM | Database interaction |
| Laravel Migrations | Database structure |
| JSON | API data exchange |
| Composer | PHP dependency management |

## Backend Structure

The Laravel application follows Laravel's standard separation of responsibilities.

Important areas include:

```text
app/
├── Http/
│   └── Controllers/
├── Models/
│
database/
├── migrations/
│
routes/
└── api.php
```

Each part has a specific responsibility:

- `Controllers` handle incoming requests.
- `Models` interact with application data.
- `Migrations` define database structure.
- `api.php` defines API endpoints.

## Error Handling

The API handles different response scenarios such as:

- Successful requests
- Authentication failures
- Validation errors
- Unauthorized requests
- Invalid data
- Server-side errors

The Flutter application can use these responses to display the appropriate state or message to the user.

## Key Concepts Practiced

This backend provided practical experience with:

- Laravel API development
- RESTful architecture
- API routing
- Controllers
- Models
- Database migrations
- Eloquent ORM
- Authentication with Sanctum
- Token-based authentication
- Request validation
- Protected routes
- JSON responses
- Error handling
- Connecting a backend API to Flutter

## Frontend

The API is consumed by a Flutter mobile application included in the same repository:
`Tasks_App_Front`

## Author

Ahmed Ezzat
