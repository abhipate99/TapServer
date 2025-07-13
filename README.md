# 📱 TapServer – Coordinate-Based iOS Tap Server

This project is a response to the **iOS Automation Take-Home Assessment** provided by Quinnox.

> **Disclaimer**: I do not have direct experience in iOS automation or XCTest. I have completed this assignment with the help of AI tools and online resources, while also managing time constraints due to ongoing interviews. Feedback is welcome and appreciated.

---

## 🧩 Overview

TapServer is a lightweight iOS app and UI test suite that launches a persistent HTTP server capable of accepting JSON-based `/tap` requests and simulating screen taps at absolute coordinates. It is implemented using `XCUITest` and `GCDWebServer`.

---

## 🏗 Architecture

- **Main App Target (`TapServer`)**: Empty minimal app, required to fulfill test launch.
- **UI Test Target (`TapServerUITests`)**:
  - Implements HTTP server via `GCDWebServer`
  - Responds to `/tap`, `/health`, and `/info` endpoints
  - Uses `XCUICoordinate` to simulate taps anywhere on the screen

---

## ⚙️ Setup Instructions

### 🔧 Requirements

- Xcode 15+
- iOS 15+ Simulator
- Swift 5.5+
- CocoaPods or Swift Package Manager

### 💡 Project Setup

If using CocoaPods:
```bash
sudo gem install cocoapods
pod install
open TapServer.xcworkspace
```

If using Swift Package Manager:
- Open the project in Xcode
- Go to **File > Add Packages...**
- Add: `https://github.com/swisspol/GCDWebServer.git`

---

## 🚀 Run the Server

```bash
xcodebuild test -scheme TapServerUITests \
  -destination "platform=iOS Simulator,name=iPhone 15" \
  -testPlan TapServerTests
```

The server runs on port `8100`.

---

## 📡 API Documentation

### 📍 `POST /tap`

**Request:**
```json
{
  "x": 120,
  "y": 250,
  "bundleId": "com.apple.Maps" // optional
}
```

**Success Response:**
```json
{
  "status": "success",
  "message": "Tap executed at coordinates (120, 250)",
  "timestamp": "2025-07-13T10:00:00Z"
}
```

**Error Types:**
- `INVALID_JSON`
- `MISSING_COORDINATES`
- `INVALID_COORDINATES`
- `TAP_EXECUTION_FAILED`
- `APP_NOT_FOUND`

---

### 🩺 `GET /health`

Returns server health and uptime.

```json
{
  "status": "running",
  "uptime_seconds": 132,
  "requests_handled": 4
}
```

---

### ℹ️ `GET /info`

Returns server and screen info.

```json
{
  "server_version": "1.0.0",
  "supported_endpoints": ["/tap", "/health", "/info"],
  "screen_dimensions": { "width": 1170, "height": 2532 }
}
```

---

## 🧪 Testing the Endpoints

```bash
# Tap test
curl -X POST http://localhost:8100/tap \
  -H "Content-Type: application/json" \
  -d '{"x": 100, "y": 300}'

# Invalid tap
curl -X POST http://localhost:8100/tap \
  -H "Content-Type: application/json" \
  -d '{"x": "invalid", "y": 300}'

# Health check
curl http://localhost:8100/health
```

---

## 🚧 Limitations

- Tested only on simulator.
- No validation for out-of-screen bounds.
- Basic queueing and logging implemented; no concurrency protection.
- May require foreground simulator window for XCUICoordinate to respond correctly.

---

## 🌱 Future Improvements

- Coordinate bounds validation
- Response time tracking
- App bundle ID validation
- Tap-and-hold / swipe gestures
- Background-safe server daemon via Launch Agent or real device test runner

---

## ⏱ Time Spent

Due to other interview engagements and lack of prior iOS automation experience, implementation and research were completed in ~6–8 hours spread across 2 days.

---

## 📬 Feedback

Please let me know if the implementation aligns with expectations, and feel free to share any suggestions or corrections. I also noticed the scope seems broader than what was discussed during the interview call — happy to clarify or iterate further if needed.

---

Thanks for reviewing the submission!
