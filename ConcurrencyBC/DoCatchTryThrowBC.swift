//
//  DoCatchTryThrowBC.swift
//  ConcurrencyBC
//
//  Created by Corptia on 27/07/2023.
//

import SwiftUI

class DocatchtryThrowsBootcampDataManage{
    let isActive: Bool = false
    
    func getTitle() -> (title: String?, error: Error?) {
        if isActive {
            return ("NEW TEXT!", nil)
        }else{
            return (nil, URLError (.badURL))
        }
    }
    func getTitle2() -> Result<String, Error>{
        if isActive{
            return .success("New Text!")
        } else {
            return .failure(URLError(.appTransportSecurityRequiresSecureConnection))
        }
    }
    
    func getTitle3() throws -> String {
        if isActive{
            return "New Text"
        }else{
            throw URLError(.badServerResponse)
        }
    }
    
}
class DoCatchTryThrowsBootcampViewModel: ObservableObject {
    @Published var text: String = "Starting text."
    let manager = DocatchtryThrowsBootcampDataManage()
    
    func fetchTitle(){
        /*
         let result = manager.getTitle2()
         switch result{
         case .success(let newTitle):
         self.text = newTitle
         case .failure(let error):
         self.text = error.localizedDescription
         }
         */
        
        do {
            let newTitle = try manager.getTitle3()
            self.text = newTitle
        } catch let error {
            self.text = error.localizedDescription
        }
        
        
    }
}
struct DoCatchTryThrowBC: View {
    
    @ObservedObject private var vm = DoCatchTryThrowsBootcampViewModel()
    
    var body: some View {
        Text(vm.text)
            .frame(width: 300 , height: 300)
            .background(.cyan)
            .onTapGesture {
                vm.fetchTitle()
            }
    }
}

struct DoCatchTryThrowBC_Previews: PreviewProvider {
    static var previews: some View {
        DoCatchTryThrowBC()
    }
}
