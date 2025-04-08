# Mazaady Task

## 📌 Important Notes
- **First Tab**: Contains the UI implementation based on the provided Figma design
- **Second Tab**: Contains the dynamic form implementation with all required logic

## 🚀 Project Overview
This project is a SwiftUI-based iOS application that implements two main features:
1. A UI implementation based on a Figma design
2. A dynamic form with category and property selection functionality

## 🛠 Technical Stack
- SwiftUI for UI implementation
- MVVM Architecture
- Async/Await for network calls
- Combine for reactive programming

## 📱 Features

### First Tab (Figma UI)
- Implementation of the provided Figma design
- Responsive layout
- Modern UI components

### Second Tab (Dynamic Form)
- Category selection with search functionality
- Property selection based on selected category
- Custom input option for both category and property
- Real-time results display
- Form reset functionality
- Loading indicators for API calls

## 🏗 Project Structure
```
MazaadyTask/
├── View/
│   ├── DynamicForm/
│   │   ├── Components/
│   │   │   └── SearchableDropdown.swift
│   │   ├── DynamicFormView.swift
│   │   └── ResultsView.swift
│   └── FigmaUI/
│       └── FigmaUIView.swift
├── ViewModel/
│   └── CategoriesViewModel.swift
├── Model/
│   ├── Category.swift
│   └── CategoryProperties.swift
├── Network/
│   └── NetworkService.swift
└── MazaadyTaskApp.swift
```

## 🔄 Data Flow
1. User selects a category or enters a custom category
2. If a category is selected, properties are fetched from the API
3. User selects a property or enters a custom property
4. Results are displayed in real-time
5. User can reset the form at any time

## 🧪 Testing
The project includes unit tests for:
- Form reset functionality
- Category selection
- Property selection
- Custom input handling
- Submit button state
- Results view content

## 🔑 API Integration
- Base URL: `https://staging.mazaady.com/api/v1`
- Endpoints:
  - `/categories`: Fetch all categories
  - `/properties`: Fetch properties for a specific category

## 🎨 UI Components
- SearchableDropdown: A reusable component for category and property selection
- ResultsView: Displays selected category and property
- LoadingIndicator: Shows during API calls

## 🚀 Getting Started
1. Clone the repository
2. Open the project in Xcode
3. Build and run the project

## 📝 Requirements
- iOS 15.0+
- Xcode 13.0+
- Swift 5.5+
