# Entwicklung und erster Windows-Testbuild

**Stand:** 11. Oktober 2026  
**Version:** 0.1.0  
**Engine:** Godot 4.7.2 Standard, `4.7.2.stable.official.ed1daf0bf`  
**Ziel:** Windows x86_64, GDScript, Compatibility-Renderer

Der Prototyp enthält ein deutsches Hauptmenü und eine Platzhalter-Spielansicht. Er ist die technische Grundlage für den späteren Tagesablauf. Die Spielregeln aus der Konzeptdokumentation werden in den folgenden Meilensteinen umgesetzt.

## Testbuild starten

Der lokale Export liegt unter `build/windows/EinShopZweiWelten-0.1.0/`. Die Datei `EinShopZweiWelten.exe` startet das Spiel. Für die Weitergabe den vollständigen Inhalt der ZIP `build/windows/EinShopZweiWelten-0.1.0-windows-x64.zip` entpacken. EXE, PCK und Begleitdateien bleiben zusammen; zum Starten wird kein Editor benötigt. Eine SHA-256-Datei liegt neben der ZIP.

Bedienung: Maus, Tab und Umschalt+Tab zur Auswahl, Enter oder Leertaste zum Auslösen. Escape führt aus dem Spielbereich ins Hauptmenü. „Beenden“ oder das Schließen des Fensters beendet das Programm. Das Fenster startet mit 1280 × 720 und lässt sich bis mindestens 960 × 540 verkleinern.

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

## Aufbau und Erweiterung

- App verwaltet jeweils genau eine aktive Ansicht und reagiert auf deren Signale `start_requested`, `back_requested` und `quit_requested`.
- Hauptmenü und Spielansicht enthalten die eigene Bedienung und setzen beim Öffnen den Tastaturfokus auf die erste Schaltfläche.
- Das gemeinsame Theme liegt unter `game/ui/`; Schriften, Farben, Schaltflächen und Fokusränder werden dort gepflegt. Die SVG-Illustrationen sind eigene Projektressourcen unter `game/assets/`.
- Der gemeinsame Spielerstand und die Weltzustände folgen im nächsten Meilenstein. Die vorhandenen Ansichten enthalten keine Wirtschafts- oder Speicherlogik.
- Git führt die Quellen, UID-Dateien, Ressourcen, Dokumentation, Werkzeuge und Exportkonfiguration. `.tools/`, `game/.godot/`, `build/` und `tmp/` sind ausgeschlossen. Das öffentliche Repository liegt unter [OnekoSL/ein-shop-zwei-welten](https://github.com/OnekoSL/ein-shop-zwei-welten). Der lokale Branch `main` folgt `origin/main`.

## Prüfung wiederholen

Importprüfung ohne Editorfenster:

```powershell
& .\.tools\godot-4.7.2\Godot_v4.7.2-stable_win64_console.exe --headless --path .\game --editor --import
```

Oberflächenprüfung mit echtem Renderer und Godot-Eingabeereignissen:

```powershell
$qaScript = (Resolve-Path .\tools\qa_ui.gd).Path
$qaOutput = Join-Path (Get-Location) 'build\qa\source'
& .\.tools\godot-4.7.2\Godot_v4.7.2-stable_win64_console.exe --path .\game --script $qaScript -- $qaOutput
```

Die Prüfung öffnet ein Fenster, wechselt mehrfach zwischen beiden Ansichten, prüft Fokus und Tastaturbedienung, simuliert Mausklicks über den Viewport und testet Mindestgröße, 1280 × 720, 1920 × 1080 und maximiertes Fenster. Sie erzeugt PNGs und `report.json`. Bei Fehlern endet sie mit Exitcode 1; bei Erfolg löst sie abschließend die Beenden-Schaltfläche aus. Bilder zusätzlich visuell prüfen. Der Prüftreiber liegt außerhalb des Spiels und wird nicht exportiert. Release-Exporte unterstützen den Parameter `--script` nicht; sie werden separat gestartet und bedient.

Zur Abnahme die ZIP außerhalb des Projektordners entpacken, den Editor schließen und die entpackte EXE starten. Starten, Zurück, Escape, Tab, Umschalt+Tab, Enter, Beenden und Fensterschließen prüfen. Das Spiel nutzt standardmäßig Godots automatische Barrierefreiheitserkennung. Für die Prüfung über die Windows-Zugänglichkeit lässt sie sich beim Start ausdrücklich aktivieren:

```powershell
& .\EinShopZweiWelten.exe --accessibility always
```

## Prüfergebnis dieses Standes

- Engine und Exportvorlagen anhand der offiziellen Prüfsummen geprüft.
- Projektimport, Öffnen im Godot-Editor, Start mit der festgelegten Engine und Release-Export ohne Skript- oder Importfehler.
- Automatische Oberflächenprüfung: 92 Kontrollen bestanden, keine fehlgeschlagen. Bilder der Ansichten bei Mindest- und Startgröße sowie maximiertem Fenster visuell geprüft.
- Export außerhalb des Projekts entpackt und bei geschlossenem Editor gestartet. Windows-Tastatureingaben und Schließen des echten Fensters separat geprüft.
- Fehlerfälle fehlende Engine, falsche Version und fehlende Exportvorlage geprüft: verständliche Fehlermeldung und Exitcode 1. Ein absichtlich fehlerhaftes Exportprofil wurde in einer isolierten Projektkopie geprüft: Exportfehler wird erkannt und kein fehlerhaftes Paket veröffentlicht.
- Die Windows-Bildaufnahme des Computer-Use-Werkzeugs meldete `FrameArrived timed out` beziehungsweise `window capture timed out`; dessen Mausklick meldete `coordinate input geometry is unavailable`. Deshalb erfolgten visuelle Prüfung und automatische Maustests über Godots Renderer und Viewport-Ereignisse, die Bedienprüfung des Release-Builds über Windows-Tastatur und Zugänglichkeitsbaum. Der Nutzer hat am 11. Oktober 2026 zusätzlich die Mausklicks auf „Spiel starten“ und „Zum Hauptmenü“ im geöffneten, entpackten Release-Build erfolgreich geprüft und bestätigt.

Die Abnahme dieses Grundgerüsts ist damit abgeschlossen.

Die Prüfung erfolgte auf dem vorhandenen Windows-Rechner mit NVIDIA GeForce RTX 4060 Ti. Weitere PCs und Grafiktreiber sind noch nicht geprüft.
