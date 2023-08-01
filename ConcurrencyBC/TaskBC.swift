//
//  TaskBC.swift
//  ConcurrencyBC
//
//  Created by Corptia on 01/08/2023.
//

import SwiftUI

class TaskBCViewModel: ObservableObject{
    
    @Published var image: UIImage? = nil
    @Published var image2: UIImage? = nil
    
    func fetchImage() async{
        do {
            guard let url = URL(string: "https://picsum.photos/3000") else {return}
            let (data , response) = try await URLSession.shared.data(from: url)
            self.image = UIImage(data: data)
        } catch  {
            print(error.localizedDescription)
        }
    }
    
    func fetchImage2() async{
        do {
            guard let url = URL(string: "https://picsum.photos/3000") else {return}
            let (data , response) = try await URLSession.shared.data(from: url)
            self.image2 = UIImage(data: data)
        } catch  {
            print(error.localizedDescription)
        }
    }
    
}

struct TaskBC: View {
    
    @StateObject private var viewModel = TaskBCViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            if let image = viewModel.image{
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200 , height: 200)
            }
            if let image = viewModel.image2{
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200 , height: 200)
            }
        }
        .task {
            await viewModel.fetchImage()
        }
//        .onAppear{
//            //            Task{
//            //               await viewModel.fetchImage()
//            //            }
//            //            Task{
//            //                await viewModel.fetchImage2()
//            //
//            //            }
//
//            Task(priority: .high) {
//                //                try? await Task.sleep (nanoseconds: 2_000_000_000)
//                // yield is used to make any task to be after the others
//                await Task.yield()
//                print("high: \(Thread .current) : \(Task.currentPriority)")
//            }
//            Task (priority: .userInitiated) {
//                print ("userintiated • Thread current •Task currentPriority")
//            }
//            Task(priority:.medium){
//                print ("medium: \(Thread.current) : \(Task.currentPriority)")
//            }
//            Task(priority: .low) {
//                print ("low • \(Thread .current) : \(Task.currentPriority)")
//            }
//            Task(priority: .utility) {
//                print("utility: \(Thread .current) : \(Task.currentPriority)")
//            }
//            Task(priority: .background) {
//                print("background: \(Thread .current) : \(Task.currentPriority)")
//            }
//        }
    }
}

struct TaskBC_Previews: PreviewProvider {
    static var previews: some View {
        TaskBC()
    }
}
