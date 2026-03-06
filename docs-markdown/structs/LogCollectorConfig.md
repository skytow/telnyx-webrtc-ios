**STRUCT**

# `LogCollectorConfig`

```swift
public struct LogCollectorConfig
```

Configuration options for the log collector

## Properties
### `enabled`

```swift
public let enabled: Bool
```

Enable or disable log collection

### `level`

```swift
public let level: String
```

Minimum log level to capture ("debug", "info", "warn", "error")

### `maxEntries`

```swift
public let maxEntries: Int
```

Maximum number of log entries to buffer

## Methods
### `init(enabled:level:maxEntries:)`

```swift
public init(enabled: Bool = true, level: String = "debug", maxEntries: Int = 1000)
```
