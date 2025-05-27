//
//  ContentView.swift
//  Recipes-Fetch
//
//  Created by Jared Work on 5/25/25.
//

import Network
import SwiftUI

struct RecipeView: View {
    @State private var vm = RecipesViewModel()
    
    
    var body: some View {
        NavigationStack {
            VStack {
                if vm.hasError {
                    MalformedList
                } else if vm.meals.isEmpty {
                    EmptyList
                } else {
                    CuisineList
                    RecipeList
                }
            }
            .task {
                do {
                    vm.meals = try await vm.networkManager.fetchRecipes()
                    populateCuisineList()
                } catch(let error) {
                    vm.dataError = error as? RFError
                    vm.hasError = true
                }
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
    
    private var RecipeList: some View {
        List {
            ForEach(searchableRecipeResults, id: \.id) { meal in
                VStack(alignment: .leading) {
                    if let image = vm.networkManager.getCachedImage(for: meal) {
                        Image(uiImage: image)
                            .resizable()
                            .frame(width: 350, height: 250)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                        
                        Text(meal.name)
                        Text(meal.cuisine)
                            .foregroundStyle(.secondary)
                    } else {
                        ProgressView()
                    }
                }
            }
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
        .searchable(text: $vm.searchText)
        .refreshable {
            Task {
                vm.meals = try await vm.networkManager.fetchRecipes()
            }
        }
    }
    
    private var EmptyList: some View {
        VStack {
            ContentUnavailableView {
                Label {
                    Text("No Recipes Found")
                } icon: {
                    Image(systemName: "questionmark")
                        .foregroundStyle(.black)
                }
            } description: {
                Text("Please try again.")
            } actions: {
                Button {
                    Task {
                        vm.meals = try await vm.networkManager.fetchRecipes(with: RecipeEndpoints.allRecipes.rawValue)
                        populateCuisineList()
                    }
                } label: {
                    Text("Retry")
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }
    
    private var MalformedList: some View {
        VStack {
            if let error = vm.dataError {
                ContentUnavailableView {
                    Label {
                        Text(error.rawValue)
                    } icon: {
                        Image(systemName: "fork.knife")
                            .foregroundStyle(.black)
                    }
                } description: {
                    Text("Please try again.")
                } actions: {
                    Button {
                        Task {
                            vm.meals = try await vm.networkManager.fetchRecipes(with: RecipeEndpoints.allRecipes.rawValue)
                            populateCuisineList()
                            vm.hasError = false
                        }
                    } label: {
                        Text("Retry")
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        }
    }
    
    private func populateCuisineList() {
        for i in 0..<vm.meals.count {
            if !vm.cuisineList.contains(vm.meals[i].cuisine) {
                vm.cuisineList.append(vm.meals[i].cuisine)
            }
        }
    }
    
    private var searchableRecipeResults: [Meals] {
        if vm.searchText.isEmpty {
            if vm.selectedCuisine == "" {
                return vm.meals
            } else {
                return vm.meals.filter({ $0.cuisine == vm.selectedCuisine})
            }
        } else {
            if vm.selectedCuisine == "" {
                return vm.meals.filter({ $0.name.localizedCaseInsensitiveContains(vm.searchText)})
            } else {
                return vm.meals.filter({ $0.name.localizedStandardContains(vm.searchText) && $0.cuisine == vm.selectedCuisine})
            }
        }
    }
}

#Preview {
    RecipeView()
}
