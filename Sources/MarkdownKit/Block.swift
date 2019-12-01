
public enum Block: Equatable {
    case quote(Quote)
    case code(Code)
    case custom(Custom)
    case heading(Heading)
    case html(HTML)
    case list(List)
    case paragraph(Paragraph)
    case thematicBreak
}

// MARK: - Block types

extension Block {

    public struct Quote: Equatable {
        public let content: [Block]
    }

    public struct Code: Equatable {
        public let literal: String
        public let info: String?

        public var language: String? {
            info?.split(separator: " ").first.map(String.init)
        }
    }

    public struct Custom: Equatable {
        public let literal: String
    }

    public struct Heading: Equatable {
        public let level: Level
        public let content: [Inline]
    }

    public struct HTML: Equatable {
        public let literal: String
    }

    public struct List: Equatable {
        public let kind: Kind
        public let tight: Bool
        public let items: [Item]
    }

    public struct Paragraph: Equatable {
        public let content: [Inline]
    }
}

extension Block.Heading {

    public enum Level: Equatable {
        case h1, h2, h3, h4, h5, h6
    }
}

extension Block.List {

    public enum Kind: Equatable {
        case ordered(start: Int)
        case unordered
    }

    public struct Item: Equatable {
        public let content: [Block]
        public init(content: [Block]) {
            self.content = content
        }
    }
}

// MARK: - Creating Block values

extension Block {

    public static func quote(items: [Block]) -> Block {
        .quote(Quote(content: items))
    }

    public static func code(_ text: String, info: String? = nil) -> Block {
        .code(Code(literal: text, info: info))
    }

    public static func custom(_ literal: String) -> Block {
        .custom(Custom(literal: literal))
    }

    public static func heading(level: Int = 1, content: [Inline]) -> Block {
        .heading(Heading(level: Heading.Level(level), content: content))
    }

    public static func html(_ text: String) -> Block {
        .html(HTML(literal: text))

    }

    public static func list(kind: List.Kind = .unordered,
                            tight: Bool = false,
                            items: [List.Item]) -> Block {
        .list(List(kind: kind, tight: tight, items: items))
    }

    public static func paragraph(text: [Inline]) -> Block {
        .paragraph(Paragraph(content: text))
    }
}

// MARK: - Conversion

extension Block.Heading.Level {

    public init(_ integer: Int) {
        switch integer {
        case 1: self = .h1
        case 2: self = .h2
        case 3: self = .h3
        case 4: self = .h4
        case 5: self = .h5
        case 6: self = .h6
        default: self = .h1
        }
    }
}

extension Int {

    public init(_ level: Block.Heading.Level) {
        switch level {
        case .h1: self = 1
        case .h2: self = 2
        case .h3: self = 3
        case .h4: self = 4
        case .h5: self = 5
        case .h6: self = 6
        }
    }
}
