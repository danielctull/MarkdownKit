
struct NilValueFound: Error {}

func Unwrap<Value>(_ value: @autoclosure () throws -> Value?) throws -> Value {
    guard let value = try value() else { throw NilValueFound() }
    return value
}
