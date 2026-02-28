# Daraz  - Flutter Product Listing
https://github.com/user-attachments/assets/d328e278-6b29-461b-8c1b-17cb20fa51ef

A Flutter implementation of a Daraz-style product listing with proper scroll architecture and gesture handling.

## Features
- Collapsible header with banner, search bar, and user profile
- Sticky tab bar that pins when scrolling
- Three product categories (All, Men's Clothing, Women's Clothing, Jewelery)
- Single vertical scrollable with pull-to-refresh
- Tab switching via tap or horizontal swipe
- Preserved scroll position per tab
- Integration with Fake Store API
- User profile display

## Implementation Details

### 1. Horizontal Swipe Implementation
Horizontal swipe is implemented using Flutter's native `TabBarView` but with a custom approach to maintain single scroll architecture:
- The tab bar itself uses Flutter's `TabController` for swipe gestures
- Tab switching via swipe updates the same `CustomTabController` index
- Content updates based on the active tab index without creating separate scrollables
- Gesture recognition is handled by Flutter's gesture arena to prevent conflicts

### 2. Vertical Scroll Ownership
The vertical scroll is owned by a single `ScrollControllerX` class that:
- Manages a single `ScrollController` instance for the entire screen
- Tracks scroll positions per tab in a Map
- Restores positions when switching tabs
- This approach ensures:
  - No scroll conflict between nested scrollables
  - Pull-to-refresh works consistently across all tabs
  - Smooth scrolling experience
  - Single source of truth for scroll state

### 3. Trade-offs and Limitations

**Trade-offs:**
- **Single Scroll Position**: All tabs share the same scrollable space, which means scrolling far down in one tab and switching to another with fewer items might show empty space
- **Memory Usage**: Storing scroll positions for each tab in memory

**Limitations:**
- Cannot have independent scroll physics per tab
- Items from different tabs are not pre-cached
- Tab bar visibility depends on scroll position rather than content

**Alternative Approaches Considered:**
1. **Nested ScrollViews**: Rejected due to scroll conflicts
2. **PageView with separate Scrollables**: Rejected due to duplicate scrolling issues
3. **CustomScrollView with SliverList per tab**: Not possible with single scroll view

## Running the App

1. Clone the repository
2. Run `flutter pub get`
3. Run `flutter run`

## API Integration
Uses Fake Store API (https://fakestoreapi.com/) for:
- Product listings
- User profile data

## State Management
GetX is used for:
- Reactive state management
- Dependency injection
- Controller lifecycle management



