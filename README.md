# Mind Matters

**Mind Matters** is a SwiftUI iOS prototype that helps students build small daily habits across mental wellness, academics, finances, and social life — visualized through a personal garden that grows with their progress.

*Team Lead:* Kimberlee Wilkens

*Team:* Kahnishga Solaidurairaj, Amaani Ziauddin, Lavanya Vats, Sneha Sharma, and Ian Aguilar

## What It Does

Mind Matters turns everyday self-care into a gentle, visual routine. Users complete short daily tasks, maintain streaks, and watch their garden respond to how consistently they show up.

### Core Features

- **Daily Tasks** — Three personalized activities each day across social, academic, financial, and wellness categories.
- **Plant of the Week** — A weekly plant that grows one stage per streak day when all daily tasks are finished. After a 7-day streak or at the end of the week, users can pick a new plant.
- **Your Garden** — Four priority plants (Academic, Financial, Social, Physical) reflect where completed tasks are focused. Tap for a full priority breakdown.
- **Full Greenhouse View** — A scene that updates based on streak progress and priority balance, from a starter shed to a flourishing greenhouse.
- **Connections & CO-OP** — Returning users can check in on relationships, invite a connection, and visit a shared greenhouse.
- **Campus Resources** — A UIC-focused hub for formal help and on-campus workshops.

## Requirements

- iOS 15.0+
- Xcode 14.0+
- Swift 5.7+

## Getting Started

1. Clone the repository.
2. Open `mindMatters.xcodeproj` in Xcode.
3. Select an **iPhone Simulator** as the run destination (not My Mac).
4. Build and run (`⌘R`).

## Project Structure

```
mindMatters/
├── App/           # App entry point
├── Models/        # AppState, tasks, plants, theme
├── Views/         # SwiftUI screens and components
└── Assets.xcassets/
```

## Architecture

The app uses **MVVM** with a central AppState object that drives navigation, task completion, streak tracking, and garden progress. Views observe AppState via @EnvironmentObject.

