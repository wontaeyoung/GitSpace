//
//  LabelModifier.swift
//  GitSpace
//
//  Created by 이승준 on 2023/02/03.
//

import SwiftUI

struct GSLabelModifier: ViewModifier {
	@Environment(\.colorScheme) var colorScheme
	
	let style: Constant.LabelHierarchy
	let maxHeight: CGFloat? = nil
	
	func body(content: Content) -> some View {
		switch style {
		case .primary:
			content
				.foregroundColor(colorScheme == .light ? .black : .black)
				.padding(.horizontal, 34)
				.padding(.vertical, 18)
				.frame(minWidth: 150)
				.frame(maxHeight: maxHeight)
				
		case let .secondary(isDisabled):
			content
				.foregroundColor(disabledLabelColorBuilder(isDisabled))
				.padding(.horizontal, 20)
				.padding(.vertical, 10)
				.frame(minWidth: 80)
				.frame(maxHeight: maxHeight)
				
		case let .tertiary(isAppliedInView, isSelectedInAddTagSheet):
			content
				.foregroundColor(
                    tertiaryForegroundColorBuilder(
                        isAppliedInView: isAppliedInView,
                        isSelectedInAddTagSheet: isSelectedInAddTagSheet
                    )
				)
				.padding(.horizontal, 12)
				.padding(.vertical, 9)
				.frame(minWidth: 62)
				.frame(maxHeight: maxHeight)
		}
	}
    
    private func disabledLabelColorBuilder(_ isDisabled: Bool) -> Color {
        if colorScheme == .light && isDisabled { return .white }
        else if colorScheme == .light && !isDisabled { return .black }
        else if colorScheme == .dark && isDisabled { return . white }
        else if colorScheme == .dark && !isDisabled { return .black }
        return .black
    }
	
    private func tertiaryForegroundColorBuilder(
        isAppliedInView: Bool?,
        isSelectedInAddTagSheet: Bool?
    ) -> Color {
        if isAppliedInView != nil {
            return .black
//            switch colorScheme {
//            case .light:
//                return .black
//            case .dark:
//                return .black
//            default:
//                return .primary
//            }
        } else if let isSelectedInAddTagSheet {
            switch colorScheme {
            case .light:
                if isSelectedInAddTagSheet {
                    return .white
                } else if !isSelectedInAddTagSheet {
                    return .black
                }
            case .dark:
                if isSelectedInAddTagSheet {
                    return .white
                } else if !isSelectedInAddTagSheet {
                    return .white
                }
            @unknown default:
                return .white
            }
        }
        return .black
    }
}
