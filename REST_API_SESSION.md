# 🌐 Working with REST APIs in Swift

> **iOS Meetup — September 2026**  
> Audience: Intermediate Swift developers, new to networking  
> API used throughout: `https://jsonplaceholder.typicode.com/posts`

---

## 📊 Presentation Slides

> 🎯 The full Keynote slide deck for this session is included in this repo:

**[📥 Download REST_APIs_Meetup.key](./REST_APIs_Meetup.key)**

> Open with **Keynote** on macOS. Covers all topics below with live code examples.

---

## 📁 Project Folder Structure

This project follows **Clean MVVM** with **feature-based modularisation**.  
Each feature has its own dedicated `di/` folder that owns ViewModel creation & dependency wiring.

```
ReadyMadeProjectSetup/
│
├── main/
│   │
│   ├── app/                                    ← App entry + routing infra
│   │   ├── MainApp.swift                       ← @main entry point
│   │   ├── MainView.swift                      ← Root tab / launch view
│   │   └── AppRouter.swift                     ← Generic Router<T: Hashable>
│   │                                              + NavigationDestination protocol
│   │
│   ├── assets/                                 ← Xcassets, icons, colours
│   │
│   ├── core/                                   ← Shared infra (zero feature logic)
│   │   │
│   │   ├── app_theme/
│   │   │   └── Theme.swift                     ← Colours, fonts, design tokens
│   │   │
│   │   ├── network/
│   │   │   │
│   │   │   ├── network_client/
│   │   │   │   ├── APIClientAsyncAwait.swift   ← async/await APIClient
│   │   │   │   │                                  • fetchPosts()   ← ACTIVE (hard-coded)
│   │   │   │   │                                  • request<T>()   ← COMMENTED (uncomment in session)
│   │   │   │   │
│   │   │   │   ├── APIClientCompletionHandler.swift
│   │   │   │   │                                  • fetchPost()    ← ACTIVE (hard-coded)
│   │   │   │   │                                  • request<T>()   ← COMMENTED (uncomment in session)
│   │   │   │   │
│   │   │   │   └── EndPointType.swift          ← Protocol: baseURL, path, method, body, headers
│   │   │   │
│   │   │   ├── network_error_core/
│   │   │   │   ├── DataError.swift             ← Typed error enum (network, HTTP, decode, auth)
│   │   │   │   └── APIErrorResponse.swift      ← Server error model
│   │   │   │
│   │   │   ├── mock_api_service/               ← Mock services for unit tests / Previews
│   │   │   └── media/
│   │   │       └── MediaUploadService.swift
│   │   │
│   │   └── storage/
│   │       ├── KeychainManager.swift           ← Secure token storage
│   │       └── LocalDatabase.swift             ← Local persistence
│   │
│   └── features/                               ← One folder per screen/feature
│       │
│       └── home/                               ← 🏠 Home Feature
│           │
│           ├── di/                             ← 💉 Dependency Injection lives HERE
│           │   └── HomeContainer.swift         ← Factory that creates & wires ViewModels
│           │                                      HomeContainer.makeHomeViewModel()
│           │                                      HomeContainer.makeDetailViewModel(post:)
│           │
│           ├── models/
│           │   └── PublicPostModel.swift       ← struct Post: Codable, Hashable
│           │
│           ├── home_router/
│           │   └── HomeNavRouter.swift         ← Type-safe nav enum (Hashable, manual == & hash)
│           │                                      case home_screen
│           │                                      case home_detail(Post)
│           │
│           └── views/
│               │
│               ├── main_screen/
│               │   ├── HomeView.swift          ← List of posts, loading / error states, .task{}
│               │   └── HomeViewModel.swift     ← @MainActor, APIStates, fetchAllPosts (both ways)
│               │
│               ├── home_detail_screen/
│               │   ├── HomeDetailView.swift    ← Full post detail (title, body, userId)
│               │   └── HomeDetailViewModel.swift ← Holds the selected Post passed from HomeView
│               │
│               └── home_components/
│                   └── PostRowView.swift       ← Reusable row: post id badge + title + body preview
│
├── REST_APIs_Meetup.key                        ← Keynote slide deck (this session)
└── REST_API_SESSION.md                         ← This file
```

---

## 🏗️ Architecture — Clean MVVM

```
View  →  ViewModel  →  APIClient  →  URLSession  →  Server
  ↑           ↑
  │     created by di/HomeContainer
  └─── reads @Published state
```

| Layer | File | Responsibility |
|-------|------|---------------|
| **View** | `HomeView.swift` | Display only. Zero business logic. |
| **ViewModel** | `HomeViewModel.swift` | `@MainActor`. Owns `APIStates`. Calls network client. |
| **DI Container** | `di/HomeContainer.swift` | Creates ViewModels, injects dependencies. Single source of truth. |
| **APIClient (async)** | `APIClientAsyncAwait.swift` | `async throws`. Fires request, validates status, decodes JSON. |
| **APIClient (callback)** | `APIClientCompletionHandler.swift` | Closure-based. `data, response, error`. Calls `.resume()`. |
| **EndPointType** | `EndPointType.swift` | Protocol: every endpoint defined as a type (URL, method, headers, body). |
| **DataError** | `DataError.swift` | Typed error enum — network, HTTP, decoding, auth (30+ cases). |
| **Router** | `AppRouter.swift` | Generic `Router<T: Hashable>`. `NavigationStack` path management. |

---

## 💉 Dependency Injection — `di/HomeContainer.swift`

Each feature has a **`di/` folder** with a **Container** that is the only place allowed to `init` ViewModels.  
Views **never** instantiate their own dependencies.

```swift
// features/home/di/HomeContainer.swift
enum HomeContainer {

    /// HomeViewModel wired to the real async APIClient.
    /// Swap APIClient() → MockAPIClient() here for unit tests — no view changes needed.
    static func makeHomeViewModel() -> HomeViewModel {
        let apiClient = APIClient()
        return HomeViewModel(asyncClient: apiClient)
    }

    /// HomeDetailViewModel for a given Post.
    static func makeDetailViewModel(post: Post) -> HomeDetailViewModel {
        HomeDetailViewModel(post: post)
    }
}
```

**Why this pattern?**
- ✅ Views are completely decoupled from network clients
- ✅ Swap real ↔ mock in one place for testing
- ✅ Scale: each new feature gets its own `di/` folder

---

## 📦 The Post Model

```swift
// features/home/models/PublicPostModel.swift
struct Post: Codable, Hashable {
    let userId: Int?
    let id:     Int?
    let title:  String?
    let body:   String?
}
```

API: `GET https://jsonplaceholder.typicode.com/posts` returns an array of 100 posts.

---

## 📞 Way 1 — Completion Handler

> `core/network/network_client/APIClientCompletionHandler.swift`

```swift
// ✅ ACTIVE — hard-coded, easy to follow in session
func fetchPost(completion: @escaping (Result<[Post], Error>) -> Void) {
    let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!

    URLSession.shared.dataTask(with: url) { data, response, error in
        // data     → raw bytes from the server
        // response → cast to HTTPURLResponse to read statusCode
        // error    → network-level error (no internet, timeout etc.)

        if let error = error { completion(.failure(error)); return }

        guard let data = data,
              let http = response as? HTTPURLResponse,
              (200..<300).contains(http.statusCode) else {
            completion(.failure(URLError(.badServerResponse)))
            return
        }

        do {
            let posts = try JSONDecoder().decode([Post].self, from: data)
            completion(.success(posts))
        } catch { completion(.failure(error)) }

    }.resume()  // ← always call .resume() or the request NEVER fires!
}

// ✂️ COMMENTED — uncomment during session to show generic version
// func request<T: Codable>(type: EndPointType,
//              completionHander: @escaping (Result<T, DataError>) -> Void) { ... }
```

**Calling it from ViewModel:**

```swift
callbackClient.fetchPost { [weak self] result in
    DispatchQueue.main.async {         // ← must switch to main thread for UI updates
        switch result {
        case .success(let posts): self?.posts = posts
        case .failure(let error): self?.apiState = .failures(error.localizedDescription)
        }
    }
}
```

---

## ⚡ Way 2 — async / await (Recommended)

> `core/network/network_client/APIClientAsyncAwait.swift`

```swift
// ✅ ACTIVE — hard-coded, easy to follow in session
func fetchPosts() async throws -> [Post] {
    let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!

    let (data, response) = try await URLSession.shared.data(from: url)
    //         ↑ thread suspends here, frees up, resumes when server replies

    guard let http = response as? HTTPURLResponse,
          (200..<300).contains(http.statusCode) else {
        throw DataError.invalidStatusCode(0)
    }

    return try JSONDecoder().decode([Post].self, from: data)
}

// ✂️ COMMENTED — uncomment during session to show generic version
// func request<T: Codable>(type: EndPointType) async throws -> T { ... }
```

**Calling it from ViewModel (`@MainActor` — no DispatchQueue needed):**

```swift
func fetchAllPostsWithAsyncAwait() {
    Task {
        self.apiState = .loading
        do {
            self.posts    = try await asyncClient.fetchPosts()
            self.apiState = .dataloaded
        } catch {
            self.apiState = .failures(error.localizedDescription)
        }
    }
}

// In SwiftUI View:
.task { viewModel.fetchAllPostsWithAsyncAwait() }
```

---

## 🔄 ViewModel State Machine — `APIStates`

```swift
enum APIStates: Equatable {
    case idle           // → before any call
    case loading        // → request in-flight  → show ProgressView
    case dataloaded     // → success            → show List
    case failures(String) // → error            → show ContentUnavailableView
}
```

---

## 🧭 Navigation — `HomeNavRouter`

```swift
// features/home/home_router/HomeNavRouter.swift
enum HomeNavRouter: NavigationDestination, Hashable {
    case home_screen
    case home_detail(Post)          // ← carries the selected Post to detail screen

    // Manual Hashable — needed because @ViewBuilder prevents auto-synthesis
    func hash(into hasher: inout Hasher) { ... }
    static func == (...) -> Bool { ... }

    var destinationView: some View {
        switch self {
        case .home_screen:          HomeView()
        case .home_detail(let post): HomeDetailView(post: post)
        }
    }
}
```

---

## 🆚 Completion Handler vs async/await

| Feature | Completion Handler | async / await |
|---------|:-----------------:|:-------------:|
| Readability | Nested closures | ✅ Linear top-to-bottom |
| Error handling | switch result | ✅ try / catch |
| Main thread | Manual `DispatchQueue.main` | ✅ `@MainActor` |
| iOS Support | iOS 12+ | iOS 15+ |
| Don't forget | `.resume()` | nothing |
| **Use for** | Legacy / Obj-C code | ✅ **All new code** |

---

## 🎯 Interview Questions

**Q1. What is a REST API?**  
→ A way for apps to communicate with servers over HTTP using GET, POST, PUT, DELETE.

**Q2. Difference between GET and POST?**  
→ `GET` fetches/reads data. `POST` sends data to create a new resource.

**Q3. What is `Codable` in Swift?**  
→ `Encodable + Decodable`. Auto-converts JSON ↔ Swift structs. No manual parsing needed.

**Q4. async/await vs completion handler?**  
→ `async/await` reads like synchronous code — no nested closures, no manual thread switching. Use for all new code.

**Q5. What happens if you forget `.resume()` on `dataTask`?**  
→ The request **never fires**. Complete silence — no error, no response.

**Q6. Why `@MainActor` on ViewModel?**  
→ All `@Published` updates automatically run on the main thread. No `DispatchQueue.main.async` needed.

**Q7. What is Dependency Injection and why use it?**  
→ Pass dependencies from outside instead of creating them inside. In this project: `di/HomeContainer` creates ViewModels — swap real ↔ mock without touching any View.

**Q8. Why is `HomeNavRouter` manually implementing `Hashable`?**  
→ It has a `@ViewBuilder` computed property returning `some View` — Swift cannot auto-synthesise `Hashable` for opaque return types. Manual `hash(into:)` and `==` exclude the view property.

---

## 🌐 Practice API — No Auth Required

```
https://jsonplaceholder.typicode.com

GET  /posts       → fetch all 100 posts  ← used in this project
GET  /posts/1     → single post by id
POST /posts       → create post (returns mock 201)
GET  /users       → all users
GET  /todos       → all todos
```

---

*Session by Kundan Dev · iOS Meetup · September 2026*
