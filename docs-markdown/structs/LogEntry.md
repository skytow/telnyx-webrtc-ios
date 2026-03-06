**STRUCT**

# `LogEntry`

```swift
public struct LogEntry: Codable
```

Log entry for debug information captured during a call

## Properties
### `timestamp`

```swift
public let timestamp: String
```

### `level`

```swift
public let level: String
```

### `message`

```swift
public let message: String
```

### `context`

```swift
public let context: [String: AnyCodable]?
```

## Methods
### `init(timestamp:level:message:context:)`

```swift
public init(timestamp: String, level: String, message: String, context: [String: AnyCodable]? = nil)
```
