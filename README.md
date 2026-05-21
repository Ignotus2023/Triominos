# TriominoScore

Profesjonalny mobilny pomocnik do liczenia punktów w grze planszowej **Triominos** (Flutter, iOS + Android).

Pełna dokumentacja produktowo-techniczna: zobacz [`CLAUDE.md`](./CLAUDE.md).

---

## Setup po sklonowaniu repo

Środowisko cloud nie ma Flutter SDK, więc poniższe kroki uruchom **u siebie lokalnie** (macOS dla iOS, dowolny OS dla Androida).

```bash
# 1. Uzupełnij natywne foldery iOS/Android (jednorazowo)
flutter create . --platforms=ios,android --org pl.triominoscore

# 2. Pobierz zależności
flutter pub get

# 3. Wygeneruj kod (drift, freezed, riverpod)
dart run build_runner build --delete-conflicting-outputs

# 4. Wygeneruj klasy l10n z plików ARB
flutter gen-l10n

# 5. Uruchom apkę
flutter run                      # podłączone urządzenie / emulator
```

### Re-generacja po zmianie schematu / modeli / @riverpod

```bash
dart run build_runner watch --delete-conflicting-outputs
```

### Testy

```bash
flutter test                       # unit + widget (głównie core/game)
flutter test --coverage            # + coverage
```

---

## Wymagane wersje

- Flutter ≥ 3.27
- Dart ≥ 3.6
- iOS 13+ (Xcode 15+)
- Android 6+ (API 23+)

## Struktura

Zgodna z [`CLAUDE.md` § 6](./CLAUDE.md#6-struktura-projektu).
