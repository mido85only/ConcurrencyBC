//
//  TaskGroupBC.swift
//  ConcurrencyBC
//
//  Created by Corptia on 01/08/2023.
//

import SwiftUI

class TaskGroupBCDataManager {
    
    func fetchImagesWithAsyncLet() async throws -> [UIImage]{
        do{
            async let fetchImage1 = fetchImage(urlString: "https://picsum.photos/3000")
            async let fetchImage2 = fetchImage(urlString: "https://picsum.photos/3000")
            async let fetchImage3 = fetchImage(urlString: "https://picsum.photos/3000")
            async let fetchImage4 = fetchImage(urlString: "https://picsum.photos/3000")
            
            let (image1 , image2 , image3 , image4) = await (try fetchImage1 , try fetchImage2 , try fetchImage3 , try fetchImage4)
            
            return [image1 , image2 , image3 , image4]
        }catch{
            throw error
        }
        
    }
    
    func fetchImagesWithTaskGroup() async throws ->[UIImage] {
        
       return try await withThrowingTaskGroup(of: UIImage.self) { group in
            var images: [UIImage] = []
           
           group.addTask {
               try await self.fetchImage(urlString: "https://picsum.photos/3000")
           }
           
           //TODO: countinue Video 07 from minute 16:27
           
            return images
        }
    }
    
    private func fetchImage(urlString: String) async throws -> UIImage{
        guard let url = URL(string: urlString) else {throw URLError(.badURL)}
        do {
            let (data , _) = try await URLSession.shared.data(from: url)
            if let image = UIImage(data: data) {
                return image
            }else{
                throw URLError(.badURL)
            }
        } catch  {
            print(error.localizedDescription)
            throw error
        }
    }
}

class TaskGroupBCViewModel: ObservableObject{
    @Published var images: [UIImage] = []
    let manager = TaskGroupBCDataManager()
    
    func getImages() async {
        if let images = try? await manager.fetchImagesWithAsyncLet(){
            self.images.append(contentsOf: images)
        }
    }

}

struct TaskGroupBC: View {
    
    @StateObject private var vm = TaskGroupBCViewModel()
    
    
    let columns = [GridItem(.flexible()) , GridItem(.flexible())]
    
    var body: some View {
        NavigationStack{
            ScrollView{
                LazyVGrid(columns: columns) {
                    ForEach(vm.images, id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 150)
                    }
                }
            }
            .navigationTitle("Async Let 🥳")
            .task {
                await vm.getImages()
            }
        }
        
    }
}

struct TaskGroupBC_Previews: PreviewProvider {
    static var previews: some View {
        TaskGroupBC()
    }
}
