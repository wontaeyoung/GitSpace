// MARK: -Process
/// 1. TextEditor에 쓰일 Font를 전달받는다
/// 2. Font를 UIFont로 변환한 연산 프로퍼티를 통해 텍스트 한 줄의 높이를 계산한다 (lineHeight)
/// 3. 행간을 추가로 max 높이에 더해주기 위해 줄 간격을 필수 파라미터로 받는다
/// 4. Font 높이, 라인 갯수, 행간, 여유공간을 모두 더해서 TextEditor 높이를 실시간으로 업데이트한다
///

// MARK: -Memo
/// 1. Font 이니셜라이저를 통해 UIFont -> Font 타입으로 변환
///     Font.init(font: CTFont(UIFont 타입))
/// 2. Font -> UIFont 타입으로 변환
///     UIFont.preferredFont(from: Font(스유 Font 타입))

import SwiftUI

struct GSTextEditor {
    
    // MARK: Style Enum
    enum GSTextEditorStyle {
        case message
    }
    
    // MARK: -View
    struct CustomTextEditorView: View {
        
        // MARK: -Properties
        // MARK: Stored Properties
        let style: GSTextEditorStyle
        let text: Binding<String>
        let font: Font
        let lineSpace: CGFloat
        let const = Constant.TextEditorConst.self
        @State private var textEditorHeight: CGFloat = 0
        
        // MARK: Computed Properties
        // font 사이즈 관련 프로퍼티를 활용하기 위해 Font -> UIFont로 변환
        private var mainUIFont: UIFont {
            return UIFont.fontToUIFont(from: .body)
        }
        
        // font의 한 줄 높이를 계산하는 프로퍼티
        private var mainFontLineHeight: CGFloat {
            return mainUIFont.lineHeight
        }
        
        // TextEditor가 5줄을 초과했는지 검사하기 위한 프로퍼티
        private var maxTextEditorHeight: CGFloat {
            return mainFontLineHeight * CGFloat(const.TEXTEDITOR_MAX_LINE_COUNT)
        }
        
        /// 현재 text가 몇 줄인지 반환하는 프로퍼티
        /// 개행문자 갯수 + 1 = maxLineCount
        /// 개행문자가 maxNewLineCount개 초과일 때, 해당 갯수로 고정
        /// 입력이 없을 때도 한 줄에 대한 최소 높이가 필요하므로 + 1
        private var newLineCounter: Int {
            let currentText: String = text.wrappedValue
            let currentNewLineCount: Int = currentText.filter{$0 == "\n"}.count
            let maxNewLineCount: Int = const.TEXTEDITOR_MAX_LINE_COUNT - 1
            return (currentNewLineCount > maxNewLineCount
                    ? maxNewLineCount
                    : currentNewLineCount) + 1
        }
        
        // MARK: Init
        /// 파라미터 font = .body, lineSpace = 2 기본값 지정
        init (
            style: GSTextEditorStyle,
            text: Binding<String>,
            font: Font = .body,
            lineSpace: CGFloat = 2
        ) {
            self.style = style
            self.text = text
            self.font = font
            self.lineSpace = lineSpace
        }
        
        // MARK: -Methods
        // MARK: Method - 시작 textEditor 높이를 세팅해주는 메서드
        private func setTextEditorStartHeight() {
            textEditorHeight = mainFontLineHeight + const.TEXTEDITOR_FRAME_HEIGHT_FREESPACE
        }
        
        // MARK: Method - line count를 통해 textEditor 현재 높이를 계산해서 업데이트하는 메서드
        // TextEditor (줄 갯수 * 폰트 높이) + (줄 갯수 * 자간) + 잘림 방지 여유 공간
        private func updateTextEditorCurrentHeight() {
            textEditorHeight =
            (CGFloat(newLineCounter) * mainFontLineHeight)
            + (CGFloat(newLineCounter) * lineSpace)
            + const.TEXTEDITOR_FRAME_HEIGHT_FREESPACE
        }
        
        var body: some View {
            switch style {
            case .message:
                TextEditor(text: text)
                    .font(font)
                    .lineSpacing(lineSpace)
                    .frame(maxHeight: textEditorHeight)
                    .padding(.horizontal, const.TEXTEDITOR_INSET_HORIZONTAL)
                    .padding(.bottom, -3)
                    .overlay {
                        RoundedRectangle(cornerRadius: const.TEXTEDITOR_STROKE_CORNER_RADIUS)
                            .stroke()
                            .foregroundColor(.gsGray2)
                    }
                    .onAppear {
                        setTextEditorStartHeight()
                    }
                    .onChange(of: newLineCounter) { n in
                        updateTextEditorCurrentHeight()
                    }
            }
        }
    }
    
    
    
    
}
