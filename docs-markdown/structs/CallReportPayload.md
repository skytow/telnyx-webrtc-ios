**STRUCT**

# `CallReportPayload`

```swift
public struct CallReportPayload: Codable
```

Complete call report payload sent to voice-sdk-proxy

## Properties
### `summary`

```swift
public let summary: CallReportSummary
```

### `stats`

```swift
public let stats: [CallReportInterval]
```

### `logs`

```swift
public let logs: [LogEntry]?
```

### `segment`

```swift
public let segment: Int?
```

## Methods
### `init(summary:stats:logs:segment:)`

```swift
public init(summary: CallReportSummary, stats: [CallReportInterval], logs: [LogEntry]? = nil, segment: Int? = nil)
```
