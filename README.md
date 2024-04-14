# iTunesSearchApp
Supports: iOS 15 and above, Swift 5.

## About the Project
iTunesSearchApp - is an iOS application developed using Swift 5 and UIKit. The app is designed to search and browse information about music and TV shows using the [iTunes Search API](https://developer.apple.com/library/archive/documentation/AudioVideo/Conceptual/iTuneSearchAPI/index.html#//apple_ref/doc/uid/TP40017632-CH3-SW1).

## Tech Stack
- Swift 5
- UIKit
- VIP (Clean Swift Architecture)
- API: [iTunes Search API](https://developer.apple.com/library/archive/documentation/AudioVideo/Conceptual/iTuneSearchAPI/index.html#//apple_ref/doc/uid/TP40017632-CH3-SW1)
- CoreData

## Установка и запуск
1. Clone the project repository:
```
git clone git@github.com:oleg-romanov/iTunesSearchApp.git
```
2. Navigate to the project directory:
```
cd iTunesSearchApp/SearchApp
```
3. Open the project file with the `.xcodeproj` extension in Xcode:
```
open SearchApp.xcodeproj
```

## Примеры работы iTunesSearchApp:
Search History with filtering and search results.
![requests history and search](./imgs/requests_history_and_search.png)

Handling empty search results and possible errors.
![an empty result and no internet connection](./imgs/empty_result_and_no_internet_connection.png)
