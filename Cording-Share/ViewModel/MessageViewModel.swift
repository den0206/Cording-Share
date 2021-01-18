//
//  MessageViewModel.swift
//  Cording-Share
//
//  Created by 酒井ゆうき on 2021/01/18.
//

import Combine

final class MessageViewModel : ObservableObject {
    
    @Published var text = ""
    @Published var editing = false
   
}
