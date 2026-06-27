# TransactionViewer

A lightweight iOS app that displays a list of bank transactions and lets users drill into the detail of each one. Built entirely in SwiftUI using the Observation framework introduced in iOS 17.

---

## Screenshots

| Transaction List | Transaction Detail | Tooltip expanded |
|---|---|---|
| `transactions_list` | `transaction_detail_screen` | `tooltip_expanded_text` |
|<image width="200" src="https://github.com/user-attachments/assets/2cfff269-8717-409f-9fa3-d6d9af32aae7"/> <image width="200" src="https://github.com/user-attachments/assets/93efbe2c-c04b-490a-b11b-c2e597fe5f59"/>|<image width="200" src="https://github.com/user-attachments/assets/96377e88-d43c-4888-860e-51664c482109"/> <image width="200" src="https://github.com/user-attachments/assets/6c1195b3-81a5-4d2c-ad13-93bdd9e4309f"/>|<image width="200" src="https://github.com/user-attachments/assets/f49d0f36-74e5-4073-b482-184ff23ad190"/> <image width="200" src="https://github.com/user-attachments/assets/26931a14-4509-4e82-8a99-1da6f7973418"/>|

---

## Requirements

| | |
|---|---|
| iOS | 17.0+ |
| Xcode | 15.0+ |
| Swift | 5.9+ |
| Dependencies | None (zero third-party packages) |

---

## Project structure

```
TransactionViewer/
├── App/
│   ├── TransactionViewerApp.swift      # @main entry point, UITestMode flag
│   └── LaunchScreenView.swift          # SwiftUI launch screen + AppIconView
│
├── Models/
│   ├── Transaction.swift               # Transaction, TransactionList, Amount
│   └── TransactionType.swift           # TransactionType enum with custom decoder
│
├── Services/
│   ├── TransactionServiceProtocol.swift
│   └── TransactionService.swift        # Reads transaction-list.json from bundle
│
├── Features/
│   ├── List/
│   │   ├── TransactionListView.swift
│   │   ├── TransactionListViewModel.swift
│   │   └── TransactionRowView.swift
│   │
│   └── Detail/
│       ├── TransactionDetailView.swift
│       ├── TransactionDetailViewModel.swift
│       └── DetailRowView.swift
│
├── Shared/
│   ├── TooltipView.swift
│   └── Extensions/
│       └── String+Localized.swift
│
├── Resources/
│   ├── Assets.xcassets/
│   │   ├── AppIcon.appiconset/
│   │   
│   ├── Localizable.strings
│   └── transaction-list.json           # Local fixture — replace with API call
│
TransactionViewerTests/
├── Unit/
│   ├── TransactionTests.swift
│   ├── TransactionServiceTests.swift
│   ├── TransactionDetailViewModelTests.swift
│   └── TransactionListViewModelTests.swift
│
└── UI/
    ├── TransactionListViewUITests.swift
    └── TransactionDetailViewUITests.swift
```

---

## Architecture

The app follows a lightweight MVVM pattern using Swift's native `@Observable` macro rather than `ObservableObject`. Each screen owns exactly one view model; views reference it via a `@State` property so the VM's lifetime is tied to the view.

```
View  ──→  ViewModel  ──→  Service (protocol)
 ↑               │
 └── @State ─────┘  (no singletons, no environment injection)
```

Dependency injection is constructor-based throughout, which keeps unit tests free of mocking frameworks — a plain `MockTransactionService` conforming to `TransactionServiceProtocol` is all that's needed.

### State machine

`TransactionListViewModel` drives the list UI through a four-case enum:

```swift
enum State {
    case idle
    case loading
    case loaded([Transaction])
    case failed(String)
}
```

Pull-to-refresh deliberately skips the `.loading` state when data is already visible, preventing a spinner from flashing over existing rows.

---

## Data layer

Transactions are currently loaded from `transaction-list.json` in the app bundle. The service layer is fully abstracted behind `TransactionServiceProtocol`, so swapping to a real network call requires changing only `TransactionService` — no view or view model code needs to change.

### JSON shape

```json
{
  "transactions": [
    {
      "key": "txn_001",
      "transaction_type": "DEBIT",
      "merchant_name": "Tim Hortons",
      "description": "Double double",
      "amount": { "value": 4.75, "currency": "CAD" },
      "posted_date": "2026-06-25",
      "from_account": "Chequing",
      "from_card_number": "4111111111111234"
    }
  ]
}
```

All fields except `key`, `transaction_type`, and `amount` are optional. Unknown `transaction_type` values throw a `DecodingError` rather than silently defaulting, so bad payloads surface immediately during development.

---

## Concurrency

All view models are `@MainActor`-isolated via the `@Observable` macro. Model types (`Transaction`, `Amount`, `TransactionType`) are `Sendable` structs and enums with immutable stored properties, so they cross actor boundaries safely.

Display-computed properties (`displayMerchantName`, `displayPostedDate`, `displayCardSuffix`, `Amount.formatted`) are explicitly marked `nonisolated` to prevent the compiler from inheriting `@MainActor` isolation through SwiftUI's `Identifiable` conformance on `List`.

`Amount.formatted` uses `NumberFormatter` rather than the `.formatted(.currency(code:))` style API because the latter references `@MainActor`-isolated `FormatStyle` types in some SDK versions, which would make the property uncallable from non-isolated contexts such as unit tests.

---

## Running the app

```bash
# Clone
git clone https://github.com/your-org/TransactionViewer.git
cd TransactionViewer

# Open in Xcode (no package resolution needed — zero dependencies)
open TransactionViewer.xcodeproj

# Run on simulator
# Select any iPhone 17+ simulator and press ⌘R

# Run with mock data (skips bundle JSON, uses MockTransactionService)
# Edit the scheme: Run → Arguments → add -UITestMode
```

---

## Running tests

```bash
# All unit and UI tests
⌘U  (in Xcode)

# Or from the terminal
xcodebuild test \
  -scheme TransactionViewer \
  -destination 'platform=iOS Simulator,name=iPhone 16' \
  -resultBundlePath TestResults.xcresult
```

Test targets and what they cover:

| Suite | What it tests |
|---|---|
| `TransactionTests` | Display helpers, card suffix, date fallback, amount formatting, type decoding |
| `TransactionServiceTests` | Bundle decode, unknown type error, error descriptions |
| `TransactionDetailViewModelTests` | Status icon per type, tooltip toggle, VM initialisation |
| `TransactionListViewModelTests` | State machine transitions, pull-to-refresh, retry, empty response |
| `TransactionListViewUITests` | List appears, row tap navigates, scroll |
| `TransactionDetailViewUITests` | Detail screen, tooltip expand/collapse, close button |

---

## Localisation

All user-facing strings go through `NSLocalizedString` via the `.localized` extension on `String`. Add new languages by creating a `Localizable.strings` file for each locale in Xcode (**File → New → Strings File**) and providing translations for the keys below.

| Key | English value |
|---|---|
| `transactions.title` | Transactions |
| `transactions.loading` | Loading transactions… |
| `transactions.empty.title` | No transactions |
| `transactions.empty.description` | Your transactions will appear here |
| `transactions.error.title` | Something went wrong |
| `transactions.error.retry` | Try again |
| `transaction.detail.title` | Transaction Details |
| `detail.credit` | Credit |
| `detail.debit` | Debit |
| `detail.from` | From |
| `detail.amount` | Amount |
| `detail.close` | Close |
| `tooltip.primary` | What is this transaction? |
| `tooltip.show_more` | Show more |
| `tooltip.expanded` | This charge was processed by your card network. |
| `tooltip.show_less` | Show less |

---

## Known limitations

- Date strings from the API are displayed as-is. Once the date format is confirmed, replace the `displayPostedDate` property with a proper `DateFormatter` pass.
- The tooltip content is static. Wire `tooltip.primary` and `tooltip.expanded` localisation keys to a real content API when available.
- `TransactionService` reads from the bundle synchronously on a background thread. For large datasets, stream with `AsyncSequence` or paginate.

---

## Licence

MIT — see `LICENSE` for details.
