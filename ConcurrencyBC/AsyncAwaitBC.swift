//
//  AsyncAwaitBC.swift
//  ConcurrencyBC
//
//  Created by Corptia on 01/08/2023.
//

import SwiftUI


class AsyncAwaitBCViewModel : ObservableObject{
    @Published var dataArray : [String] = []
    
//    func addTitle1(){
//        self.dataArray.append("title 1 : \(Thread.current)")
//    }
    
    func addAuthor1() async {
        let author1  = "Author1 : \(Thread.current)"
        await MainActor.run(body: {
        self.dataArray.append(author1)
        })
        
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        let author2 = "Author 2:  \(Thread.current)"
        await MainActor.run(body: {
            self.dataArray.append(author2)
        })
        
        
    }
}

struct AsyncAwaitBC: View {
    
    @StateObject var vm = AsyncAwaitBCViewModel()
    
        var body: some View {
            List{
                ForEach(vm.dataArray, id: \.self) { data in
                    Text(data)
                }
            }
            .onAppear{Task{
                await vm.addAuthor1()
            }}
    }
}

struct AsyncAwaitBC_Previews: PreviewProvider {
    static var previews: some View {
        AsyncAwaitBC()
    }
}
