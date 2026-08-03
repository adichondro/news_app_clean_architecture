# Daily News — Flutter Clean Architecture Practice

[![Flutter](https://img.shields.io/badge/Flutter-v3.12+-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-v3.0+-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![Architecture](https://img.shields.io/badge/Architecture-Clean_Architecture-green)](https://clean-architecture.org)
[![State Management](https://img.shields.io/badge/State_Management-BLoC-blue)](https://bloclibrary.dev)
[![Local DB](https://img.shields.io/badge/Database-Drift_%2F_SQLite-orange)](https://drift.simonbinder.eu/)

A professional, cross-platform Flutter application built to explore and practice **Clean Architecture**, state management using **BLoC**, offline caching, database migrations, and modern software design principles in Dart. 

---

## Overview

**Daily News** is a mobile application that fetches the latest headlines from a remote API (NewsAPI) and displays them in a clean, modern user interface. In addition to online reading, the application features a robust bookmarking and offline persistence mechanism, enabling users to save articles for offline access.

The application serves as a concrete, hands-on playground to implement clean segregation between business logic, data mapping, API consumption, and user interface rendering.

---

## Motivation

This project was built out of a desire to bridge the gap between simple, UI-only apps and production-grade software. In typical Flutter projects, developers often mix network calls, UI logic, and state management in a single layer, leading to fragile, hard-to-test codebases. 

By enforcing a strict **Clean Architecture** boundary, this project explores:
- How to write decoupled, modular code that is resistant to platform or library changes (e.g., swapping databases or network clients).
- How to manage asynchronous data streams cleanly using the BLoC pattern.
- How to utilize local SQLite persistence as a local cache source of truth for bookmarked content.
- Best practices in dependency injection (DI) and separation of concerns.

---

## Learning Objectives

Through the lifecycle of this project, several key software engineering concepts and practices are explored:

1. **Layered Separation of Concerns**: Isolating the application into Domain, Data, and Presentation layers.
2. **Dependency Inversion Principle**: Ensuring that the Domain layer (business rules) does not depend on the Data layer (databases, API clients) but instead defines interfaces that the Data layer implements.
3. **Type-Safe Local Persistence**: Leveraging SQLite through Drift (formerly Moor) to generate compiled, safe queries and schema management.
4. **Declarative State Flows**: Implementing the BLoC library to convert UI events (e.g., fetching news, toggling bookmarks) into predictable states.
5. **Modern API Consumption**: Utilizing Retrofit and Dio with custom interceptors to handle HTTP headers, base URLs, and query parameters cleanly.
6. **Graceful Loading & Image States**: Employing skeleton layouts (Skeletonizer) for placeholder loading, and cached network images with error fallback widgets to ensure a premium user experience.
7. **Robust Error Handling**: Utilizing strongly-typed `Failure` subclasses and a centralized `ExceptionHandler` to catch exceptions and present user-friendly error messages via `FailureExtension` and `AppStrings`.

---

## Features

* **Atomic Design System**: A scalable UI architecture organizing components into Atoms, Molecules, and Organisms for maximum reusability and maintainability.
* **Top Headlines Feed**: Fetches real-time, curated daily news articles from the NewsAPI general category in the US.
* **Empty States & UX Handling**: Features premium SVG illustrations and custom empty states for error handling, no-data scenarios, and connection issues.
* **Premium Skeleton Shimmers**: Employs `skeletonizer` to display an organic, matching layout outline while the remote request resolves, avoiding jarring loading spinners.
* **Offline Bookmarking / Caching**: Saves full articles locally to an SQLite database. Saved articles can be read offline even without network connectivity.
* **Bookmark Management & Bulk Delete**: Easily manage saved articles and clear all bookmarked content with a single button.
* **Cached Network Images**: Utilizes `cached_network_image` to cache remote article images on disk, reducing network bandwidth and ensuring images render instantly on repeat visits.
* **Safe Secrets Management**: Utilizes dotenv configuration (`.env`) to load NewsAPI credentials securely without hardcoding them in the source code.

---

## Architecture

This project is structured around the principles of **Clean Architecture** (proposed by Uncle Bob). It strictly divides the codebase into three main layers: **Domain**, **Data**, and **Presentation**, complemented by a robust **Core Infrastructure** layer.

```mermaid
graph TD
    %% Presentation Layer
    subgraph Presentation ["Presentation Layer (UI & State)"]
        UI["Pages & Widgets\n(DailyNewsPage, SavedArticlesPage)"] -->|Triggers Events| BLoC["BLoC\n(RemoteArticlesBloc, LocalArticleBloc)"]
        BLoC -->|Emits States\n(Loading, Done, Error)| UI
    end

    %% Domain Layer
    subgraph Domain ["Domain Layer (Business Logic)"]
        BLoC -->|Invokes| UseCase["Use Cases\n(GetArticleUseCase, SaveArticleUseCase, etc.)"]
        UseCase -->|Calls| RepoInterface["Repository Interface\n(ArticleRepository)"]
        RepoInterface -->|Returns| DataState["DataState<T>"]
        DataState -->|Holds Payload| Entity["Entities\n(ArticleEntity)"]
    end

    %% Data Layer
    subgraph Data ["Data Layer (Infrastructure & Data Sources)"]
        RepoImpl["Repository Implementation\n(ArticleRepositoryImpl)"] -.->|Implements| RepoInterface
        RepoImpl -->|Calls| RemoteDS["Remote DataSource\n(NewsApiService / Dio)"]
        RepoImpl -->|Calls| LocalDS["Local DataSource\n(ArticleDao / Drift SQLite)"]
        RemoteDS -->|Returns API Response| Model["Models / DTOs\n(ArticleModel, ArticleResponseModel)"]
        LocalDS -->|Returns DB Rows| Model
        Model <==>|"toEntity() / fromEntity()"| Entity
    end

    classDef presentation fill:#e1f5fe,stroke:#01579b,stroke-width:2px,color:#003057;
    classDef domain fill:#efebe9,stroke:#3e2723,stroke-width:2px,color:#21100b;
    classDef data fill:#efe8e0,stroke:#e65100,stroke-width:2px,color:#802b00;
    
    class UI,BLoC presentation;
    class UseCase,RepoInterface,DataState,Entity domain;
    class RepoImpl,RemoteDS,LocalDS,Model data;
```

### 1. Domain Layer (The Core)
The domain layer contains the core business rules of the application. It is completely independent of any external library, framework, or database.
* **Entities**: Plain Dart objects containing business data (e.g., `ArticleEntity` extending `Equatable`).
* **Repositories (Interfaces)**: Defines contracts for data operations. Returns type-safe `DataState<T>` wrappers (including `DataState<void>` for mutation methods) to ensure failure feedback is explicitly defined.
* **Use Cases**: Individual, single-responsibility units of work (e.g., `GetArticleUseCase`, `GetSavedArticlesUseCase`, `SaveArticleUseCase`, `RemoveArticleUseCase`, `ClearArticleUseCase`) extending `UseCase<T, Params>`.

### 2. Data Layer (The Infrastructure)
The data layer implements the interfaces defined in the domain layer. It interacts directly with the API and database.
* **Models**: Data Transfer Objects (DTOs) handling JSON parsing (`ArticleModel.fromJson`, `ArticleResponseModel.fromJson`), SQLite database rows (`ArticleModel.fromTableData`), and domain entity mappers (`toEntity()`, `fromEntity()`).
* **Data Sources**: Handles low-level network and database calls:
  * *Remote*: `NewsApiService` (generated using `retrofit` and powered by `dio` with custom `ApiKeyInterceptor`).
  * *Local*: `ArticleDao` (Data Access Object) and `ArticleTable` (Drift SQLite schema definition).
* **Repositories (Implementation)**: Coordinates data fetching from remote/local sources, delegates exception catching to `ExceptionHandler`, and returns unified `DataSuccess` or `DataFailed(Failure)` responses.

### 3. Presentation Layer (The UI)
This layer is responsible for rendering views and handling user interactions. It implements the **Atomic Design Methodology** to ensure high reusability:
* **BLoC**: Receives user actions (Events), processes logic via Use Cases, and emits corresponding UI states (e.g., `RemoteArticlesLoading`, `RemoteArticlesDone`, `LocalArticlesDone`).
* **Atoms, Molecules, & Organisms**: Reusable UI building blocks (e.g., buttons and chips as Atoms, article info sections as Molecules, full article cards and custom app bars as Organisms).
* **Pages**: High-level screens built as clean `StatelessWidget`s (`DailyNewsPage`, `ArticleDetailPage`, `SavedArticlesPage`).

### 4. Core Infrastructure & Functional Error Handling
* **Strongly-Typed Failures**: Base `Failure` class with 15 concrete subclasses (`ServerFailure`, `NetworkFailure`, `UnauthorizedFailure`, `ForbiddenFailure`, `NotFoundFailure`, `ValidationFailure`, `TooManyRequestsFailure`, `ServiceUnavailableFailure`, `GatewayTimeoutFailure`, `InternalServerErrorFailure`, `BadCertificateFailure`, `RequestCancelledFailure`, `FormatFailure`, `CacheFailure`, `UnknownFailure`).
* **Centralized Exception Handler**: `ExceptionHandler` converts network timeouts, HTTP status errors, format errors, and database exceptions into strongly-typed `Failure` instances with debug logging (`developer.log`).
* **UI Message Extension**: `FailureExtension.toUserMessage()` maps technical `Failure` objects to user-friendly UI string constants defined in `AppStrings`.
* **Functional Folding**: `DataState.fold<R>(onFailure, onSuccess)` enables clean pattern matching on operational results across Use Cases and BLoCs.

---

## Technologies & Dependencies

Here is a breakdown of the core technologies, libraries, and tools utilized in this project:

| Dependency | Purpose | Details |
| :--- | :--- | :--- |
| **Flutter SDK** | Framework | Mobile, Desktop, and Web UI development engine. |
| **flutter_bloc** | State Management | Implements the BLoC pattern to separate presentation from business logic. |
| **equatable** | Value Equality | Enables value-based object comparison for domain entities, states, and failures. |
| **get_it** | Dependency Injection | Service locator for clean DI across data, domain, and UI layers. |
| **drift** | Local Database | Reactive, type-safe SQLite database wrapper for Dart/Flutter. |
| **dio** | HTTP Client | Powerful network client supporting interceptors, global configuration, and error catching. |
| **retrofit** | Network Mapping | Code-generation tool to convert REST API endpoints to clean Dart methods. |
| **flutter_hooks** | Hook Widgets | Manages widget lifecycles reactively without boilerplate `StatefulWidget` subclasses. |
| **skeletonizer** | Loading UI | Automatically creates skeleton load placeholders using existing widget structures. |
| **cached_network_image** | Image Loading | Downloads, caches, and renders web images with progress indicators and error fallbacks. |
| **path_provider** / **path** | Storage Path | Provides cross-platform filesystem paths for SQLite database storage. |
| **flutter_dotenv** | Configuration | Loads runtime environment configurations safely from `.env` files. |
| **flutter_svg** | Vector Graphics | Renders scalable SVG illustrations for rich empty states and UX components. |
| **build_runner** | Code Generation | CLI tool orchestrating code generation for Retrofit API services and Drift database. |

---

## Project Structure

```text
assets/
├── fonts/                     # Custom typography
│   ├── inter/                 # Inter font files (Inter-VariableFont_opsz,wght.ttf, etc.)
│   └── worksans/              # WorkSans font files (WorkSans-VariableFont_wght.ttf, etc.)
└── illustrations/             # SVG graphics for empty and error states
lib/
├── config/
│   └── routes/                # Navigation and routing setup (AppRoutes)
├── core/
│   ├── constant/              # API endpoints, query params, and AppStrings UI messages
│   │   ├── api_constants.dart
│   │   ├── app_strings.dart
│   │   └── query_constants.dart
│   ├── database/              # Drift database initialization (AppDatabase)
│   ├── env/                   # Environment variable mappings (Env)
│   ├── error/                 # Strongly-typed Failure hierarchy & ExceptionHandler
│   │   ├── exception_handler.dart
│   │   └── failure.dart
│   ├── network/               # Custom Dio configurations, interceptors, and clients
│   │   ├── dio/               # NewsDioClient
│   │   └── interceptors/      # ApiKeyInterceptor
│   ├── presentation/          # Shared UI Atoms, Molecules, Organisms
│   │   ├── atoms/             # AppPrimaryButton, CategoryChip
│   │   ├── molecules/         # ClearAllSavedButton, CustomSnackbar, SaveButton
│   │   └── organisms/         # CustomAppBar, EmptyStateView
│   ├── resources/             # Sealed states (DataState, DataSuccess, DataFailed)
│   ├── theme/                 # Global app styling and tokens
│   │   ├── app_theme.dart     # ThemeData configs
│   │   └── tokens/            # Design Tokens (app_colors, app_radius, app_shadow, app_spacing, app_typography)
│   ├── usecases/              # Base UseCase<Type, Params> template
│   └── util/                  # Helper extensions (date_extension, failure_extension, string_extension)
├── features/
│   └── daily_news/            # Main feature domain
│       ├── data/
│       │   ├── data_sources/
│       │   │   ├── local/     # ArticleDao & ArticleTable (Drift SQLite DAO & Schema)
│       │   │   └── remote/    # NewsApiService (Retrofit)
│       │   ├── models/        # ArticleModel & ArticleResponseModel
│       │   └── repositories/  # ArticleRepositoryImpl
│       ├── domain/
│       │   ├── entities/      # Pure business objects (ArticleEntity)
│       │   ├── repositories/  # Abstract repository contracts (ArticleRepository)
│       │   └── usecases/      # Use cases (GetArticleUseCase, SaveArticleUseCase, etc.)
│       └── presentation/
│           ├── bloc/          # Remote (API) and Local (DB) BLoCs & message types
│           ├── components/    # Feature-specific UI components (Atoms, Molecules, Organisms)
│           └── pages/         # Standardized Screen Pages
│               ├── article_detail/   # ArticleDetailPage
│               ├── daily_news/       # DailyNewsPage
│               └── saved_articles/   # SavedArticlesPage
├── injection_container.dart   # Service locator (GetIt) registrations
└── main.dart                  # Application entry point & configuration setups
```

---

## Getting Started

### Prerequisites
Before running the project locally, ensure you have:
* The **Flutter SDK** installed (v3.12.0 or higher recommended). Check via `flutter --version`.
* An active **NewsAPI Key**. You can register and acquire a free developer key at [newsapi.org](https://newsapi.org).

### Step-by-Step Installation

1. **Clone the Repository**
   ```bash
   git clone https://github.com/adichondro/news_app_clean_architecture.git
   cd news_app_clean_architecture
   ```

2. **Retrieve Project Dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Environment Variables**
   Create a file named `.env` in the root directory of the project and add your NewsAPI key:
   ```env
   API_KEY=your_actual_news_api_key_here
   ```

4. **Generate Code files (Drift & Retrofit)**
   This project relies on code generation. Run the build runner command to generate the `.g.dart` files for the API service and the SQLite database:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

5. **Run the Application**
   Start a simulator or connect a physical debugging device and run:
   ```bash
   flutter run
   ```

---

## Future Improvements

As an ongoing learning project, the following enhancements are planned to explore further advanced concepts:

- [ ] **Comprehensive Automated Testing**: Add unit tests for Blocs and Use Cases (using `mocktail`), widget tests for UI elements, and mock network services to achieve robust coverage.
- [ ] **Dual Theme Support (Light / Dark Mode)**: Implement dynamic theme swapping by connecting a local settings Bloc and persisting preference storage.
- [ ] **Multi-language Localization**: Wire up the Flutter localization package to support multiple translation profiles.
- [ ] **Advanced Search & Category Filters**: Provide a search bar in the Daily News feed with scrollable category tabs to dynamic fetch different headlines (e.g., technology, sports).
- [ ] **Network State Observer**: Integrate a network connectivity listener (`connectivity_plus`) to show banner notifications when the user loses internet connection and automatically switch to reading saved articles.

---

## Lessons Learned

- **Decoupled Architecture Prevents Spaghetti Code**: Although separating folders into data, domain, and presentation requires writing more initial files (like UseCases and models), it pays off immediately when debugging or changing UI layout, as it reduces cross-class side effects.
- **Drift makes SQL Easy**: Generating schema helpers automatically ensures that SQL syntax errors are caught at compile time rather than crashing the database engine at runtime.
- **State Management Simplifies UI**: By using Blocs, views remain simple and declarative. They just build the interface based on the state emitted, which drastically reduces the complexity of handling user gestures and loading screens.
- **Centralized Exception Handling Streamlines UX**: Mapping external exceptions (Dio, Socket, SQL) to strongly-typed domain `Failure` objects ensures that user interfaces can react cleanly with meaningful messages rather than unhandled exception crashes.

---

## Disclaimer

> [!IMPORTANT]
> **Educational & Learning Project Sandbox**
>
> * This project was created primarily as a **personal learning and practice project** to explore modern software development concepts and improve programming skills.
> * The features are implemented as part of a learning process rather than to create a production-ready application.
> * The project is used to practice software engineering best practices including Clean Architecture, state management, dependency injection, API integration, local database management, error handling, etc.
> * The codebase will continue to evolve, be refactored, or contain experimental implementations as new concepts are discovered.
> * It serves as an active portfolio of software exploration and learning progress.

---
*Created by [adichondro](https://github.com/adichondro) as a learning experiment.*
