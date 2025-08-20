# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

SpeedType is a macOS typing speed test and practice application built with SwiftUI. Users can test their typing speed on predefined challenges (like alphabet sequences or QWERTY keyboard layout) and share their results as visually appealing cards with QR codes that allow others to attempt the same challenge.

## Development Commands

### Building the Application
```bash
# Build for debugging
xcodebuild -project SpeedType.xcodeproj -scheme SpeedType -configuration Debug build

# Build for release
xcodebuild -project SpeedType.xcodeproj -scheme SpeedType -configuration Release build

# Clean build artifacts
xcodebuild -project SpeedType.xcodeproj -scheme SpeedType clean
```

### Running the Application
```bash
# Build and run (opens in Simulator or connected device)
xcodebuild -project SpeedType.xcodeproj -scheme SpeedType -configuration Debug run

# Or open in Xcode for interactive development
open SpeedType.xcodeproj
```

### Project Information
```bash
# List available schemes and configurations
xcodebuild -list -project SpeedType.xcodeproj
```

## Architecture Overview

### Core Structure
The application follows a standard SwiftUI architecture with clear separation of concerns:

- **`SpeedTypeApp.swift`**: Main app entry point using SwiftUI's `@main` attribute
- **`ContentView.swift`**: Main UI view containing the typing test interface, timer logic, and input handling
- **`Challenge.swift`**: Data model defining typing challenges with predefined challenges array
- **`ShareCardView.swift`**: SwiftUI view for generating shareable result cards with QR codes
- **`StatisticItem.swift`**: Reusable component for displaying statistics (WPM, accuracy, etc.)
- **`QRCodeGenerator.swift`**: Utility for generating QR codes from challenge URLs

### Key Features Implementation
- **High-precision timing**: Uses `CACurrentMediaTime()` for accurate timing measurements
- **Real-time input validation**: Character-by-character comparison with visual feedback
- **Custom URL scheme**: `speedtype://` for challenge sharing via QR codes
- **Statistics calculation**: WPM (words per minute), accuracy percentage, character count
- **Share functionality**: Generates image cards that can be copied to clipboard

### State Management
ContentView manages all application state using SwiftUI's `@State`:
- `selectedChallenge`: Currently active typing challenge
- `userInput`: User's typed text
- `isTyping`/`isFinished`: Test state flags
- `startTime`/`elapsedTime`: Timing data
- `currentIndex`/`errorCount`/`correctChars`: Progress tracking

### Custom URL Scheme
The app is configured to handle `speedtype://` URLs through Info.plist configuration. Challenge URLs follow the pattern: `speedtype://challenge/{challengeId}`

## Project Configuration

- **Target Platform**: macOS (minimum deployment target: macOS 15.5)
- **Development Tools**: Xcode 16.4+, Swift 5.0+
- **UI Framework**: SwiftUI
- **Bundle ID**: `com.lzhlovesjyq.SpeedType`
- **Development Team**: V65YCRQZ2M

## Adding New Features

### Adding New Challenges
Modify the `predefinedChallenges` array in `Challenge.swift`:
```swift
Challenge(
    id: "unique-identifier",
    title: "Display Name", 
    text: "Text to type"
)
```

### Modifying Statistics
Update the computed properties in `ContentView.swift`:
- `wpm`: Words per minute calculation
- `accuracy`: Percentage of correct characters

### Customizing Share Cards
Modify `ShareCardView.swift` to change the appearance of generated share images.