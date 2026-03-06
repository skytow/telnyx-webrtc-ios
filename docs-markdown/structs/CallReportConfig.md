**STRUCT**

# `CallReportConfig`

```swift
public struct CallReportConfig
```

Configuration options for the call report collector

## Properties
### `enabled`

```swift
public let enabled: Bool
```

Enable or disable call report collection

### `interval`

```swift
public let interval: TimeInterval
```

Interval in seconds for collecting call statistics

## Methods
### `init(enabled:interval:)`

```swift
public init(enabled: Bool = true, interval: TimeInterval = 5.0)
```
