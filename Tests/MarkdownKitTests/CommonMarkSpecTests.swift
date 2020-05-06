
import MarkdownKit
import XCTest

struct Test: Codable {
    let section: String
    let example: Int
    let markdown: String
    let html: String
}

final class CommonMarkSpecTests: XCTestCase {

    func test() throws {
        let data = try Unwrap(commonMarkSpec.data(using: .utf8))
        let tests = try JSONDecoder().decode([Test].self, from: data)
        var failures: [Failure] = []
        for test in tests {
            do {
                try runTest(test)
            } catch let failure as Failure {
                failures.append(failure)
            }
        }
        XCTAssertEqual(failures.count, 0)
    }

    struct Failure: Error {
        let test: Test
        let markdown: Markdown
    }

    private func runTest(_ test: Test) throws {
        let markdown = try Markdown(string: test.markdown)
        if markdown.html != test.html.unescape {
            print("=========")
            print("Test #\(test.example)")
            print("FAILED")
            print("test.markdown: \(test.markdown)")
            print("test.html:     \(test.html)")
            print("markdown.html: \(markdown.html)")
            throw Failure(test: test, markdown: markdown)
        }
    }
}

extension String {

    fileprivate var unescape: String {

        var result = self
        let mapping = [
            "&amp;": "&",
            "&lt;": "<",
            "&gt;": ">",
            "&quot;": "\"",
            "&apos;": "'"
        ]

        for item in mapping {
            result = result.replacingOccurrences(of: item.key, with: item.value, options: .literal)
        }

        return result
    }
}
