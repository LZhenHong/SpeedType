# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

SpeedType is a macOS typing speed test application built with SwiftUI. Users test their typing speed on predefined challenges and share results as visual cards with QR codes.

## Development Commands

```bash
# Build
xcodebuild -project SpeedType.xcodeproj -scheme SpeedType -configuration Debug build
xcodebuild -project SpeedType.xcodeproj -scheme SpeedType -configuration Release build

# Clean
xcodebuild -project SpeedType.xcodeproj -scheme SpeedType clean

# Run
open SpeedType.xcodeproj  # then ⌘R in Xcode

# Format code (uses .swiftformat config)
swiftformat .
```

## Architecture Overview

### State Management Pattern
The app uses a centralized state + engine pattern:
- **`TypingTestState`** (`@Observable`): Manages test lifecycle, timing (via `CACurrentMediaTime()`), and statistics (WPM, accuracy)
- **`TypingEngine`**: Stateless utility that processes input and updates state
- **UI Views**: React to state changes and delegate actions to the engine

### Key Files
| File | Purpose |
|------|---------|
| `ContentView.swift` | Main UI coordinating the typing test interface |
| `TypingTestState.swift` | Observable state with test lifecycle, timing, and stats |
| `TypingEngine.swift` | Core input validation and character matching logic |
| `Challenge.swift` | Data model with `predefinedChallenges` array |
| `DesignSystem.swift` | macOS-native design tokens (colors, spacing, shadows) |
| `ButtonStyles.swift` | Reusable button styles with `ButtonPressEffect` modifier |
| `ImageShareHelper.swift` | Result image generation with `ImageLayout` configuration |
| `ResultView.swift` | Test completion view with data-driven card layout |

### Design Patterns Used
- **ViewModifier**: `ButtonPressEffect` for reusable press animations
- **Generic View**: `ButtonBackground<S: ShapeStyle>` for flexible button backgrounds
- **Configuration Enum**: `ImageLayout` centralizes all drawing constants
- **Data-Driven UI**: `ResultCardData` model drives `ForEach` card generation

### Custom URL Scheme
Handles `speedtype://challenge/{challengeId}` via Info.plist configuration.

## Project Configuration

- **Platform**: macOS 15.5+
- **Tools**: Xcode 16.4+, Swift 5.0+
- **Bundle ID**: `com.lzhlovesjyq.SpeedType`

## Adding New Challenges

In `Challenge.swift`, add to the `predefinedChallenges` array:
```swift
Challenge(id: "unique-id", title: "Display Name", text: "Text to type")
```

## Code Style Guidelines

- Use trailing closure syntax for SwiftUI modifiers (`.overlay { }` not `.overlay(Group { })`)
- Extract reusable ViewModifiers for common animations/effects
- Use private enums for configuration constants (e.g., `ImageLayout`, `MacSpacing`)
- Prefer data-driven views with `ForEach` over repeated similar code