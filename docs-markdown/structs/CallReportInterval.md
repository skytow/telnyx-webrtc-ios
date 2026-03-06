**STRUCT**

# `CallReportInterval`

```swift
public struct CallReportInterval: Codable
```

Statistics collected during a single reporting interval

## Properties
### `intervalStartUtc`

```swift
public let intervalStartUtc: String
```

### `intervalEndUtc`

```swift
public let intervalEndUtc: String
```

### `audio`

```swift
public let audio: AudioStats?
```

### `connection`

```swift
public let connection: ConnectionStats?
```

## Methods
### `init(intervalStartUtc:intervalEndUtc:audio:connection:)`

```swift
public init(intervalStartUtc: String, intervalEndUtc: String, audio: AudioStats? = nil, connection: ConnectionStats? = nil)
```
