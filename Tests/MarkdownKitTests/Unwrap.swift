
struct NilValueFound: Error {}

func Unwrap<Value>(_ value: @autoclosure () throws -> Value?,
                   _ message: @autoclosure () -> String = "",
                   file: StaticString = #file,
                   line: UInt = #line) throws -> Value {

    guard let value = try value() else { throw NilValueFound() }
    return value
}
