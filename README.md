# 📱 TapServer

A minimal UI automation tap server built using XCTest and GCDWebServer. It allows you to perform taps at absolute screen coordinates via an HTTP API, even when the app is backgrounded.

---

## 🚀 Overview

**TapServer** runs a persistent HTTP server inside an XCTest UI test target and supports absolute coordinate taps on the iOS simulator using `XCUICoordinate`. It's designed to simulate system-level taps for automation and remote control tasks.

---

## 🏗️ Architecture

- **XCTest-based UI Test** keeps the test runner alive indefinitely using `RunLoop.main.run()`
- **GCDWebServer** powers the HTTP server inside the UITest
- **XCUICoordinate API** is used to tap anywhere on the screen
- Requests are JSON-formatted and allow optional switching of foreground app via `bundleId`

---

## 🧰 Setup Instructions

### 📦 Prerequisites

- Xcode 15+
- iOS 15+ Simulator
- CocoaPods (with Ruby 3.1+)
- GCDWebServer installed via CocoaPods

### ⚙️ Installation

1. Clone the project:
   ```bash
   git clone <your-repo-url>
   cd TapServer
