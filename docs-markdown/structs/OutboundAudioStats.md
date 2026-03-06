**STRUCT**

# `OutboundAudioStats`

```swift
public struct OutboundAudioStats: Codable
```

Statistics for outbound audio stream

## Properties
### `packetsSent`

```swift
public let packetsSent: Int?
```

### `bytesSent`

```swift
public let bytesSent: Int?
```

### `audioLevelAvg`

```swift
public let audioLevelAvg: Double?
```

### `bitrateAvg`

```swift
public let bitrateAvg: Double?
```

## Methods
### `init(packetsSent:bytesSent:audioLevelAvg:bitrateAvg:)`

```swift
public init(packetsSent: Int? = nil, bytesSent: Int? = nil, audioLevelAvg: Double? = nil, bitrateAvg: Double? = nil)
```
