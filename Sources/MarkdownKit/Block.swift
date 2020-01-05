
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

    public static func quote(_ content: [Block]) -> Block {
        .quote(Quote(content: content))
    }

    public static func code(_ literal: String, info: String? = nil) -> Block {
        .code(Code(literal: literal, info: info))
    }

    public static func custom(_ literal: String) -> Block {
        .custom(Custom(literal: literal))
    }

    public static func heading(_ content: [Inline], level: Heading.Level = .h1) -> Block {
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
}
