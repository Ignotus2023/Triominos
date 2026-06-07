# Profesjonalny audyt aplikacji TriominoScore

Data: 2026-06-07 · Gałąź: `claude/professional-audits-FV6U2` · Zakres: cały kod w `lib/`, schemat bazy, konfiguracja platform, testy.

> **Metodyka.** Audyt statyczny (przegląd kodu + schematu). W tym środowisku nie ma zainstalowanego Fluttera, więc `flutter analyze`, `flutter test` i golden testy **nie zostały uruchomione** — wszystkie ustalenia wynikają z lektury źródeł. Odniesienia mają postać `ścieżka:linia`.

## Skala ważności

| Poziom | Znaczenie |
| ------ | --------- |
| 🔴 Krytyczny | Awaria, utrata danych lub błędny wynik gry. Naprawić przed wydaniem. |
| 🟠 Wysoki | Wyraźny błąd funkcjonalny / istotny dług. Naprawić szybko. |
| 🟡 Średni | Zauważalny problem jakości/UX. Zaplanować. |
| 🟢 Niski | Kosmetyka, higiena, nice-to-have. |

## Streszczenie dla zarządu

Aplikacja jest **schludnie zorganizowana** (feature-first, czysta warstwa domenowa, czytelny kod, dobre testy rdzenia punktacji) i jako pomocnik do liczenia punktów **działa w happy-path**. Ryzyko bezpieczeństwa jest niskie (100% offline, brak sieci/uwierzytelniania/PII w logach).

Najpoważniejsze ustalenia:

1. 🔴 **Usunięcie gracza, który grał w jakiejkolwiek grze, rzuca wyjątkiem** — brak `onDelete` na kluczu obcym `game_players.playerId` przy włączonym `PRAGMA foreign_keys = ON`. Wyjątek nieobsłużony w UI.
2. 🟠 **Cały podsystem audio nie istnieje** — przełącznik „Dźwięki" w ustawieniach niczego nie robi (martwy UX, niezgodność ze specyfikacją §13).
3. 🟠 **Reguła „kto zaczyna" (§2.3) nie jest podłączona** — `StarterResolver`/`Tile` to martwy kod; rundę zawsze zaczyna gracz z miejsca 0.
4. 🟠 **Brak jakiejkolwiek dostępności (a11y)** — zero `Semantics`/`tooltip`, przyciski-ikony bez etykiet, ryzyko przepełnienia layoutu przy dużej czcionce.
5. 🟡 **Wielokrotne nakładające się `BackdropFilter` (blur 24)** na listach — najpoważniejszy koszt wydajności na słabszych urządzeniach.

Szczegóły poniżej, pogrupowane w sześć audytów.

---

# 1. Audyt bezpieczeństwa

Profil ryzyka jest z natury niski: brak backendu, brak sieci, brak kont, dane wyłącznie lokalnie (SQLite + SharedPreferences). Mimo to:

### 1.1 🟡 Brak walidacji liczby wprowadzanej ręcznie (suma rąk przeciwników)
`smart_input_sheet.dart:306` — `int.tryParse(...) ?? 0` przyjmuje dowolną liczbę, w tym **ujemną** (wklejenie / klawiatura z minusem). Ujemna suma rąk zaniża wynik finiszera i fałszuje partię. Zalecenie: `clamp` do `>= 0` i rozsądnego maksimum.

### 1.2 🟡 Brak zabezpieczenia integralności przy usuwaniu encji
Patrz §4.1 (klucz obcy). Z perspektywy bezpieczeństwa danych: operacja modyfikująca wiele tabel (`addMove` → `_adjustScore`) jest poprawnie w transakcji (`games_dao.dart:101`), ale `resetAllData` i kaskady polegają na `PRAGMA foreign_keys = ON` ustawianym w `beforeOpen` (`app_database.dart:42`) — to dobre. Brakuje natomiast kaskady na jednym kluczu (sekcja 4).

### 1.3 🟢 Wbudowany artefakt webowy w repozytorium
`docs/` to skompilowany build webowy (~45 MB, `main.dart.js`, `canvaskit/`). Dla aplikacji offline nie ma w nim sekretów (ryzyko niskie), ale:
- powiększa repozytorium i utrudnia review,
- może zawierać source-mapy ujawniające strukturę (do sprawdzenia).
Zalecenie: budować na CI i publikować przez GitHub Actions zamiast commitować build (sekcja 4.6).

### 1.4 🟢 Nazwy graczy bez sanityzacji treści
`players_providers.dart:41` — egzekwowana jest tylko długość (≤32, `constants.dart:13`) i trim. Specyfikacja (§18.2) wspomina „brak emoji". To nie jest luka bezpieczeństwa (dane są lokalne i tylko wyświetlane jako tekst, brak HTML/SQL injection dzięki drift parametryzującemu zapytania), ale warto domknąć zgodnie z założeniem produktowym.

### 1.5 🟢 Parsowanie koloru hex
`players_list_page.dart:282` używa `int.parse` (rzuca przy złym wejściu), `player_avatar.dart:55` używa bezpiecznego `int.tryParse` z fallbackiem. Pierwszy działa tylko na stałej palecie, więc obecnie bezpieczny — ale rozbieżność jest pułapką na przyszłość. Ujednolicić do `tryParse`.

**Werdykt:** brak luk wysokiego ryzyka. Pozycje to utwardzenie (hardening) walidacji wejścia i higiena repo.

---

# 2. Audyt wydajności

### 2.1 🟡 Stosy `BackdropFilter` na listach
`glass_container.dart:44` renderuje `BackdropFilter(blur 24)` dla **każdej** instancji. Na ekranie gry (`game_page.dart`) w jednym `ListView` mamy: baner progu + kartę każdego gracza (2–6) + każdy kafel historii rundy — czyli kilkanaście jednoczesnych rozmyć backdrop. To najdroższa operacja renderu we Flutterze; na słabszych telefonach spadnie płynność przewijania.
Zalecenia:
- ograniczyć blur lub renderować „szkło" jako półprzezroczyste tło bez `BackdropFilter` poza kluczowymi powierzchniami,
- dodać `RepaintBoundary` wokół kafli historii (zalecenie samej specyfikacji §18.3 — obecnie **niezaimplementowane**),
- rozważyć niższą `sigma` (np. 12) — różnica wizualna niewielka, koszt znacząco mniejszy.

### 2.2 🟡 `addMove`/`undo` robią dodatkowy odczyt liczby ruchów
`game_controller.dart:22,57,82` liczą `moveIndex` przez `(_dao.getMoves(round.id)).length` — pełny SELECT wszystkich ruchów rundy tylko po to, by poznać następny indeks. Przy długich rundach to liniowy narzut na każdy ruch. Lepiej `SELECT MAX(moveIndex)+1` lub `COUNT(*)` w SQL zamiast materializować listę.

### 2.3 🟢 `playerColorsProvider` przelicza mapę przy każdej zmianie listy graczy
`players_providers.dart:81` buduje całą mapę przy każdym evencie strumienia graczy. Mała skala (kilku graczy), więc realnie nieistotne — ale `select`/memoizacja byłyby zgodne ze specyfikacją §18.3.

### 2.4 🟢 Listy bez `.builder`
`game_page.dart:127`, `game_summary_page.dart:88`, `round_history_list.dart:41` budują dzieci pętlą `for`. Dla N ≤ ~kilkudziesięciu OK; gdyby historia rundy potrafiła urosnąć, warto `ListView.builder` (specyfikacja §18.3 zaleca lazy >20 elementów).

### 2.5 🟢 `google_fonts` w runtime
Pakiet `google_fonts` pobiera font sieciowo przy pierwszym użyciu, jeśli nie spakowano go jako asset. W aplikacji „100% offline" pierwsze uruchomienie bez sieci użyje fallbacku systemowego (akceptowalne), ale dla spójności warto dołączyć Inter jako lokalny asset (przewidziane w strukturze `assets/fonts/`, obecnie pusty).

**Werdykt:** architektura wydajności jest zdrowa; jedyny realny dług to gęstość `BackdropFilter` na listach.

---

# 3. Audyt dostępności (a11y)

### 3.1 🟠 Zero semantyki w całej aplikacji
Wyszukiwanie `Semantics|semanticLabel|tooltip|excludeSemantics` w `lib/` daje **0 trafień**. Przyciski wyłącznie ikonowe nie mają etykiet czytanych przez TalkBack/VoiceOver:
- ikona ustawień `home_page.dart:31`,
- usuwanie gracza `players_list_page.dart:53`,
- cofnij ruch `round_history_list.dart:109`,
- uchwyt przeciągania `game_setup_page.dart:222`.
Zalecenie: `IconButton(tooltip: ...)` (daje i tooltip, i semantykę) oraz `Semantics(label: ...)` dla kluczowych elementów.

### 3.2 🟠 Ryzyko przepełnienia layoutu przy skalowaniu czcionki
`smart_input_sheet.dart:326` — `_CornerRow` układa 6 `ChoiceChip` w **`Row` z `spaceBetween`** (nie `Wrap`). Na wąskim ekranie (≈320 dp) lub przy dużym `textScaleFactor` to przepełni się (żółto-czarny RenderFlex overflow). To jednocześnie błąd a11y i UX. Zalecenie: `Wrap` albo poziomy scroll/`FittedBox`.
Podobnie duże style (`displayMedium` 40, `headlineLarge`) w `game_summary_page.dart` mogą się przycinać przy 200% czcionki — przetestować przy maksymalnym skalowaniu.

### 3.3 🟡 Kontrast na powierzchniach „szkła"
Tekst drugorzędny (`#6B7280` light / `#9CA3AF` dark) na półprzezroczystym, rozmytym tle o zmiennej jasności może spaść poniżej WCAG AA (4.5:1) w zależności od tego, co jest pod spodem. Zweryfikować realny kontrast na ekranie gry (gradient + szkło).

### 3.4 🟡 Treść niosąca znaczenie wyłącznie w emoji
🏆/🥇/🥈/🥉 (`game_page.dart:110`, `game_summary_page.dart:67,127`) niosą sens (zwycięzca, miejsce). Czytnik ekranu przeczyta nazwę emoji, ale lepiej opakować w `Semantics(label: l10n...)`.

### 3.5 🟢 Rozmiary celów dotykowych
Próbniki koloru 40×40 (`players_list_page.dart:261`) są poniżej rekomendowanych 48×48. Reszta opiera się na Material (OK).

**Werdykt:** dostępność jest praktycznie nieobecna — to największa luka jakościowa względem deklarowanego „premium". Wymaga dedykowanej iteracji.

---

# 4. Audyt kodu i jakości

### 4.1 🔴 Brakująca kaskada/akcja na kluczu obcym `game_players.playerId`
`game_players_table.dart:9`:
```dart
TextColumn get playerId => text().references(Players, #id)();   // brak onDelete
```
Przy `PRAGMA foreign_keys = ON` (`app_database.dart:43`) usunięcie gracza, który jest w jakiejkolwiek grze, **rzuca FK constraint violation**. Wywołanie w `players_list_page.dart:90` (`await ...delete(player.id)`) jest bez `try/catch` → nieobsłużony wyjątek (błąd dla użytkownika, brak informacji zwrotnej).
Decyzja projektowa: profil ma być „trwały między grami" i istnieje `displayNameSnapshot` właśnie po to, by przetrwać usunięcie. To sugeruje świadomy zamiar zachowania historii. Opcje naprawy:
- **soft-delete** (flaga `deletedAt`/`isArchived`, ukrycie z listy) — zgodne z intencją snapshotów, **rekomendowane**, albo
- `onDelete: KeyAction.setNull` + dopuszczenie `playerId` jako nullable, albo
- jawny `KeyAction.restrict` + komunikat „nie można usunąć gracza z historii".
Każda zmiana schematu wymaga migracji i bumpa `schemaVersion` (obecnie `1`, `app_database.dart:37`).

### 4.2 🟠 Martwy kod reguły startu gry
`starter_resolver.dart` (`StarterResolver`, `StarterCandidate`, `StarterResult`) oraz `tile.dart` (`Tile`) **nie są używane nigdzie w aplikacji** (tylko w testach). W praktyce rundę zawsze zaczyna gracz z miejsca 0:
- `game_setup_controller.dart:25` — `starter = starterPlayerId ?? players.first.id`, a `starterPlayerId` nigdy nie jest przekazywany z UI,
- `game_controller.dart:131` — kolejne rundy: `starterPlayerId: seats.first.playerId`.
Skutek: zasada §2.3 („najwyższy triplet zaczyna") jest zaimplementowana, przetestowana — i nieaktywna. Albo ją podłączyć (UI pytające o najlepszą płytkę startową), albo świadomie usunąć martwy kod i zaktualizować specyfikację.

### 4.3 🟠 Starter kolejnych rund zawsze = miejsce 0
`game_controller.dart:131` ustawia startera nowej rundy na `seats.first`. Niezależnie od reguł, w grach rundowych zwykle starter się rotuje. Tu runda 2, 3, … zawsze startuje od tego samego gracza, co wpływa na `_activeIndex` (`game_page.dart:158`) i kolejność tur. Do rozstrzygnięcia produktowego.

### 4.4 🟡 Etykieta statystyki niezgodna z zapytaniem
`statistics_page.dart:37` pokazuje `statsMostHexagons` („najwięcej hexagonów"), ale `stats_dao.dart:29` (`watchTotalHexagons`) liczy **łączną** liczbę hexagonów we wszystkich grach, nie maksimum w jednej grze (specyfikacja §10.8 mówi „najwięcej hexagonów w jednej grze"). Albo poprawić zapytanie (grupowanie po grze + MAX), albo etykietę.

### 4.5 🟡 Niezgodność z deklarowanymi konwencjami
- Specyfikacja (§14.1) wymaga lintera **`very_good_analysis`**; projekt używa `flutter_lints` (`analysis_options.yaml:10`). Mniej rygorystycznie niż założono.
- Specyfikacja zakłada Riverpod **code-gen (`@riverpod`)** i `freezed` — w kodzie są ręczne providery i ręczne `copyWith`. Działa, ale to odejście od źródła prawdy; ujednolicić albo zaktualizować CLAUDE.md.
- `intl: any` w `pubspec.yaml:28` — niezablokowana wersja, sprzecznie z §4 „lock to minor".

### 4.6 🟡 Higiena repozytorium
45 MB skompilowanego buildu w `docs/` (sekcja 1.3). Rekomendacja: `.gitignore` + publikacja przez CI.

### 4.7 🟢 Drobny martwy/nieużywany kod
- `opponentsCount` przekazywany do `SmartInputSheet` (`game_page.dart:96`, `smart_input_sheet.dart:33`) i nigdy nie używany.
- `HapticsService.success()` (`haptics_service.dart:29`, 3× wibracja na wygraną wg §13.2) — zdefiniowane, nigdy nie wywołane.
- `GamesDao.abandonGame` (`games_dao.dart:163`) — niewywoływane (patrz UX 5.5).
- Stałe `ScoringRules.maxDraws` i `AppConstants.maxUndoDepth` — nieegzekwowane (patrz QA 6.4).
- `score_calculator.dart:8` `calculateMoveScore` to cienkie opakowanie `move.totalScore` — OK jako stabilny punkt wejścia/testów, zostawić.

### 4.8 🟢 Drobiazgi
- Magiczne liczby mimo `AppSpacing` (np. `fontSize: 28/64/96`, `size: 36/44`, `radius: 14`) — `game_page.dart:110`, `player_score_card.dart:34`, `game_summary_page.dart:67`.
- `round_history_list.dart:24` `orElse: () => seats.first` może podpisać ruch złym graczem, gdy `playerId` nie znaleziony (skrajny przypadek po zmianach składu).

**Werdykt:** kod jest czysty i czytelny, ale ma jeden krytyczny błąd schematu (4.1) i sporo rozjazdu „kod vs deklarowana specyfikacja".

---

# 5. Audyt UX/UI

### 5.1 🟠 Przełącznik „Dźwięki" nie robi nic
`settings_page.dart:99-103` zapisuje `soundsEnabled`, ale w całym kodzie **nie ma odtwarzania dźwięku** (brak `just_audio`/`AudioPlayer`; jedyne wystąpienia `soundsEnabled` to warstwa ustawień). Cały §13.1 (tap/triplet/bridge/hexagon/win/round_end) jest niezaimplementowany. To wprost mylący UX: użytkownik przełącza opcję bez efektu. Albo dodać audio, albo ukryć przełącznik do czasu implementacji.

### 5.2 🟡 Brak konfetti i haptyki zwycięstwa
Specyfikacja (§10.6, §13.2) obiecuje konfetti i potrójną wibrację przy wygranej. `game_summary_page.dart` ma tylko animację skali emoji 🏆. Pakiet `confetti` nie jest nawet w zależnościach. „Najbardziej satysfakcjonujący" moment gry jest okrojony.

### 5.3 🟡 Kafel historii gier to ślepy zaułek
`history_page.dart:54` — kafel zakończonej gry nie ma `onTap`, choć §10.7 zakłada przejście do szczegółów (odtworzenie rund/ruchów). Użytkownik widzi listę, ale nie może wejść w grę.

### 5.4 🟡 „Rewanż" nie przenosi składu
`game_summary_page.dart:53` — „Rewanż" nawiguje do pustego setupu, podczas gdy §10.6 obiecuje „auto-setup z tymi samymi graczami". Tracona wygoda.

### 5.5 🟡 Brak zarządzania aktywną grą / kumulacja gier „w toku"
Rozpoczęcie nowej gry nie kończy poprzedniej. `watchActiveGame` (`games_dao.dart:23`) zwraca tylko najnowszą „inProgress", więc starsze niedokończone gry zostają w bazie na zawsze (osierocone), a `abandonGame` istnieje, lecz nie jest podpięte do UI. Brakuje też opcji „Porzuć grę" na ekranie rozgrywki.

### 5.6 🟡 Edycja ruchu i undo „3 wstecz" — niezaimplementowane
§8.6 obiecuje: undo do 3 ruchów i edycję dowolnego ruchu long-pressem. Faktycznie: `round_history_list.dart:45` pozwala cofnąć **tylko ostatni** ruch (powtarzanie usuwa kolejne — brak limitu 3, brak edycji). Ruchu kończącego rundę (`endOfHandBonus`) nie da się cofnąć (po nim startuje nowa runda i poprzedni ruch znika z widoku).

### 5.7 🟢 Chip „Triplet" wygląda na wyłączony
`smart_input_sheet.dart:128` ma `onSelected: null` (auto-detekcja). To poprawne zachowanie (nie da się ręcznie), ale `null` wyszarza chip mimo stanu „selected" — może mylić. Rozważyć styl „auto" zamiast disabled.

### 5.8 🟢 Koniec ręki tylko dla aktywnego gracza
`smart_input_sheet` otwierany jest dla aktywnego miejsca, więc „Wyjście (wyczerpana ręka)" można zarejestrować tylko dla gracza, którego jest tura. W praktyce zwykle to on kończy, ale to ograniczenie warto znać.

**Werdykt:** szkielet UX jest elegancki i spójny (glassmorphism, motyw, i18n natychmiastowe), ale kilka obiecanych „premium" elementów (audio, konfetti, szczegóły historii, rewanż ze składem, pełne undo/edycja) jest niedokończonych.

---

# 6. Audyt funkcjonalny / QA

### 6.1 🔴 Usunięcie gracza z historii = crash
Patrz 4.1 — najważniejszy defekt funkcjonalny. Scenariusz: utwórz gracza → zagraj grę → usuń gracza → wyjątek FK, brak feedbacku. Wymaga test regresyjny (fail przed fixem, pass po — §18.7).

### 6.2 🟠 Reguła „kto zaczyna" niespełniona
Patrz 4.2 — gra nie wyłania startera po najwyższym triplecie; zaczyna miejsce 0. Niezgodność z zasadami gry (§2.3), choć bonus startowy jest naliczany pierwszemu ruchowi rundy 1 (`game_page.dart:96`).

### 6.3 🟠 Ujemna „suma rąk przeciwników" akceptowana
Patrz 1.1 — fałszuje wynik finiszera. Dodać walidację `>= 0`.

### 6.4 🟡 Reguły kar/dobierania nieegzekwowane
§2.6 mówi: max 3 dobrania (po -5), potem przymusowy pas (-10). Aplikacja pozwala dobierać dowolnie wiele razy i pasować w dowolnym momencie (`smart_input_sheet.dart:205-228`). Jako „pomocnik do liczenia" to obrona przez elastyczność — ale `ScoringRules.maxDraws` sugeruje zamiar egzekwowania. Doprecyzować.

### 6.5 🟡 Rotacja tury vs cofanie/koniec rundy
`_activeIndex` (`game_page.dart:160`) liczy turę jako liczbę ruchów typu `play` lub `passPenalty` od startera. To poprawnie ignoruje dobrania (gracz dobiera i gra dalej). Należy jednak przetestować ścieżki brzegowe:
- cofnięcie pasu/zagrania → tura wraca poprawnie? (logicznie tak, bo zliczanie jest deterministyczne),
- w trybie rundowym po `endHand` nowa runda startuje od miejsca 0 (6.2/4.3).

### 6.6 🟡 Statystyki: rozbieżność etykieta/dane
Patrz 4.4 (hexagony). Dodatkowo `watchBestScore` (`stats_dao.dart:23`) bierze MAX `totalScore` ze **wszystkich** miejsc, także gier w toku — „najlepszy wynik all-time" może pokazać wynik niedokończonej gry. Do rozważenia filtr po grach `finished`.

### 6.7 🟡 Parzystość plików tłumaczeń do weryfikacji
`app_en.arb` ma ~137 kluczy/linii vs ~124 w pl/de/es/fr/it. Prawdopodobnie to metadane `@klucz` w szablonie EN (wygenerowane `app_localizations_*.dart` mają komplet getterów), ale **należy potwierdzić**, że żaden łańcuch user-facing nie jest nieprzetłumaczony (§18.1 wymaga obecności w 6 plikach). Bez `flutter gen-l10n` w tym środowisku nie zweryfikowano automatycznie.

### 6.8 🟢 Pokrycie testami
Mocne: `score_calculator_test.dart` (kompletne reguły punktacji, w tym kombinacje i 0-0-0), `game_controller_test.dart` (scoreLimit nie kończy auto, rounds kończy, finishNow). Są też testy startera, logiki graczy, widgetów (avatar, smart input) i bazy.
Braki: brak testów integracyjnych E2E (§15.1 „happy path"), brak golden testów (§15.3, mimo deklaracji), brak testu regresyjnego dla 6.1, brak testów ścieżek brzegowych rotacji tury (6.5) i undo (5.6).

### 6.9 🟢 Obsługa stanów loading/error
Konsekwentne `AsyncValue.when` na ekranach (gra, gracze, historia, setup). Błąd renderowany jako surowy `Text('$e')` (`game_page.dart:45`, `players_list_page.dart:31`, …) — funkcjonalne, ale nie „premium"; warto przyjazny komunikat.

**Werdykt:** rdzeń liczenia punktów jest solidny i dobrze przetestowany; QA blokuje przede wszystkim crash przy usuwaniu gracza (6.1) oraz rozjazdy względem zasad gry/specyfikacji (6.2–6.4).

---

# Priorytetyzowana lista działań

### Przed wydaniem (🔴/🟠)
1. **Naprawić usuwanie gracza** (4.1/6.1) — soft-delete lub `onDelete` + migracja + test regresyjny.
2. **Audio albo ukrycie przełącznika** (5.1) — nie wypuszczać martwego ustawienia.
3. **Podłączyć lub usunąć regułę startera** (4.2/6.2) i rozstrzygnąć rotację rund (4.3).
4. **Dostępność: tooltipy/Semantics + naprawa `_CornerRow` (`Wrap`)** (3.1/3.2).
5. **Walidacja sumy rąk ≥ 0** (1.1/6.3).

### Wkrótce (🟡)
6. Ograniczyć koszt `BackdropFilter` + `RepaintBoundary` na historii (2.1).
7. Spójność statystyk (etykieta vs zapytanie, filtr „finished") (4.4/6.6).
8. Szczegóły gry w historii + „Rewanż" ze składem + zarządzanie aktywną grą (5.3/5.4/5.5).
9. Pełne undo (limit 3) i edycja ruchu (5.6).
10. Potwierdzić parzystość ARB i uruchomić `flutter analyze`/`test`/golden w CI (6.7/6.8).

### Higiena (🟢)
11. Wyrównać konwencje do CLAUDE.md (linter, code-gen) lub zaktualizować specyfikację (4.5).
12. Wyjąć build `docs/` z repo, publikować z CI (1.3/4.6).
13. Posprzątać martwy kod (4.7) i magiczne liczby (4.8).

---

*Audyt statyczny — bez uruchamiania narzędzi Flutter. Zalecane domknięcie weryfikacją dynamiczną: `flutter analyze`, `flutter test --coverage`, testy na realnych urządzeniach (iPhone/iPad/Android phone+tablet) oraz przy 200% skali czcionki.*
