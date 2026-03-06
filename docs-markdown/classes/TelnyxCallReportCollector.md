**CLASS**

# `TelnyxCallReportCollector`

```swift
public class TelnyxCallReportCollector
```

Collects WebRTC statistics during a call and posts them to voice-sdk-proxy
at the end of the call for quality analysis and debugging.

Stats Collection Strategy (based on Twilio/Jitsi best practices):
- Collects stats at regular intervals (default 5 seconds)
- Stores cumulative values (packets, bytes) from WebRTC API
- Calculates averages for variable metrics (audio level, jitter, RTT)
- Uses in-memory buffer with size limits for long calls
- Posts aggregated stats to voice-sdk-proxy on call end

## Methods
### `init(config:logCollectorConfig:)`

```swift
public init(config: CallReportConfig = CallReportConfig(), logCollectorConfig: LogCollectorConfig = LogCollectorConfig())
```

### `start(peerConnection:)`

```swift
public func start(peerConnection: RTCPeerConnection)
```

Start collecting stats from the peer connection
- Parameter peerConnection: The RTCPeerConnection to monitor

#### Parameters

| Name | Description |
| ---- | ----------- |
| peerConnection | The RTCPeerConnection to monitor |

### `stop()`

```swift
public func stop()
```

Stop collecting stats and prepare for final report

### `postReport(summary:callReportId:host:voiceSdkId:)`

```swift
public func postReport(summary: CallReportSummary, callReportId: String, host: String, voiceSdkId: String? = nil)
```

Post the final collected stats to voice-sdk-proxy
- Parameters:
  - summary: Call summary information
  - callReportId: Call report ID from REGED message
  - host: WebSocket host URL (will be converted to HTTP)
  - voiceSdkId: Optional voice SDK ID

#### Parameters

| Name | Description |
| ---- | ----------- |
| summary | Call summary information |
| callReportId | Call report ID from REGED message |
| host | WebSocket host URL (will be converted to HTTP) |
| voiceSdkId | Optional voice SDK ID |

### `addLogEntry(level:message:context:)`

```swift
public func addLogEntry(level: String, message: String, context: [String: Any]? = nil)
```

Add a structured log entry to the call report.
- Parameters:
  - level: Log level (e.g. "info", "warn", "error")
  - message: Human-readable event description
  - context: Optional dictionary with structured event data

#### Parameters

| Name | Description |
| ---- | ----------- |
| level | Log level (e.g. “info”, “warn”, “error”) |
| message | Human-readable event description |
| context | Optional dictionary with structured event data |

### `getStatsBuffer()`

```swift
public func getStatsBuffer() -> [CallReportInterval]
```

Get the current stats buffer (for debugging)
- Returns: Array of collected intervals

### `getLogs()`

```swift
public func getLogs() -> [LogEntry]
```

Get the collected logs (for debugging)
- Returns: Array of log entries

### `cleanup()`

```swift
public func cleanup()
```

Clean up resources (call after postReport)
