# Square Repositories iOS App

A simple iOS application that displays a list of public repositories from the **Square** GitHub organization.

The project was implemented as a technical assignment with a focus on **clean architecture**, **testability**, and **production-ready code structure**.

---

## ✨ Features

- Fetches repositories from GitHub API (`/orgs/square/repos`)
- Displays repository name and description
- Supports:
  - Initial loading state
  - Pull-to-refresh
  - Pagination
  - Empty state
  - Error handling with retry
- Fully programmatic UI (UIKit)
- No third-party libraries

---

## 🧱 Architecture

The project follows a **feature-based architecture** with clear separation of concerns:

```
Networking
│
Features
└── ReposList
    ├── Domain
    ├── Data
    └── Presentation
```

### Layers overview

#### Domain
Contains pure business logic and abstractions:
- Domain entities (`Repo`)
- Repository contracts (`ReposRepository`)

The Domain layer is completely isolated from networking, JSON, and UIKit.

#### Data
Responsible for data fetching and mapping:
- API implementations
- DTOs
- Mappers (DTO → Domain)

Each feature owns its own data layer, keeping features isolated and scalable.

#### Presentation
UIKit-based UI and state management:
- `UIViewController`
- `ViewModel`
- Diffable Data Source
- UI state rendering

#### Networking (Shared)
Reusable networking infrastructure:
- `HTTPClient` abstraction
- `URLSession` implementation
- Strongly typed `Endpoint`
- Centralized error model

---

## 🌐 Networking & Endpoints

Endpoints are defined as **strongly typed enums**, which prevents invalid request construction and improves readability.

```swift
enum GitHubEndpoint {
    case squareRepos(page: Int, perPage: Int)
}
```

Request building and execution are fully decoupled:
- `Endpoint` → describes request
- `RequestBuilder` → builds `URLRequest`
- `HTTPClient` → executes request
- Data layer → interprets response and status codes

---

## ⚠️ Error Handling

The project uses a layered error approach:

- `NetworkError` — technical errors (transport, server, decoding)
- `UserFacingError` — UI-friendly errors shown to the user

Error mapping happens in the **ViewModel**, so the UI never depends on low-level networking details.

---

## 🧪 Testing

Unit tests are written using **XCTest**.

### Covered areas:
- ViewModel logic (loading, success, failure states)
- Repository logic using mocked HTTP client

### Testing principles:
- ViewModels are tested with stub repositories
- Networking is mocked using `HTTPClient`
- Tests are fast, deterministic, and isolated

A small `TestDataFactory` is used to reduce duplication and keep tests readable.

---

## 🛠 Technologies

- Swift
- UIKit (programmatic UI)
- URLSession
- Codable
- UITableViewDiffableDataSource
- XCTest
- Swift Concurrency (`async/await`)

---

## 🚀 Possible Improvements

Given more time, the project could be extended with:
- Disk caching
- Parsing pagination from `Link` headers
- Repository details screen
- Search and filtering
- Modularization using Swift Packages

---

## ▶️ Running the Project

1. Open the project in Xcode
2. Select an iOS Simulator
3. Run the app (`Cmd + R`)

---

## 🧠 Notes

The main goal of this project is to demonstrate:
- Clean separation of concerns
- Scalable architecture
- Testability
- Thoughtful error handling
- Production-ready UIKit code
