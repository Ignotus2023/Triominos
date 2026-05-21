# TriominoScore – Mobilny pomocnik do liczenia punktów w Triominos

Dokumentacja produktowo-techniczna projektu. Źródło prawdy dla każdego agenta AI lub developera pracującego nad aplikacją.

---

## Spis treści

1. [Cel i kontekst](#1-cel-i-kontekst)
2. [Zasady gry Triominos](#2-zasady-gry-triominos)
3. [Decyzje produktowe](#3-decyzje-produktowe)
4. [Stack technologiczny](#4-stack-technologiczny)
5. [Architektura aplikacji](#5-architektura-aplikacji)
6. [Struktura projektu](#6-struktura-projektu)
7. [Model danych i schemat bazy](#7-model-danych-i-schemat-bazy)
8. [Smart Input – algorytm i UX](#8-smart-input--algorytm-i-ux)
9. [System bonusów i kar](#9-system-bonusów-i-kar)
10. [Ekrany aplikacji](#10-ekrany-aplikacji)
11. [Design system – Glassmorphism](#11-design-system--glassmorphism)
12. [Internacjonalizacja (i18n)](#12-internacjonalizacja-i18n)
13. [Audio i Haptics](#13-audio-i-haptics)
14. [Konwencje kodowania](#14-konwencje-kodowania)
15. [Testy](#15-testy)
16. [Build, dystrybucja i wersjonowanie](#16-build-dystrybucja-i-wersjonowanie)
17. [Roadmapa](#17-roadmapa)
18. [Zasady dla agenta AI](#18-zasady-dla-agenta-ai)

---

## 1. Cel i kontekst

**TriominoScore** to natywna aplikacja mobilna (iOS + Android) pełniąca rolę profesjonalnego pomocnika do liczenia punktów w grze planszowej **Triominos**. Aplikacja **nie jest cyfrową wersją gry** — fizyczne płytki nadal układane są na stole, a aplikacja zastępuje papier, ołówek i kalkulator.

### Dla kogo

- Hobbyści planszówek grający regularnie w Triominos
- Rodziny i grupy znajomych
- Kluby planszowych spotkań

### Co wyróżnia produkt

- **Smart Input** — wprowadzenie trzech cyfr narożników + jedno tapnięcie na bonus, koniec
- **Auto-bonusy** — aplikacja sama liczy premię za triplet, bridge, hexagon
- **Pełne profile graczy** z trwałą historią i statystykami
- **Premium UX** — glassmorphism, haptics, dźwięki, konfetti przy bonusach
- **6 języków** od dnia premiery
- **100% offline** — żadnej rejestracji, żadnej chmury, żadnych reklam (w MVP)

### Zakres MVP (v1.0)

✅ Liczenie punktów, bonusy, kary
✅ Profile graczy z historią
✅ Statystyki (per gracz i globalne)
✅ Wybór trybu końca gry (limit punktów / liczba rund / dowolny)
✅ Pełny tutorial + ekran zasad
✅ 6 języków (PL, EN, DE, FR, ES, IT)
✅ Glassmorphism (light + dark mode)
✅ Haptics + sound effects
✅ iPhone + iPad + Android phone + Android tablet (responsive)

❌ Pełna gra cyfrowa (drag-and-drop płytek) — poza scope
❌ Multiplayer online — poza scope
❌ OCR skaner płytki (kamera) — przeniesione do v2.0 jako premium
❌ Reklamy / monetyzacja — w v1.0 wszystko free
❌ Backend / chmura — wszystko lokalnie

---

## 2. Zasady gry Triominos

**Konfiguracja:** klasyczny zestaw 56 płytek 0-5 (Pressman / Goliath / Schmidt Spiele).

### 2.1 Komponenty

- **56 trójkątnych płytek**, każda z cyfrą 0-5 w każdym z trzech narożników
- Każda kombinacja występuje **raz** (nie ma powtórzeń): od (0,0,0) do (5,5,5)
- **Triplety** (3 razy ta sama cyfra): 6 szt. — (0,0,0), (1,1,1), (2,2,2), (3,3,3), (4,4,4), (5,5,5)

### 2.2 Liczba graczy i płytki startowe

| Liczba graczy | Płytek na rękę |
| ------------- | -------------- |
| 2             | 9              |
| 3-4           | 7              |
| 5-6           | 6              |

Pozostałe płytki tworzą **pulę dobierania (boneyard)**.

### 2.3 Pierwszy ruch

Pierwszy ruch wykonuje gracz, który ma **najwyższy triplet** w ręce. Kolejność preferencji:

1. (5,5,5) → start + **+10 premii za triplet** + **+10 bonusu startowego** = **+25 pkt** (15 + 10)
2. (4,4,4) → +12 + 10 + 10 = **+32 pkt**
3. ...analogicznie aż do (0,0,0) → **+30 premii za triplet** (specjalny) + 10 bonusu = **+40 pkt**
4. Jeśli nikt nie ma tripleta → startuje gracz z **najwyższą sumą narożników** dowolnej płytki, dostaje **+10 bonusu startowego**.

> **Uwaga:** w literaturze istnieją drobne warianty (np. Goliath: 10 pkt bonusu, Pressman: brak osobnego bonusu, tylko premia za triplet). MVP implementuje wariant Goliath — wartości bonusów są **konfigurowalne** w `lib/core/game/scoring_rules.dart` aby łatwo dostosować do warianów lokalnych.

### 2.4 Przebieg tury

Gracz dokłada **jedną płytkę** tak, aby przylegała krawędzią do już ułożonej płytki **z dopasowaniem dwóch cyfr** (jak w domino, ale na trójkątach).

**Punkty za ruch = suma trzech cyfr na zagranej płytce** (0 do 15).

### 2.5 Bonusy (kumulują się)

| Bonus              | Warunek                                                                         | Punkty                 |
| ------------------ | ------------------------------------------------------------------------------- | ---------------------- |
| **Triplet**        | Zagrana płytka to triplet (np. 4-4-4)                                           | +10 (lub +30 dla 0-0-0) |
| **Bridge / Most**  | Płytka domyka *narożnikiem* dwa wcześniej rozłączone regiony                    | +40                    |
| **Hexagon**        | Zagrana płytka domyka sześciokąt z 6 trójkątów                                  | +50                    |
| **Podwójny hex**   | Jedna płytka domyka jednocześnie dwa hexagony                                   | +60 + +50 = +110       |
| **Bridge + Hex**   | Kombo: most + domknięcie hexa                                                   | sumują się             |

### 2.6 Kary i dobieranie

Gracz, który **nie może wykonać ruchu**:

1. **Dobiera 1 płytkę** z puli → kara **-5 pkt**
2. Jeśli nadal nie może, dobiera ponownie → kolejne **-5 pkt** (do 3 dobrań)
3. Jeśli po 3 dobraniach nadal nie może → **pasuje, kara -10 pkt** i tura przechodzi dalej

### 2.7 Koniec rundy

Runda kończy się gdy:
- Któryś z graczy **wyczerpał rękę** → **+25 pkt bonusu + suma cyfr na rękach przeciwników**
- LUB nikt nie może wykonać ruchu (pula pusta, wszyscy spasowali) → wygrywa gracz z najniższą sumą na ręce

### 2.8 Koniec gry

Trzy obsługiwane warianty (wybór w setup):

1. **Pierwszy do progu punktowego** (domyślnie 400 pkt)
2. **Ustalona liczba rund** (np. 3, 5)
3. **Dowolnie** (rozgrywka kończy się ręcznie / na życzenie gracza)

Wszystkie wartości progów konfigurowalne w UI setup.

---

## 3. Decyzje produktowe

Ustalenia z fazy odkrywania:

| Aspekt              | Decyzja                                                                 |
| ------------------- | ----------------------------------------------------------------------- |
| Nazwa               | **TriominoScore**                                                       |
| Platformy           | iOS (priorytet) + Android (równolegle dzięki Flutter)                   |
| Stack               | **Flutter** (Dart) — jeden kod, dwie platformy                          |
| Zakres              | Pomocnik do liczenia punktów (bez cyfrowej rozgrywki)                   |
| Wariant zasad       | Klasyczny 56 płytek; **Goliath + Pressman** — wybór w Setup od v1.0     |
| Liczba graczy       | 2-6                                                                     |
| Profile / historia  | Goście default; opcjonalny zapis jako profil; nielimitowana historia    |
| Tryb końca gry      | Limit punktów + ustalona liczba rund (oba do wyboru w setup)            |
| Input wyników       | Smart input: 3 narożniki (0-5) + checkboxy bonusów                      |
| Storage             | Tylko lokalnie — SQLite (drift) + SharedPreferences                     |
| Backend             | Brak                                                                    |
| Branding            | Glassmorphism premium, kolor wiodący **Indigo / Royal Purple**          |
| Tematy              | Light + Dark (auto z systemu, override w ustawieniach)                  |
| Responsive          | Phone-first (iPhone + Android phone); tablet layouty w v1.1             |
| Scenariusz użycia   | Solo score-keeper — jedna osoba wpisuje wyniki za wszystkich            |
| Tura                | Autopilot — app prowadzi turę (kolejność przez seatIndex)               |
| Walidacja płytek    | Licznik widoczny (np. 23/56) bez blokady duplikatów                     |
| Języki              | PL, EN, DE, FR, ES, IT (6 lokalizacji)                                  |
| Audio / Haptics     | Tak — subtelne sound effects + HapticFeedback per platforma             |
| Onboarding          | Pełny tutorial przy pierwszym uruchomieniu + ekran "Zasady"             |
| Monetyzacja v1.0    | Brak — wszystko darmowe, bez reklam                                     |
| Premium (v2.0)      | OCR skaner płytki przez kamerę                                          |
| Dystrybucja MVP     | Lokalne builds (flutter run na symulatorze/emulatorze)                  |

---

## 4. Stack technologiczny

### Język i framework

- **Flutter 3.x** (stable channel)
- **Dart 3.x** (sound null safety, records, patterns)

### Kluczowe pakiety

| Kategoria             | Pakiet                              | Uzasadnienie                                           |
| --------------------- | ----------------------------------- | ------------------------------------------------------ |
| State management      | `flutter_riverpod` + `riverpod_generator` | Typowane, async-first, code-gen, branżowy standard |
| Routing               | `go_router`                         | Oficjalny pakiet Flutter team, deep-link friendly      |
| Baza danych           | `drift` (+ `drift_dev`)             | SQLite ORM, type-safe queries, code-gen                |
| Settings              | `shared_preferences`                | Standard dla key-value preferences                     |
| i18n                  | `flutter_localizations` + `intl`    | Oficjalne narzędzia ARB                                |
| Dane / modele         | `freezed` + `json_serializable`     | Immutable models, copyWith, equals, JSON               |
| ID generation         | `uuid`                              | UUID v4 dla encji                                      |
| Audio                 | `just_audio`                        | Niezawodne odtwarzanie krótkich sampli                 |
| Haptics               | `vibration` lub `flutter/services`  | HapticFeedback z `flutter/services` jest wbudowane     |
| Animacje              | `flutter_animate`                   | Deklaratywne, eleganckie API                           |
| Glassmorphism         | `BackdropFilter` (wbudowane)        | Natywne, performance OK                                |
| Konfetti              | `confetti`                          | Efekt przy hexagonie / wygranej                        |
| Wykresy               | `fl_chart`                          | Statystyki, przebieg gry                               |
| Typografia            | `google_fonts`                      | Font Inter / Manrope                                   |
| Splash / Icons        | `flutter_native_splash`, `flutter_launcher_icons` | Build-time generation              |
| Date / time           | `intl` (już mamy)                   | Formatowanie zlokalizowane                             |
| Testy                 | `flutter_test`, `mocktail`, `golden_toolkit` | Unit + widget + golden + integration testy    |

### Wersjonowanie pakietów

- Strategia: **lock to minor**, semver-strict
- `pubspec.lock` **commitujemy** (mobilna apka, nie biblioteka)

---

## 5. Architektura aplikacji

### 5.1 Wzorzec architektoniczny

**Feature-first Clean Architecture** z trzema warstwami per feature:

```
features/<feature>/
├── presentation/    # UI: Widgets, Pages, Providers (Riverpod)
├── domain/          # Pure Dart: Entities, UseCases, Repository interfaces
└── data/            # Repository implementations, DataSources (DB, prefs)
```

**Zalety:**
- Każdy feature jest samowystarczalny (łatwy do dodania/usunięcia)
- Domain warstwa **bez zależności** od Fluttera — testowalna jak zwykły Dart
- Wymiana implementacji (np. drift → hive) bez ruszania UI

### 5.2 Zarządzanie stanem

**Riverpod 2.x** z code-gen (`@riverpod`):

- **AsyncNotifierProvider** dla danych z bazy (gracze, gry, statystyki)
- **NotifierProvider** dla stanu UI (current game, current round)
- **Provider** dla services (DB, audio, haptics, settings)
- **FutureProvider** / **StreamProvider** dla async lookupów

### 5.3 Dependency Injection

Riverpod **jest** systemem DI w tym projekcie. Brak GetIt, brak osobnego service locatora.

### 5.4 Routing

`go_router` z deklaratywnym configiem w `lib/core/routing/app_router.dart`. Wszystkie ścieżki nazwane (`.named('game.play')`).

### 5.5 Persystencja

- **drift** (SQLite) dla wszystkich danych transakcyjnych: gracze, gry, rundy, ruchy, statystyki
- **shared_preferences** dla preferencji UI: tryb dark/light, język, wybrana grupa graczy, włączone haptics/sounds

### 5.6 Schemat zależności

```
┌─────────────────────────────────────────────┐
│  Presentation (Widgets, Riverpod providers) │
└──────────────────┬──────────────────────────┘
                   ↓ wywołuje
┌──────────────────────────────────────────────┐
│  Domain (UseCases, Entities, Repository abs.)│ ← pure Dart, brak Flutter
└──────────────────┬───────────────────────────┘
                   ↑ implementuje
┌──────────────────────────────────────────────┐
│  Data (Repository impl, drift, prefs)        │
└──────────────────────────────────────────────┘
```

---

## 6. Struktura projektu

```
triomino_score/
├── CLAUDE.md                          # Ten plik
├── README.md                          # Krótkie info dla devs
├── pubspec.yaml                       # Dependencies + assets
├── analysis_options.yaml              # Lints (very_good_analysis)
├── l10n.yaml                          # Konfiguracja generatora i18n
├── android/                           # Android wrapper
├── ios/                               # iOS wrapper
├── assets/
│   ├── images/
│   │   ├── logo.svg
│   │   ├── tiles/                     # Ilustracje przykładowych płytek (do tutoriala)
│   │   └── onboarding/
│   ├── sounds/
│   │   ├── tap.mp3                    # Krótki feedback tapnięcia
│   │   ├── triplet.mp3                # Bonus triplet
│   │   ├── bridge.mp3                 # Bonus most
│   │   ├── hexagon.mp3                # Bonus hexagon (najbardziej satysfakcjonujący)
│   │   ├── win.mp3                    # Wygrana
│   │   └── lose.mp3                   # (opcjonalnie)
│   └── fonts/                         # Lokalne fonty fallback (jeśli google_fonts offline fail)
├── lib/
│   ├── main.dart                      # Entry point: runApp, init drift, init prefs
│   ├── app.dart                       # MaterialApp.router + theme + locale
│   │
│   ├── core/                          # Współdzielona infrastruktura
│   │   ├── routing/
│   │   │   └── app_router.dart        # go_router config
│   │   ├── theme/
│   │   │   ├── app_theme.dart         # ThemeData light/dark
│   │   │   ├── app_colors.dart        # Paleta Indigo + neutralne
│   │   │   ├── app_typography.dart    # TextStyles (Inter)
│   │   │   ├── app_spacing.dart       # 4/8/12/16/24/32/48
│   │   │   ├── glass.dart             # GlassContainer widget (BackdropFilter)
│   │   │   └── motion.dart            # Durations + curves
│   │   ├── database/
│   │   │   ├── app_database.dart      # drift database class
│   │   │   ├── tables/
│   │   │   │   ├── players_table.dart
│   │   │   │   ├── games_table.dart
│   │   │   │   ├── rounds_table.dart
│   │   │   │   ├── moves_table.dart
│   │   │   │   └── game_players_table.dart
│   │   │   ├── daos/                  # Data Access Objects (drift)
│   │   │   │   ├── players_dao.dart
│   │   │   │   ├── games_dao.dart
│   │   │   │   └── stats_dao.dart
│   │   │   └── migrations/            # Migracje schematu (versioned)
│   │   ├── settings/
│   │   │   ├── settings_repository.dart    # shared_preferences wrapper
│   │   │   └── settings_provider.dart      # Riverpod
│   │   ├── audio/
│   │   │   ├── audio_service.dart
│   │   │   └── audio_provider.dart
│   │   ├── haptics/
│   │   │   └── haptics_service.dart
│   │   ├── game/                      # Pure Dart - logika gry, bez Fluttera
│   │   │   ├── scoring_rules.dart     # Konfiguracja bonusów (TRIPLET_BONUS, BRIDGE_BONUS itp.)
│   │   │   ├── score_calculator.dart  # Czysta funkcja: Move → punkty
│   │   │   ├── starter_resolver.dart  # Kto startuje (najwyższy triplet)
│   │   │   └── game_state_machine.dart # turn → end of round → end of game
│   │   ├── localization/
│   │   │   ├── l10n.dart              # Generowane przez flutter gen-l10n
│   │   │   └── locale_provider.dart
│   │   ├── utils/
│   │   │   ├── id.dart                # UUID generator
│   │   │   ├── date_format.dart
│   │   │   └── result.dart            # sealed class Result<T> dla domain
│   │   └── constants.dart             # MAX_PLAYERS, MIN_PLAYERS, DEFAULT_SCORE_LIMIT
│   │
│   ├── features/
│   │   ├── home/
│   │   │   └── presentation/
│   │   │       ├── home_page.dart
│   │   │       └── widgets/
│   │   │           ├── home_action_card.dart
│   │   │           └── resume_game_banner.dart
│   │   ├── onboarding/
│   │   │   └── presentation/
│   │   │       ├── onboarding_page.dart
│   │   │       └── widgets/
│   │   ├── players/
│   │   │   ├── domain/
│   │   │   │   ├── player.dart        # Freezed entity
│   │   │   │   └── players_repository.dart
│   │   │   ├── data/
│   │   │   │   └── players_repository_impl.dart
│   │   │   └── presentation/
│   │   │       ├── players_list_page.dart
│   │   │       ├── player_form_page.dart
│   │   │       └── widgets/
│   │   ├── game_setup/
│   │   │   └── presentation/
│   │   │       ├── game_setup_page.dart  # Wybór graczy, trybu, progu
│   │   │       └── widgets/
│   │   │           ├── player_picker.dart
│   │   │           ├── end_mode_selector.dart
│   │   │           └── score_limit_input.dart
│   │   ├── game/                      # Sercem aplikacji
│   │   │   ├── domain/
│   │   │   │   ├── game.dart
│   │   │   │   ├── round.dart
│   │   │   │   ├── move.dart          # Pojedyncze zagranie
│   │   │   │   ├── bonus.dart         # enum: triplet / bridge / hexagon / doubleHex
│   │   │   │   └── game_repository.dart
│   │   │   ├── data/
│   │   │   │   └── game_repository_impl.dart
│   │   │   └── presentation/
│   │   │       ├── game_page.dart     # Główny ekran rozgrywki
│   │   │       ├── controllers/
│   │   │       │   └── game_controller.dart  # @riverpod NotifierProvider
│   │   │       └── widgets/
│   │   │           ├── player_score_card.dart   # Karta z aktualnym wynikiem
│   │   │           ├── active_player_indicator.dart
│   │   │           ├── smart_input_sheet.dart   # Bottom sheet z 3 cyframi + bonusami
│   │   │           ├── corner_picker.dart       # 0-5 chip selector
│   │   │           ├── bonus_toggles.dart       # triplet / bridge / hexagon
│   │   │           ├── round_history_list.dart  # Lista ruchów z undo
│   │   │           ├── penalty_dialog.dart      # Dobranie z puli / pas
│   │   │           └── end_round_dialog.dart    # Kto wyczerpał rękę / kto z najmniej
│   │   ├── game_summary/
│   │   │   └── presentation/
│   │   │       ├── game_summary_page.dart  # Po zakończeniu gry
│   │   │       └── widgets/
│   │   │           ├── winner_celebration.dart  # Konfetti, animacja
│   │   │           ├── final_scoreboard.dart
│   │   │           └── share_button.dart
│   │   ├── history/
│   │   │   ├── domain/
│   │   │   └── presentation/
│   │   │       ├── history_page.dart
│   │   │       └── widgets/
│   │   │           └── game_history_tile.dart
│   │   ├── statistics/
│   │   │   ├── domain/
│   │   │   │   └── stats_calculator.dart   # Win rate, średnie, najlepszy ruch
│   │   │   └── presentation/
│   │   │       ├── statistics_page.dart
│   │   │       └── widgets/
│   │   │           ├── stat_card.dart
│   │   │           ├── progress_chart.dart    # fl_chart
│   │   │           └── per_player_stats.dart
│   │   ├── rules/
│   │   │   └── presentation/
│   │   │       └── rules_page.dart    # Scrollowane zasady + obrazki + przykłady
│   │   └── settings/
│   │       └── presentation/
│   │           ├── settings_page.dart
│   │           └── widgets/
│   │               ├── theme_selector.dart
│   │               ├── language_selector.dart
│   │               ├── sound_toggle.dart
│   │               └── haptics_toggle.dart
│   │
│   ├── shared/
│   │   ├── widgets/
│   │   │   ├── glass_container.dart   # BackdropFilter + border + radius
│   │   │   ├── primary_button.dart    # Główny CTA
│   │   │   ├── secondary_button.dart
│   │   │   ├── score_chip.dart        # +15 z animacją
│   │   │   ├── player_avatar.dart     # Inicjały lub ikona
│   │   │   ├── responsive_layout.dart # phone / tablet
│   │   │   └── empty_state.dart
│   │   └── extensions/
│   │       ├── build_context.dart     # context.colors, context.l10n
│   │       └── num_format.dart        # 1240 → "1 240" zlokalizowane
│   │
│   └── l10n/                          # ARB pliki tłumaczeń
│       ├── app_pl.arb
│       ├── app_en.arb
│       ├── app_de.arb
│       ├── app_fr.arb
│       ├── app_es.arb
│       └── app_it.arb
│
├── test/
│   ├── core/
│   │   ├── game/
│   │   │   ├── score_calculator_test.dart   # Najwięcej testów tu — czysta logika
│   │   │   └── starter_resolver_test.dart
│   │   └── database/
│   ├── features/
│   │   ├── game/
│   │   └── statistics/
│   └── widget/
│       ├── smart_input_sheet_test.dart
│       └── player_score_card_test.dart
│
└── integration_test/
    ├── flows/
    │   ├── new_game_to_end_test.dart  # Pełna gra E2E
    │   └── tutorial_flow_test.dart
    └── app_test.dart
```

---

## 7. Model danych i schemat bazy

### 7.1 Schemat (drift)

Wszystkie ID jako **TEXT** (UUID v4) — łatwo unikalne między urządzeniami bez konfliktu.

#### `players`

Profil gracza (trwały między grami).

```dart
class Players extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().withLength(min: 1, max: 32)();
  TextColumn get avatarColor => text()();      // hex np. "#7C3AED"
  TextColumn get initials => text().withLength(min: 1, max: 3)();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
```

#### `games`

Pojedyncza gra (zbiór rund).

```dart
class Games extends Table {
  TextColumn get id => text()();
  TextColumn get endMode => textEnum<EndMode>()();   // scoreLimit | rounds | freeform
  IntColumn get scoreLimit => integer().nullable()();      // dla scoreLimit
  IntColumn get totalRounds => integer().nullable()();     // dla rounds
  IntColumn get currentRound => integer().withDefault(const Constant(1))();
  TextColumn get status => textEnum<GameStatus>()();  // inProgress | finished | abandoned
  TextColumn get winnerId => text().nullable()();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get finishedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
```

#### `game_players`

Powiązanie gracza z grą + kolejność tury.

```dart
class GamePlayers extends Table {
  TextColumn get gameId => text().references(Games, #id, onDelete: KeyAction.cascade)();
  TextColumn get playerId => text().references(Players, #id)();
  IntColumn get seatIndex => integer()();          // 0..5 — kolejność
  IntColumn get totalScore => integer().withDefault(const Constant(0))();
  TextColumn get displayNameSnapshot => text()();  // imię w momencie gry (gdy potem usunie profil)

  @override
  Set<Column> get primaryKey => {gameId, playerId};
}
```

#### `rounds`

Runda w grze.

```dart
class Rounds extends Table {
  TextColumn get id => text()();
  TextColumn get gameId => text().references(Games, #id, onDelete: KeyAction.cascade)();
  IntColumn get roundNumber => integer()();
  TextColumn get starterPlayerId => text()();         // kto rozpoczął rundę
  TextColumn get finisherPlayerId => text().nullable()();  // kto wyczerpał rękę
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get finishedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
```

#### `moves`

Pojedynczy ruch (zagrana płytka lub kara).

```dart
class Moves extends Table {
  TextColumn get id => text()();
  TextColumn get roundId => text().references(Rounds, #id, onDelete: KeyAction.cascade)();
  TextColumn get playerId => text()();
  IntColumn get moveIndex => integer()();              // 0..n w ramach rundy
  TextColumn get moveType => textEnum<MoveType>()();   // play | drawPenalty | passPenalty | endOfHandBonus
  IntColumn get corner1 => integer().nullable()();     // 0..5 (null dla penalty)
  IntColumn get corner2 => integer().nullable()();
  IntColumn get corner3 => integer().nullable()();
  IntColumn get baseScore => integer()();              // suma narożników (lub kara ujemna)
  IntColumn get bonusScore => integer().withDefault(const Constant(0))();
  BoolColumn get isTriplet => boolean().withDefault(const Constant(false))();
  BoolColumn get isBridge => boolean().withDefault(const Constant(false))();
  BoolColumn get isHexagon => boolean().withDefault(const Constant(false))();
  BoolColumn get isDoubleHexagon => boolean().withDefault(const Constant(false))();
  BoolColumn get isStarter => boolean().withDefault(const Constant(false))();  // pierwszy ruch w grze
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
```

> **Po co `moveIndex`?** Aby zachować dokładną kolejność ruchów (undo musi działać w odwrotnej kolejności) i aby query po `ORDER BY` był deterministyczny.

#### `settings` (jeśli potrzebujemy bardziej złożonych ustawień)

W MVP wszystko trzymamy w `shared_preferences`. Tabela `settings` w drift dopiero gdy będą potrzebne złożone struktury.

### 7.2 Migracje

System migracji `drift` — wersjonowane, uruchamiane automatycznie:

```dart
@override
int get schemaVersion => 1;

@override
MigrationStrategy get migration => MigrationStrategy(
  onCreate: (m) => m.createAll(),
  onUpgrade: (m, from, to) async {
    if (from < 2) {
      // np. await m.addColumn(playersTable, playersTable.avatarColor);
    }
  },
);
```

Każda zmiana schematu = nowa migracja, bump `schemaVersion`.

---

## 8. Smart Input – algorytm i UX

**Smart Input** to bottom-sheet otwierany przyciskiem **"+ Dodaj ruch"** na karcie aktywnego gracza. To **najważniejszy element UX aplikacji** — 90% interakcji odbywa się tutaj.

### 8.1 Layout (od góry):

```
╔══════════════════════════════════════╗
║  Ruch gracza: Bartosz                ║
║  Runda 2 · ruch #14                  ║
║                                      ║
║  Cyfry narożników płytki             ║
║   ┌───┐  ┌───┐  ┌───┐                ║
║   │ 5 │  │ 3 │  │ 2 │   = 10 pkt    ║
║   └───┘  └───┘  └───┘                ║
║   chips 0-5 z hapticem               ║
║                                      ║
║  Bonusy (tap aby dodać)              ║
║   [✓ Triplet]  [  Bridge ]           ║
║   [  Hexagon ] [  Hex×2  ]           ║
║                                      ║
║  ─────────── Podsumowanie ─────────  ║
║   Bazowo:        10                  ║
║   + Triplet:    +10                  ║
║   ────────────────                   ║
║   Razem:         20                  ║
║                                      ║
║   [  Anuluj  ]    [  Zatwierdź  ]    ║
╚══════════════════════════════════════╝
```

### 8.2 Algorytm walidacji wejścia

```dart
class MoveValidation {
  // Triplet: wszystkie 3 narożniki takie same
  static bool isTriplet(int c1, int c2, int c3) => c1 == c2 && c2 == c3;

  // 0-0-0 to specjalny triplet (premia +30 zamiast +10)
  static bool isSpecialZeroTriplet(int c1, int c2, int c3) =>
      c1 == 0 && c2 == 0 && c3 == 0;

  // Walidacja: każdy narożnik 0-5
  static bool isValid(int c1, int c2, int c3) =>
      [c1, c2, c3].every((v) => v >= 0 && v <= 5);
}
```

### 8.3 Auto-detekcja tripletu

Gdy wszystkie 3 chipy mają tę samą cyfrę → automatycznie:
1. Toggle "Triplet" włącza się
2. Pojawia się haptic medium impact
3. Na karcie podsumowania świeci się "✨ Triplet"

### 8.4 Konflikty bonusów

- **Hexagon** i **Double Hexagon** są **mutually exclusive** (radio, nie checkbox)
- **Bridge** + **Hexagon** mogą występować razem (kombo)
- **Triplet** może łączyć się ze wszystkim (zagrana płytka to nadal triplet)

### 8.5 Kary / specjalne ruchy

W bottom sheet, w dolnej części, **collapsible section "Inne akcje"**:
- **Dobranie z puli (-5)** — szybki guzik, dodaje karny ruch bez 3 cyfr
- **Pas (-10)** — kończy turę z karą
- **Wyjście (wyczerpana ręka)** — kończy rundę, otwiera dialog: "Podaj sumy cyfr na rękach przeciwników"

### 8.6 Edycja i Undo

- **Undo ostatniego ruchu** — przycisk na karcie ostatniego ruchu w historii rundy, max 3 ruchy wstecz
- **Edycja dowolnego ruchu** — long-press na ruch w historii → otwiera Smart Input z istniejącymi danymi
- Edycja **przelicza totalScore** wszystkich graczy automatycznie (transakcja DB)

---

## 9. System bonusów i kar

Wartości w `lib/core/game/scoring_rules.dart` — łatwo konfigurowalne na potrzeby wariantów house rules.

### 9.1 Stałe bonusów

```dart
abstract class ScoringRules {
  // Premia za zagranie tripletu (z wyjątkiem 0-0-0)
  static const int tripletBonus = 10;

  // Specjalna premia za 0-0-0 (triplet zer dający 0 punktów bazowych)
  static const int zeroTripletBonus = 30;

  // Most: zagrana łącząca dwa odrębne regiony tylko narożnikiem
  static const int bridgeBonus = 40;

  // Hexagon: domknięcie sześciokąta z 6 trójkątów
  static const int hexagonBonus = 50;

  // Podwójny hexagon: jedna płytka domyka dwa hexagony jednocześnie
  static const int doubleHexagonBonus = 60;  // sumuje się z hexagonBonus

  // Bonus za pierwszy ruch w grze
  static const int starterBonus = 10;

  // Bonus za zakończenie rundy (wyczerpanie ręki)
  static const int endOfHandBonus = 25;

  // Kary
  static const int drawPenalty = -5;
  static const int passPenalty = -10;

  // Limity
  static const int maxDraws = 3;
  static const int defaultScoreLimit = 400;
  static const int defaultRounds = 3;
}
```

### 9.2 Kalkulator punktów

Czysta funkcja w `lib/core/game/score_calculator.dart`:

```dart
int calculateMoveScore(Move move) {
  if (move.type == MoveType.drawPenalty) return ScoringRules.drawPenalty;
  if (move.type == MoveType.passPenalty) return ScoringRules.passPenalty;
  if (move.type == MoveType.endOfHandBonus) {
    return ScoringRules.endOfHandBonus + (move.opponentsHandSum ?? 0);
  }

  int score = (move.corner1 ?? 0) + (move.corner2 ?? 0) + (move.corner3 ?? 0);

  if (move.isTriplet) {
    score += (move.corner1 == 0)
        ? ScoringRules.zeroTripletBonus
        : ScoringRules.tripletBonus;
  }
  if (move.isBridge) score += ScoringRules.bridgeBonus;
  if (move.isHexagon) score += ScoringRules.hexagonBonus;
  if (move.isDoubleHexagon) score += ScoringRules.doubleHexagonBonus;
  if (move.isStarter) score += ScoringRules.starterBonus;

  return score;
}
```

**100% testowalne** bez Fluttera (zwykły Dart test).

---

## 10. Ekrany aplikacji

### 10.1 Splash (natywny)

- Generowany przez `flutter_native_splash`
- Logo TriominoScore + tło indigo gradient
- ~500ms, niknie gdy app gotowy

### 10.2 Onboarding (pierwsze uruchomienie)

4 ekrany swipe (lub auto-advance):
1. **Welcome** — "Witaj w TriominoScore. Twój profesjonalny pomocnik."
2. **Smart Input** — animacja jak wprowadza się ruch
3. **Bonusy** — pokazuje triplet / bridge / hexagon z grafiką
4. **Gotowi do gry** → CTA "Zaczynamy"

Po skończeniu zapisuje `prefs.onboardingCompleted = true`.

### 10.3 Home

Karty akcji (glass containers):
- **➕ Nowa gra** (CTA, indigo gradient)
- **▶ Wznów grę** (widoczne tylko gdy `games.status == inProgress` istnieje)
- **👥 Gracze** (zarządzanie profilami)
- **📊 Historia**
- **📈 Statystyki**
- **📜 Zasady**
- **⚙️ Ustawienia** (ikona w prawym górnym rogu app baru)

### 10.4 Setup gry

Wieloetapowy formularz (stepper):
1. **Gracze** — picker z istniejących profili + szybkie dodanie nowego inline
2. **Tryb końca** — radio: Limit punktów / Liczba rund / Dowolny
3. **Próg** — slider (100-1000 dla punktów, 1-10 dla rund)
4. **Start** → CTA tworzy `Game` w DB, nawiguje do `/game/:id`

### 10.5 Game (serce aplikacji)

**Layout (phone portrait):**
```
┌────────────────────────────────┐
│  ← Daniel · Runda 2 · 240 pkt  │ ← app bar (gradient indigo)
├────────────────────────────────┤
│                                │
│  ┌──────────────────────────┐  │
│  │  🔵 Daniel (TWÓJ RUCH)   │  │ ← aktywny, świeci, glow
│  │  240 pkt    [+5 ostatnio]│  │
│  └──────────────────────────┘  │
│                                │
│  ┌──────────────────────────┐  │
│  │  Bartosz                 │  │
│  │  198 pkt                 │  │
│  └──────────────────────────┘  │
│                                │
│  ┌──────────────────────────┐  │
│  │  Anna                    │  │
│  │  171 pkt                 │  │
│  └──────────────────────────┘  │
│                                │
│  Historia tej rundy            │
│  • Daniel: 12 pkt (4-4-4)  ↩  │
│  • Bartosz: 8 pkt (1-3-4)   ↩  │
│  • Anna: 15 pkt (5-5-5) ✨    │
│                                │
├────────────────────────────────┤
│  [        ➕ DODAJ RUCH       ]│ ← główny CTA
│  [   ⏭ Pas    🤝 Wyjście     ]│
└────────────────────────────────┘
```

**Layout (tablet landscape):**
- 2 kolumny: karty graczy po lewej (siatka 2×3), historia rundy po prawej
- Bottom sheet smart input nadal centralnie na dole

### 10.6 Game Summary

Po osiągnięciu warunku końca gry:
- **Animacja konfetti** dla zwycięzcy (`confetti` package)
- **Final scoreboard** z miejscami 🥇🥈🥉
- **Statystyki gry:** czas trwania, liczba rund, najlepszy ruch (z ikoną gracza), liczba hexagonów
- **CTA:** "Rewanż" (auto-setup z tymi samymi graczami) / "Powrót do home" / "Udostępnij"

### 10.7 Historia

Lista wszystkich zakończonych gier:
- Tile per gra: data, gracze, zwycięzca, suma punktów
- Tap → szczegóły gry (read-only odtworzenie: rundy, ruchy)

### 10.8 Statystyki

**Globalne:**
- Łącznie rozegranych gier
- Najlepszy wynik all-time
- Najwięcej hexagonów w jednej grze

**Per gracz** (wybór z dropdown):
- Win rate (% wygranych)
- Średnia punktów na grę
- Średnia punktów na ruch
- Najlepszy ruch (typ + wartość)
- Wykres ostatnich 10 gier (fl_chart)

### 10.9 Zasady

Scrollowana strona z formatowanym tekstem:
- Markdown rendering (lub własne sekcje)
- Spis treści na górze (chips)
- Ilustracje płytek i hexagonów
- "Quick reference" na końcu — tabela bonusów

### 10.10 Ustawienia

- **Język** (dropdown z 6 językami)
- **Motyw** (system / light / dark)
- **Dźwięki** (toggle)
- **Haptics** (toggle)
- **Próg punktowy domyślny** (slider)
- **O aplikacji** — wersja, link do polityki prywatności
- **Reset danych** (z potwierdzeniem) — czyści wszystkie gry i graczy

---

## 11. Design system – Glassmorphism

### 11.1 Paleta kolorów

**Light mode:**
```dart
primary:        #6366F1   // Indigo 500
primaryDark:    #4338CA   // Indigo 700 (gradient)
secondary:      #A78BFA   // Violet 400
background:     #F5F3FF   // Subtle violet-white
surface:        #FFFFFF
glass:          rgba(255, 255, 255, 0.65) // background dla GlassContainer
glassBorder:    rgba(255, 255, 255, 0.4)
text:           #1E1B4B   // Indigo 950
textSecondary:  #6B7280
success:        #10B981
warning:        #F59E0B
error:          #EF4444
```

**Dark mode:**
```dart
primary:        #818CF8   // Indigo 400 (jaśniejszy w dark)
primaryDark:    #6366F1
secondary:      #C4B5FD
background:     #0F0A2E   // Deep indigo-black
surface:        #1E1B4B
glass:          rgba(255, 255, 255, 0.08)
glassBorder:    rgba(255, 255, 255, 0.12)
text:           #F9FAFB
textSecondary:  #9CA3AF
```

### 11.2 GlassContainer (rdzeń systemu)

```dart
class GlassContainer extends StatelessWidget {
  final Widget child;
  final double blur;           // domyślnie 24
  final double opacity;        // domyślnie 0.65 light / 0.08 dark
  final BorderRadius? radius;  // domyślnie BorderRadius.circular(24)
  final EdgeInsets? padding;
  // ...
}
```

Implementacja: `BackdropFilter(filter: ImageFilter.blur(...))` + `DecoratedBox`.

### 11.3 Typografia

**Font:** Inter (przez google_fonts), fallback do San Francisco / Roboto.

| Styl           | Rozmiar | Waga    | Użycie                            |
| -------------- | ------- | ------- | --------------------------------- |
| `displayLarge` | 56      | 700     | Wynik gracza w game summary        |
| `displayMedium`| 40      | 700     | Punktacja aktywnego gracza        |
| `headlineLg`   | 32      | 600     | Tytuły ekranów                    |
| `headlineSm`   | 24      | 600     | Sekcje                            |
| `titleLg`      | 20      | 600     | Karty graczy                      |
| `bodyLg`       | 16      | 400     | Tekst standardowy                 |
| `bodyMd`       | 14      | 400     | Tekst pomocniczy                  |
| `labelLg`      | 14      | 600     | CTA buttons                       |
| `labelSm`      | 12      | 500     | Chips, badges                     |

### 11.4 Spacing scale

`4, 8, 12, 16, 24, 32, 48, 64`. Wszystko z `AppSpacing.x12`.

### 11.5 Animacje

- **Default duration:** 250ms
- **Easing:** `Curves.easeOutCubic` (premium feel)
- **Page transitions:** fade + slide-up subtelne (16px)
- **Score change:** scale + fade + counter animation (`AnimatedFlipCounter`)
- **Bonus reveal:** spring scale 0.8 → 1.0 + glow

### 11.6 Responsive breakpoints

```dart
abstract class Breakpoints {
  static const double phone = 600;
  static const double tablet = 900;
  static const double desktop = 1200; // future-proof
}
```

**LayoutBuilder strategy:**
- `< 600px` — phone layout (single column)
- `600-900px` — tablet portrait (2 kolumny w game)
- `> 900px` — tablet landscape / iPad Pro (sidebar + content)

---

## 12. Internacjonalizacja (i18n)

### 12.1 Lokalizacje

6 języków od dnia premiery:

| Locale | Język      | Status |
| ------ | ---------- | ------ |
| `pl`   | Polski     | Primary (developer's language) |
| `en`   | English    | Required (rynek globalny) |
| `de`   | Deutsch    | Required (Schmidt Spiele) |
| `fr`   | Français   | Required (rynek francuski) |
| `es`   | Español    | Required (rynek hiszpański) |
| `it`   | Italiano   | Required (rynek włoski) |

### 12.2 Pliki ARB

`lib/l10n/app_<locale>.arb`. Generator Flutter (`flutter gen-l10n`) tworzy `AppLocalizations` typowo.

**Konwencja kluczy:**
- `home.newGame.cta`
- `game.bonus.tripletDescription`
- `errors.invalidPlayerName`

**Pluralizacja:**
```json
{
  "playersCount": "{count, plural, =1{1 gracz} few{{count} graczy} other{{count} graczy}}"
}
```

### 12.3 Przełączanie języka

`Locale` przez Riverpod `localeProvider`. User wybiera w ustawieniach, zapisane w `shared_preferences`. Default = locale systemu jeśli dostępny w supported, inaczej `en`.

### 12.4 Format dat i liczb

Wyłącznie przez `intl` z `MaterialApp.locale`. Nigdy `'$score pkt'` hardcoded — zawsze `l10n.scoreUnit(score)`.

---

## 13. Audio i Haptics

### 13.1 Sound effects

**Pakiet:** `just_audio` (stabilny, dobre API).

| Event              | Plik              | Czas    | Volume |
| ------------------ | ----------------- | ------- | ------ |
| Score added        | `tap.mp3`         | <200ms  | 0.3    |
| Triplet bonus      | `triplet.mp3`     | ~500ms  | 0.6    |
| Bridge bonus       | `bridge.mp3`      | ~600ms  | 0.6    |
| Hexagon bonus      | `hexagon.mp3`     | ~1s     | 0.8    |
| Game won           | `win.mp3`         | ~2s     | 0.7    |
| Round ended        | `round_end.mp3`   | ~700ms  | 0.5    |

**Reguły:**
- Krótkie, niskie pliki MP3 (<50KB)
- Wszystkie zsynchronizowane z animacjami
- Wyciszane przez ustawienie `prefs.soundsEnabled`
- Respektują system mute (silent mode na iOS)

### 13.2 Haptic feedback

**Wbudowane `flutter/services` HapticFeedback:**

| Akcja                  | Feedback                      |
| ---------------------- | ----------------------------- |
| Chip narożnika tap     | `selectionClick()` (lekki)    |
| Toggle bonusa          | `lightImpact()`               |
| Zatwierdzenie ruchu    | `mediumImpact()`              |
| Triplet auto-detect    | `mediumImpact()`              |
| Bonus hexagon          | `heavyImpact()`               |
| Wygrana                | 3× `mediumImpact()` w sekwencji |
| Błąd walidacji         | `vibrate()` krótka            |

Wyciszane przez `prefs.hapticsEnabled`.

---

## 14. Konwencje kodowania

### 14.1 Style guide

- **Lints:** `very_good_analysis` (rygorystyczne, Apache-style)
- **Formatter:** `dart format` (line length 100)
- **Pre-commit hook:** `dart format --set-exit-if-changed .` + `flutter analyze`

### 14.2 Nazewnictwo

| Element         | Konwencja            | Przykład                        |
| --------------- | -------------------- | ------------------------------- |
| Pliki           | `snake_case`         | `score_calculator.dart`         |
| Klasy           | `PascalCase`         | `GameController`                |
| Metody/fields   | `camelCase`          | `calculateScore`                |
| Stałe (top)     | `lowerCamelCase`     | `defaultScoreLimit`             |
| Stałe (w class) | `lowerCamelCase`     | `static const tripletBonus`     |
| Enum values     | `lowerCamelCase`     | `MoveType.drawPenalty`          |
| Private         | `_underscore`        | `_calculateBonus()`             |
| Generated       | `.g.dart` / `.freezed.dart` | autogen — w .gitignore: NIE — commitujemy |

### 14.3 Struktura widgetów

```dart
class PlayerScoreCard extends ConsumerWidget {
  const PlayerScoreCard({
    required this.playerId,
    required this.isActive,
    super.key,
  });

  final String playerId;
  final bool isActive;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final player = ref.watch(playerProvider(playerId));
    // ...
  }
}
```

- **Zawsze** `const` constructor jeśli możliwe
- **Zawsze** `super.key`
- **Required named params** — pozycyjne tylko gdy 1 oczywisty parametr

### 14.4 Komentarze

**Domyślnie zero komentarzy.** Komentarz tylko gdy:
- Logika nie jest oczywista z kodu
- Workaround dla konkretnego buga (z linkiem do issue)
- Niezmienność (invariant) którego maintainer musi przestrzegać

`// SECURITY:` / `// PERF:` / `// FLUTTER-BUG:` jako prefiksy ważnych adnotacji.

### 14.5 Riverpod conventions

- **Provider naming:** `xxxProvider` (sufix), generowane przez `@riverpod`
- **Async providers:** zawsze `AsyncValue` w UI z `.when(data, loading, error)`
- **Family providers:** dla parametrów (np. `playerProvider(id)`)

### 14.6 Domain layer

**Pure Dart, bez `package:flutter/*`** — wymagane do unit testów bez TestWidgetsFlutterBinding. Złamanie tej reguły = blokujący review.

---

## 15. Testy

### 15.1 Strategie testowania

| Warstwa             | Typ testów             | Pokrycie target |
| ------------------- | ---------------------- | --------------- |
| `core/game/*`       | Unit (pure Dart)       | **100%**        |
| `core/database/*`   | Integration (in-memory drift) | **90%**  |
| Repositories        | Unit + mocked DAOs     | **80%**         |
| Providers           | Unit + mocked deps     | **70%**         |
| Widgets             | Widget tests           | **60%**         |
| E2E flows           | Integration tests      | Happy paths     |

### 15.2 Test driven dla core/game

Score calculator i game state machine **piszemy testami pierwsze**. Łatwiej iterować nad regułami gry gdy widać natychmiast wpływ na testy.

### 15.3 Golden tests

Dla kluczowych widgetów (PlayerScoreCard, SmartInputSheet, GameSummary) — `golden_toolkit`. Zapobiega regresjom wizualnym (cień, blur, gradient).

### 15.4 Komendy

```bash
flutter test                       # Wszystkie unit + widget
flutter test --coverage            # + coverage report
flutter test integration_test      # E2E (potrzebny device/emulator)
flutter test --update-goldens      # Re-generuj golden files
```

---

## 16. Build, dystrybucja i wersjonowanie

### 16.1 Wersjonowanie

**Semantic versioning:** `MAJOR.MINOR.PATCH+BUILD`

```yaml
# pubspec.yaml
version: 1.0.0+1
```

- `1.0.0` — pierwszy release MVP
- `1.0.1` — bugfix
- `1.1.0` — feature dodawany do MVP
- `2.0.0` — premium z OCR

### 16.2 Build komendy

```bash
flutter run                          # Dev na podłączonym device/emulatorze
flutter run -d chrome                # Web preview (debugging)
flutter build apk --release          # Android APK
flutter build appbundle --release    # Android Bundle (Google Play)
flutter build ios --release          # iOS (na macOS)
flutter build ipa --release          # iOS IPA (App Store)
```

### 16.3 Code signing

- **Android:** `android/key.properties` (gitignore) + keystore (gitignore, **backup gdzie indziej**)
- **iOS:** Xcode Automatic Signing przez Apple Developer account

### 16.4 Dystrybucja MVP

Zgodnie z ustaleniami: **lokalne builds**. Brak TestFlight / Play Console na start.

Gdy MVP gotowy do beta:
1. Konto **Apple Developer** ($99/rok) → TestFlight
2. Konto **Google Play Console** ($25 jednorazowo) → Internal Testing track

### 16.5 CI/CD (przyszłość)

Plan na v1.1:
- **GitHub Actions** workflow:
  - `flutter analyze` + `flutter test` na każdym PR
  - Build APK + IPA na merge do `main`
  - Auto-upload do Firebase App Distribution / TestFlight

---

## 17. Roadmapa

### v1.0 (MVP) — Cel: gotowy do beta w 6-8 tygodni

**Tydzień 1-2: Foundation**
- [ ] Setup projektu Flutter, dependencies, lint
- [ ] Theme system + GlassContainer
- [ ] go_router skeleton
- [ ] drift schema + migrations
- [ ] i18n setup z 6 językami (kluczowe stringi)

**Tydzień 3-4: Core gameplay**
- [ ] Score calculator + testy
- [ ] Game state machine
- [ ] Players CRUD (UI + DB)
- [ ] Game setup flow
- [ ] Game screen + Smart Input

**Tydzień 5: Polish & misc**
- [ ] Onboarding
- [ ] Statistics + charts
- [ ] History
- [ ] Rules page
- [ ] Settings
- [ ] Audio + Haptics integration
- [ ] Konfetti + animacje

**Tydzień 6-7: QA**
- [ ] Unit testy core/game 100%
- [ ] Widget testy smart input + game page
- [ ] Integration test happy path
- [ ] Tłumaczenia (review native speakers)
- [ ] Polishing animacji
- [ ] iPad layout review

**Tydzień 8: Beta-ready**
- [ ] App icon + splash
- [ ] Polityka prywatności (mockup, app jest offline więc krótka)
- [ ] Build configs release
- [ ] Smoke test na realnych urządzeniach

### v1.1 — Quality of life

- Konfigurowalne house rules (UI w settings)
- Tryb turniejowy (best of N)
- Eksport historii (CSV / PDF)
- Achievements
- Dodatkowe motywy (pakiet kolorów)
- iCloud / Google Drive backup
- TestFlight + Play Beta

### v2.0 — Premium

- **OCR skaner płytki** przez aparat (Apple Vision / ML Kit)
- Freemium tier (premium one-time purchase)
- Pakiety dźwięków premium
- Statystyki PRO (eksport, deep analytics)
- Avatar packs

### Backlog (poza roadmapą)

- AR overlay (pokaż gdzie ułożysz płytkę aby najwięcej zyskać)
- Multiplayer online (Bluetooth lub Firebase)
- Pełna gra cyfrowa (drag-and-drop)
- Apple Watch / Wear OS companion
- Widget z aktualnym wynikiem na home screen

---

## 18. Zasady dla agenta AI

### 18.1 Przed wprowadzeniem zmian

1. **Przeczytaj powiązane pliki** — domain entity + repository + UI dla pełnego kontekstu zmiany
2. **Sprawdź czy istnieje test** — jeśli zmieniasz logikę w `core/game/`, najpierw uruchom `flutter test test/core/game/` aby zobaczyć baseline
3. **Migracje DB** — każda zmiana w `lib/core/database/tables/` wymaga nowej migracji i bump `schemaVersion`
4. **i18n** — każdy nowy string user-facing musi trafić do **wszystkich 6 plików ARB**, nie tylko `app_pl.arb`

### 18.2 Bezpieczeństwo i niezawodność

- **Nigdy nie usuwaj** ani nie modyfikuj plików `.g.dart` / `.freezed.dart` ręcznie — zawsze przez `dart run build_runner build`
- **Nie loguj** PII (imiona graczy) w `debugPrint` / `logger` — appka jest 100% lokalna ale dobry zwyczaj
- **Walidacja** imion graczy: trim, min 1 max 32, brak emoji w polach formy (alternatywa: avatar)
- **Transakcje DB** dla zmian wpływających na wiele tabel (np. dodanie ruchu = update `totalScore` w `game_players` w jednym `transaction`)

### 18.3 Performance

- **`const` widgets** wszędzie gdzie się da — zmniejsza rebuild cost
- **`select`** w Riverpod dla wąskich obserwacji (`ref.watch(provider.select((s) => s.field))`)
- **Lazy loading** dla list dłuższych niż 20 itemów (`ListView.builder`)
- **Tile na liście historii** = `RepaintBoundary` przy złożonych dekoracjach (cienie, blur)

### 18.4 Styl kodu

- **Brak komentarzy** wyjaśniających "co" robi kod (nazwa zmiennej / metody powinna wystarczyć)
- **Komentarze tylko dla "dlaczego"** — invariant, workaround, decyzja architektoniczna
- **Brak feature flagów** dla scenariuszy które jeszcze nie istnieją — YAGNI
- **Brak abstrakcji** "na zapas" — 3 podobne linie są lepsze niż przedwczesna generalizacja

### 18.5 Domain layer

- **Pure Dart only.** Brak `import 'package:flutter/*'` w `lib/core/game/`, `lib/features/*/domain/`
- Naruszenie = blokujący review

### 18.6 UI

- **Zawsze** używaj `GlassContainer` zamiast `Container` z `BoxDecoration` dla powierzchni glassmorphic
- **Zawsze** używaj `context.l10n.xxx` zamiast hardcoded stringów
- **Zawsze** używaj `AppSpacing.x12` zamiast magic numbers `12`
- **Zawsze** `theme.colorScheme.xxx` zamiast `Colors.indigo`

### 18.7 Testy

- **Nowa funkcja w `core/game/`** = nowy test w `test/core/game/`. Bez wyjątków.
- **Nowy widget** = przynajmniej smoke test (renders without throwing)
- **Naprawa buga** = test który **failuje przed** fixem, **przechodzi po**

### 18.8 Git

- **Branch developmentu:** `claude/triominos-score-app-Hvuph` (aktywny)
- **Commit messages:**
  - Style: `feat(game): add bridge bonus auto-detection`
  - Kategorie: `feat`, `fix`, `refactor`, `test`, `docs`, `style`, `chore`, `perf`
  - Czas teraźniejszy, tryb rozkazujący
- **PR** tylko jeśli user wyraźnie poprosi

---

**Aktualizacje tego pliku:** każda istotna zmiana architektoniczna, nowa funkcja, nowe założenie produktowe — aktualizuj odpowiednią sekcję. CLAUDE.md jest **źródłem prawdy** dla wszystkich przyszłych iteracji.
