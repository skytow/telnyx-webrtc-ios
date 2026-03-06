**STRUCT**

# `AudioStats`

```swift
public struct AudioStats: Codable
```

Combined audio statistics for a reporting interval

## Properties
### `outbound`

```swift
public let outbound: OutboundAudioStats?
```

### `inbound`

```swift
public let inbound: InboundAudioStats?
```

## Methods
### `init(outbound:inbound:)`

```swift
public init(outbound: OutboundAudioStats? = nil, inbound: InboundAudioStats? = nil)
```
