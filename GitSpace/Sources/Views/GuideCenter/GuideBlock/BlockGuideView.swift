//
//  BlockGuideView.swift
//  GitSpace
//
//  Created by 최한호 on 2023/02/07.
//

import SwiftUI

struct BlockGuideView: View {
    
    @State private var blockGuide: Bool = false
    @State private var unblockGuide: Bool = false
    
    var body: some View {
            ScrollView {
                VStack(alignment: .leading) {
                    Group {
                        Text("When someone offends you")
                            .font(.system(size: 22, weight: .light))
                        
                        Divider()
                        
                        Text(
"""
When someone offends you, you can block that user.
There are multiple ways to block someone on GitSpace.
""")
                        .padding(.vertical)
                    }
                    
                    Group {
                        Text("Block a user")
                            .font(.title2)
                            .bold()
                        
                        Text(
"""
To block someone on GitSpace:
""")
                        .padding(.top, -5)
                        
                        DisclosureGroup("**From someone's GitSpace profile:**",
                            isExpanded: $blockGuide) {
                            
                            VStack(alignment: .leading, spacing: 10) {
                                HStack(alignment: .top) {
                                    Text("1.")
                                    Text("Tap their username of profile picture from their repository or contributor list or chatting room to go to their profile.")
                                }
                                
                                HStack(alignment: .top) {
                                    Text("2.")
                                    Text("Tap **⋯** in the top right, then tap **Block** at the top to confirm.")
                                }
                                
                                HStack(alignment: .top) {
                                    Text("3.")
                                    Text("Tap **Yes** to confirm.")
                                }
                            }
                            .padding(.top, 5)
                        }
                    }
                    
                    Group {
                        Text("Unblock a user")
                            .font(.title2)
                            .bold()
                            .padding(.top)
                        
                        Text(
"""
To unblock someone on GitSpace:
""")
                        .padding(.top, -5)
                        
                        DisclosureGroup("**From your GitSpace settings:**",
                            isExpanded: $unblockGuide) {
                            
                            VStack(alignment: .leading, spacing: 10) {
                                HStack(alignment: .top) {
                                    Text("1.")
                                    Text("Tap **profile** in the bottom right to go to your profile")
                                }
                                
                                HStack(alignment: .top) {
                                    Text("2.")
                                    Text("Tap **gear icon** in the top right.")
                                }
                                
                                HStack(alignment: .top) {
                                    Text("3.")
                                    Text("Tap **Account** at the top and tap **Blocked users**.")
                                }
                                
                                HStack(alignment: .top) {
                                    Text("4.")
                                    Text("Tap the **Unblock** button located on the right side of the profile of the user you want to unblock.")
                                }
                            }
                            .padding(.top, 5)
                        }
                    }
                } // VStack
                .padding(.horizontal)
            } // ScrollView
            .navigationBarTitle("Block or Unblock")
    } // body
}

struct BlockGuideView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            BlockGuideView()
        }
    }
}
