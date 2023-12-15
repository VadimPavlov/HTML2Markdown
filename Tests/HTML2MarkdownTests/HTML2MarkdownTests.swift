import XCTest
@testable import HTML2Markdown

final class HTML2MarkdownTests: XCTestCase {
    
    let converter = HTML2Markdown(unorderedListSymbol: "•")
    
    func testHeaders() {
        let h = "<h1>Header 1</h1><h3>Header 3</h3><h6>Header 6</h6>"
        XCTAssertEqual(try converter.markdown(html: h), "# Header 1\n\n### Header 3\n\n###### Header 6")
    }
    
    func testParagraphs() {
        let f = "<p>First</p>"
        let s = "<p>First</p><p>Second</p>"
        let t = "<p>First</p>Text<p>Second</p>"
        XCTAssertEqual(try converter.markdown(html: f), "First")
        XCTAssertEqual(try converter.markdown(html: s), "First\n\nSecond")
        XCTAssertEqual(try converter.markdown(html: t), "First\n\nText\n\nSecond")
    }
    
    func testLineBreak() {
        let br = "Line<br/>Break"
        let pb = "<p>Line<br/></p><p>Break</p>"
        XCTAssertEqual(try converter.markdown(html: br), "Line\nBreak")
        XCTAssertEqual(try converter.markdown(html: pb), "Line\n\nBreak")
    }
    
    func testBold() throws {
        let b = "<b>Bold</b>"
        let s = "<strong>Strong</strong>"
        XCTAssertEqual(try converter.markdown(html: b), "**Bold**")
        XCTAssertEqual(try converter.markdown(html: s), "**Strong**")
    }
    
    func testItalic() {
        let i = "<i>Italic</i>"
        let e = "<em>Emphasis</em>"
        XCTAssertEqual(try converter.markdown(html: i), "*Italic*")
        XCTAssertEqual(try converter.markdown(html: e), "*Emphasis*")
    }
    
    func testAnchor() {
        let a = #"<a href="htpps://apple.com">link</a>"#
        let l = #"<a ref="htpps://apple.com">link</a>"#
        XCTAssertEqual(try converter.markdown(html: a), "[link](htpps://apple.com)")
        XCTAssertEqual(try converter.markdown(html: l), "link")
    }
    
    func testUnorderedList() {
        let ul1 = "<ul><li>one</li><li>two</li><li>three</li></ul>"
        let ul2 = "first<ul><li>one</li><li>two</li><li>three</li></ul>"
        let ul3 = "<ul><li>one</li><li>two</li><li>three</li></ul>last"
        XCTAssertEqual(try converter.markdown(html: ul1), "• one\n• two\n• three")
        XCTAssertEqual(try converter.markdown(html: ul2), "first\n\n• one\n• two\n• three")
        XCTAssertEqual(try converter.markdown(html: ul3), "• one\n• two\n• three\n\nlast")
    }
    
    func testOrderedList() {
        let ol1 = "<ol><li>one</li><li>two</li><li>three</li></ol>"
        let ol2 = "first<ol><li>one</li><li>two</li><li>three</li></ol>"
        let ol3 = "<ol><li>one</li><li>two</li><li>three</li></ol>last"
        XCTAssertEqual(try converter.markdown(html: ol1), "1. one\n2. two\n3. three")
        XCTAssertEqual(try converter.markdown(html: ol2), "first\n\n1. one\n2. two\n3. three")
        XCTAssertEqual(try converter.markdown(html: ol3), "1. one\n2. two\n3. three\n\nlast")
    }
    
    func testTable() {
        let table = "<table><tr><td>R1C1</td><td>R1C2</td><td>R1C3</td></tr><tr><td>R2C1</td><td>R2C2</td><td>R3C2</td></tr><tr><td>R3C1</td><td>R3C2</td><td>R3C3</td></tr></table>"
        let tb = """
        |   |   |   |
        |---|---|---|
        | R1C1 | R1C2 | R1C3 |
        | R2C1 | R2C2 | R3C2 |
        | R3C1 | R3C2 | R3C3 |
        """
        XCTAssertEqual(try converter.markdown(html: table), tb)
    }
    
    func testNested() {
        let html = """
<h1>Header 1</h1><h3>Header 3</h3><h6>Header 6</h6><p>Normal text</p><p><b>Bold Text</b></p><p><i>Italic</i></p><p><b><i>Bold Italic text</i></b></p><ul><li><p>Unordered</p></li><li><p>List</p></li></ul><ol><li><p>One</p></li><li><p>Two</p></li><li><p>Three</p></li></ol><p><br></p><table><tbody><tr><td>R1C1</td><td>R1C2</td></tr><tr><td>R2C2</td><td>R2C2</td></tr></tbody></table>
"""
        let markdown = """
# Header 1\n\n### Header 3\n\n###### Header 6\n\nNormal text\n\n**Bold Text**\n\n*Italic*\n\n***Bold Italic text***\n\n• Unordered\n• List\n\n1. One\n2. Two\n3. Three\n\n|   |   |\n|---|---|\n| R1C1 | R1C2 |\n| R2C2 | R2C2 |
"""
        XCTAssertEqual(try converter.markdown(html: html), markdown)
    }
}
