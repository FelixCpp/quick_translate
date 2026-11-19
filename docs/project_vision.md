# Project Vision & Technical Strategy
## Quick Translator – Local-First AI Translation for macOS

**Project Status:** Concept & Discovery
**Platform:** macOS
**Primary Framework:** Flutter
**Document Type:** Product Vision, Technical Strategy & Project Foundation
**Version:** 1.0

---

# 1. Executive Summary

Quick Translator ist eine schlanke, intelligente macOS-Menüleistenanwendung, die es ermöglicht, Wörter, Sätze und längere Textpassagen schnell und unkompliziert in andere Sprachen zu übersetzen.

Das Projekt verfolgt einen Local-First-Ansatz und setzt auf moderne On-Device-KI-Technologien. Anstatt Übersetzungsanfragen grundsätzlich an externe Cloud-Dienste zu übertragen, sollen lokale Large Language Models (LLMs) die primäre Grundlage der Übersetzungsfunktionalität bilden.

Die Anwendung orientiert sich dabei an modernen Entwicklungen im Bereich lokaler KI-Anwendungen, insbesondere an **Google AI Edge Eloquent**. Dessen Architektur und technologische Entscheidungen zeigen, dass leistungsfähige, lokal ausgeführte KI-Anwendungen mit Flutter und nativen Inferenz-Runtimes realisierbar sind.

Quick Translator soll drei zentrale Eigenschaften vereinen:

1. **Speed:** Übersetzungen müssen unmittelbar und ohne unnötige Interaktion verfügbar sein.
2. **Privacy:** Texte sollen standardmäßig lokal auf dem Gerät verarbeitet werden.
3. **Simplicity:** Die Anwendung soll sich nahtlos in den macOS-Workflow integrieren.

Langfristig soll aus dem klassischen Übersetzungswerkzeug ein kompakter, kontextbewusster Sprachassistent werden, der nicht nur übersetzt, sondern auch bei der sprachlichen Optimierung und Bearbeitung von Texten unterstützt.

---

# 2. Product Vision

## 2.1 Vision

Eine Übersetzung sollte nicht mehr als eigenständiger Arbeitsprozess wahrgenommen werden.

Der Nutzer soll jederzeit und unabhängig von der gerade verwendeten Anwendung einen Text eingeben, übersetzen und direkt weiterverwenden können.

Quick Translator soll genau diesen Workflow ermöglichen.

Die Anwendung lebt in der macOS-Menüleiste und ist dadurch jederzeit erreichbar. Ein globaler Shortcut öffnet die Anwendung, der Nutzer gibt einen Text ein und erhält unmittelbar die gewünschte Übersetzung.

Keine Browser-Tabs, keine externen Websites, keine unnötigen Fenster und möglichst keine Wartezeiten.

**The goal: Make language barriers disappear without interrupting the user's workflow.**

## 2.2 Produktprinzipien

### Local First

Die lokale Verarbeitung ist der bevorzugte Weg.

Übersetzungen sollen nach Möglichkeit vollständig auf dem Gerät stattfinden. Dadurch werden externe Abhängigkeiten reduziert und sensible Texte verlassen den Computer nicht.

### Privacy by Design

Datenschutz ist keine nachträgliche Funktion, sondern ein grundlegendes Architekturprinzip.

- Keine obligatorischen Benutzerkonten.
- Keine standardmäßige Übertragung von Texten an Cloud-Dienste.
- Keine verpflichtende Backend-Infrastruktur.
- Lokale Verarbeitung als Standard.
- Transparente Kennzeichnung externer Übersetzungsdienste.

### Instant Interaction

Die Anwendung soll sich wie ein natives macOS-Utility anfühlen.

- Globaler Tastatur-Shortcut.
- Schnelles Öffnen.
- Automatische Spracherkennung.
- Übersetzung ohne zusätzlichen Button-Klick.
- Schnelles Kopieren des Ergebnisses.

### Minimalism

Die Anwendung soll sich auf ihre Kernaufgabe konzentrieren.

Keine überladene Oberfläche, keine unnötigen Einstellungen und keine komplexen Workflows.

### Extensibility

Die Architektur soll zukünftige Erweiterungen ermöglichen, ohne die grundlegende Anwendung neu entwickeln zu müssen.

Insbesondere die Übersetzungs-Engine muss austauschbar sein.

---

# 3. Inspiration & Technical Learnings

## 3.1 Google AI Edge Eloquent

Google AI Edge Eloquent dient als wichtige technische und konzeptionelle Referenz für das Projekt.

Eloquent demonstriert, wie eine moderne KI-Anwendung mit Flutter und lokalen KI-Modellen umgesetzt werden kann.

Die Anwendung konzentriert sich auf lokale Spracheingabe, Transkription und KI-gestützte Textbearbeitung.

Besonders interessant sind die Architekturentscheidungen:

- Flutter und Dart als zentrale Anwendungsschicht.
- Native KI-Inferenz über LiteRT-LM.
- Direkte Anbindung nativer Komponenten über Dart FFI.
- Lokale Ausführung leistungsfähiger Sprachmodelle.
- Modulare Wiederverwendung gemeinsamer KI-Infrastruktur.
- Integration zusätzlicher ML-Komponenten über MediaPipe.

### Wichtigste Erkenntnisse

**1. Flutter ist auch für anspruchsvolle lokale KI-Anwendungen geeignet.**

Flutter muss nicht auf die Darstellung der Benutzeroberfläche beschränkt bleiben. Dart kann einen großen Teil der Anwendungslogik und KI-Orchestrierung übernehmen.

**2. Native KI-Inferenz muss nicht über HTTP oder einen lokalen Server erfolgen.**

Mit Dart FFI können native C/C++-Bibliotheken direkt angesprochen werden.

Das ermöglicht eine performante Integration ohne zusätzliche Serverprozesse.

**3. Die KI-Infrastruktur sollte modular aufgebaut sein.**

Die Trennung zwischen UI, Anwendungslogik, Modellverwaltung und Inferenz-Runtime ermöglicht eine bessere Wartbarkeit und Wiederverwendbarkeit.

**4. Lokale LLMs eröffnen neue Produktmöglichkeiten.**

Die lokale Ausführung von Sprachmodellen ermöglicht Anwendungen, die unabhängig von Cloud-Diensten funktionieren und sensible Inhalte lokal verarbeiten können.

### Technologische Referenzen

- Google AI Edge: https://ai.google.dev/edge
- LiteRT-LM: https://github.com/google-ai-edge/LiteRT-LM
- Flutter MediaPipe: https://github.com/google-ai-edge/flutter-mediapipe
- Flutter Gemma: https://github.com/DenisovAV/flutter_gemma

Die konkrete Implementierung von Eloquent und die öffentlich verfügbaren Flutter-Integrationen sind dabei als unterschiedliche technische Referenzen zu betrachten. Die tatsächliche Kompatibilität der einzelnen Komponenten mit der gewünschten macOS-Zielplattform muss im Rahmen eines technischen Prototyps validiert werden.

---

# 4. Product Scope & Core Features

## 4.1 Core Experience – Quick Translation

Der zentrale Anwendungsfall ist die schnelle Übersetzung eines beliebigen Textes.

Der Nutzer öffnet die Anwendung und erhält eine kompakte Eingabemaske.

### Geplanter Workflow

1. Anwendung über Menüleisten-Icon oder globalen Shortcut öffnen.
2. Text eingeben oder einfügen.
3. Ausgangssprache automatisch erkennen.
4. Zielsprache auswählen.
5. Übersetzung automatisch ausführen.
6. Ergebnis anzeigen.
7. Übersetzung kopieren.

### Anforderungen

- Automatische Übersetzung nach Texteingabe.
- Konfigurierbare Zielsprache.
- Automatische Erkennung der Ausgangssprache.
- Unterstützung einzelner Wörter, Sätze und längerer Texte.
- Streaming der Modellausgabe, sofern von der Runtime unterstützt.
- Copy-to-Clipboard-Funktion.
- Möglichkeit, die Übersetzung erneut auszuführen.

## 4.2 macOS Integration

Die Anwendung soll sich möglichst natürlich in macOS integrieren.

Geplante Funktionen:

- Permanentes Menüleisten-Icon.
- Kompaktes Popover.
- Globaler Keyboard-Shortcut.
- Unterstützung der Zwischenablage.
- Schnelles Öffnen und Schließen.
- Fokussteuerung für die Texteingabe.
- Optionale Übersetzung markierter Texte aus anderen Anwendungen.

Die native Menüleisten-Integration soll über macOS-spezifische Komponenten erfolgen, beispielsweise `NSStatusItem`.

Flutter übernimmt primär die Oberfläche und Anwendungslogik.

## 4.3 Language Management

Die Anwendung soll eine Auswahl verschiedener Zielsprachen ermöglichen.

Für den MVP sind insbesondere folgende Sprachen interessant:

- Deutsch
- Englisch
- Französisch
- Spanisch
- Italienisch
- Niederländisch

Die tatsächliche Sprachunterstützung hängt vom verwendeten Modell ab und muss für jede Sprachkombination validiert werden.

## 4.4 Translation Styles

Ein wesentlicher Vorteil von LLM-basierten Übersetzungen ist die Möglichkeit, den sprachlichen Stil zu beeinflussen.

Daher sollen perspektivisch verschiedene Übersetzungsmodi angeboten werden:

| Modus | Beschreibung |
|---|---|
| Neutral | Natürliche Standardübersetzung |
| Formal | Professionelle und höfliche Ausdrucksweise |
| Casual | Lockerer, alltäglicher Sprachstil |
| Business | Geschäftliche Kommunikation |
| Literal | Möglichst nahe am Originaltext |

Die Auswahl erfolgt über entsprechende System-Prompts und Modellparameter.

## 4.5 Clipboard Integration

Die Zwischenablage soll eine zentrale Rolle spielen.

Denkbare Workflows:

- Text aus der Zwischenablage automatisch übernehmen.
- Übersetzung mit einem Klick kopieren.
- Optional übersetzten Text direkt in die ursprüngliche Anwendung zurückschreiben.
- Markierten Text über einen globalen Shortcut übernehmen.

---

# 5. Technical Architecture

## 5.1 Architectural Philosophy

Die Anwendung soll modular, erweiterbar und möglichst unabhängig von einzelnen KI-Anbietern entwickelt werden.

Die wichtigste Architekturentscheidung ist die Trennung zwischen Übersetzungslogik und KI-Inferenz.

Die UI soll nicht wissen müssen, welches Modell gerade eine Übersetzung ausführt.

Stattdessen kommuniziert sie ausschließlich mit einer zentralen `TranslationService`-Abstraktion.

## 5.2 Proposed Architecture

```text
┌─────────────────────────────────────────┐
│             macOS Application           │
│                                         │
│  Flutter UI                             │
│  ├── Translation View                   │
│  ├── Language Selector                  │
│  ├── Settings                           │
│  └── Translation History                │
│                                         │
├─────────────────────────────────────────┤
│           Application Layer             │
│                                         │
│  TranslationService                     │
│  ├── Language Detection                  │
│  ├── Prompt Management                  │
│  ├── Translation Orchestration           │
│  └── Provider Selection                 │
│                                         │
├─────────────────────────────────────────┤
│           Provider Layer                │
│                                         │
│  ├── LiteRTLMProvider                    │
│  ├── AppleFoundationModelsProvider       │
│  └── DeepLProvider                       │
│                                         │
├─────────────────────────────────────────┤
│           Native Integration             │
│                                         │
│  Dart FFI / Native Swift                 │
│                                         │
├─────────────────────────────────────────┤
│           Inference Layer                │
│                                         │
│  ├── LiteRT-LM                           │
│  ├── Apple Foundation Models             │
│  └── Cloud API                           │
│                                         │
└─────────────────────────────────────────┘
```

## 5.3 Flutter

Flutter wird als primäres Framework für die Anwendung verwendet.

Verantwortlichkeiten:

- Benutzeroberfläche.
- State Management.
- Eingabeverarbeitung.
- Übersetzungsworkflow.
- Provider-Auswahl.
- Einstellungen.
- Lokale Persistenz.
- Kommunikation mit nativen Komponenten.

Flutter bietet eine gute Grundlage für eine modulare und wartbare Codebasis.

## 5.4 LiteRT-LM

LiteRT-LM ist der bevorzugte Kandidat für die lokale KI-Inferenz.

Das Framework stammt aus dem Google AI Edge-Ökosystem und ist für die Ausführung lokaler Sprachmodelle konzipiert.

Interessante Eigenschaften:

- Lokale LLM-Inferenz.
- Hardwarebeschleunigung.
- Streaming der generierten Tokens.
- Verwaltung von Modellzuständen.
- Unterstützung geeigneter quantisierter Modelle.
- Integration in native Anwendungen.

Für Quick Translator soll LiteRT-LM zunächst als primäre lokale Inferenz-Runtime untersucht werden.

Die Integration soll möglichst direkt und ohne zusätzlichen lokalen HTTP-Server erfolgen.

## 5.5 Dart FFI

Dart FFI ist ein besonders interessanter Bestandteil der Architektur.

Anstatt die KI-Runtime über einen lokalen REST-Service anzusprechen, kann Flutter direkt mit nativen Bibliotheken kommunizieren.

Vorteile:

- Keine zusätzliche Serverinstanz.
- Weniger Prozess-Overhead.
- Direkte native Schnittstellen.
- Potenziell bessere Performance.
- Klare Trennung zwischen Dart und nativer Inferenz.

Die genaue Integration hängt von den verfügbaren macOS-Builds und APIs der jeweiligen Runtime ab.

## 5.6 Apple Foundation Models

Das Foundation Models Framework von Apple soll als alternative lokale KI-Engine berücksichtigt werden.

Es bietet eine native Schnittstelle für die Nutzung von Apple-Intelligence-Sprachmodellen.

Vorteile:

- Native macOS-Integration.
- Keine eigene Modellverwaltung.
- Lokale Verarbeitung auf unterstützten Geräten.
- Keine separate Modellinstallation.
- Swift-basierte Integration.

Die Integration erfolgt über eine kleine native Swift-Komponente, die mit Flutter über einen MethodChannel kommuniziert.

Wichtige Einschränkungen:

- Abhängigkeit von unterstützter Apple-Hardware und Betriebssystemversion.
- Verfügbarkeit der Modelle und unterstützten Sprachen.
- Begrenzte Kontrolle über die verwendete Modellversion.
- Qualität und Eignung für Übersetzungen müssen getestet werden.

## 5.7 Cloud Provider

Cloud-basierte Übersetzungsdienste sollen optional unterstützt werden.

Ein möglicher Kandidat ist DeepL.

Cloud Provider sind insbesondere interessant, wenn:

- Ein lokales Modell eine Sprachkombination nicht ausreichend unterstützt.
- Besonders hohe Übersetzungsqualität benötigt wird.
- Ein lokales Modell auf älterer Hardware zu langsam ist.

Cloud-Dienste dürfen nicht unbemerkt als Standard verwendet werden.

Die Verarbeitung muss für den Nutzer transparent sein.

---

# 6. Model Strategy

## 6.1 Model Selection

Die Auswahl des Sprachmodells ist eine der wichtigsten technischen Entscheidungen.

Ein größeres Modell ist nicht automatisch die bessere Wahl.

Quick Translator benötigt primär:

- Hohe Übersetzungsqualität.
- Geringe Latenz.
- Niedrigen RAM-Verbrauch.
- Gute Sprachabdeckung.
- Zuverlässiges Instruction Following.
- Gute Performance auf Apple Silicon.

Für den initialen Prototyp sollen unterschiedliche Modellgrößen getestet werden.

### Kandidaten

| Modellfamilie | Relevanz |
|---|---|
| Gemma | Google-Ökosystem und LiteRT-LM |
| Qwen | Interessante mehrsprachige Modelle |
| Llama | Breites lokales Modell-Ökosystem |
| Spezialisierte Übersetzungsmodelle | Potenziell bessere Effizienz für reine Übersetzungen |

Die konkrete Modellversion und Quantisierung müssen anhand der Runtime-Kompatibilität ausgewählt werden.

## 6.2 Model Size

Für den MVP sollen nicht direkt die größten verfügbaren Modelle verwendet werden.

Ein kleineres Modell kann für kurze Übersetzungen ausreichend sein und bietet möglicherweise deutlich bessere Reaktionszeiten.

Geplante Tests:

- Kleine Modelle im Bereich von 1–3 Milliarden Parametern.
- Mittlere Modelle im Bereich von 4–8 Milliarden Parametern.
- Größere Modelle ab etwa 10 Milliarden Parametern.

Diese Größen sind Evaluationsklassen, keine bereits festgelegten Anforderungen.

## 6.3 Quantization

Quantisierte Modelle sollen bevorzugt werden, sofern die Qualität ausreichend bleibt.

Ziel ist eine Reduktion von:

- RAM-Verbrauch.
- Modellgröße.
- Ladezeiten.
- Inferenzkosten.

Die Quantisierung muss jedoch immer gegen die Übersetzungsqualität getestet werden.

## 6.4 Translation Prompting

Die Qualität der Übersetzung hängt nicht nur vom Modell ab, sondern auch von der Gestaltung der Prompts.

Beispiel:

```text
You are a professional translator.

Translate the following text from {source_language}
to {target_language}.

Requirements:
- Preserve the original meaning.
- Use natural and idiomatic language.
- Preserve the original tone and intent.
- Do not add explanations.
- Do not summarize.
- Preserve formatting where possible.
- Return only the translated text.

Text:
{input_text}
```

Weitere Prompt-Varianten sollen für die unterschiedlichen Übersetzungsstile entwickelt werden.

---

# 7. Performance & User Experience

Performance ist ein entscheidendes Qualitätsmerkmal.

Eine Menüleistenanwendung muss sich unmittelbar anfühlen.

Daher sollen folgende Aspekte frühzeitig berücksichtigt werden:

## 7.1 Model Lifecycle

Das Laden eines lokalen Modells kann mehrere Sekunden dauern.

Es soll untersucht werden, wie das Modell möglichst effizient verwaltet werden kann.

Mögliche Strategien:

- Modell beim ersten Öffnen laden.
- Modell nach der ersten Übersetzung im Speicher halten.
- Modell bei Inaktivität optional entladen.
- Modellstatus transparent darstellen.
- Ladezustand und Fehler sauber behandeln.

## 7.2 Streaming

Die Übersetzung soll möglichst früh sichtbar werden.

Sobald die Runtime erste Tokens generiert, sollen diese in der UI dargestellt werden.

Dadurch entsteht ein wesentlich direkteres Nutzererlebnis.

## 7.3 Debouncing

Automatische Übersetzung darf nicht bei jedem Tastendruck eine neue Inferenz starten.

Ein Debouncing-Mechanismus soll verhindern, dass unnötige Modellaufrufe ausgeführt werden.

Ein initialer Richtwert liegt bei 400–600 ms nach der letzten Eingabe.

Laufende Übersetzungen sollen bei einer neuen Eingabe nach Möglichkeit abgebrochen werden.

## 7.4 Hardware Considerations

Die Performance lokaler LLMs hängt stark von der verwendeten Hardware ab.

Daher sollen mindestens unterschiedliche Apple-Silicon-Konfigurationen getestet werden.

Zu untersuchen sind:

- Modell-Ladezeit.
- RAM-Verbrauch.
- Token-Generierung pro Sekunde.
- Zeit bis zum ersten Token.
- Energieverbrauch.
- Verhalten bei längerer Nutzung.

---

# 8. Privacy & Security

Datenschutz ist ein zentrales Alleinstellungsmerkmal.

## 8.1 Local Processing

Lokale Übersetzungen sollen ohne Internetverbindung funktionieren.

Nach dem initialen Download eines Modells soll die Kernfunktionalität offline verfügbar sein.

## 8.2 Data Storage

Übersetzungsverläufe sollen standardmäßig lokal gespeichert werden.

Der Nutzer soll die Möglichkeit haben, den Verlauf vollständig zu deaktivieren oder zu löschen.

## 8.3 External Services

Bei Verwendung eines Cloud-Providers muss klar erkennbar sein, dass Daten das Gerät verlassen.

API-Schlüssel dürfen nicht ungeschützt in der Anwendung gespeichert werden.

Bei einer späteren Cloud-Integration muss außerdem geprüft werden, ob ein Backend zur sicheren Verwaltung von API-Zugangsdaten erforderlich ist.

---

# 9. Development Roadmap

## Phase 1 – Technical Discovery

Ziel: Technische Machbarkeit überprüfen.

Aufgaben:

- Flutter-macOS-Projekt aufsetzen.
- LiteRT-LM und verfügbare Flutter-Integrationen untersuchen.
- Lokales Modell laden.
- Erste Inferenz durchführen.
- Übersetzungsprompts testen.
- Streaming implementieren.
- RAM- und Performance-Messungen durchführen.

**Ergebnis:** Ein funktionierender lokaler Übersetzungsprototyp.

## Phase 2 – MVP

Ziel: Eine nutzbare erste Anwendung entwickeln.

Funktionen:

- macOS-Menüleisten-Integration.
- Kompaktes Popover.
- Texteingabe.
- Sprachauswahl.
- Automatische Spracherkennung.
- Lokale Übersetzung.
- Copy-to-Clipboard.
- Basis-Einstellungen.

**Ergebnis:** Eine eigenständig nutzbare Quick-Translator-Anwendung.

## Phase 3 – macOS Workflow Integration

Ziel: Die Anwendung stärker in den täglichen Workflow integrieren.

Funktionen:

- Globaler Shortcut.
- Markierten Text übernehmen.
- Zwischenablage integrieren.
- Übersetzung direkt zurückschreiben.
- Übersetzungsverlauf.
- Schnellere Modellinitialisierung.

**Ergebnis:** Ein nahtlos integriertes macOS-Utility.

## Phase 4 – Advanced Translation

Ziel: Die Übersetzungsqualität und Flexibilität erweitern.

Funktionen:

- Verschiedene Übersetzungsstile.
- Mehrere Modelloptionen.
- Apple Foundation Models Integration.
- Optional DeepL.
- Individuelle Prompts.
- Erweiterte Spracheinstellungen.

**Ergebnis:** Eine flexible Übersetzungsplattform.

## Phase 5 – Beyond Translation

Ziel: Aus dem Übersetzer einen lokalen Sprachassistenten entwickeln.

Mögliche Erweiterungen:

- Grammatik verbessern.
- Texte umformulieren.
- Texte kürzen.
- Texte formalisieren.
- E-Mails optimieren.
- Textzusammenfassungen.
- Kontextbasierte Textbearbeitung.

**Ergebnis:** Ein universeller, lokaler Sprachassistent für macOS.

---

# 10. Project Risks & Open Questions

Vor der eigentlichen Produktentwicklung müssen einige technische Fragen beantwortet werden.

| Thema | Offene Frage |
|---|---|
| LiteRT-LM | Wie stabil und performant ist die macOS-Integration? |
| Model Selection | Welches Modell liefert die beste Übersetzungsqualität? |
| Model Size | Welche Modellgröße bietet das beste Verhältnis aus Qualität und Geschwindigkeit? |
| Quantization | Welche Quantisierung ist noch qualitativ ausreichend? |
| Apple Silicon | Welche Hardware wird mindestens unterstützt? |
| Foundation Models | Welche Sprachkombinationen funktionieren zuverlässig? |
| Flutter FFI | Wie aufwendig ist die Integration der nativen Runtime? |
| Menu Bar | Wie lässt sich das Popover performant mit Flutter umsetzen? |
| Distribution | Wie werden Modelle heruntergeladen, aktualisiert und bereitgestellt? |

Besonders wichtig ist die technische Validierung der Modell- und Runtime-Kompatibilität auf macOS.

Eine Flutter-Integration, die auf Android funktioniert, ist nicht automatisch auch für macOS verfügbar.

Ebenso muss geprüft werden, welche Hardwarebeschleunigung die jeweilige Runtime auf Apple Silicon tatsächlich nutzt.

---

# 11. Success Criteria

Der Erfolg des MVP soll nicht primär anhand der Anzahl implementierter Features gemessen werden.

Entscheidend ist die Qualität des Kernworkflows.

Folgende initiale Zielwerte dienen als Produktanforderungen und müssen durch Prototypen validiert werden:

| Kriterium | Ziel |
|---|---|
| App-Zugriff | Globaler Shortcut |
| Modellverfügbarkeit | Nach Initialisierung ohne Internet |
| Erste Ausgabe | Möglichst unter 1 Sekunde |
| Kurze Übersetzung | Möglichst unter 2 Sekunden |
| Übersetzungsqualität | Natürlich und bedeutungstreu |
| Datenschutz | Lokale Standardverarbeitung |
| Benutzerfreundlichkeit | Keine unnötigen Zwischenschritte |

Die Zeitziele beziehen sich auf typische kurze Texte und geeignete Hardware. Sie sind keine garantierten Leistungswerte.

---

# 12. Initial Technical Decisions

Für den Start werden folgende Entscheidungen als Arbeitshypothesen festgehalten:

| Bereich | Bevorzugte Lösung |
|---|---|
| Plattform | macOS |
| UI Framework | Flutter |
| Anwendungssprache | Dart |
| Menüleisten-Integration | Native Swift / NSStatusItem |
| Popover | Flutter-basierte Oberfläche |
| Lokale KI-Runtime | LiteRT-LM |
| Runtime-Anbindung | Dart FFI, sofern auf macOS unterstützt |
| Primäre Modellfamilie | Gemma |
| Alternative Runtime | Apple Foundation Models |
| Cloud Provider | Optional, zunächst nicht erforderlich |
| Lokale Persistenz | Lokale Einstellungen und optionaler Verlauf |
| Architektur | Modular und Provider-basiert |

Diese Entscheidungen sind bewusst nicht alle endgültig. Insbesondere Runtime, Modell und FFI-Integration müssen zunächst durch einen technischen Proof of Concept bestätigt werden.

---

# 13. Long-Term Vision

Quick Translator soll langfristig mehr sein als ein klassischer Übersetzer.

Die Vision ist eine kleine, leistungsfähige und intelligente macOS-Anwendung, die sprachliche Aufgaben direkt dort erledigt, wo sie entstehen.

Der Nutzer soll nicht mehr darüber nachdenken müssen, welches Tool er für eine Übersetzung, eine Formulierung oder eine sprachliche Verbesserung benötigt.

Die Anwendung soll diese Aufgaben unmittelbar und möglichst lokal erledigen.

Google AI Edge Eloquent zeigt, dass diese Produktkategorie mit moderner lokaler KI und Flutter realisierbar ist.

Quick Translator soll diesen Ansatz auf einen klar definierten Anwendungsfall übertragen: schnelle, hochwertige und private Sprachverarbeitung.

**Product Philosophy:**

> Small interface. Powerful local intelligence. Zero friction.

---

# 14. References & Further Reading

### Google AI Edge

- Google AI Edge: https://ai.google.dev/edge
- LiteRT-LM: https://github.com/google-ai-edge/LiteRT-LM
- Flutter MediaPipe: https://github.com/google-ai-edge/flutter-mediapipe
- Flutter Gemma: https://github.com/DenisovAV/flutter_gemma

### Apple

- Foundation Models Framework: https://developer.apple.com/documentation/FoundationModels
- Apple Intelligence: https://www.apple.com/apple-intelligence/

### Flutter

- Flutter macOS: https://docs.flutter.dev/platform-integration/macos
- Dart FFI: https://dart.dev/interop/c-interop

---

**End of Document**

*Dieses Dokument bildet die initiale Produktvision und technische Grundlage von Quick Translator. Architektur- und Technologieentscheidungen werden im Rahmen der technischen Discovery anhand realer Prototypen, Benchmarks und Kompatibilitätstests weiter konkretisiert.*
