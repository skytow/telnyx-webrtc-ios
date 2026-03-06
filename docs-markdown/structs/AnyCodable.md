**STRUCT**

# `AnyCodable`

```swift
public struct AnyCodable: Codable
```

Helper type for encoding/decoding arbitrary JSON values

## Properties
### `value`

```swift
public let value: Any
```

## Methods
### `init(_:)`

```swift
public init(_ value: Any)
```

### `init(from:)`

```swift
public init(from decoder: Decoder) throws
```

#### Parameters

| Name | Description |
| ---- | ----------- |
| decoder | The decoder to read data from. |

### `encode(to:)`

```swift
public func encode(to encoder: Encoder) throws
```

#### Parameters

| Name | Description |
| ---- | ----------- |
| encoder | The encoder to write data to. |