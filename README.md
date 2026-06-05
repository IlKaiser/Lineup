# Lineup

A native iOS/iPadOS app for building soccer starting lineups. Add your players, drag colored shirts onto the pitch, manage a substitutes bench, and share the result as an image.

Built with **SwiftUI + SwiftData**, targeting **iOS 18+** with **Liquid Glass** styling on iOS 26.

## Features

- **Multiple lineups** — create, rename, and delete named lineups (e.g. "vs Roma", "4-3-3 Attack"). Each is independent.
- **Persistent squad** — build your roster once (name, number, role); reuse players across lineups.
- **Formation templates** — 9 formations (4-4-2, 4-3-3, 4-2-3-1, 3-5-2, 3-4-3, 5-3-2, 4-5-1, 5-4-1, 4-1-4-1). Applying one auto-positions the starting XI.
- **Free drag** — fine-tune any starter's position on the pitch; positions are stored normalized so they render at any size.
- **Substitutes bench** — wrapping rows of shirts; drag to reorder (overlapping two players swaps them). Quick add via the picker.
- **Player roles** — Portiere, Difensore, Centrocampista, Attaccante; bench shirts are tinted by role.
- **Add to starting XI** — a `+` button drops a player into the next open formation slot.
- **Customizable shirts** — set the starter and bench colors per lineup; numbers and names render on each shirt.
- **Export & share** — renders the title + pitch + substitutes to an image, shared via the iOS share sheet (with app-icon link metadata) and savable to Photos.
- **Adaptive layout** — `TabView` on iPhone, `NavigationSplitView` on iPad.

## Requirements

- Xcode 26+
- iOS 18.0+ device or simulator (Liquid Glass effects activate on iOS 26+)

## Build & Run

```bash
git clone https://github.com/IlKaiser/Lineup.git
cd Lineup
open Lineup.xcodeproj
```

Select a simulator (or your device) and press **Cmd+R**.

### Running on a personal device (free Apple ID)

1. Connect your iPhone and trust the Mac.
2. In **Signing & Capabilities**, enable *Automatically manage signing* and pick your Apple ID team.
3. Give the bundle identifier a unique value (e.g. `com.yourname.lineup`).
4. Build & run, then trust the developer profile under **Settings → General → VPN & Device Management**.

> Free provisioning installs expire after 7 days; re-run from Xcode to refresh. A paid Apple Developer account removes this limit.

## Architecture

```
Lineup/
├── LineupApp.swift            # Entry point; adaptive iPhone/iPad root
├── Models/
│   ├── Player.swift           # @Model: name, number, role
│   ├── PlayerRole.swift       # Role enum + per-role colors
│   ├── PlayerPosition.swift   # @Model: player + normalized x/y
│   └── LineupModel.swift      # @Model: lineup, starters, substitutes, colors
├── Views/
│   ├── LineupsListView.swift  # List of lineups (create/rename/delete)
│   ├── LineupDetailView.swift # Pitch + bench + toolbar (formation, add, share)
│   ├── PitchCanvasView.swift  # Pitch container + draggable starters
│   ├── PitchBackgroundView.swift
│   ├── DraggableShirtView.swift
│   ├── ShirtView.swift        # Path-drawn shirt with number + name
│   ├── BenchStripView.swift   # Substitutes, drag-to-reorder
│   ├── FormationPickerView.swift
│   ├── PlayerEditView.swift
│   ├── SquadView.swift
│   └── LineupExportView.swift # Static board used for image export
└── Utilities/
    ├── Color+Hex.swift
    ├── Formations.swift       # Normalized coordinates per formation
    ├── ImageExporter.swift    # ImageRenderer → UIImage
    ├── GlassModifier.swift    # adaptiveGlass() (Liquid Glass / material fallback)
    └── ShareImageSource.swift # Share-sheet metadata (title + app icon)
```

Data persists locally via SwiftData. iCloud sync is intentionally out of scope (it requires a paid developer account) but can be enabled later with a one-line `ModelConfiguration` change.

## License

Personal project — no license specified.
