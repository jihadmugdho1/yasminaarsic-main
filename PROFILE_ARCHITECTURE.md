# Profile Module Architecture

## Overview
Clean architecture with separation of concerns:
- **Models**: Data structure mapping from API response
- **Service**: Handles all API communication
- **Controller**: GetX controller managing state and business logic
- **UI**: Remains dump (unchanged) and only displays data

## File Structure

```
lib/features/profile/
├── data/
│   ├── models/
│   │   ├── notification_model.dart     (NEW)
│   │   └── user_model.dart             (NEW)
│   ├── services/
│   │   └── profile_service.dart        (NEW)
│   ├── notification_preference_model.dart (EXISTING - for UI)
│   └── profile_model.dart              (EXISTING - for UI)
├── controller/
│   └── profile_controller.dart         (UPDATED)
└── presentation/
    ├── screens/
    │   └── profile_screen.dart         (UNCHANGED)
    └── widgets/
        ├── language_selection_card.dart
        ├── notification_preferences_card.dart
        ├── password_change_card.dart
        ├── profile_detail_card.dart
        └── profile_header_card.dart
```

## API Response Mapping

The API returns:
```json
{
  "success": true,
  "message": "Success",
  "data": {
    "id": "...",
    "email": "...",
    "name": "...",
    "dateOfBirth": "...",
    "location": "...",
    "phone": "...",
    "notifications": [
      {
        "newOffer": true,
        "renewalReminder": true,
        "promotional": true
      }
    ]
  }
}
```

## Data Flow

1. **UI (ProfileScreen)** - Dump component, displays data from controller
2. **Controller (ProfileController)** - GetX controller
   - Calls `_profileService.getProfile()` in `onInit()`
   - Receives `UserModel` from service
   - Transforms `UserModel` → `ProfileModel` (for UI compatibility)
   - Provides `profile` observable to UI
   - Handles language changes and notification toggling
3. **Service (ProfileService)** - Pure API layer
   - Uses `NetworkCaller` to make requests
   - Maps `UserModel` from JSON response
   - Returns `ResponseData<UserModel>`
4. **Models**
   - `UserModel`: Maps API response structure
   - `NotificationModel`: Maps notification data
   - `ProfileModel`: Display model for UI (existing)

## Usage

The UI remains unchanged. The controller automatically fetches profile data on initialization:

```dart
class ProfileController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _fetchProfile(); // Automatic fetch
  }
}
```

## Error Handling

- `isLoading`: Observable for loading state
- `errorMessage`: Observable for error messages
- Logs errors using `AppLoggerHelper`

## Key Features

✅ Clean separation: Service handles API, Controller handles state, UI displays data
✅ Type-safe: Full model typing from API to UI
✅ Reactive: Uses GetX observables for real-time updates
✅ Error handling: Proper error messages and logging
✅ Localization: Supports language-specific notification labels
✅ Dump UI: UI components unchanged, only receive and display data
