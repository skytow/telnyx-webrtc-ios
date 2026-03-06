## Call Reports

The iOS SDK automatically collects WebRTC statistics and structured call lifecycle logs during calls, then posts them to the Telnyx `voice-sdk-proxy` when calls end. This feature helps diagnose call quality issues and provides insights into call performance.

### Overview

Call Reports consist of three main components:

1. **Summary** - Call metadata (duration, direction, timestamps, SDK version)
2. **Stats** - WebRTC statistics collected at regular intervals during the call
3. **Logs** - Structured call lifecycle events (state changes, ICE events, etc.)

The collected data is automatically posted to the `/call_report` endpoint on `voice-sdk-proxy` when calls end, enabling comprehensive call quality analysis and troubleshooting.

### Enabling Call Reports

Call Reports are **enabled by default**. You can configure the feature through `TxConfig`:

```swift
let txConfig = TxConfig(
    sipUser: sipUser,
    password: password,
    pushDeviceToken: "DEVICE_APNS_TOKEN",
    enableCallReports: true,          // Enable/disable feature (default: true)
    callReportInterval: 5.0,          // Stats collection interval in seconds (default: 5s)
    callReportLogLevel: "debug",      // Minimum log level filter (default: "debug")
    callReportMaxLogEntries: 1000     // Max log buffer size (default: 1000)
)
```

### Configuration Options

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `enableCallReports` | Bool | `true` | Enable/disable automatic call quality reporting |
| `callReportInterval` | TimeInterval | `5.0` | Interval in seconds for collecting WebRTC statistics |
| `callReportLogLevel` | String | `"debug"` | Minimum log level to capture (`"debug"`, `"info"`, `"warn"`, `"error"`) |
| `callReportMaxLogEntries` | Int | `1000` | Maximum number of log entries to buffer per call |

### Collected Statistics

#### Inbound Audio Statistics (per interval)

- `packetsReceived` - Total packets received
- `bytesReceived` - Total bytes received
- `packetsLost` - Packets lost during transmission
- `packetsDiscarded` - Packets discarded by jitter buffer
- `jitterBufferDelay` - Total jitter buffer delay
- `jitterBufferEmittedCount` - Samples emitted from jitter buffer
- `totalSamplesReceived` - Total audio samples received
- `concealedSamples` - Samples concealed due to packet loss
- `concealmentEvents` - Number of concealment events
- `audioLevelAvg` - Average audio level (calculated)
- `jitterAvg` - Average jitter (calculated)
- `bitrateAvg` - Average bitrate (calculated)

#### Outbound Audio Statistics (per interval)

- `packetsSent` - Total packets sent
- `bytesSent` - Total bytes sent
- `audioLevelAvg` - Average audio level (calculated)
- `bitrateAvg` - Average bitrate (calculated)

#### Connection Statistics (per interval)

- `roundTripTimeAvg` - Average round-trip time
- `packetsSent` - Total packets sent
- `packetsReceived` - Total packets received
- `bytesSent` - Total bytes sent
- `bytesReceived` - Total bytes received

### Structured Log Events

The SDK captures the following call lifecycle events:

| Event | Context Fields |
|-------|----------------|
| Call started | `callId`, `direction` |
| Call state changed | `state`, `reason` |
| Call ended | `cause`, `causeCode`, `sipCode`, `sipReason` |
| ICE connection state changed | `state`, `previousState` |
| Signaling state changed | `state` |
| ICE gathering state changed | `state` |

### Report Format

When a call ends, the SDK posts a JSON report to `https://rtc.telnyx.com/call_report`:

#### Request Headers

```
Content-Type: application/json
x-call-report-id: <call_report_id from REGED>
x-call-id: <call_uuid>
x-voice-sdk-id: <voice_sdk_id>
```

#### Request Body

```json
{
  "summary": {
    "callId": "uuid",
    "direction": "inbound",
    "state": "done",
    "durationSeconds": 13.46,
    "startTimestamp": "2026-02-19T14:04:02.691Z",
    "endTimestamp": "2026-02-19T14:04:16.153Z",
    "sdkVersion": "3.0.0",
    "platform": "iOS",
    "osVersion": "17.0",
    "deviceModel": "iPhone 15 Pro"
  },
  "stats": [
    {
      "intervalStartUtc": "2026-02-19T14:04:02.691Z",
      "intervalEndUtc": "2026-02-19T14:04:07.691Z",
      "audio": {
        "inbound": {
          "packetsReceived": 250,
          "bytesReceived": 40000,
          "packetsLost": 2,
          "jitterAvg": 0.012,
          "audioLevelAvg": 0.65
        },
        "outbound": {
          "packetsSent": 250,
          "bytesSent": 40000,
          "audioLevelAvg": 0.70
        }
      },
      "connection": {
        "roundTripTimeAvg": 0.045,
        "packetsSent": 250,
        "packetsReceived": 250
      }
    }
  ],
  "logs": [
    {
      "timestamp": "2026-02-19T14:04:02.691Z",
      "level": "info",
      "message": "Call started",
      "context": {
        "callId": "uuid",
        "direction": "inbound"
      }
    },
    {
      "timestamp": "2026-02-19T14:04:03.123Z",
      "level": "debug",
      "message": "ICE connection state changed",
      "context": {
        "state": "connected",
        "previousState": "checking"
      }
    }
  ]
}
```

#### Intermediate Segment Flushing (Long Calls)

For very long calls (>25 minutes), the SDK automatically flushes intermediate report segments to prevent memory issues:

```json
{
  "summary": { ... },
  "stats": [ ... ],
  "logs": [ ... ],
  "segment": 0  // Present only for intermediate flushes
}
```

### Authentication Flow

1. SDK connects to `voice-sdk-proxy` via WebSocket
2. On `REGED` message, proxy generates:
   - `call_report_id` (encodes user_id)
   - `voice_sdk_id` (SDK instance identifier)
3. SDK stores both IDs from the Socket
4. When call ends, SDK posts report with headers:
   - `x-call-report-id`
   - `x-call-id`
   - `x-voice-sdk-id`
5. Proxy decodes `user_id` from token — works even after WebSocket disconnects

### Call Lifecycle Integration

#### Initialization
- `TelnyxCallReportCollector` and `TelnyxLogCollector` created at Call initialization
- Captures pre-ACTIVE events (call started, signaling state changes)

#### ACTIVE State
- Stats collection timer starts (default: 5-second intervals)
- ICE connection state logging begins
- Peer event logging wired (`onSignalingStateChangeForLog`, `onIceGatheringStateChangeForLog`)

#### Long Calls
- Automatic intermediate segment flush when:
  - ~25 minutes of stats collected (~300 intervals)
  - ~800 log entries buffered
- Prevents memory issues on very long calls

#### DONE / DROPPED State
- Collector stops stats collection
- Final report posted asynchronously with retry logic
- Report includes complete call summary and all collected data

### Reliability Features

#### Retry Logic
- 3 retry attempts with exponential backoff (1s, 2s, 4s)
- Retries only on 5xx server errors or network errors
- 4xx errors are not retried (client errors)

#### Self-Signed Certificate Support
- Custom URLSession delegate handles self-signed certificates
- Matches WebSocket behavior for consistency

#### Buffer Limits
- Maximum 360 stats intervals (~30 minutes at 5s intervals)
- Maximum 1000 log entries (configurable via `callReportMaxLogEntries`)
- Automatic segment flushing prevents buffer overflow

### Relationship to Other Features

#### vs. `debug` Flag (WebRTCStatsReporter)
- **Call Reports** (`enableCallReports`):
  - Collects stats during call, posts aggregate report at end
  - Enabled by default
  - Works independently of WebSocket connection
  - Designed for post-call analysis and troubleshooting

- **Debug Mode** (`debug: true`):
  - Streams real-time stats via WebSocket during call
  - Disabled by default
  - Requires active WebSocket connection
  - Designed for live monitoring and debugging

Both features can coexist and operate independently.

#### vs. Call Quality Metrics (`enableQualityMetrics`)
- **Call Reports**: Post-call aggregated statistics sent to voice-sdk-proxy
- **Call Quality Metrics**: Real-time MOS/jitter/RTT metrics via `onCallQualityChange` callback

### Disabling Call Reports

To disable Call Reports (e.g., for privacy or bandwidth reasons):

```swift
let txConfig = TxConfig(
    sipUser: sipUser,
    password: password,
    enableCallReports: false  // Disable call reports
)
```

When disabled:
- No stats collection during calls
- No POST requests to `/call_report` endpoint
- Reduced memory usage and network traffic

### Best Practices

1. **Leave Enabled by Default**
   - Call Reports are designed to be lightweight and non-intrusive
   - Valuable for troubleshooting and improving call quality
   - Minimal performance impact (5-second collection intervals)

2. **Adjust Interval for Specific Use Cases**
   - Shorter intervals (e.g., 2s) for detailed analysis
   - Longer intervals (e.g., 10s) for reduced overhead

3. **Configure Log Level Appropriately**
   - `"debug"` - Full detail (default, recommended for development)
   - `"info"` - Important events only
   - `"warn"` - Warnings and errors
   - `"error"` - Errors only

4. **Monitor Long Calls**
   - Intermediate segment flushing handles long calls automatically
   - No manual intervention required

5. **Combine with Other Features**
   - Use with `enableQualityMetrics` for real-time user feedback
   - Use with `debug: true` for live troubleshooting during development

### Troubleshooting

#### Reports Not Being Sent

1. Verify `enableCallReports: true` in `TxConfig`
2. Check console logs for `TelnyxCallReportCollector` messages
3. Ensure call reached `ACTIVE` state (reports only sent for active calls)
4. Verify network connectivity when call ends

#### Missing Data in Reports

1. Check `callReportLogLevel` - may be filtering out events
2. Verify `callReportMaxLogEntries` - may be hitting buffer limit
3. For long calls, check for intermediate segment flushes

#### Authentication Errors

1. Ensure valid SIP credentials in `TxConfig`
2. Verify WebSocket connection established (check for `REGED` message)
3. Check that `call_report_id` and `voice_sdk_id` are present in Socket

### Console Log Filtering

To see Call Report activity in Xcode console:

```
Filter by: TelnyxCallReportCollector
```

Example logs:
```
TelnyxCallReportCollector: Stats collection started (interval: 5.0s)
TelnyxCallReportCollector: Collected stats for interval 0
TelnyxCallReportCollector: Collected stats for interval 1
TelnyxCallReportCollector: Payload: {"summary":{...},"stats":[...],"logs":[...]}
TelnyxCallReportCollector: Successfully posted call report
```

### Related Documentation

- [WebRTC Statistics](../webrtc-stats/webrtc-stats.md) - Real-time stats streaming
- [TxConfig](../structs/TxConfig.md) - SDK configuration options
- [Call Quality Metrics](../structs/CallQualityMetrics.md) - Real-time quality monitoring

### Related Pull Requests

- iOS Implementation: [PR #325](https://github.com/team-telnyx/telnyx-webrtc-ios/pull/325)
- Web Implementation: [PR #494](https://github.com/team-telnyx/webrtc/pull/494)
- voice-sdk-proxy: [PR #76](https://github.com/team-telnyx/voice-sdk-proxy/pull/76)
- voice-sdk-debug: [PR #24](https://github.com/team-telnyx/voice-sdk-debug/pull/24)

---
