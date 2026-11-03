//
//  ShowSearchView.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 26.09.2026.
//

import SwiftUI

struct ShowSearchMainView: View {
    private enum Constants {
        static let title = "TV Shows"
        static let searchPrompt = "Search a show"
        static let alertTitle = "Error"
        static let alertMessage = "Something went wrong, try again later."
    }
    
    @State private var viewModel = ShowSearchViewModel(service: TVMazeAPIServiceImpl())
    @State private var searchText = ""
    @State private var submittedSearch = ""

    var body: some View {
        NavigationStack {
            ScrollView(.horizontal) {
                LazyHStack(alignment: .top) {
                    ForEach(viewModel.shows) { show in
                        NavigationLink {
                            ShowDetailView(show: show)
                        } label: {
                            CardView(show: show)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding()
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .overlay {
                if viewModel.isLoading {
                    ProgressView()
                }
            }
            .navigationTitle(Constants.title)
            .searchable(
                text: $searchText,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: Constants.searchPrompt)
            .onSubmit(of: .search) {
                submittedSearch = searchText
            }
            .task(id: submittedSearch) {
                guard !submittedSearch.isEmpty else { return }
                await viewModel.loadShows(entry: submittedSearch)
            }
            .alert(Constants.alertTitle, isPresented: $viewModel.isShowingAlert) {
            } message: {
                Text(Constants.alertMessage)
            }
        }
    }
}

#Preview {
    ShowSearchMainView()
}
