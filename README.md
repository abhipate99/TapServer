# TapServer
iOS Application to capture Http Requests

# TapServer

### Overview
iOS UI automation tap server using XCTest & XCUICoordinate APIs.

### Architecture
- GCDWebServer-based lightweight HTTP server
- UI test keeps server alive to accept requests
- Supports system-wide taps via XCUICoordinate
- Robust error handling & logging

### Setup
- Xcode 15+
- iOS 15+ simulator
- `xcodebuild test -scheme TapServerUITests ...`

### API
- POST /tap
- GET /health
- GET /info

### Testing
Use `curl` as shown in assessment for /tap and /health

### Known Limitations
- iOS sandbox prevents true system-wide taps on physical devices
- Works best on simulator

### Future Improvements
- Queue incoming requests
- Metrics logging
- Tap retries or validations
