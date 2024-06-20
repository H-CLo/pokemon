# Pokemon!

> This is a practice iOS project displaying pokemon information with Coordinator pattern, clean code, MVVM structure and comprehensive testing.

|  Pokemon   | Pokemon List  | Pokemon Detail |
|  ----  | ----  | ---- |
| ![](https://github.com/H-CLo/pokemon/assets/13503418/20e5f9d7-6bb7-409d-9d0e-7f33ab1dc080) | ![](https://github.com/H-CLo/pokemon/assets/13503418/32359485-0d3b-4960-b79f-76f5fccdbc03) | ![](https://github.com/H-CLo/pokemon/assets/13503418/d0791eb8-06aa-4039-be12-38cf3e908ca2) |

# Developmnet Environment
- Xcode 15.4
# Features
## PokemonList
- 基本資訊
  - 寶可夢 ID
  - 名稱
  - 屬性
  - 縮圖
- 點擊圖像後可以進入到詳細頁面
- 實作分頁式下載，捲到底部會自動加載新資料
- 使用 UserDefault 作為本地儲存技術，可以對寶可夢加為我的最愛
- 實現Gird/List 列表的顯示，可透過點擊右上方 reload 按鈕
- 實現顯示我的最愛的列表，可透過點擊右上方的 bookmark 按鈕
### Dev notes
1. 使用 `https://pokeapi.co/api/v2/pokemon/`取得列表資料，再請求`https://pokeapi.co/api/v2/pokemon/\(id)` 取得寶可夢資訊，透過欄位`Types`, `Thunmail image`顯示到介面
2. Api request 支援 HTTP Caching, 透過自訂義的URLSessionConfiguration 實現快取機制，搭配 `Alamofire` 進行請求
3. 使用UserDefault 管理收藏Pokemon 資訊
## PokemonDetail
- 基本資訊
  - 寶可夢 ID
  - 名稱
  - 屬性
  - 縮圖
- 進化資訊
  - 點擊寶可夢可看詳細資訊
- 呈現寶可夢 description text in en
- 收藏功能
### Dev Notes
1. 使用 `https://pokeapi.co/api/v2/pokemon/\(id)` 取得寶可夢詳細資訊
2. 透過寶可夢詳細資訊取得 description text
3. 使用 `https://pokeapi.co/api/v2/pokemon-species/\(id)` 取得 evolution-chain id，再帶入 `https://pokeapi.co/api/v2/evolution-chain/\(id)` 取得寶可夢 Evolution Chains
4. 使用 UserDefault 管理 Pokemon 收藏
## Others
- Writing unit tests.
- Writing UI tests.
- Implementing dependency injection.
- Adding the ability to switch between List and Grid views for the Pokemon List.
- Implementing local caching of data for faster app loading.
---
# Tech
- Swift
- UIKit
- Combine
- UserDefault
- Swift Package Manager
## Testing
- Unit Tests (33 tests)
- UI Tests (3 tests)
## Dependencies
- Alamofire 網路請求
- SnapKit 介面 Code layout
- SDWebImage 圖像套件
- OHHTTPStubs 網路請求Stub工具
# Document
- Pokemon Api V2: https://pokeapi.co/docs/v2#pokemon-section
