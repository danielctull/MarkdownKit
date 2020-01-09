
public enum Inline {
    case code(Code)
    case custom(Custom)
    case emphasis(Emphasis)
    case html(HTML)
    case image(Image)
    case lineBreak
    case link(Link)
    case softBreak
    case strong(Strong)
    case text(Text)
}

// MARK: - Inline types

extension Inline {

    public struct Code {
        public let literal: String
    }

    public struct Custom {
        public let literal: String
    }

    public struct Emphasis {
        public let content: [Inline]
    }

    public struct HTML {
        public let literal: String
    }

    public struct Image {
        public let title: String?
        public let url: String?
        public let content: [Inline]
    }

    public struct Link {
        public let title: String?
        public let url: String?
        public let content: [Inline]
    }

    public struct Strong {
        public let content: [Inline]
    }

    public struct Text {
        public let literal: String
    }
}

// MARK: - Equatable

extension Inline: Equatable {}
extension Inline.Code: Equatable {}
extension Inline.Custom: Equatable {}
extension Inline.Emphasis: Equatable {}
extension Inline.HTML: Equatable {}
extension Inline.Image: Equatable {}
extension Inline.Link: Equatable {}
extension Inline.Strong: Equatable {}
extension Inline.Text: Equatable {}

// MARK: - Creating Inline values

extension Inline {

    public static func code(_ literal: String) -> Inline {
        .code(Code(literal: literal))
    }

    public static func custom(_ literal: String) -> Inline {
        .custom(Custom(literal: literal))
    }

    public static func emphasis(_ content: [Inline]) -> Inline {
        .emphasis(Emphasis(content: content))
    }

    public static func html(_ text: String) -> Inline {
        .html(HTML(literal: text))
    }

    public static func image(title: String? = nil,
                             url: String? = nil,
                             content: [Inline]) -> Inline {
        .image(Image(title: title, url: url, content: content))
    }

    public static func link(title: String? = nil,
                            url: String? = nil,
                            content: [Inline]) -> Inline {
        .link(Link(title: title, url: url, content: content))
   }

    public static func strong(_ content: [Inline]) -> Inline {
        .strong(Strong(content: content))
    }

    public static func text(_ text: String) -> Inline {
        .text(Text(literal: text))
    }
}
