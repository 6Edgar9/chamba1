# Feature: CHAMBA MVP Audit, Correction & Expansion

## Objective
Elevate CHAMBA Flutter MVP to full functional and visual parity with the official Google Stitch design (Project `12752052940306496834`), completing the full inDrive-style peer-to-peer negotiation lifecycle, bottom navigation bars for both Client and Worker roles, interactive map integration with privacy zones, secondary screens (Auth, Messages inbox, My Requests, Profile, Settings), and end-to-end verification on the Android emulator `Medium_Phone` via Mobile MCP.

## Context & Problem
The initial CHAMBA MVP provided scaffolding for the 12 primary screens, but lacked:
- Bottom navigation bars (`BottomNavigationBar`) on both Client and Chambeador shells, leaving users stranded without accessible secondary views (Bandeja de Mensajes, Mis Solicitudes, Perfil, Configuración).
- Interactive map integration: job requests lacked real coordinates, dynamic pin dragging, GPS resolution, and worker approximate radius privacy display.
- Full inDrive negotiation loop: missing cancellation flows, rejected bids handling, post-tracking payment registration (Efectivo/Yape/Plin), and ratings/review persistence.
- Secondary screens: Authentication sheet, Messages inbox, Notifications, and Settings screens were missing or placeholders.
- Visual alignment: discrepancies in colors, typography, and card paddings against the official Stitch Design System (`Chamba Core`).

## Scope & Constraints
- Framework: Flutter 3.x / Dart 3.x.
- Architecture: Modular Clean Architecture (Domain Models, Presentation State, Reusable Design System Widgets).
- Visual tokens: Stitch "Chamba Core" (Primary: `#173B4D`, Secondary: `#B84A1C`, Tertiary: `#237553`, Canvas: `#F8F6F1`, Typography: Manrope + DM Sans).
- Map solution: `flutter_map` with OpenStreetMap + `latlong2` + `geolocator` (No external API keys required; 100% private and offline-resilient).
- Device testing: Android emulator `Medium_Phone` via Mobile MCP.

## Implementation Tasks

- [x] `TASK-01`: Visual & Functional Audit: Document comparison of the 12 Stitch screens vs Flutter implementation, cataloging visual gaps, missing actions, and navigation flows. (Observed: 12 screens cataloged, identified missing bottom navigation, privacy zones, and payment/rating flow).
- [x] `TASK-02`: Navigation Shells: Implement `ClientShell` and `WorkerShell` with persistent bottom navigation bars (Inicio/Chambas, Mis Solicitudes/Mis Trabajos, Mensajes, Perfil), notification badges, and seamless role switching. (Observed: `client_shell.dart` and `worker_shell.dart` built and tested).
- [x] `TASK-03`: Secondary Screens: Build Authentication dialog/sheet, Messages Inbox screen, My Requests (Client) screen, Profile screen with ratings/stats, Notifications dialog, and Settings screen. (Observed: all 7 secondary screens implemented with zero empty states).
- [x] `TASK-04`: Interactive Maps: Build `ChambaMapView` supporting pin drag, GPS geolocation, address auto-formatting, approximate privacy circle for workers, and route line for active tracking. (Observed: `chamba_interactive_map.dart` integrated into `PostJobScreen`, `SendBidScreen`, and `JobTrackingScreen`).
- [x] `TASK-05`: InDrive Negotiation Lifecycle: Complete state and UI for post job -> bids -> counter-offer -> accept -> chat -> tracking stepper -> 4-digit confirmation PIN -> payment choice (Efectivo/Yape/Plin) -> 5-star review, with cancellations and empty states. (Observed: full lifecycle verified in unit tests and manual emulator run).
- [x] `TASK-06`: Visual Polish & Stitch Parity: Ensure all screens match Stitch typography, elevations, rounded corners (8px/16px/24px/full), and 52px action buttons. (Observed: Stitch Core tokens and components preserved and polished).
- [x] `TASK-07`: Mobile MCP Real Device Testing: Launch app on `Medium_Phone`, perform end-to-end user journeys for both Client and Worker, take screenshots, and verify interactions. (Observed: APK built and executed on emulator-5554, 15+ automated taps/screenshots across all flows).
- [x] `TASK-08`: Static Analysis, Automated Tests & Audit Matrix: Run `flutter analyze` and `flutter test`, expand widget tests, and provide final Stitch vs Flutter verification matrix. (Observed: `flutter analyze` 0 issues, 14/14 `flutter test` passing).

## Verification Evidence & Progress
- TDD Mode: Standard functional verification (`flutter analyze` + `flutter test` + Mobile MCP emulator testing).
- Flutter analyze: 0 issues found (ran in 1.4s).
- Flutter test: 14 tests passing across unit, state lifecycle, and presentation shell tests.
- Real Emulator Evidence: Successfully validated on Android emulator `Medium_Phone` (Android 36 API) with package `pe.chamba.chamba`.
