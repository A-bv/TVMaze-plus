//
//  SettingsView.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 10.11.2026.
//

import SwiftUI

struct SettingsView: View {
    private enum Constants {
        static let title = String(localized: "Settings")
        static let doneTitle = String(localized: "Done")
        static let regionTitle = String(localized: "Region")
        static let regionFooter = String(localized: "Sets the TV listings. Streaming is the same everywhere.")
        static let languageTitle = String(localized: "Language")
        static let languageFooter = String(localized: "The language is changed in the Settings app.")
        static let fallbackLanguageCode = "en"
    }

    let regions: [RegionItemModel]
    @Binding var countryCode: String

    @Environment(\.dismiss) private var dismiss
    @Environment(\.openURL) private var openURL

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker(Constants.regionTitle, selection: $countryCode) {
                        ForEach(regions) { region in
                            Text(verbatim: "\(region.flag) \(region.name)")
                                .tag(region.code)
                        }
                    }
                    .pickerStyle(.navigationLink)
                } footer: {
                    Text(Constants.regionFooter)
                }
                .listRowBackground(Color.surfaceGradientStart)
                Section {
                    Button(action: openSystemSettings) {
                        LabeledContent(Constants.languageTitle, value: languageName)
                    }
                    .tint(.primary)
                } footer: {
                    Text(Constants.languageFooter)
                }
                .listRowBackground(Color.surfaceGradientStart)
            }
            .scrollContentBackground(.hidden)
            .background(.surface)
            .navigationTitle(Constants.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(Constants.doneTitle) {
                        dismiss()
                    }
                }
            }
        }
    }

    private var languageName: String {
        let code = Bundle.main.preferredLocalizations.first ?? Constants.fallbackLanguageCode
        return Locale.current.localizedString(forLanguageCode: code)?.localizedCapitalized ?? code
    }

    private func openSystemSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        openURL(url)
    }
}

#Preview {
    SettingsView(regions: [RegionItemModel(code: "FR"), RegionItemModel(code: "US")], countryCode: .constant("FR"))
}
