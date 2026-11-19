# Technical Architecture

## Quick Translator – macOS Local-First AI Application

**Project:** Quick Translator
**Document:** Technical Architecture & Implementation Specification
**Version:** 1.0
**Status:** Initial Architecture
**Platform:** macOS
**Framework:** Flutter
**Primary Language:** Dart
**Native Integration:** Swift / C++
**State Management:** flutter_bloc
**AI Runtime Candidate:** Google LiteRT-LM

---

# 1. Architecture Goals

The architecture of Quick Translator should fulfill five primary objectives:

1. **Local-First:** Translation should work without a cloud connection.
2. **Performance:** The application should provide translations with minimal latency.
3. **Modularity:** AI models and inference providers must be interchangeable.
4. **Native Integration:** macOS functionality should integrate naturally with the operating system.
5. **Maintainability:** The codebase should remain understandable and extensible as new capabilities are introduced.

The application should not be tightly coupled to a specific LLM, AI runtime or translation provider.

Flutter and Dart should own the application logic. Native macOS and C++ components should provide platform-specific functionality and AI inference where necessary.

# 2. High-Level System Architecture

```text
┌──────────────────────────────────────────────────┐
│                    macOS                          │
│                                                  │
│  ┌────────────────────────────────────────────┐  │
│  │              Native Layer                  │  │
│  │                                            │  │
│  │  NSStatusItem     Global Shortcut          │  │
│  │  NSPopover        Clipboard Integration    │  │
│  └──────────────────────┬─────────────────────┘  │
│                         │                        │
│  ┌──────────────────────▼─────────────────────┐  │
│  │               Flutter Application          │  │
│  │                                            │  │
│  │  Presentation Layer                        │  │
│  │  ├── Translator Bloc                       │  │
│  │  ├── Translator View / Language Selector   │  │
│  │  ├── Translation Result                    │  │
│  │  └── Settings                              │  │
│  │                                            │  │
│  │  Domain Layer                              │  │
│  │  ├── Translation Interactors (Use Cases)   │  │
│  │  ├── Translation Request / Result          │  │
│  │  ├── Translation Repository (Interface)    │  │
│  │  └── Prompt Management                     │  │
│  │                                            │  │
│  │  Data Layer                                │  │
│  │  ├── Translation Repository (Impl)         │  │
│  │  ├── LiteRT-LM Provider                    │  │
│  │  ├── Apple Foundation Models Provider      │  │
│  │  ├── DeepL Provider                        │  │
│  │  └── Model Manager                         │  │
│  └──────────────────────┬─────────────────────┘  │
│                         │                        │
│  ┌──────────────────────▼─────────────────────┐  │
│  │              Native AI Layer               │  │
│  │                                            │  │
│  │  Dart FFI / Swift MethodChannel            │  │
│  │                                            │  │
│  │  LiteRT-LM Runtime                         │  │
│  │  Apple Foundation Models                   │  │
│  └──────────────────────┬─────────────────────┘  │
│                         │                        │
│  ┌──────────────────────▼─────────────────────┐  │
│  │              Local Model                   │  │
│  │                                            │  │
│  │  Gemma / Other Compatible Models           │  │
│  └────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────┘
```

# 3. Technology Stack

| Component         | Technology                            | Responsibility                          |
| ----------------- | ------------------------------------- | --------------------------------------- |
| UI                | Flutter                               | Application interface                   |
| Language          | Dart                                  | Application logic                       |
| State Management  | flutter_bloc                          | State and event handling                |
| Event Concurrency | bloc_concurrency                      | Transformers for overlapping events     |
| Presentation Events | bloc_presentation                   | One-shot UI effects outside of state    |
| Use Cases         | use_in_case                           | Interactor composition                  |
| Immutable Models  | freezed                               | Bloc states, events and value objects   |
| Logging           | logger                                | Diagnostics behind an internal facade   |
| Architecture      | Feature-oriented, three layers        | data / domain / presentation            |
| Dependency Injection | RepositoryProvider / BlocProvider  | Composition through the widget tree     |
| Native macOS      | Swift                                 | Menu bar, shortcuts, system integration |
| Local AI          | LiteRT-LM                             | Local model inference                   |
| FFI               | Dart FFI                              | Native C/C++ communication              |
| Apple AI          | Foundation Models                     | Alternative local inference             |
| Persistence       | SharedPreferences / SQLite            | Settings and history                    |
| Model Storage     | Application Support                   | Local model files                       |
| Cloud Translation | DeepL API                             | Optional external translation           |

The stack represents the intended architecture. Package versions and macOS compatibility must be verified during technical discovery.

# 4. Flutter Project Structure

The project should follow a feature-oriented architecture.

Every feature is divided into exactly three layers:

| Layer          | Contains                                                                 |
| -------------- | ------------------------------------------------------------------------ |
| `presentation` | Blocs, freezed states and events, pages, widgets                         |
| `domain`       | Entities, value objects, repository interfaces, interactors (use cases)  |
| `data`         | Repository implementations, translation providers, native bridges, DTOs  |

Dependencies point inwards only: `presentation` → `domain` ← `data`. The domain layer must not import Flutter, `flutter_bloc`, `logger` or any provider SDK.

Proposed structure:

```text
quick_translator/
│
├── macos/
│   ├── Runner/
│   │   ├── AppDelegate.swift
│   │   ├── MenuBarManager.swift
│   │   ├── ShortcutManager.swift
│   │   └── ClipboardManager.swift
│   │
│   └── Runner.xcodeproj/
│
├── lib/
│   │
│   ├── main.dart
│   ├── app.dart
│   │
│   ├── core/
│   │   ├── config/
│   │   ├── constants/
│   │   ├── errors/
│   │   ├── extensions/
│   │   ├── logging/
│   │   └── utils/
│   │
│   ├── features/
│   │
│   │   ├── translator/
│   │   │   ├── presentation/
│   │   │   │   ├── bloc/
│   │   │   │   │   ├── translator_bloc.dart
│   │   │   │   │   ├── translator_event.dart
│   │   │   │   │   ├── translator_state.dart
│   │   │   │   │   └── translator_presentation_event.dart
│   │   │   │   ├── pages/
│   │   │   │   └── widgets/
│   │   │   │
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   ├── repositories/
│   │   │   │   └── usecases/
│   │   │   │
│   │   │   └── data/
│   │   │       ├── providers/
│   │   │       ├── repositories/
│   │   │       └── dto/
│   │   │
│   │   ├── settings/
│   │   │   ├── presentation/
│   │   │   ├── domain/
│   │   │   └── data/
│   │   │
│   │   ├── history/
│   │   │   ├── presentation/
│   │   │   ├── domain/
│   │   │   └── data/
│   │   │
│   │   └── model_manager/
│   │       ├── presentation/
│   │       ├── domain/
│   │       └── data/
│   │
│   ├── shared/
│   │   ├── widgets/
│   │   ├── services/
│   │   └── providers/
│   │
│   └── native/
│       ├── ffi/
│       └── channels/
│
├── native/
│   └── inference/
│       ├── include/
│       └── src/
│
├── assets/
│   ├── icons/
│   └── images/
│
├── test/
│
├── integration_test/
│
├── docs/
│   ├── PROJECT_VISION.md
│   └── TECHNICAL_ARCHITECTURE.md
│
└── pubspec.yaml
```

The `native/inference` directory is only needed if a custom C/C++ wrapper becomes necessary. We should initially investigate whether an existing LiteRT-LM integration can be used directly.

## 4.1 Composition and Dependency Injection

No service locator is used. `get_it` and `injectable` are deliberately excluded.

Dependencies are composed through the widget tree: `RepositoryProvider` for repositories and long-lived services, `BlocProvider` for blocs. Everything else is passed by constructor.

Rationale:

- The dependency graph is visible in `app.dart` instead of spread across registration annotations.
- No code generation step for wiring, and no global mutable registry to reset between tests.
- Blocs and interactors take their dependencies as constructor parameters, so unit tests construct them directly.

Root composition:

```dart
MultiRepositoryProvider(
  providers: [
    RepositoryProvider<TranslationRepository>(
      create: (_) => TranslationRepositoryImpl(...),
    ),
    RepositoryProvider<ModelManager>(
      lazy: false,
      create: (_) => ModelManager(...),
    ),
  ],
  child: const QuickTranslatorApp(),
);
```

Interactors are stateless and are constructed where the bloc is created, rather than becoming provider nodes of their own:

```dart
BlocProvider(
  create: (context) => TranslatorBloc(
    translateText: TranslateText(
      context.read<TranslationRepository>(),
    ),
  ),
  child: const TranslatorPage(),
);
```

An interactor only becomes a `RepositoryProvider` of its own if several blocs share it.

### Constraints of this approach

Two things do not have a `BuildContext`, and the architecture has to account for that:

- **Model lifecycle.** §7.2 starts at application launch, before any widget exists. The `ModelManager` is therefore created in root composition with `lazy: false` and owns its own initialization; the UI observes it, it does not drive it.
- **Native callbacks.** Code triggered from `AppDelegate` (menu bar, global shortcut) cannot look anything up. Such events must enter through a platform channel and be dispatched as bloc events, never through a global accessor.

The providers must also sit above any part of the tree that the popover tears down and rebuilds, so that a loaded model survives closing and reopening the popover (§12).

# 5. Translation Domain

The translation domain must remain independent of the underlying AI provider.

The application should communicate with all translation engines through a common interface.

## 5.1 Translation Provider Interface

```dart
abstract interface class TranslationProvider {
  String get id;

  String get displayName;

  Future<bool> isAvailable();

  Stream<String> translate(
    TranslationRequest request,
  );
}
```

The interface provides:

- Provider identification.
- Human-readable provider name.
- Runtime availability checks.
- Streaming translation output.

A provider must not expose implementation-specific details to the UI.

Cancellation is deliberately **not** part of this contract. There is no cancellation token and no `cancel()` method. A translation is cancelled by cancelling the returned stream's subscription, and it is the transport layer's job (see §8.4) to turn that into a stop signal for the native runtime. This keeps the domain contract free of lifecycle plumbing.

## 5.2 Translation Request

```dart
class TranslationRequest {
  final String text;
  final String? sourceLanguage;
  final String targetLanguage;
  final TranslationStyle style;

  const TranslationRequest({
    required this.text,
    this.sourceLanguage,
    required this.targetLanguage,
    this.style = TranslationStyle.neutral,
  });
}
```

The source language is optional because automatic language detection should be supported.

## 5.3 Translation Style

```dart
enum TranslationStyle {
  neutral,
  formal,
  casual,
  business,
  literal,
}
```

## 5.4 Translation Use Cases

Application logic lives in interactors built with `use_in_case`. There is no separate service layer; an interactor is the single entry point for one operation.

Initial interactors:

| Interactor          | Input                | Output                 |
| ------------------- | -------------------- | ---------------------- |
| `TranslateText`     | `TranslationRequest` | `Stream<String>`       |
| `DetectLanguage`    | `String`             | `String?`              |
| `ListProviders`     | –                    | `List<ProviderInfo>`   |
| `SelectProvider`    | `String` (id)        | `void`                 |

`use_in_case` models interactors only; it has no concept of observers or streams. The streaming interactor therefore **produces** the stream rather than consuming it:

```dart
class TranslateText
    implements Interactor<TranslationRequest, Stream<String>> {

  TranslateText(this._repository);

  final TranslationRepository _repository;

  @override
  Future<Stream<String>> process(
    TranslationRequest input,
  ) async {
    // Validate the request, resolve the prompt,
    // then hand back the provider stream.
    return _repository.translate(input);
  }
}
```

The bloc consumes that stream. Two consequences follow:

- Interactor responsibilities end when the stream is opened: validation, prompt selection and provider resolution.
- Errors raised *after* the stream is open cannot be normalized by the interactor. Error normalization (§11) therefore belongs in the data layer, so that the stream only ever emits domain errors.

Provider selection is a repository concern. The initial implementation can resolve a single configured provider; a registry can be introduced later without touching the interactors.

# 6. AI Provider Architecture

## 6.1 LiteRT-LM Provider

The first local provider should be based on LiteRT-LM.

```dart
class LiteRTLMProvider
    implements TranslationProvider {

  @override
  String get id => 'litert_lm';

  @override
  String get displayName => 'Local AI';

  @override
  Future<bool> isAvailable() async {
    // Check native runtime and model availability.
    return false;
  }

  @override
  Stream<String> translate(
    TranslationRequest request,
  ) async* {
    // Connect to the local inference runtime.
    // Forward generated tokens.
  }
}
```

The actual native integration will depend on the selected LiteRT-LM macOS API and package compatibility.

The provider should not contain UI-specific code.

## 6.2 Apple Foundation Models Provider

Apple's Foundation Models Framework can be implemented as an additional provider.

```dart
class AppleFoundationModelsProvider
    implements TranslationProvider {

  @override
  String get id => 'apple_foundation_models';

  @override
  String get displayName => 'Apple Intelligence';

  @override
  Future<bool> isAvailable() async {
    // Query native availability from Swift.
    return false;
  }

  @override
  Stream<String> translate(
    TranslationRequest request,
  ) async* {
    // Send request through native Swift bridge.
  }
}
```

Swift should handle:

- Framework availability.
- Model availability.
- Session initialization.
- Prompt execution.
- Streaming responses.
- Native error handling.

Flutter should only receive normalized results.

## 6.3 DeepL Provider

A DeepL provider can be implemented later.

Unlike local providers, it requires network access.

The API key must not be embedded as a shared application secret in the distributed client.

A secure integration strategy must be established before production use.

# 7. Local Model Management

Model management is an important part of the local-first architecture.

The application should eventually provide a dedicated component responsible for model lifecycle management.

## 7.1 Responsibilities

- Check whether a model is installed.
- Download compatible models.
- Validate model files.
- Track model versions.
- Initialize the inference runtime.
- Release model resources.
- Handle insufficient memory.
- Report model loading progress.

## 7.2 Proposed Model Lifecycle

```text
Application Start
       |
       v
Check Runtime Availability
       |
       v
Check Model Installation
       |
       +---- Model Missing ----> Download Model
       |                              |
       |                              v
       |                        Validate Files
       |                              |
       +------------------------------+
       |
       v
Initialize Runtime
       |
       v
Model Ready
       |
       v
Accept Translation Requests
       |
       v
Release Resources When Needed
```

## 7.3 Model Storage

Models should be stored in the macOS Application Support directory.

They should not be bundled directly into the application package by default.

This provides several advantages:

- Smaller application downloads.
- Independent model updates.
- Multiple model support.
- Easier model replacement.
- Better control over disk usage.

Model downloads must be restricted to trusted sources and verified using published checksums where available.

---

# 8. macOS Native Integration

Flutter alone does not provide all functionality required for a polished macOS menu bar utility.

Native macOS functionality should be isolated behind dedicated interfaces.

## 8.1 Menu Bar

Use Apple's `NSStatusItem` API.

Responsibilities:

- Register menu bar icon.
- Show and hide the application interface.
- Manage popover state.
- Respond to menu bar interactions.

## 8.2 Global Keyboard Shortcut

The application should support a configurable global shortcut.

Initial default:

`Option + Space`

The shortcut should open the translator and focus the input field.

The implementation should use a native macOS event or shortcut integration that respects macOS permissions and conflicts with other applications.

## 8.3 Clipboard

The clipboard integration should support:

- Reading text.
- Writing translated text.
- Optional automatic input population.
- Optional paste-back workflow.

The native integration should remain independent of the translation engine.

## 8.4 Flutter Communication

Use Flutter platform channels for ordinary macOS functionality.

Suggested channels:

```text
com.quicktranslator/menu_bar
com.quicktranslator/shortcuts
com.quicktranslator/clipboard
com.quicktranslator/apple_ai
```

Dart FFI should be reserved for native C/C++ APIs where direct calls are appropriate.

We should avoid introducing unnecessary FFI complexity for functionality already supported by Swift.

### Cancellation

Cancellation is owned by the transport layer, not by the domain contract.

When a stream subscription is cancelled, the bridge must:

- Stop forwarding tokens to Dart.
- Signal the native runtime to abort the running generation.
- Release the inference session without unloading the model.

This matters because `restartable()` (§9) cancels the previous subscription on every new request. If the bridge does not abort the native run, fast typing stacks up concurrent generations on a single loaded model. Verifying this is part of Milestone 1.

---

# 9. State Management

`flutter_bloc` is the state management solution. It was chosen over Riverpod for its explicit event/state flow, which maps directly onto the request/stream shape of translation.

Blocs manage:

- Current input text.
- Source and target language.
- Active translation provider.
- Translation status.
- Streaming output.
- Model availability.
- Application settings.

## 9.1 States and Events

States and events are `freezed` classes. Whether a feature uses a sealed union or a single state class with a status field is decided per feature — the translator state, for example, has to carry the previous translation while a new one streams in (§10.3).

Where a status field is used, the initial set is:

```dart
enum TranslationStatus {
  idle,
  loading,
  translating,
  completed,
  error,
}
```

## 9.2 Event Concurrency

Event transformers come from `bloc_concurrency`:

| Event                   | Transformer     | Reason                                     |
| ----------------------- | --------------- | ------------------------------------------ |
| Input changed           | `restartable()` | A newer input invalidates the running run  |
| Target language changed  | `restartable()` | Same request, different target             |
| Provider changed        | `sequential()`  | Provider switches must not interleave      |
| Model download          | `droppable()`   | Ignore repeated taps while downloading     |

`restartable()` gives request cancellation for free on the Dart side; see §8.4 for the native half.

## 9.3 Presentation Events

`bloc_presentation` carries one-shot effects that must not become part of the state:

- Copied to clipboard.
- Paste-back performed.
- Transient error notification.
- Focus the input field.

These fire once and are not replayed on rebuild, which keeps the state free of flags that have to be manually reset.

## 9.4 Logging

Logging uses the `logger` package behind an internal facade in `core/logging`, so no layer outside that folder depends on the package directly. Logging is a diagnostic channel and is independent of what the user is shown (§11).

The UI should react to state changes without directly controlling the underlying inference runtime.

# 10. User Interface Architecture

The UI should be designed specifically for a compact macOS utility.

## 10.1 Main Translator

Components:

- Source language indicator.
- Target language selector.
- Input field.
- Translation result.
- Copy action.
- Clear action.
- Provider indicator.

## 10.2 Interaction States

The interface should support:

1. Empty state.
2. Input entered.
3. Waiting for translation.
4. Streaming translation.
5. Completed translation.
6. Translation error.
7. Model unavailable.
8. Model loading.

## 10.3 UX Principles

- Keep the window compact.
- Avoid unnecessary navigation.
- Focus the input field on open.
- Preserve the previous translation when appropriate.
- Display loading feedback without blocking the UI.
- Make the copy action immediately accessible.
- Provide keyboard-first interaction.

---

# 11. Error Handling

Errors are normalized in the data layer, before they enter the stream the domain exposes (see §5.4).

Suggested error categories:

| Error               | Meaning                              |
| ------------------- | ------------------------------------ |
| RuntimeUnavailable  | AI runtime cannot be initialized     |
| ModelNotInstalled   | Required model is missing            |
| ModelLoadingFailed  | Model initialization failed          |
| InsufficientMemory  | Available resources are insufficient |
| TranslationFailed   | Inference failed                     |
| ProviderUnavailable | Selected provider is unavailable     |
| NetworkError        | Cloud provider cannot be reached     |
| RequestCancelled    | User cancelled translation           |

The UI should show useful messages rather than raw native errors.

A local provider failure must not silently trigger a cloud translation.

## 11.1 Error Presentation

Modal dialogs are not acceptable in a menu bar application; they steal focus and break the keyboard-first flow. Errors are surfaced in place instead:

- Persistent conditions (model missing, runtime unavailable) as an inline banner inside the popover, with the corrective action attached.
- Transient failures (a single translation failed) as a short notification via `bloc_presentation`, leaving the previous result visible.

The exact presentation is still open and should be settled during the MVP milestone.

---

# 12. Performance Requirements

Initial performance targets:

| Metric                | Target                           |
| --------------------- | -------------------------------- |
| Menu bar interaction  | Immediate                        |
| Input responsiveness  | No perceptible blocking          |
| Model initialization  | Minimize repeated initialization |
| First generated token | Target under 1 second            |
| Short translation     | Target under 2 seconds           |
| UI rendering          | Smooth during inference          |

These targets are provisional and depend on model size, hardware and runtime configuration.

Performance measurements should distinguish:

- Cold start.
- Warm start.
- Time to first token.
- Total generation time.
- Memory consumption.

The model should ideally remain initialized during active usage, provided resource consumption is reasonable.

---

# 13. Testing Strategy

Testing should be introduced from the beginning.

## Unit Tests

Test:

- Translation request validation.
- Interactor behaviour.
- Provider selection.
- Prompt generation.
- Language handling.
- Error mapping.
- Bloc state transitions (`bloc_test`).
- Blocs and interactors are constructed directly in tests; there is no container to reset.
- Event transformer behaviour, especially `restartable()` cancellation.

## Integration Tests

Test:

- Flutter-to-native communication.
- Runtime initialization.
- Model loading.
- Token streaming.
- Cancellation.
- Clipboard integration.

## Translation Quality Tests

Create a fixed evaluation dataset containing:

- Simple sentences.
- Idioms.
- Colloquial language.
- Business communication.
- Long paragraphs.
- Ambiguous expressions.
- Formatting-sensitive text.

Compare outputs across models and providers.

Quality should be evaluated for meaning preservation, fluency, terminology and tone.

## Hardware Tests

At minimum, test different Apple Silicon configurations and record:

- RAM usage.
- Model loading time.
- First-token latency.
- Generation speed.
- Stability during repeated requests.

---

# 14. Implementation Roadmap

## Milestone 1 – Runtime Proof of Concept

**Objective:** Successfully run a local LLM on macOS through Flutter.

Tasks:

- Create Flutter project.
- Verify LiteRT-LM macOS compatibility.
- Evaluate available Dart integrations.
- Load a small compatible model.
- Execute a prompt.
- Stream generated tokens.
- Measure resource consumption.

Acceptance criteria:

- A local model can be initialized.
- A prompt can be submitted.
- A response can be streamed into Flutter.
- No cloud connection is required.

## Milestone 2 – Translation Engine

**Objective:** Implement a reusable translation abstraction.

Tasks:

- Define TranslationProvider.
- Define TranslationRequest.
- Implement the translation repository.
- Implement the TranslateText interactor.
- Create prompt templates.
- Add source and target language handling.
- Implement cancellation.
- Add error normalization.

Acceptance criteria:

- Translation works through a provider-independent interface.
- The UI does not depend on the concrete model implementation.

## Milestone 3 – macOS Menu Bar

**Objective:** Integrate the application into macOS.

Tasks:

- Implement NSStatusItem.
- Create popover integration.
- Add global shortcut.
- Connect Flutter interface.
- Implement clipboard support.

Acceptance criteria:

- Application is accessible from the menu bar.
- Keyboard shortcut opens the translator.
- Input and output work without opening a conventional application window.

## Milestone 4 – MVP

**Objective:** Deliver the first usable version.

Tasks:

- Implement complete translator interface.
- Add language selection.
- Add automatic translation.
- Add copy action.
- Add basic settings.
- Add model lifecycle handling.

Acceptance criteria:

- A user can translate text without internet access.
- The application handles missing models and runtime errors.
- The workflow is fast and reliable.

## Milestone 5 – Additional Providers

**Objective:** Expand the translation ecosystem.

Tasks:

- Investigate Apple Foundation Models.
- Implement native Swift provider.
- Evaluate DeepL integration.
- Add provider selection.
- Compare translation quality.

---

# 15. First Development Sprint

The first sprint should focus exclusively on proving the technical foundation.

We should deliberately avoid spending time on the final UI or advanced macOS integration at this stage.

`use_in_case`, `bloc_presentation` and the full three-layer split are introduced in Milestone 2, not here. The first sprint only has to prove local inference.

### Sprint Tasks

- [ ] Create Flutter macOS application.
- [ ] Configure project structure.
- [ ] Add flutter_bloc.
- [ ] Investigate LiteRT-LM macOS support.
- [ ] Investigate flutter_gemma compatibility.
- [ ] Select an initial model.
- [ ] Load the model locally.
- [ ] Send a translation prompt.
- [ ] Stream the response into a basic Flutter interface.
- [ ] Measure latency and RAM usage.
- [ ] Document technical limitations.

### Sprint Deliverable

A minimal Flutter application with one input field and one output field.

The user enters a German sentence and receives an English translation from a locally running LLM.

No menu bar, no settings, no history and no cloud integration are required yet.

**The first milestone is successful only when local inference is proven on the actual target platform.**

---

# 16. Architectural Decisions & Constraints

The following decisions are considered provisional:

| Decision                            | Status               |
| ----------------------------------- | -------------------- |
| Flutter as primary framework        | Accepted             |
| Dart as application language        | Accepted             |
| flutter_bloc for state management   | Accepted             |
| bloc_concurrency for transformers   | Accepted             |
| bloc_presentation for UI effects    | Accepted             |
| freezed for states and events       | Accepted             |
| use_in_case for interactors         | Accepted             |
| logger behind an internal facade    | Accepted             |
| data / domain / presentation layers | Accepted             |
| RepositoryProvider/BlocProvider DI  | Accepted             |
| No get_it / injectable              | Accepted             |
| Cancellation owned by transport     | Accepted             |
| No modal dialogs in the popover     | Accepted             |
| LiteRT-LM as primary runtime        | To validate          |
| Gemma as initial model family       | To validate          |
| Dart FFI for native C/C++ inference | To validate          |
| Swift for macOS integration         | Accepted             |
| NSStatusItem for menu bar           | Accepted             |
| Foundation Models as alternative    | Proposed             |
| DeepL as optional provider          | Future consideration |

The project must not assume that an Android-compatible Flutter package automatically supports macOS.

Runtime availability, model compatibility, hardware acceleration and distribution requirements must be validated independently.

---

# 17. Final Architecture Principle

Quick Translator should be built around a simple but important principle:

**The application owns the translation experience. The provider owns the translation execution. The runtime owns the model inference.**

These responsibilities must remain separated.

This allows Quick Translator to evolve independently of individual AI technologies.

New models, new inference engines and new translation providers should be integrable without requiring a fundamental redesign of the application.

The initial implementation should remain deliberately small, with a strong technical foundation and a clear path toward a more advanced local-first language assistant.

---

**End of Technical Architecture Document**

_This document is the initial implementation specification. Technical assumptions must be validated through the Proof of Concept before being treated as production architecture._
