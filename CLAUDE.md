# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

SnapDex is a SwiftUI iOS app for generating and collecting AI-powered cards based on real-world objects. Users can take photos of objects, and the app generates trading-card-style collectibles with stats and descriptions.

## Architecture

This project follows Domain-Driven SwiftUI Architecture with clear separation of concerns:

- **UI Layer** (`UI/`): Pure SwiftUI views organized by feature (CardCollection, CardCreation, CardDetail, Components)
- **Domain Layer** (`Domain/`): Core business logic including:
  - `Models/`: Core data structures (Card, Stat, CardType enum)
  - `State/`: Centralized state management (AppState as single source of truth)
  - `Actions/`: Action definitions for state mutations
- **Service Layer** (`Services/`): External integrations (AIService, ImageService)
- **Repository Layer** (`Repository/`): Data persistence abstractions with UserDefaults implementation

## Key Architectural Patterns

### State Management
- **AppState** (`Domain/State/AppState.swift`) serves as the central ObservableObject
- Uses Redux-like action dispatching pattern via `send(_ action: AppAction)`
- All UI state flows through this single source of truth
- Injected via SwiftUI's `@EnvironmentObject`

### Data Flow
1. UI dispatches actions to AppState
2. AppState processes actions and updates published properties
3. SwiftUI views automatically re-render based on state changes
4. Repository layer handles persistence to UserDefaults

### Service Architecture
- Protocol-based service interfaces for testability
- MockAIService for previews and development
- OpenAIService stub for production AI integration (currently empty)

## Development Commands

### Building and Running
```bash
# Open project in Xcode
open SnapDex/SnapDex.xcodeproj

# Build from command line
xcodebuild -project SnapDex/SnapDex.xcodeproj -scheme SnapDex build

# Run tests
xcodebuild test -project SnapDex/SnapDex.xcodeproj -scheme SnapDex -destination 'platform=iOS Simulator,name=iPhone 15'
```

### Project Structure Notes
- **Duplicate folder structure**: Code exists both in root and inside `SnapDex/SnapDex/` (Xcode project structure)
- **Work in**: `SnapDex/SnapDex/` folder for Xcode project integration
- **Main targets**: SnapDex (main app), SnapDexTests, SnapDexUITests

### Key Files for Development
- `SnapDex/SnapDex/App/SnapDexApp.swift`: App entry point
- `SnapDex/SnapDex/Domain/State/AppState.swift`: Central state management
- `SnapDex/SnapDex/Domain/Models/Card.swift`: Core data model
- `SnapDex/SnapDex/Repository/CardRepository.swift`: Persistence interface
- `SnapDex/SnapDex/UI/CardCollection/CardCollectionView.swift`: Main collection view

### 3D Card Animation Architecture
- **CardFlipAnimation.swift**: Modular view modifiers for 3D effects
  - `CardDragRotation`: Handles drag gestures with spring-back animation
  - `DynamicCardShadow`: Rotation-responsive shadows
  - Clean extension-based API for reusability
- **Realistic flip animation**: Uses ZStack with opacity-based content switching at 90° rotation
- **Matched dimensions**: Card back mirrors front layout exactly to prevent glitches

### Development Considerations
- Uses `#if DEBUG` blocks for sample data in previews
- Card IDs are managed via `@AppStorage("totalSnapDexCardsMade")`
- Mock services are used for development until AI integration is complete
- Image URLs currently use placeholder services (placekitten.com, unsplash.com)
- **No Technical Debt**: Redundant code removed, modular architecture maintained
- **Future-proof**: Clean separation between animation logic and view presentation