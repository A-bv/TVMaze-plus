# TVMazeApp

Search TV shows, open their details and keep favorites on device. A native SwiftUI app for iOS 26.5, built on the [TVMaze API](https://www.tvmaze.com/api) with no third-party dependencies.

![Swift 5](https://img.shields.io/badge/Swift-5-F05138?logo=swift&logoColor=white)
![iOS 26.5+](https://img.shields.io/badge/iOS-26.5%2B-007AFF?logo=apple&logoColor=white)

<p align="center">
  <img src="docs/screenshots/search.png" width="190" alt="Search results for “stranger” shown as a horizontal carousel of poster cards">
  <img src="docs/screenshots/detail.png" width="190" alt="Stranger Things detail screen with poster, rating, favorite button, genres and summary">
  <img src="docs/screenshots/favorites.png" width="190" alt="Favorites tab listing two saved shows">
  <img src="docs/screenshots/detail-dark.png" width="190" alt="The detail screen in dark mode">
</p>

## Features

- Search shows by name and browse the results as poster cards.
- Open a show for its full details and a link to its website.
- Save favorites on device from any card or detail screen.

## Architecture

<p align="center">
  <img src="docs/architecture.svg" width="860" alt="App: shows the Search and Favorites tabs and gives the SwiftData container to every view. UI: the search screen owns the ViewModel, sends it the search and renders its state; tapping a card opens the show detail; the heart button sits on every card and on the detail; the Favorites tab lists saved shows. ViewModel: fetches API models from the API service and passes them to the transformer, which fills the display models. Networking: the API service sends a GET through a network session to the TVMaze API and decodes the JSON. Persistence: the heart button inserts or deletes favorites and the Favorites tab deletes them, both reading SwiftData with @Query.">
</p>

The app uses three models:

<p align="center">
  <img src="docs/models.svg" width="820" alt="The API model, decoded from the JSON, is transformed into the display model that every screen uses, which is copied into the stored model when a show is saved as a favorite.">
</p>

### UI

The app sets up SwiftData and a tab bar with Search and Favorites. The search screen shows poster cards, a card opens the show detail, and a heart button on every card and on the detail saves the show. Views only display ready-made data; posters load straight from TVMaze with `AsyncImage`. Styled with Liquid Glass and the `Tab` API.

### ViewModel

Search follows MVVM. The search screen owns an `@Observable` ViewModel, sends it the query and redraws when its state changes: results, a spinner while loading, an alert on error. It runs on the main actor, the project's default isolation, and calls the network with `async/await`.

The ViewModel passes the API models to a transformer, which fills the display models: year range, formatted rating, summary without HTML, defaults for missing fields. API changes stop there and never reach the views.

### Networking

- The API service sends a `GET` through the network session, accepts only HTTP 200, decodes the JSON and throws typed errors for a bad URL, a bad response or a decoding failure.
- The API service and the network session (`URLSession`) are behind protocols, so tests replace them with mocks.

### Persistence

Favorites are a SwiftData `@Model`, unique by show id. The heart button saves a display model as a favorite or deletes it, and the Favorites tab lists and deletes them. Both read with `@Query` and write through the model context; SwiftData keeps every view in sync, so no ViewModel is needed.

## Getting started

Requires Xcode 26.5 or later. Open `TVMazeApp/TVMazeApp.xcodeproj`, run with **⌘R** and test with **⌘U**.

## Tests

The API service, ViewModel and transformer are unit tested offline with Swift Testing and mocked dependencies. Decoding is checked against a real API response saved as a fixture: one show with every field filled, and one where every optional field is `null` or missing.
