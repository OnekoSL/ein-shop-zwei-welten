# Entwicklung und Windows-Testbuild

**Stand:** 11. Oktober 2026  
**Version:** 0.2.0  
**Engine:** Godot 4.7.2 Standard, `4.7.2.stable.official.ed1daf0bf`  
**Ziel:** Windows x86_64, GDScript, Compatibility-Renderer

Der Prototyp enthält Hauptmenü, zwei Stadtkarten mit je fünf Orten, vollständige Tagesrunden, eine Bestandsansicht und einen lokalen Spielstand. Einkauf, Herstellung, Lernen und Verkäufe folgen im nächsten Meilenstein.

## Spielen

Die portable ZIP liegt unter `build/windows/EinShopZweiWelten-0.2.0-windows-x64.zip`. Vollständig entpacken und `EinShopZweiWelten.exe` starten. EXE, PCK und Begleitdateien bleiben zusammen; ein Editor ist nicht erforderlich. Eine SHA-256-Datei liegt neben der ZIP. Buildausgaben werden nicht ins Repository übertragen.

1. **Neues Spiel** legt eine Partie an. Ein vorhandener Stand wird erst nach Bestätigung und erfolgreicher Speicherung ersetzt.
2. **Welt wählen**, ein Gebäude auf der Karte auswählen und mit **Betreten** bestätigen. Damit sind Welt und einziger Besuch für diesen Tag festgelegt.
3. **Runde beenden**, das neutrale Ereignis mit **Weiter zum Tagesabschluss** bestätigen und die Zusammenfassung ansehen. Erst nach erfolgreichem Speichern steigt der aktive Welttag.
4. **Nächste Runde** öffnet die Weltwahl. **Fortsetzen** im Hauptmenü lädt stets diese Tagesgrenze, auch nach einem vollständigen Neustart.

Maus, Tab, Umschalt+Tab, Enter und Leertaste bedienen die Schaltflächen. Escape führt zum Hauptmenü; während einer begonnenen Runde erscheint vorher eine Rückfrage. Fensterschließen verwendet dieselbe Rückfrage. In Dialogen ist zunächst Abbrechen bzw. Zurück fokussiert. An der Weltwahl und nach gespeichertem Tagesabschluss kann man ohne Verlustwarnung verlassen. Startgröße 1280 × 720, Mindestgröße 960 × 540, maximierbar.

Der Teststart umfasst 100 €, 100 Silbergroschen, leeres Lager und leere Auslagen, Küchenstuhlrezept, Tischlerfähigkeit 1 und Tag 1 in beiden Welten. Im eigenen Laden werden Lager, Fähigkeiten, Rezepte und ausschließlich die aktive Auslage angezeigt. Andere Orte enthalten Beschreibungen ihrer späteren Fachfunktionen.

## Entwicklungsumgebung einrichten

Die folgenden Befehle im Projektstamm in **PowerShell 7** ausführen. Git ist für die Versionsverwaltung installiert. Für GDScript ist kein .NET-SDK erforderlich.

Für eine neue Arbeitskopie zuerst das öffentliche Repository klonen:

```powershell
git clone https://github.com/OnekoSL/ein-shop-zwei-welten.git
Set-Location ein-shop-zwei-welten
```

```powershell
pwsh -NoProfile -File .\tools\setup_godot.ps1
```

Das Setup lädt die Standardausgabe von Godot und die offiziellen Exportvorlagen, prüft beide Archive gegen die festgehaltenen SHA-512-Prüfsummen und entpackt die Engine nach `.tools/godot-4.7.2/`. Aus dem Vorlagenarchiv werden nur Windows-x64-Vorlagen sowie deren Versionsdatei nach `%APPDATA%/Godot/export_templates/4.7.2.stable/` installiert. Bereits geladene Archive werden erneut geprüft und wiederverwendet. Beim ersten Aufruf werden etwa 1,37 GB heruntergeladen. Die vorhandenen anderen Godot-Versionen bleiben separat nutzbar.

Quellen: [Godot 4.7.2](https://godotengine.org/download/archive/4.7.2-stable/) und [offizielle Prüfsummen](https://github.com/godotengine/godot-builds/releases/download/4.7.2-stable/SHA512-SUMS.txt).

Editor öffnen:

```powershell
& .\.tools\godot-4.7.2\Godot_v4.7.2-stable_win64.exe --editor --path .\game
```

Das vollständige Projekt mit F5 beziehungsweise Godots Startschaltfläche ausführen. Einstieg ist die Szene App.

## Windows-Build erstellen

```powershell
pwsh -NoProfile -File .\tools\build_windows.ps1 `
  -GodotExe .\.tools\godot-4.7.2\Godot_v4.7.2-stable_win64_console.exe
```

Der Engine-Pfad darf absolut sein. Das Skript löst die Projekt- und Ausgabepfade relativ zu seinem eigenen Speicherort auf; auch der Projektpfad mit Leerzeichen funktioniert. Ein falscher Engine-Stand, die .NET-Ausgabe oder eine fehlende Windows-Exportvorlage führen zu Exitcode 1 mit einer Erklärung.

Das Skript importiert das Projekt und verwendet das Profil „Windows Desktop“ für einen Release-Export. Es kontrolliert Exitcode und Godot-Fehlerausgaben. Erst nach erfolgreichem Export wird der versionsbezogene Ausgabeordner ersetzt und mit Lizenzhinweisen, Bedienungsanleitung und BUILDINFO als ZIP verpackt. Vor einem erneuten Build das Programm aus diesem Ausgabeordner schließen. Import- und Exportprotokolle stehen unter `build/windows/logs/`.

`application/config/version` im Godot-Projekt ist die Quelle der Prototypversionsnummer für Menü und Paket. Bei einer Versionsänderung auch die Windows-Versionsfelder im Exportprofil und die mitgelieferte Bedienungsanleitung anpassen.

## Spielstand und Fehlerbehandlung

Standardpfad unter Windows:

```text
%APPDATA%\Godot\app_userdata\Ein Shop, zwei Welten\savegame.json
```

Godots `user://`-Verzeichnis liegt außerhalb der EXE und des Repositorys. Editor und Export desselben Windows-Benutzers teilen standardmäßig diesen Stand. `savegame.json.bak` enthält die vorherige gültige Sicherung; `.tmp` und `.bak.tmp` dienen ausschließlich dem Schreibvorgang.

Der neue Zustand wird zunächst in eine temporäre Datei geschrieben und geprüft. Nur ein gültiger bisheriger Hauptstand darf die Sicherung ersetzen. Danach wird die neue Datei veröffentlicht. Beim Fehler bleibt die laufende Runde vor dem Abschluss; **Erneut versuchen** wiederholt das Speichern ohne doppelte Tagesfortschreibung. Über **Zurück** lässt sich der Dialog schließen und der ungespeicherte Tag anschließend bewusst verwerfen.

Fehlende, beschädigte und inkompatible Spielstände werden unterschieden. Fortsetzen ist ohne gültigen Hauptstand deaktiviert. Bei gültiger Sicherung erscheint **Sicherung wiederherstellen**, ebenfalls mit Bestätigung. Es gibt keine automatische Rücksetzung oder stillschweigende Wiederherstellung. Version 0.1.0 hatte keine Spielstände; deshalb ist keine Migration erforderlich.

## Aufbau und Schnittstellen

- **App** verwaltet die Ansichten, Bestätigungen und die laufende GameSession. Ansichten erhalten eine Kopie des Zustands und senden Benutzerwünsche als Signale; sie ändern keine Bestände direkt.
- **GameSession** kontrolliert `WORLD_SELECTION → CITY_MAP → VISIT → EVENT → SUMMARY`. `choose_world`, `visit`, `end_round`, `finish_event` und `next_round` prüfen die erlaubte Phase. `changed` aktualisiert die Ansicht, `save_failed` öffnet den Fehlerdialog. Neue Partien und Fortsetzen verwenden dieselbe Zustandsverwaltung.
- **GameState** enthält ausschließlich Daten. Geld steht als ganze Cent/Pfennig, Zeit als nächster Welttag darin. `last_summary` merkt Welt, Ort und den tatsächlich abgeschlossenen Tag. Eine laufende Runde gehört nicht zum gespeicherten Zustand; Laden beginnt mit leerer Orts-/Weltauswahl.
- **SaveService** kapselt Lesen, Validierung, temporäres Schreiben und ausdrückliche Wiederherstellung. Das Speicherverzeichnis ist für Tests austauschbar.
- **CityMap** zeichnet die räumliche Karte mit beschrifteten, fokussierbaren Gebäudeschaltflächen. Beide Welten teilen den Aufbau und verwenden verschiedene Farben. Das Theme und die vorhandenen SVG-Ressourcen bleiben gemeinsam.

Speicherformat `format_version: 1`:

| Feld | Inhalt |
| --- | --- |
| `money` | `eur_cent` und `fantasy_pfennig`, nichtnegative Ganzzahlen |
| `inventory` | `materials`: Material-ID → positive Anzahl; `prototype_ids`: eindeutige Exemplar-IDs |
| `prototypes` | Exemplar-ID → `recipe_id`, `material_ids`, gespeicherte `quality` |
| `skills`, `recipes` | Gemeinsame Fähigkeitswerte und eindeutige bekannte Rezept-IDs |
| `worlds` | Genau `real` und `fantasy`, jeweils `day` ab 1 und geordnetes `display` |
| Auslagenplatz | `prototype_id`, lokaler Preis `price_minor` in Cent bzw. Pfennig; Reihenfolge entspricht Ladenplätzen |
| `last_summary` | Anfangs leer; später `world_id`, `location_id`, abgeschlossener `day` |

Validierung prüft Pflichtfelder, Typen, Wertebereiche, eindeutige Listen und Exemplarzuordnung. Jedes gebaute Exemplar gehört genau einem Lager-/Auslagenplatz; verwaiste oder mehrfach zugeordnete Exemplare werden abgewiesen. Geld und Zähler werden nach JSON-Laden in Ganzzahlen überführt. Technische Obergrenze numerischer Zustandswerte: 10¹²; keine Spielbalancegrenze. Qualitätsformeln und endgültige Auslagenkapazität folgen später. Orts-IDs: `shop`, `smith`, `sawmill`, `tailor`, `library`.

Git führt Quellen, Ressourcen, UID-Dateien, Dokumentation und Werkzeuge. `.tools/`, `game/.godot/`, `build/` und `tmp/` sind ausgeschlossen. Das öffentliche Repository ist [OnekoSL/ein-shop-zwei-welten](https://github.com/OnekoSL/ein-shop-zwei-welten); `main` folgt `origin/main`.

## Prüfungen wiederholen

Zustands- und Speichertests ohne Fenster:

```powershell
$qaScript = (Resolve-Path .\tools\qa_state.gd).Path
$qaOutput = Join-Path (Get-Location) 'build\qa\state'
& .\.tools\godot-4.7.2\Godot_v4.7.2-stable_win64_console.exe --headless --path .\game --script $qaScript -- $qaOutput
```

Diese Prüfung erzeugt pro Lauf einen eigenen Unterordner mit `report.json`. Ein absichtlich blockierter Verzeichnispfad erzeugt die erwartete Godot-Meldung `Could not create directory`; der Test prüft, dass diese Situation korrekt abgefangen wird. Maßgeblich sind Bericht und Exitcode.

Oberflächenprüfung mit echtem Renderer und Viewport-Eingabeereignissen:

```powershell
$qaScript = (Resolve-Path .\tools\qa_ui.gd).Path
$qaOutput = Join-Path (Get-Location) 'build\qa\m2-ui'
& .\.tools\godot-4.7.2\Godot_v4.7.2-stable_win64_console.exe --path .\game --script $qaScript -- $qaOutput
```

Die Prüfung besucht alle zehn Orte, nutzt Maus- und Tastaturereignisse, testet Fokus, Bestätigungen, Speicherfehler, Wiederherstellung und vorbereitete nichtleere Bestände. Sie prüft 960 × 540, 1280 × 720, 1920 × 1080 und maximiertes Fenster und erstellt PNGs sowie `report.json`. Testspielstände liegen in eigenen Unterordnern des Ausgabeordners. Die Skripte liegen außerhalb des Spiels und werden nicht exportiert; Fehler liefern Exitcode 1. Bilder zusätzlich visuell prüfen.

Release-Exporte werden separat geprüft; sie unterstützen `--script` nicht. Dafür die ZIP außerhalb des Projektordners entpacken, den Editor schließen und mit einem eigenen Test-Speicherordner starten:

```powershell
& .\EinShopZweiWelten.exe --accessibility always -- '--save-dir=C:\Temp\Shop-Testspielstand'
```

Der optionale Spielparameter `--save-dir=...` überschreibt ausschließlich das Speicherverzeichnis. Ohne ihn gilt der normale Benutzerpfad. `--accessibility always` aktiviert den Windows-Zugänglichkeitsbaum ausdrücklich für die Bedienprüfung.

Einen Tag abschließen, vollständig beenden, dieselbe EXE mit demselben Speicherordner neu starten und Fortsetzen prüfen. Zusätzlich einen begonnenen Folgetag abbrechen: Nach Fortsetzen muss wieder die letzte gespeicherte Weltwahl erscheinen.

## Prüfergebnis 0.2.0

- Zustands- und Speichertests: 171 bestanden, 0 fehlgeschlagen. Enthalten sind 3/2-Tageszähler, alle Orte, unerlaubte Übergänge, doppelte Abschlüsse, gefüllte Bestände, beschädigte/inkompatible Daten, Wiederherstellung und reale bzw. simulierte Schreibfehler.
- Oberflächentests: 586 bestanden, 0 fehlgeschlagen. Alle Tagesphasen, Abbruch-/Neustart-/Wiederherstellungsdialoge, Speicherfehler und gefüllte Auslagen wurden geprüft. PNGs bei Mindest- und Startgröße sowie maximiertem Fenster visuell geprüft.
- Projektimport und Windows-Release-Export erfolgreich. ZIP außerhalb des Projekts entpackt und bei geschlossenem Editor gestartet. Ein Tag wurde über native Windows-Tastatureingaben abgeschlossen; nach vollständigem Beenden und Neustart wurden Weltwahl, Tageszähler 2/1, Geldbestände und letzte Zusammenfassung korrekt geladen. Ein anschließend begonnener und verworfener Folgetag veränderte den Speicherstand nicht. Beide Prozesse wurden sauber über Fensterschließen beendet; die Fehlerprotokolle blieben leer.

Meilenstein 2 ist damit umgesetzt und abgenommen. Die Build-Fehlerfälle des unveränderten Exportskripts wurden bereits in Meilenstein 1 geprüft.

Die Prüfung erfolgt auf dem vorhandenen Windows-Rechner mit NVIDIA GeForce RTX 4060 Ti. Weitere PCs und Grafiktreiber sind noch nicht geprüft. Die Windows-Bildaufnahme des Computer-Use-Werkzeugs war beim vorherigen Build nicht verfügbar; visuelle Tests nutzen deshalb Godots Renderer, native Bedienprüfungen den Windows-Zugänglichkeitsbaum und Tastatureingaben.
