//
//  ContentView.swift
//  Recipes-Fetch
//
//  Created by Jared Work on 5/25/25.
//

import SwiftUI

struct RecipeView: View {
    @State private var vm = RecipesViewModel()
    
    var body: some View {
        VStack {
            CuisineList
        }
        .task {
            do {
                vm.meals = try await vm.networkManager.fetchRecipes()
                populateCuisineList()
            } catch {
                print(error)
            }
            
        }
    }
    
    private var CuisineList: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(vm.cuisineList, id: \.self) { cuisine in
                    VStack {
                        Text(cuisine)
                            .onTapGesture {
                                if vm.selectedCuisine != cuisine {
                                    vm.selectedCuisine = cuisine
                                } else {
                                    vm.selectedCuisine = ""
                                }
                            }
                            .foregroundStyle(vm.selectedCuisine == cuisine ? .black : .secondary)
                            
                        if vm.selectedCuisine == cuisine {
                            Divider()
                                .frame(width: 30, height: 2)
                                .background(.black)
                        }
                    }
                    .containerRelativeFrame(.horizontal, count: 4, spacing: 5)
                    .scrollTransition { content, phase in
                        content
                            .opacity(phase.isIdentity ? 1.0 : 0.0)
                            .scaleEffect(x: phase.isIdentity ? 1.0 : 0.3, y: phase.isIdentity ? 1.0 : 0.3)
                            .offset(y: phase.isIdentity ? 0 : 50)
                    }
                }
            }
            .scrollTargetLayout()
        }
        .scrollIndicators(.hidden)
        .scrollTargetBehavior(.viewAligned)
        .padding()
    }
    
    private func populateCuisineList() {
        for i in 0..<vm.meals.count {
            if !vm.cuisineList.contains(vm.meals[i].cuisine) {
                vm.cuisineList.append(vm.meals[i].cuisine)
            }
        }
    }
}

#Preview {
    RecipeView()
}
