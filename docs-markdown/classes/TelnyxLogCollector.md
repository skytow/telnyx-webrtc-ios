**CLASS**

# `TelnyxLogCollector`

```swift
public class TelnyxLogCollector
```

Collects debug logs during a call for inclusion in call reports

## Methods
### `init(config:)`

```swift
public init(config: LogCollectorConfig = LogCollectorConfig())
```

### `start()`

```swift
public func start()
```

Start capturing logs

### `stop()`

```swift
public func stop()
```

Stop capturing logs

### `addEntry(level:message:context:)`

```swift
public func addEntry(level: String, message: String, context: [String: Any]? = nil)
```

Add a log entry if capturing is active and level passes filter
- Parameters:
  - level: Log level ("debug", "info", "warn", "error")
  - message: Log message
  - context: Optional context dictionary

#### Parameters

| Name | Description |
| ---- | ----------- |
| level | Log level (“debug”, “info”, “warn”, “error”) |
| message | Log message |
| context | Optional context dictionary |

### `getLogs()`

```swift
public func getLogs() -> [LogEntry]
```

Get all collected logs (non-destructive)
- Returns: Array of log entries

### `drain()`

```swift
public func drain() -> [LogEntry]
```

Atomically returns all logs and clears the buffer.
Used by intermediate flushes so logs are not re-sent.
- Returns: Array of log entries that were in the buffer

### `getLogCount()`

```swift
public func getLogCount() -> Int
```

Get the number of collected logs
- Returns: Number of log entries in buffer

### `clear()`

```swift
public func clear()
```

Clear the buffer

### `isActive()`

```swift
public func isActive() -> Bool
```

Check if collector is currently capturing
- Returns: True if capturing, false otherwise

### `isEnabled()`

```swift
public func isEnabled() -> Bool
```

Check if collector is enabled
- Returns: True if enabled, false otherwise
