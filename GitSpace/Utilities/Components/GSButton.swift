//
//  GSButton.swift
//  GitSpace
//
//  Created by 이승준 on 2023/01/20.
//

import SwiftUI

public struct GSButton {
	/**
	 각 버튼의 케이스에 따라 기본 레이아웃을 구성합니다.
	 - Important: 각 케이스는 연관 값을 갖고 있으며 `hometab` 케이스의 경우, 그 연관값을 **필수**로 입력해야 합니다.
	 `primary`와 `secondary` 케이스의 연관값은 필수가 아니며, 연관값을 할당하면 GSButton의 label 을 **비운 채로** UI를 그릴 수 있습니다.
	*/
	struct CustomButtonView<CustomLabelType: View>: View {
		public let style: GSButtonStyle
		public let action: () -> Void
		public var label: CustomLabelType?
		
		var body: some View {
			switch style {
				
				// MARK: DONE
			case .primary:
				Button(action: action) {
					if let label {
						label
							.labelHierarchyModifier(style: .primary)
					}
				}
				.buttonColorSchemeModifier(style: style)
				
				// MARK: - DONE
			case let .secondary(isDisabled):
				Button(action: action) {
					label
						.labelHierarchyModifier(
                            style: .secondary(
                                isDisabled: isDisabled
                            )
                        )
				}
				.buttonColorSchemeModifier(style: style)
				
				// MARK: - TODO : 태그 액션과 상태 기획 정리되면 추가
			case let .tag(isAppliedInView, isSelectedInAddTagSheet):
				Button(action: action) {
					label
						.labelHierarchyModifier(
							style: .tertiary(
                                isAppliedInView: isAppliedInView,
                                isSelectedInAddTagSheet: isSelectedInAddTagSheet
                            )
						)
				}
				.buttonColorSchemeModifier(style: style)
				
				// MARK: - DONE
			case let .plainText(isDestructive):
				Button(action: action) {
					label
						.foregroundColor(isDestructive ? .gsRed : Color.primary)
				}
				.buttonColorSchemeModifier(style: style)
				
				// MARK: - DONE
			case let .homeTab(tabName, tabSelection):
				Button(action: action) {
					label
						.overlay(alignment: .bottom) {
							if tabName == tabSelection.wrappedValue {
								Divider()
									.frame(minHeight: 2)
									.overlay(Color.primary)
									.offset(y: 3)
							}
						}
				}
			}
		}
		
		// Simple Initializer
		init(
			style: GSButtonStyle,
			action: @escaping () -> Void,
			@ViewBuilder label: () -> CustomLabelType
        ) {
            self.style = style
            self.action = action
            self.label = label()
        }
	}
}

struct Test2: View {
	private let starTab = "Starred"
	private let followTab = "Following"
	@State private var isDisabled = false
	@State private var isEditing = false
	@State private var isSelected = false
	
	@State private var selectedHomeTab = "Starred"
	@Environment(\.colorScheme) var colorScheme
	
	var body: some View {
		NavigationView {
			VStack {
                Text(isEditing.description)
                
                Button {
                    isDisabled.toggle()
                } label: {
                    Text("\(isDisabled.description)")
                }

                
                GSNavigationLink(style: .secondary()) {
                    Text("?")
                } label: {
                    Text("?")
                }
                
                GSButton.CustomButtonView(
                    style: .secondary(isDisabled: isDisabled)
                ) {
                    print("??")
                } label: {
                    Text("HI")
                }
                
                NavigationLink {
                    Text("?")
                } label: {
                    Text("?")
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .frame(minWidth: 80)
//                        .frame(maxHeight: maxHeight)
                }
                .buttonBorderShape(.capsule)
                .buttonStyle(.borderedProminent)

                Button {
                    print()
                } label: {
                    Text("?")
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .frame(minWidth: 80)
//                        .frame(maxHeight: maxHeight)
                }
                .buttonBorderShape(.capsule)
                .buttonStyle(.borderedProminent)
			}	
		}
	}
}

struct GSButton_Previews: PreviewProvider {
    static var previews: some View {
		Test2()
    }
}
