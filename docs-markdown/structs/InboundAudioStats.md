**STRUCT**

# `InboundAudioStats`

```swift
public struct InboundAudioStats: Codable
```

Statistics for inbound audio stream

## Properties
### `packetsReceived`

```swift
public let packetsReceived: Int?
```

### `bytesReceived`

```swift
public let bytesReceived: Int?
```

### `packetsLost`

```swift
public let packetsLost: Int?
```

### `packetsDiscarded`

```swift
public let packetsDiscarded: Int?
```

### `jitterBufferDelay`

```swift
public let jitterBufferDelay: Double?
```

### `jitterBufferEmittedCount`

```swift
public let jitterBufferEmittedCount: Int?
```

### `totalSamplesReceived`

```swift
public let totalSamplesReceived: Int?
```

### `concealedSamples`

```swift
public let concealedSamples: Int?
```

### `concealmentEvents`

```swift
public let concealmentEvents: Int?
```

### `audioLevelAvg`

```swift
public let audioLevelAvg: Double?
```

### `jitterAvg`

```swift
public let jitterAvg: Double?
```

### `bitrateAvg`

```swift
public let bitrateAvg: Double?
```

## Methods
### `init(packetsReceived:bytesReceived:packetsLost:packetsDiscarded:jitterBufferDelay:jitterBufferEmittedCount:totalSamplesReceived:concealedSamples:concealmentEvents:audioLevelAvg:jitterAvg:bitrateAvg:)`

```swift
public init(
    packetsReceived: Int? = nil,
    bytesReceived: Int? = nil,
    packetsLost: Int? = nil,
    packetsDiscarded: Int? = nil,
    jitterBufferDelay: Double? = nil,
    jitterBufferEmittedCount: Int? = nil,
    totalSamplesReceived: Int? = nil,
    concealedSamples: Int? = nil,
    concealmentEvents: Int? = nil,
    audioLevelAvg: Double? = nil,
    jitterAvg: Double? = nil,
    bitrateAvg: Double? = nil
)
```
