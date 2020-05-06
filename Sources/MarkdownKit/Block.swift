
/// A markdown block element.
public enum Block {
    case code(Code)
    case custom(Custom)
    case heading(Heading)
    case html(HTML)
    case list(List)
    case paragraph(Paragraph)
    case quote(Quote)
    case thematicBreak
}

// MARK: - Block types

extension Block {

    public struct Code {
        public let literal: String
        public let info: String?
    }

    public struct Custom {
        public let literal: String
    }

    public struct Heading {
        public let level: Level
        public let content: [Inline]
    }

    public struct HTML {
        public let literal: String
    }

    public struct List {
        public let kind: Kind
        public let tight: Bool
        public let items: [Item]
    }

    public struct Paragraph {
        public let content: [Inline]
    }

    public struct Quote {
        public let content: [Block]
    }
}

extension Block.Code {

    public struct Language: RawRepresentable, Hashable {
        public let rawValue: String
        public init(rawValue: String) {
            self.rawValue = rawValue
        }
    }

    public var language: Language? {
        info?
            .split(separator: " ")
            .first
            .map(String.init)
            .map(Language.init(rawValue:))
    }
}

extension Block.Code.Language: ExpressibleByStringLiteral {

    public init(stringLiteral value: String) {
        self.init(rawValue: value)
    }
}

extension Block.Heading {

    public enum Level {
        case h1, h2, h3, h4, h5, h6
    }
}

extension Block.List {

    public struct Item {
        public let content: [Block]
        public init(content: [Block]) {
            self.content = content
        }
    }

    public enum Kind {
        case ordered(start: Int)
        case unordered
    }
}

// MARK: - Equatable

extension Block: Equatable {}
extension Block.Code: Equatable {}
extension Block.Custom: Equatable {}
extension Block.Heading: Equatable {}
extension Block.Heading.Level: Equatable {}
extension Block.HTML: Equatable {}
extension Block.List: Equatable {}
extension Block.List.Item: Equatable {}
extension Block.List.Kind: Equatable {}
extension Block.Paragraph: Equatable {}
extension Block.Quote: Equatable {}

// MARK: - Creating Block values

extension Block {

    public static func code(_ literal: String,
                            info: String? = nil) -> Block {
        .code(Code(literal: literal, info: info))
    }

    public static func custom(_ literal: String) -> Block {
        .custom(Custom(literal: literal))
    }

    public static func heading(_ content: [Inline],
                               level: Heading.Level = .h1) -> Block {
        .heading(Heading(level: level, content: content))
    }

    public static func html(_ literal: String) -> Block {
        .html(HTML(literal: literal))

    }

    public static func list(kind: List.Kind = .unordered,
                            tight: Bool = false,
                            items: [List.Item]) -> Block {
        .list(List(kind: kind, tight: tight, items: items))
    }

    public static func paragraph(_ content: [Inline]) -> Block {
        .paragraph(Paragraph(content: content))
    }

    public static func quote(_ content: [Block]) -> Block {
        .quote(Quote(content: content))
    }
}
