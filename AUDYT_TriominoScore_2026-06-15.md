# Kompleksowy audyt aplikacji TriominoScore

**Data:** 2026-06-15  
**Gałąź:** `claude/determined-fermi-30czch`  
**Audytor:** starszy audytor aplikacji (AppSec + jakość kodu + architektura)  
**Zakres:** cały kod `lib/`, schemat bazy (drift), konfiguracja platform (Android/iOS/web), testy, higiena repozytorium, zgodność z `CLAUDE.md`.

> **Metodyka.** Audyt **statyczny** (przegląd kodu + schematu + konfiguracji). W tym kontenerze **nie ma zainstalowanego toolchainu Flutter/Dart** (`flutter`/`dart` nieobecne w PATH — potwierdzone), więc `flutter analyze`, `flutter test`, `flutter pub outdated` i golden testy **nie zostały uruchomione**. Wszystkie ustalenia wynikają z lektury źródeł i są oznaczone `[POTWIERDZONE]` (widoczne w kodzie/output) lub `[DO WERYFIKACJI]` (wymaga sprawdzenia dynamicznego). Odniesienia w formacie `ścieżka:linia`.

> **Kontekst.** W repozytorium istnieje wcześniejszy audyt `AUDYT.md` (2026-06-07), po którym wprowadzono poprawki w commicie `0a701e0` (zmergowanym przez PR #8). **Niniejszy audyt jest niezależny i opisuje bieżący stan kodu po tych poprawkach** — weryfikuje, co faktycznie naprawiono, a co pozostaje otwarte. Tam, gdzie istotne, odnotowuję status względem poprzednich ustaleń.

---

## Skala istotności

| Poziom | Znaczenie |
| ------ | --------- |
| 🔴 KRYTYCZNY | Aktywna luka / utrata danych / kompromitacja. Reakcja natychmiastowa. |
| 🟠 WYSOKI | Poważne ryzyko bezpieczeństwa lub stabilności / blokada wydania. |
| 🟡 ŚREDNI | Istotny dług techniczny / ryzyko warunkowe. Zaplanować. |
| 🟢 NISKI | Drobne usprawnienia, kosmetyka, higiena. |
| ⚪ INFORMACYJNY | Obserwacja / dobra praktyka do rozważenia. |

---

## 1. Podsumowanie wykonawcze (dla zarządu)

TriominoScore to natywna, **w pełni offline'owa** aplikacja mobilna (Flutter) wspomagająca liczenie punktów w grze planszowej Triominos. Z perspektywy bezpieczeństwa profil ryzyka jest **z natury niski**: brak backendu, brak sieci w wersji produkcyjnej, brak kont użytkowników, dane wyłącznie lokalne, brak logowania danych osobowych. Kod jest **schludny, dobrze zorganizowany** (czysta architektura feature-first, warstwa domenowa bez zależności od Fluttera), a rdzeń liczenia punktów jest solidnie pokryty testami jednostkowymi.

Aplikacja jest w stanie **„zaawansowane MVP”**: happy-path działa, a poprzednia runda poprawek zamknęła najgroźniejszy defekt (crash przy usuwaniu gracza), uzupełniła dostępność i wydajność. **Nie ma ustaleń krytycznych w bieżącym kodzie.** Najpoważniejsze otwarte ryzyka są **operacyjne i dystrybucyjne, nie aplikacyjne**: (1) wersja release Androida jest podpisywana **kluczem debugowym** — blokada publikacji w Google Play; (2) **brak jakiegokolwiek CI** — żaden test ani lint nie jest uruchamiany automatycznie, mimo braku toolchainu u dewelopera w tym środowisku; (3) skompilowany build webowy (~45 MB) jest commitowany do repozytorium.

Wymiarem o najniższej dojrzałości jest **DevOps/CI** i **dokumentacja onboardingu** (README to wciąż szablon Fluttera). Istnieje też znaczący **rozjazd między zadeklarowaną specyfikacją (`CLAUDE.md`) a implementacją**: audio, konfetti, reguła „kto zaczyna”, pełne undo/edycja ruchów oraz szczegóły gry w historii są opisane, ale niezaimplementowane. Część z nich to martwy kod w repo.

**Rekomendacja:** aplikacja jest bezpieczna do testów wewnętrznych/beta. **Przed publiczną dystrybucją** należy domknąć: realny keystore release (🟠), uruchomić pełny toolchain (`build_runner`, `gen-l10n`, `analyze`, `test`) na CI (🟠) oraz zdecydować, które funkcje ze specyfikacji wchodzą do v1.0, a które przenieść — i zsynchronizować `CLAUDE.md` ze stanem faktycznym.

---

## 2. Faza 0 — Mapa projektu

### 2.1 Charakterystyka techniczna `[POTWIERDZONE]`

| Aspekt | Wartość |
| ------ | ------- |
| Typ | Natywna aplikacja mobilna (iOS + Android) + build webowy (GitHub Pages) |
| Język / framework | Dart 3 (`sdk: ^3.12.0`) / Flutter (stable, rev `559ffa3f…`) |
| Build / pakiety | Flutter tool + pub; Gradle KTS (Android), Xcode (iOS) |
| State / DI | `flutter_riverpod` ^3.3.1 (providery ręczne, bez codegen) |
| Routing | `go_router` ^17.2.3 |
| Baza | `drift` ^2.31.0 (SQLite) + `drift_flutter`; `shared_preferences` ^2.5.5 |
| i18n | `flutter_localizations` + `intl` (6 języków: pl/en/de/fr/es/it) |
| Rozmiar kodu | ~4 351 linii Dart źródłowego (bez generowanych), 75 plików `.dart` |
| Testy | 7 plików, ~42 przypadki (unit + 2 widget) |
| Zależności zewn. | **Brak** — żadnych API, sieci, kolejek, usług third-party (zgodnie z założeniem „100% offline”) |

### 2.2 Punkty wejścia i warstwy `[POTWIERDZONE]`

- **Wejście:** `lib/main.dart:8` (`main()` → inicjalizacja `SharedPreferences`, `ProviderScope`) → `lib/app.dart` (`MaterialApp.router`, motyw, locale, router).
- **Warstwy (feature-first clean architecture):**
  - `lib/core/` — infrastruktura: `database/` (drift: tabele, DAO, migracje), `game/` (czysta logika punktacji), `theme/`, `settings/`, `haptics/`, `routing/`, `localization/`.
  - `lib/features/<feature>/` — `home`, `onboarding`, `players`, `game_setup`, `game`, `game_summary`, `history`, `statistics`, `rules`, `settings`.
  - `lib/shared/` — współdzielone widgety (`GlassContainer`, `PlayerAvatar`, `PrimaryButton`…) i rozszerzenia.
- **Czystość domeny `[POTWIERDZONE]`:** `grep package:flutter lib/core/game` → **brak trafień**. Warstwa logiki gry jest czystym Dartem (zgodność z `CLAUDE.md` §18.5).

### 2.3 Przepływ danych `[POTWIERDZONE]`

UI (ConsumerWidget) → providery Riverpod → kontrolery (`GameController`, `GameSetupController`, `PlayersService`) → DAO drift (`GamesDao`, `PlayersDao`, `StatsDao`) → SQLite. Ustawienia UI → `SettingsRepository` → `shared_preferences`. Operacje wielotabelowe (`createGame`, `addMove`, `undoLastMove`, `resetAllData`) są opakowane w `transaction()` — **poprawnie** (`games_dao.dart:95,111,122`, `app_database.dart:49`).

### 2.4 Zakres dostosowany do typu aplikacji

Aplikacja **ma UI** → sekcja a11y/i18n istotna. **Nie ma backendu/sieci/auth** → sekcje auth, injection sieciowy, SSRF, CORS, nagłówki TLS są w większości N/A i tak oznaczone.

---

## 3. Karta wyników

| # | Wymiar | Ocena | Uzasadnienie (jednozdaniowe) |
| - | ------ | :---: | ---------------------------- |
| 1 | Bezpieczeństwo | 🟢 7/10 | Minimalna powierzchnia ataku (offline, brak PII w logach, zapytania parametryzowane), ale release na kluczu debug i zero obsługi błędów. |
| 2 | Zależności / supply chain | 🟡 6/10 | `pubspec.lock` jest commitowany, lecz `intl: any` niezablokowany i brak automatycznego skanowania podatności (toolchain niedostępny). |
| 3 | Jakość kodu | 🟢 7/10 | Czysty, czytelny, spójny — ale martwy kod (StarterResolver/Tile), zero `try/catch`, linter słabszy niż deklarowany. |
| 4 | Architektura | 🟢 9/10 | Wzorowa separacja warstw, czysta domena, sensowne DI przez Riverpod, transakcje DB. |
| 5 | Wydajność | 🟢 7/10 | Gęstość `BackdropFilter` złagodzona (blur 18 + RepaintBoundary), ale `moveIndex` liczony pełnym SELECT-em. |
| 6 | Testy | 🟡 6/10 | Mocny rdzeń jednostkowy (punktacja, kontroler, baza), brak E2E/golden, brak możliwości uruchomienia. |
| 7 | Dokumentacja / DevEx | 🟡 5/10 | Świetny `CLAUDE.md`, ale README to szablon, brak instrukcji setupu i rozjazd spec↔kod. |
| 8 | Operacje / DevOps / CI | 🔴 3/10 | Brak CI, release podpisany kluczem debug, 45 MB buildu w repo. |
| 9 | Ochrona danych / RODO | 🟢 8/10 | Dane wyłącznie lokalne, „Reset danych” realizuje prawo do usunięcia; brak polityki prywatności w UI i szyfrowania at-rest. |
| 10 | Dostępność / i18n | 🟡 6/10 | Parzystość 6 języków potwierdzona, tooltipy/Semantics dodane — ale kontrast i skalowanie czcionki niezweryfikowane. |

---

## 4. Szczegółowe ustalenia (wg istotności)

### 🔴 KRYTYCZNE

**Brak ustaleń krytycznych w bieżącym kodzie.** `[POTWIERDZONE]` Najgroźniejszy defekt z poprzedniego audytu (crash przy usuwaniu gracza z historią) został złagodzony — patrz §6 (Q-1).

---

### 🟠 WYSOKIE

#### H-1 — Release Androida podpisywany kluczem debugowym `[POTWIERDZONE]`
- **Gdzie:** `android/app/build.gradle.kts:34-37`
  ```kotlin
  buildTypes {
      release {
          // TODO: Add your own signing config for the release build.
          signingConfig = signingConfigs.getByName("debug")
      }
  }
  ```
- **Dlaczego ważne:** Build `--release` jest podpisany ogólnodostępnym kluczem debugowym Androida. Konsekwencje: (1) **niemożliwa publikacja w Google Play** (Play odrzuca APK na kluczu debug); (2) brak ścieżki aktualizacji (zmiana klucza = inna aplikacja); (3) klucz debug jest publicznie znany → każdy może podpisać „aktualizację” podszywającą się pod aplikację przy dystrybucji bocznej. Mapowanie OWASP Mobile: **M7 (Insufficient Binary Protections) / M10**.
- **Naprawa:** wygenerować keystore release, skonfigurować `android/key.properties` (gitignore) + `signingConfigs.release`, wczytać z env/CI. Dla iOS potwierdzić Automatic Signing pod kontem Apple Developer.
- **Nakład:** S (konfiguracja) + proces zarządzania kluczem.

#### H-2 — Brak jakiegokolwiek CI/CD `[POTWIERDZONE]`
- **Gdzie:** brak katalogu `.github/workflows` (potwierdzone: `ls .github/workflows` → nie istnieje). Brak innego configu CI w repo.
- **Dlaczego ważne:** Specyfikacja (`CLAUDE.md` §16.5) zakłada `flutter analyze` + `flutter test` na każdym PR. Obecnie **żaden** lint/test/build nie jest weryfikowany automatycznie. Ponieważ w środowisku roboczym nie ma nawet toolchainu Dart/Flutter, **kod jest mergowany bez kompilacji i bez testów** — to systemowe ryzyko regresji (kod generowany przez `build_runner`/`gen-l10n` i ręcznie edytowane klasy lokalizacji mogą się rozjechać niezauważone).
- **Naprawa:** workflow GitHub Actions: `flutter pub get` → `dart run build_runner build` → `flutter gen-l10n` → `flutter analyze` → `flutter test --coverage`. Docelowo build APK/IPA + deploy webu (zastępując commitowany `docs/`).
- **Nakład:** M.

#### H-3 — Martwy kod kluczowej reguły gry: „kto zaczyna” (§2.3) `[POTWIERDZONE]`
- **Gdzie:** `lib/core/game/starter_resolver.dart` (`StarterResolver`, `StarterCandidate`, `StarterResult`) i `lib/core/game/tile.dart` (`Tile`) — `grep` użycia w `lib/` zwraca **wyłącznie wzajemne odwołania i testy**; żaden ekran/kontroler ich nie wywołuje. Faktyczny starter rundy: `game_setup_controller.dart:25` (`starterPlayerId ?? players.first.id`, a UI nigdy nie przekazuje `starterPlayerId`) oraz rotacja `game_controller.dart:143` (`_nextStarterId`).
- **Dlaczego ważne:** Reguła §2.3 („pierwszy ruch wykonuje gracz z najwyższym tripletem”) jest napisana i przetestowana (`starter_resolver_test.dart`), lecz **nieaktywna** — grę zawsze zaczyna gracz z miejsca 0 (z poprawną rotacją w kolejnych rundach). To jednocześnie niezgodność z zasadami gry i ~90 linii mylącego martwego kodu. (Pozytyw: rotacja startera między rundami została naprawiona od poprzedniego audytu — `_nextStarterId` + test.)
- **Naprawa:** podjąć decyzję produktową — albo (a) podłączyć `StarterResolver` do `game_setup` (krok „kto ma najwyższą płytkę?”), albo (b) świadomie usunąć martwy kod i zaktualizować `CLAUDE.md` §2.3.
- **Nakład:** M (podłączenie) / S (usunięcie).

---

### 🟡 ŚREDNIE

#### M-1 — Integralność referencyjna gracza oparta wyłącznie na kontroli aplikacyjnej `[POTWIERDZONE]`
- **Gdzie:** `game_players_table.dart:9` — `TextColumn get playerId => text().references(Players, #id)();` (**brak `onDelete`**), przy `PRAGMA foreign_keys = ON` (`app_database.dart:43`). `schemaVersion` nadal `1` (`app_database.dart:37`).
- **Dlaczego ważne:** Twarde usunięcie gracza z historią rzuciłoby naruszeniem klucza obcego. Obecnie chroni przed tym **kontrola aplikacyjna** (`players_list_page.dart:79` blokuje usunięcie, gdy `countGamesForPlayer > 0`). Działa, ale jest kruche: jakakolwiek nowa ścieżka usuwania gracza pominie ten guard i wywoła wyjątek bez `try/catch`. Docelowy soft-delete ze specyfikacji nadal odłożony.
- **Naprawa:** soft-delete (kolumna `deletedAt`/`isArchived` + filtr w `watchAll`) — wymaga migracji i bumpa `schemaVersion`. Alternatywnie `onDelete: KeyAction.setNull` (z `playerId` nullable).
- **Nakład:** M (migracja + `build_runner`).

#### M-2 — Zerowa obsługa błędów (brak `try/catch` w całym `lib/`) `[POTWIERDZONE]`
- **Gdzie:** `grep "catch|on Exception|on Error" lib` → **0 trafień**. Operacje DB takie jak `PlayersService.delete` (`players_providers.dart:84`), `GameController.addPlay` (`game_controller.dart:23`) czy `resetAllData` (`app_database.dart:48`) nie mają żadnego zabezpieczenia.
- **Dlaczego ważne:** Błędy strumieni są przechwytywane na poziomie UI (`AsyncValue.when`), ale **akcje imperatywne** (zapisy/usunięcia wywoływane z `onPressed`) nie mają fallbacku — wyjątek z bazy stanie się nieobsłużonym błędem bez komunikatu dla użytkownika. To nie „połknięte wyjątki”, lecz odwrotność — całkowity brak defensywności.
- **Naprawa:** opakować akcje mutujące w `try/catch` z przyjaznym `SnackBar`; rozważyć globalny `FlutterError.onError`/`runZonedGuarded` w `main`.
- **Nakład:** S–M.

#### M-3 — Komunikaty błędów renderowane jako surowy wyjątek `[POTWIERDZONE]`
- **Gdzie:** `game_page.dart:49`, `players_list_page.dart:32`, `history_page.dart:25` — `error: (e, _) => Center(child: Text('$e'))`.
- **Dlaczego ważne:** Surowy `toString()` wyjątku to słaby UX (sprzeczne z deklarowanym „premium”) i potencjalny wyciek szczegółów implementacji. Dla aplikacji lokalnej ryzyko niskie, ale jakościowo poniżej standardu.
- **Naprawa:** przyjazny komunikat z `context.l10n` + opcjonalny przycisk „spróbuj ponownie”.
- **Nakład:** S.

#### M-4 — Statystyki: etykieta i dane niespójne; „best score” liczy gry w toku `[POTWIERDZONE]`
- **Gdzie:** `stats_dao.dart:23` (`watchBestScore`) bierze `MAX(totalScore)` ze **wszystkich** wierszy `game_players`, także gier `inProgress` → „najlepszy wynik all-time” może pokazać wynik niedokończonej gry. `stats_dao.dart:29` (`watchTotalHexagons`) liczy **sumę** hexagonów we wszystkich ruchach, ale `statistics_page.dart:38` etykietuje to jako `statsMostHexagons` („najwięcej hexagonów” — wg §10.8 *w jednej grze*). Dodatkowo `countAll(filter: moves.isHexagon.equals(true))` **nie liczy** podwójnych hexagonów (w `smart_input_sheet.dart:159` wybór „Hex×2” ustawia `_hexagon=false`).
- **Dlaczego ważne:** Prezentowane liczby są mylące względem opisu i nie sumują podwójnych hexów.
- **Naprawa:** filtr `status = finished` w `watchBestScore`; grupowanie po grze + `MAX` dla hexagonów (lub korekta etykiety na „łącznie hexagonów”); uwzględnić `isDoubleHexagon` w zliczaniu.
- **Nakład:** S–M.

#### M-5 — Gęstość `BackdropFilter` na listach (złagodzona, nie usunięta) `[POTWIERDZONE / DO WERYFIKACJI na urządzeniu]`
- **Gdzie:** `glass_container.dart:44` renderuje `BackdropFilter` per instancja. Na `game_page.dart:119-168` w jednym `ListView` współistnieją: baner progu + 2–6 kart graczy + lista historii. `RepaintBoundary` dodano **tylko** wokół kafli historii (`round_history_list.dart:42`), nie wokół kart graczy.
- **Dlaczego ważne:** `BackdropFilter` to najdroższa operacja renderu Fluttera; nakładające się rozmycia obniżają płynność na słabszym sprzęcie. Złagodzono (`blur` 24→18), ale fundament pozostaje. `[DO WERYFIKACJI]` realny FPS na low-endzie.
- **Naprawa:** ograniczyć liczbę aktywnych `BackdropFilter` (np. jedno tło sekcji zamiast per-karta), `RepaintBoundary` także na karty graczy.
- **Nakład:** M.

#### M-6 — `moveIndex` wyliczany pełnym SELECT-em listy ruchów `[POTWIERDZONE]`
- **Gdzie:** `game_controller.dart:22,57,82` — `final index = (await _dao.getMoves(round.id)).length;` przy każdym ruchu/karze/zakończeniu ręki.
- **Dlaczego ważne:** Materializacja całej listy ruchów rundy tylko po to, by poznać następny indeks — liniowy narzut na każdy zapis. Skala mała, ale to czysty dług.
- **Naprawa:** `SELECT MAX(moveIndex)+1` / `COUNT(*)` w SQL.
- **Nakład:** S.

#### M-7 — Niezgodność z deklarowanymi konwencjami (`CLAUDE.md`) `[POTWIERDZONE]`
- **Gdzie / co:**
  - Linter: `analysis_options.yaml:13` używa `flutter_lints`, a §14.1 wymaga **`very_good_analysis`** (znacznie rygorystyczniejszy).
  - State: §5.2 zakłada **Riverpod code-gen (`@riverpod`)** i **`freezed`**; w kodzie są providery ręczne i ręczne `copyWith` (`move.dart:130`, `app_settings.dart:24`). Działa, ale odbiega od „źródła prawdy”.
  - `pubspec.yaml:28` — `intl: any` (niezablokowana wersja) sprzecznie z §4 „lock to minor”.
- **Dlaczego ważne:** Rozjazd specyfikacja↔implementacja utrudnia onboarding i podważa `CLAUDE.md` jako źródło prawdy.
- **Naprawa:** albo dociągnąć kod do specyfikacji, albo zaktualizować `CLAUDE.md`. `intl` przypiąć do zakresu minor.
- **Nakład:** S (decyzja + aktualizacja) / L (migracja na codegen+freezed).

#### M-8 — Niezaimplementowane funkcje obiecane w specyfikacji `[POTWIERDZONE]`
- **Gdzie / co (rozjazd spec↔kod):**
  - **Audio** (§13.1) — `grep just_audio|AudioPlayer|\.mp3` w `lib`/`pubspec` → **0 trafień**. `soundsEnabled` żyje w modelu, ale przełącznik usunięto z UI (dobrze — brak martwego UX), efektów dźwiękowych brak.
  - **Konfetti** (§10.6) — pakiet `confetti` **nie jest** w zależnościach; `game_summary_page.dart` ma tylko animację skali 🏆.
  - **Pełne undo (3 wstecz) + edycja ruchu long-pressem** (§8.6) — `round_history_list.dart:46` pozwala cofnąć **tylko ostatni** ruch (`canUndo: i == 0`); brak edycji; stała `AppConstants.maxUndoDepth` (`constants.dart:18`) nieegzekwowana.
  - **Szczegóły gry w historii** (§10.7) — `_GameHistoryTile` (`history_page.dart:54`) **nie ma `onTap`**; brak ekranu odtworzenia partii.
  - **Egzekwowanie kar/dobierania** (§2.6) — `ScoringRules.maxDraws` (`scoring_rules.dart:38`) zadeklarowane, nieegzekwowane.
- **Dlaczego ważne:** Deklarowane „premium” doświadczenie (audio, konfetti, pełne undo, replay) jest okrojone; część kodu/stałych to zapowiedzi bez realizacji.
- **Naprawa:** zakresowo zdecydować, co wchodzi do v1.0; resztę przenieść do roadmapy i usunąć nieużywane stałe/zapowiedzi.
- **Nakład:** L (zależnie od zakresu).

#### M-9 — Higiena repozytorium: 45 MB skompilowanego buildu webowego `[POTWIERDZONE]`
- **Gdzie:** `docs/` — 42 śledzone pliki, 45 MB (`main.dart.js`, `canvaskit/*.wasm`, `sqlite3.wasm`). To wdrożony GitHub Pages.
- **Dlaczego ważne:** Build w repo powiększa klon, utrudnia review i miesza artefakty ze źródłem. Brak sekretów (aplikacja offline) — ryzyko bezpieczeństwa niskie, ale to dług operacyjny.
- **Naprawa:** budować web na CI i publikować przez GitHub Actions (Pages) zamiast commitować; `docs/` do `.gitignore` po przejściu na pipeline.
- **Nakład:** M (zależne od H-2).

#### M-10 — Brak polityki prywatności i informacji o danych w UI `[POTWIERDZONE]`
- **Gdzie:** `settings_page.dart:142-151` — sekcja „O aplikacji” ma tylko wersję i „Reset danych”; brak linku do polityki prywatności (zapowiadanej w §10.10 i §17). Imiona graczy to dane osobowe (lokalne).
- **Dlaczego ważne:** Sklepy (App Store/Play) wymagają polityki prywatności nawet dla aplikacji offline. Patrz §8 (RODO).
- **Naprawa:** krótka polityka prywatności (offline, brak zbierania danych) + link/ekran w ustawieniach.
- **Nakład:** S.

---

### 🟢 NISKIE

- **L-1 `[POTWIERDZONE]` Magiczne liczby mimo `AppSpacing`/`AppTypography`:** `game_page.dart:128` (`fontSize: 28`), `game_summary_page.dart:69` (`fontSize: 64`), `statistics_page.dart:63` (`size: 32`). Zalecane stałe.
- **L-2 `[POTWIERDZONE]` Brak górnego ograniczenia „sumy rąk przeciwników”:** `smart_input_sheet.dart:304-305` clampuje tylko do `>= 0`; brak rozsądnego maksimum (literówka w klawiaturze zawyży wynik). Dolny clamp to poprawka z poprzedniej rundy.
- **L-3 `[POTWIERDZONE]` Cele dotykowe próbników koloru 40×40 px:** `players_list_page.dart:274-275` poniżej rekomendowanych 48×48 (WCAG 2.5.5 / Material).
- **L-4 `[POTWIERDZONE]` Brak sanityzacji emoji w imionach:** `players_providers.dart:46,60` tylko `trim()` + limit długości; §18.2 wspomina „brak emoji”. **Nie jest luką** (drift parametryzuje zapytania, brak HTML/SQL injection, tekst tylko wyświetlany), ale odbiega od założenia produktowego.
- **L-5 `[POTWIERDZONE]` Brak lokalnego fontu Inter:** `google_fonts` pobiera font sieciowo, a produkcyjny `AndroidManifest.xml` (main) **nie ma** uprawnienia `INTERNET` → pierwsze uruchomienie użyje fallbacku systemowego (akceptowalne, ale niespójne z „premium”; `assets/fonts/` pusty).
- **L-6 `[POTWIERDZONE]` Bonus startowy tylko w rundzie 1:** `game_page.dart:114` (`isStarterMove: game.currentRound == 1 && moves.isEmpty`) — w grach rundowych kolejne rundy nie naliczają bonusu startowego. Do rozstrzygnięcia produktowego (interpretacja §2.3 vs §9).

---

### ⚪ INFORMACYJNE

- **I-1 `[POTWIERDZONE]` Bezpieczeństwo zapytań:** wszystkie zapytania przez drift są parametryzowane (companions/typed API) → brak ryzyka SQL injection. Brak `customStatement` z konkatenacją wejścia użytkownika (jedyny `customStatement` to `PRAGMA foreign_keys = ON`).
- **I-2 `[POTWIERDZONE]` Brak logowania PII:** `grep print|debugPrint lib` → 0 trafień; brak logowania imion graczy (zgodnie z §18.2).
- **I-3 `[POTWIERDZONE]` iOS/web bezpieczne domyślne:** `ios/Runner/Info.plist` bez wyjątków ATS i bez nadmiarowych uprawnień; `web/index.html` to czysty szablon (brak inline secrets). Brak nagłówków CSP — przy hostingu na GitHub Pages i braku backendu ryzyko niskie.
- **I-4 `[POTWIERDZONE]` Transakcyjność:** operacje wielotabelowe są atomowe (`transaction()`), zgodnie z §18.2.
- **I-5 `[POTWIERDZONE]` Parzystość i18n:** 126 realnych kluczy w **każdym** z 6 plików ARB; różnica liczby linii to wyłącznie metadane `@klucz` w szablonie EN (zweryfikowane `comm` — żaden klucz user-facing nie brakuje).
- **I-6 `[POTWIERDZONE]` Brak znaczników TODO/FIXME/HACK w `lib/`** (jedyne `TODO` to szablonowe w `android/app/build.gradle.kts` — H-1).

---

## 5. Audyt zależności i łańcucha dostaw

- `[POTWIERDZONE]` `pubspec.lock` jest **commitowany** (`git ls-files pubspec.lock` → obecny) — poprawnie dla aplikacji (nie biblioteki).
- `[POTWIERDZONE]` Zależności bezpośrednie: `flutter_riverpod ^3.3.1`, `go_router ^17.2.3`, `drift ^2.31.0`, `drift_flutter ^0.3.0`, `sqlite3_flutter_libs`, `path_provider`, `shared_preferences`, `uuid`, `google_fonts ^8.1.0`, `flutter_animate`, `collection`, `intl: any`. Dev: `flutter_lints ^6.0.0`, `build_runner`, `drift_dev`, `flutter_launcher_icons`, `flutter_native_splash`, `image`.
- `[DO WERYFIKACJI]` **Nie uruchomiono** `flutter pub outdated` ani audytu podatności — brak toolchainu. Pakiety to renomowane, aktywnie utrzymywane biblioteki ekosystemu Flutter; brak egzotycznych/nieutrzymywanych zależności w warstwie bezpośredniej.
- `[POTWIERDZONE]` **Ryzyko licencyjne:** wszystkie wymienione pakiety są standardowo na licencji **BSD-3 / MIT / Apache-2.0** (permisywne) — brak GPL/copyleft w widocznym zestawie. `[DO WERYFIKACJI]` pełny przegląd licencji tranzytywnych przez `flutter pub deps`/plik `NOTICES` (obecny w `docs/assets/NOTICES`).
- `[POTWIERDZONE]` `intl: any` (M-7) to jedyne odstępstwo od pinowania.

---

## 6. Audyt funkcjonalny / QA (kluczowe)

- **Q-1 `[POTWIERDZONE]` Usuwanie gracza z historią — naprawione (interim):** `players_list_page.dart:79` blokuje usunięcie i pokazuje `SnackBar` zamiast crashować; `countGamesForPlayer` przetestowane. Pełny soft-delete pozostaje otwarty (M-1).
- **Q-2 `[POTWIERDZONE]` Rdzeń punktacji solidny:** `score_calculator_test.dart` (17 przypadków: triplety, 0-0-0, hex, podwójny hex, most, kombinacje, kary), `game_controller_test.dart` (7: scoreLimit nie kończy auto, rounds kończy, finishNow, rotacja startera, abandon).
- **Q-3 `[POTWIERDZONE]` Rotacja tury:** `game_page.dart:174` (`_activeIndex`) liczy turę jako liczbę ruchów `play`+`passPenalty` od startera — poprawnie ignoruje dobrania. `[DO WERYFIKACJI]` ścieżki brzegowe undo na granicy rundy.
- **Q-4 `[POTWIERDZONE]` Braki testowe:** brak testów E2E (§15.1) i golden (§15.3, mimo deklaracji), brak testu rotacji tury i undo na granicy rundy. `[DO WERYFIKACJI]` faktyczne pokrycie (`--coverage` nieuruchamialne).
- **Q-5 `[POTWIERDZONE]` Spójność stanów loading/error:** konsekwentne `AsyncValue.when` na ekranach; słabość to surowy `Text('$e')` (M-3).

---

## 7. Audyt dostępności i i18n

- `[POTWIERDZONE]` **Poprawione od poprzedniego audytu:** `tooltip:` na przyciskach-ikonach (`players_list_page.dart:55` usuń, `round_history_list.dart:112` undo, `home`/ustawienia), `semanticsLabel` na medalach (`game_summary_page.dart:141`), `_CornerRow` używa `Wrap` (`smart_input_sheet.dart:327` — brak overflow przy wąskim ekranie).
- `[DO WERYFIKACJI]` **Kontrast** tekstu drugorzędnego (`#6B7280`/`#9CA3AF`) na półprzezroczystym „szkle” — może spaść poniżej WCAG AA 4.5:1 zależnie od tła (gradient). Wymaga pomiaru.
- `[DO WERYFIKACJI]` **Skalowanie czcionki** do 200% na dużych stylach (`displayMedium` 40, `fontSize: 64`) — ryzyko przycięcia; przetestować.
- `[POTWIERDZONE]` **i18n mocne:** 6 języków, parzystość kluczy potwierdzona (I-5), formatowanie dat przez `intl`/locale (`history_page.dart:64`), brak hardcoded stringów user-facing w przejrzanych ekranach.
- `[POTWIERDZONE]` Cele dotykowe próbników 40×40 < 48 (L-3).

---

## 8. Ochrona danych / RODO (kontekst UE)

- `[POTWIERDZONE]` **PII:** jedyne dane osobowe to **imiona graczy** (+ pochodne inicjały, kolor awatara) w tabeli `players`/`game_players` (snapshot). Przechowywane **wyłącznie lokalnie** (SQLite na urządzeniu).
- `[POTWIERDZONE]` **Obieg danych:** brak transmisji — brak backendu, brak sieci w release (`AndroidManifest` main bez `INTERNET`), brak third-party. Brak profilowania, brak identyfikatorów reklamowych.
- `[POTWIERDZONE]` **Prawo do usunięcia:** zrealizowane lokalnie — „Reset danych” (`settings_page.dart:149` → `resetAllData`, `app_database.dart:48`, kasuje wszystkie tabele w transakcji). Usuwanie pojedynczego gracza ograniczone integralnością (M-1).
- `[POTWIERDZONE / DO WERYFIKACJI]` **Szyfrowanie at-rest:** baza SQLite **nieszyfrowana**. Dla danych niewrażliwych (imiona w grze hobbystycznej) i ochrony na poziomie systemu (sandbox aplikacji) — akceptowalne; do rozważenia, jeśli profil danych się rozszerzy.
- `[POTWIERDZONE]` **Braki formalne:** brak polityki prywatności w UI (M-10). Ponieważ przetwarzanie jest czysto lokalne i bez zbierania danych, podstawa prawna i zgody w praktyce nie są wymagane, ale sklepy aplikacji i tak wymagają deklaracji prywatności.
- **Werdykt:** profil RODO **bardzo korzystny** (privacy-by-design: dane lokalne, brak zbierania). Domknąć formalną politykę prywatności przed publikacją.

---

## 9. Plan naprawczy z priorytetami

### A. Szybkie zwycięstwa (mały nakład, duży efekt)
1. **`intl` przypiąć do wersji minor** (M-7) — `pubspec.yaml:28`. `[S]`
2. **Przyjazne komunikaty błędów** zamiast `Text('$e')` (M-3) + `try/catch` na akcjach mutujących z `SnackBar` (M-2). `[S]`
3. **Statystyki:** filtr `finished` w `watchBestScore`, korekta etykiety/zliczania hexagonów (M-4). `[S]`
4. **`moveIndex` przez `MAX(...)+1`** (M-6). `[S]`
5. **Polityka prywatności + link w ustawieniach** (M-10). `[S]`
6. **Sprzątanie:** usunąć nieegzekwowane stałe lub je egzekwować (`maxDraws`, `maxUndoDepth`); stałe zamiast magic numbers (L-1); górny clamp sumy rąk (L-2). `[S]`

### B. Działania strategiczne (większe inwestycje)
1. **Keystore release + signing config** (H-1) — warunek publikacji Androida. `[S+proces]`
2. **CI/CD GitHub Actions** (H-2): `build_runner` → `gen-l10n` → `analyze` → `test --coverage`; potem build + deploy webu zastępujący commitowany `docs/` (M-9). Domyka też weryfikację, której dziś brak. `[M]`
3. **Decyzja o regule startera** (H-3): podłączyć `StarterResolver` albo usunąć martwy kod i zaktualizować `CLAUDE.md`. `[M/S]`
4. **Soft-delete gracza** (M-1): migracja + bump `schemaVersion` + filtr — usuwa kruchość kontroli aplikacyjnej. `[M]`
5. **Domknięcie zakresu v1.0 vs spec** (M-8): zdecydować o audio/konfetti/pełnym undo/edycji/szczegółach historii; zsynchronizować `CLAUDE.md`. `[L]`
6. **Wydajność szkła** (M-5): ograniczyć liczbę `BackdropFilter`, `RepaintBoundary` na karty + test na low-endzie. `[M]`
7. **Konwencje** (M-7): decyzja o `very_good_analysis` i codegen (`@riverpod`/`freezed`) — albo dociągnąć kod, albo zaktualizować specyfikację. `[L]`
8. **Testy:** dodać E2E happy-path, golden dla kluczowych widgetów, testy brzegowe undo/rotacji. `[M]`

### Sugerowana kolejność
**Sprint 1 (wydanie-blокery):** B1, B2, A1, A2 → **Sprint 2 (poprawność i dane):** B3, B4, A3, A4 → **Sprint 3 (zakres i jakość):** B5, B6, A5, B7, B8 → **bieżąco:** A6, ustalenia 🟢.

---

## 10. Założenia i ograniczenia audytu

- `[POTWIERDZONE]` **Brak toolchainu Dart/Flutter** w środowisku → **nie uruchomiono**: `flutter analyze`, `flutter test`, `flutter test --coverage`, golden tests, `flutter pub outdated`, audytu podatności zależności, `build_runner`, `gen-l10n`. Wszystkie ustalenia jakościowe/architektoniczne są statyczne.
- **Nie weryfikowano dynamicznie** (oznaczone `[DO WERYFIKACJI]`): faktyczny FPS/wydajność szkła na urządzeniach low-end, realny kontrast WCAG na powierzchniach „szkła”, zachowanie przy `textScaleFactor` 200%, pełne pokrycie testami, kompletność licencji tranzytywnych.
- **Nie audytowano binariów** w `docs/` (skompilowany `main.dart.js`/wasm) ani realnego procesu wdrożenia GitHub Pages poza obecnością artefaktów.
- **Nie analizowano** historii sekretów w całym drzewie git (jedynie bieżący stan plików źródłowych — sekretów brak).
- Audyt obejmuje stan gałęzi `claude/determined-fermi-30czch` na 2026-06-15 (po poprawkach z commita `0a701e0`).

**Zalecane domknięcie:** po przywróceniu toolchainu uruchomić `dart run build_runner build --delete-conflicting-outputs`, `flutter gen-l10n`, `flutter analyze`, `flutter test --coverage` oraz testy na realnych urządzeniach (iPhone/iPad/Android phone+tablet) przy maksymalnym skalowaniu czcionki — i potwierdzić pozycje `[DO WERYFIKACJI]`.

---

*Audyt statyczny, tryb tylko-do-odczytu. Żaden plik źródłowy ani konfiguracyjny nie został zmodyfikowany; jedynym artefaktem tego audytu jest niniejszy raport.*
