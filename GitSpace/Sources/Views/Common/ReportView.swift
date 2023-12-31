//
//  ReportView.swift
//  GitSpace
//
//  Created by Da Hae Lee on 2023/04/19.
//

import SwiftUI
import FirebaseFirestore

struct ReportView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var userInfoManager: UserStore
    @EnvironmentObject var blockedUsers: BlockedUsers
    
    @Binding var isReportViewShowing: Bool
    @Binding var isSuggestBlockViewShowing: Bool
    
    @State private var reportReason: String?
    @State private var reportReasonNumber: Int?
    
    var reportType: Report.ReportType
    var targetUser: UserInfo
    
    var isReportReasonSelected: Bool {
        guard reportReasonNumber != nil else {
            return false
        }
        return true
    }
    
    var isBlocked: Bool {
        blockedUsers.blockedUserList.contains{
            $0.userInfo.id == targetUser.id
        }
    }
        
    var body: some View {
        VStack {
            /* Report Title */
            GSText.CustomTextView(style: .title2, string: "Report")
                .padding()
            
            /* Report Description */
            VStack(alignment: .leading) {
                GSText.CustomTextView(
                    style: .body1,
                    string: "When you Report this user, the following things happen.")
                .padding(.bottom, 1)

                GSText.CustomTextView(
                    style: .caption1,
                    string:
"""
• The selected content is sent to Gitspace for review.
• The report is not delivered to the other user.
""")

            }
                        
            /* Select Report Reason Description */
            VStack(alignment: .leading) {
                GSText.CustomTextView(
                    style: .body1,
                    string:
"""
Please Tell me what happened with this user. Select one of the reporting categories below.
Gitspace operation team will check and help you.
""")
                .padding(10)
            }
            
            /* Select Report Reason */
            ForEach(
                Array(zip(Report.ReportReason.allCases, (0...Report.ReportReason.allCases.count-1))),
                id:\.0
            ) { (reason, index) in
                Divider()
                VStack(alignment: .leading) {
                    HStack {
                        GSText.CustomTextView(
                            style: .title3,
                            string: "\(reason.rawValue)"
                        )
                        Spacer()
                        Image(systemName: (isReportReasonSelected && reportReasonNumber == index)
                              ? "checkmark.circle.fill"
                              : "circle"
                        )
                    }
                    .padding([.leading,.trailing])
                    .padding([.top, .bottom], 5)
                    .contentShape(Rectangle())  /// HStack을 전부 탭 영역으로 잡기 위해 추가함.
                    .onTapGesture {
                        /**
                         차단 이유를 선택합니다.
                         단, 이미 선택한 이유를 다시 재선택하면 deselection 됩니다.
                         */
                        if isReportReasonSelected && reportReasonNumber == index {
                            withAnimation {
                                reportReasonNumber = nil
                                reportReason = nil
                            }
                        } else {
                            withAnimation {
                                reportReasonNumber = index
                                reportReason = reason.rawValue
                            }
                        }
                    }
                    
                    if (isReportReasonSelected && reportReasonNumber == index) {
                        GSText.CustomTextView(
                            style: .caption1,
                            string: reason.getDescription()
                        )
                        .padding(EdgeInsets(top: 0, leading: 18, bottom: 10, trailing: 50))
                        .transition(
                            .asymmetric(
                                insertion: .opacity,
                                removal: .opacity)
                            .animation(.easeInOut(duration: 0.3))
                        )
                    }
                }
            }
            Divider()
            
            /* Submit Report */
            GSButton.CustomButtonView(
                style: .secondary(isDisabled: !isReportReasonSelected)
            ) {
                /* report method call */
                if
                    let reportReasonNumber,
                    let reporter = userInfoManager.currentUser {
                    Task {
                        let report: Report = Report.init(
                            reason: Report.ReportReason.allCases[reportReasonNumber].rawValue,
                            reporterID: reporter.id,
                            targetUserID: targetUser.id,
                            date: Timestamp(date: Date.now),
                            type: reportType.rawValue
                        )
                        try await reportTarget(by: reporter, with: report)
                        /* report view dismiss -> suggest block view appear */
                        dismiss()
                        isReportViewShowing = false
                        if !isBlocked {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { /// animation이 끝나는데 시간이 걸리기 때문에, true로 바꾸는 코드를 조금 늦춘다. 그렇지 않으면 모달이 띄워지는데 충돌이 일어난다.
                                isSuggestBlockViewShowing = true
                            }
                        }
                    }
                }
            } label: {
                Text("Submit Report")
            }
            .padding()
        }
    }
}

extension ReportView: Blockable, Reportable { }

//struct ReportView_Previews: PreviewProvider {
//    static var previews: some View {
//        ReportView(isReportViewShowing: .constant(true), isSuggestBlockViewShowing: .constant(false))
//    }
//}
