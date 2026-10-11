# Roadmap für die Umsetzung in Godot

**Stand:** 11. Oktober 2026  
**Bestätigt:** Godot als Engine, zunächst ein PC-Spiel (E-046); erster Build mit Godot 4.7.2 Standard, GDScript und Windows x86_64 (E-069).  
**Status:** Meilensteine 1 bis 3 sind umgesetzt. Die Regeln des ersten Handelsablaufs sind als Testbalance festgelegt; die endgültige Balance und spätere Meilensteine bleiben offen. Details: [Handelsregeln 0.3.0](handelsprototyp-0.3.md) und [Prüfstand](entwicklung.md).

Das erste Ziel ist eine spielbare Fassung, in der der Spieler in beiden Welten Materialien beschafft, Produkte herstellt, Angebote vorbereitet und die wirtschaftlichen sowie gesellschaftlichen Folgen erlebt. Dafür wird zunächst eine Tischlerei umgesetzt. Das bereits ausgearbeitete Beispiel „Stuhl = Holz + Nägel“ erlaubt es, Materialwahl, Qualität, Preis, Tagesabsatz und Chaos gemeinsam zu prüfen. Danach folgen Wochenmarkt, Einzelstücke und die vollständigen Spielenden.

Die bestätigten Regeln aus [Entscheidungen](entscheidungen.md) gelten als Grundlage. Offene Regeln werden vor dem jeweils abhängigen Arbeitsschritt konkretisiert. Vorläufige Formeln und Testwerte bleiben als solche gekennzeichnet und werden erst nach Bestätigung als verbindliche Festlegungen übernommen.

## Umfang der ersten spielbaren Fassung

Die bestätigten Einkaufsorte und Bibliotheksfunktionen werden mit folgenden vorgeschlagenen Testinhalten umgesetzt:

| Bestandteil | Erster Umfang |
| --- | --- |
| Spielweise | Einzelspieler; Bedienung über Stadtkarte und Menüs |
| Welten | Unsere Welt und Fantasywelt; getrennte Tageszähler, Geldbestände, Angebote und geheime Chaoswerte |
| Handwerk | Eine Tischlerei in beiden Welten; Küchenstuhl als bekanntes Startrezept, drei weitere Rezepte als Bibliotheksangebot umgesetzt |
| Materialien | Je drei verschiedene Waren bei Schmied, Sägewerk und Schneider sind bestätigt; umgesetzt sind je Welt drei Holzarten, drei Nägelarten und drei Stoffarten gemäß Testsortiment |
| Orte | Eigener Laden, Schmied, Sägewerk, Schneider und Bibliothek; diese Orte sind in jeder Welt umgesetzt. Wochenmarkt ab Meilenstein 5 |
| Bibliothek | Werte verbessern und Rezepte kaufen; einmal lernen je Besuch zusätzlich zu Rezeptkäufen. Tischlern kostenlos +1 bis Stufe 10; Analyse einmalig in der Fantasybibliothek statt Tischlern lernen |
| Lager | Gemeinsames Lager für Materialien und gebaute Exemplare; praktisch unbegrenzter Platz |
| Verkauf | Dauerhafte Ausstellungsstücke, Preiswahl, verborgener Wert, Analyse und qualitätsabhängiges Tageslimit |
| Rückmeldung | Tagesabrechnung, Gespräche und ein Ereignis nach jeder beendeten Runde |
| Markt | Ein einmaliges Material, ein daraus gebautes Einzelstück und ein eigener Marktstand |
| Ziele | Omas Erbe und Brief, Gläubigerbesuche an Welttag 1 und 366, vier Endtypen |
| Spielstand | Speichern und Laden; zunächst an abgeschlossenen Tagesgrenzen |

Für die erste Prüfung genügt eine Folge von ungefähr 20 bis 30 Tagesrunden mit mehreren Weltwechseln. Die Schuldenfristen bleiben bei Tag 366; vorbereitete Testspielstände erlauben das Prüfen der Enden ohne hunderte manuelle Runden. Eine vollständige Partie gehört zur anschließenden Prüfung der Wirtschaft.

Weitere Handwerke, Rezepte über das erste Bibliotheksangebot hinaus, Startberufe, freie Fähigkeitsauswahl sowie eine Fortsetzung nach dem guten Ende folgen nach dem Prototyp. Bibliothek und Weiterbildung sind bereits Teil des ersten Tests. Der endgültige Grafikstil wird nach Prüfung des Ablaufs festgelegt; zunächst genügen einfache Karten, Symbole und Texte. Die acht genannten Handwerksbereiche bleiben Grundlage für die spätere Auswahl und Ausarbeitung.

## Meilensteine und Abhängigkeiten

| Meilenstein | Ergebnis | Voraussetzung |
| --- | --- | --- |
| 0 | Regeln und Umfang für den ersten Handelsablauf | Bestehendes Konzept |
| 1 | Startbares Godot-Projekt und erster PC-Testbuild | Engine, Zielsystem und Oberfläche festgelegt; vollständige Wirtschaftsformeln werden erst für den Handel benötigt |
| 2 | Tagesablauf, zwei Welten und gespeicherter Grundzustand | Meilenstein 1 |
| 3 | Beschaffung, Lernen, Rezeptkäufe, Herstellung, Auslage und berechnete Verkäufe | Meilenstein 2; Lern-, Rezept-, Verkaufs- und Kostenregeln |
| 4 | Chaos, Reputation, Gewöhnung, Ereignisse und Gespräche | Meilenstein 3; Wirkungsregeln |
| 5 | Wochenmarkt, Einzelstücke und eigener Stand | Meilenstein 4; Marktregeln |
| 6 | Spielbeginn, Schuldenfristen und alle vier Endtypen | Meilensteine 4 und 5; Übergangsregeln |
| 7 | Geprüfte und weitergebbare erste spielbare Fassung | Meilenstein 6 |

### Meilenstein 0 Regeln für den ersten Handelsablauf klären

**Stand:** Für den Tischlerei-Test abgeschlossen. Einkauf, Materialverbrauch, eingefrorene Qualität, lokale Werte, Nachfrage, Produktionslimit, Vorfinanzierung und Prototypverkauf sind in den [Handelsregeln 0.3.0](handelsprototyp-0.3.md) konkretisiert.

Drei Auslagenplätze, unbegrenzte Händlervorräte, kostenlose Lernaktionen, Rezeptkäufe und Analysezugang sind bestätigt. Drei Kundengruppen vergleichen den Spieler mit zwei festen Konkurrenten. Materialpreise verändern sich ab Welttag 8 in festen Wochenzyklen. Das Küchenstuhlbeispiel und Mehrangebotsfälle dienen als verbindliche Rechenproben.

**Weiter offen:** endgültige Balance, Omas Startbestand, Chaos- und Gewöhnungswirkung, gesellschaftliche Ereignisse sowie Anpassung und Produktentwicklung der Konkurrenz. Diese Fragen blockieren den umgesetzten Handelsablauf nicht.

### Meilenstein 1 Godot-Projekt und Export einrichten

**Stand:** Grundprojekt und Windows-Release-Testbuild 0.1.0 umgesetzt und abgenommen. Import, Export, automatische Eingabe- und Layoutprüfungen sowie Tastaturbedienung und Fensterschließen des entpackten Builds sind geprüft. Die Mausbedienung im Release-Build wurde zusätzlich vom Nutzer bestätigt. Details: [Entwicklung und Prüfstand](entwicklung.md).

**Umgesetzt:**

- Godot 4.7.2 Standard mit geprüften Windows-x64-Exportvorlagen, GDScript und Compatibility-Renderer eingerichtet.
- Projekt unter `game/` mit App, Hauptmenü, Spielansicht und gemeinsamem Theme erstellt.
- Starten, Zurück, Escape, Beenden, Tastaturfokus und skalierbare Oberfläche mit 1280 × 720 Startgröße und 960 × 540 Mindestgröße umgesetzt.
- PowerShell-7-Werkzeuge für Einrichtung und Windows-Release-Export samt ZIP, Prüfsumme und Fehlerbehandlung erstellt.
- Versionsverwaltung auf `main` eingerichtet; Quellen, Ressourcen, Werkzeuge und Dokumentation im öffentlichen [GitHub-Repository](https://github.com/OnekoSL/ein-shop-zwei-welten) veröffentlicht.

**Fertig, wenn:** Das Projekt im Editor startet und ein exportierter Testbuild unabhängig vom Editor geöffnet und beendet werden kann. Projektstart und Export sind kurz dokumentiert.

### Meilenstein 2 Tagesablauf und Spielzustand umsetzen

**Stand:** In Version 0.2.0 umgesetzt und abgenommen. Beide Stadtkarten, alle zehn Ortsbesuche, Tagesphasen und ein automatischer Spielstand sind vorhanden. Prüfstand und Wiederholungsanleitung: [Entwicklung](entwicklung.md).

**Umgesetzt:**

- Kostenlose Weltwahl zu Rundenbeginn; danach genau ein bestätigter Ortsbesuch in der festen Welt.
- Je Welt eigener Laden, Schmied, Sägewerk, Schneider und Bibliothek. Fachfunktionen folgen in Meilenstein 3.
- Runde beenden → neutrales Ereignis → gespeicherter Tagesabschluss → nächste Weltwahl.
- Nur der aktive Welttag steigt, und erst nach erfolgreichem Speichern. Wiederholte Abschlussaktionen werden abgefangen.
- Gemeinsame Geldbestände, Lager-, Fähigkeits- und Rezeptdaten sowie getrennte geordnete Auslagen; reine Bestandsanzeige im eigenen Laden.
- Eine Partie mit automatisch gespeichertem Anfangsstand und Tagesgrenzen. Fortsetzen beginnt an der Weltwahl; neues Spiel und Verwerfen eines begonnenen Tages verlangen Bestätigung.
- Versionierte JSON-Datei, temporäre Schreibdatei und vorherige gültige Sicherung; lesbare Fehler und ausdrückliche Wiederherstellung.

**Abnahme:** Zwei Tage in unserer Welt und ein Fantasywelt-Tag führen zu nächsten Welttagen 3 und 2. Weltwechsel, zweite Ortsbesuche und doppelte Abschlüsse innerhalb derselben Runde sind ausgeschlossen. Gespeicherte Daten einschließlich gefüllter Lager und Auslagen werden unverändert geladen. Maus, Tastatur, Dialoge und Fenstergrößen wurden geprüft; der entpackte Windows-Build wurde unabhängig gestartet, gespeichert und nach einem vollständigen Neustart fortgesetzt.

**Abgrenzung:** Der Teststart verwendet die vorläufigen Werte aus dem [Testsortiment](testsortiment-und-startbestand.md), keine endgültige Balance. Physischer Lagerzugang und spätere zeitabhängige Wirkungen bei F-06/F-25 bleiben offen. Verschieben von Waren, Lernen, Rezeptkauf und Handel folgen in Meilenstein 3. Das neutrale Ereignis enthält noch keine Gläubiger- oder Chaosregeln.

### Meilenstein 3 Den vollständigen Handelsablauf spielen

**Stand:** Handelsprototyp 0.3.0 umgesetzt. Regeln und Testwerte: [Handelsregeln 0.3.0](handelsprototyp-0.3.md). Abnahme und Buildanleitung: [Entwicklung](entwicklung.md).

- Je Welt drei Materialhändler mit je drei Waren, Mengenwahl, sichtbaren Preisen und Einkauf ins gemeinsame Lager.
- Bibliothek mit einmal kostenlosem Lernen, zusätzlichen Rezeptkäufen und Analysezugang. Gemeinsame Fähigkeiten und Rezepte werden gespeichert.
- Rezept- und Materialauswahl, beliebig viele durch Material begrenzte Bauten sowie gespeicherte Qualität je Exemplar.
- Gruppiertes Lager und drei feste Auslagenplätze pro Welt. Rücknahme und Wechsel über das Lager, eigener Preis und Analyse je Exemplar.
- Drei Kundengruppen und zwei feste Konkurrenten; getrennte Nachfrage-, Limit- und Finanzierungsberechnung. Sämtliche Einnahmen folgen der Finanzierung aller Plätze.
- Wochenpreise ab aktivem Welttag 8, ursprüngliche Kostenwährungen, Prototypverkauf nur bei positiver Nachfrage und fehlender Finanzierung.
- Tagesbericht, vollständiges Verwerfen ungespeicherter Aktionen und verlustfreie Migration kompatibler 0.2.0-Spielstände in Format 2.

**Abnahme:** Das Küchenstuhlbeispiel ergibt 40 € / 240 S, dann 0 € / 360 S und schließlich 0 € / 400 S. Zusätzliche Prüfungen decken mehrere Angebote, Nullnachfrage, Preiswechsel, Lernen, Stoffverbrauch, Analyse, Welttransfer, Ladenisolation, Migration und fehlgeschlagenes Speichern ab. Oberflächen und exportierter Windows-Build werden mit separaten Spielständen geprüft; der tatsächliche Prüfstand steht in der Entwicklungsanleitung.

**Nächster Schritt:** Chaos, Reputation, Gewöhnung und Ereignisse konkretisieren. Reagierende Konkurrenz und neue Konkurrenzwaren benötigen anschließend eine eigene festgelegte Reaktionsregel.

### Meilenstein 4 Gesellschaftliche Folgen erfahrbar machen

**Arbeit:**

- Risiko eines Angebots je Zielwelt bestimmen und dessen Beitrag zum geheimen Chaoswert berechnen. Bereits das Angebot muss wirken können, auch bei null Verkäufen.
- Gewöhnung getrennt von bestehendem Chaos führen. Entwicklung und Einfluss auf lokale Werte oder Preise so festlegen, dass zunehmende Gewöhnung die Preisdifferenz verringert.
- Reputation als eigene Größe führen; Dumpingdefinition, Wiederholung und Folgen zunächst auf eine überschaubare Regel begrenzen.
- Je Welt mindestens ein neutrales Ereignis, ein Ereignis mit Handelsfolgen und ein Chaosfolgeereignis schreiben. Mindestens eine Ereignisentscheidung mit konkreter Wirkung umsetzen.
- Gespräche mit indirekten Hinweisen auf Misstrauen und Händlerverhältnis ergänzen.
- Auswahl und Reihenfolge fester, besonderer und allgemeiner Ereignisse festlegen. Entscheidungen und Verkäufe in einer eindeutigen Reihenfolge abrechnen.
- Verdeckte Werte und Berechnungsgründe für Entwicklung und Tests protokollieren; sie erscheinen nicht in der Spieleroberfläche.

**Fertig, wenn:** Ein sicheres und ein auffälliges Angebot in der Zielwelt unterschiedliche Folgen auslösen. Eine Risikoware kann bei null Verkäufen Chaos verursachen. Wiederholtes Dumping verändert Reputation nach der festgelegten Regel. Gewöhnung verkleinert die vergleichbare Preisdifferenz. Der Spieler erlebt Folgen über Ereignisse und Gespräche; die Zahlenwerte des Chaos bleiben geheim.

**Vorher klären:** F-14, F-16, F-17, F-27, F-31 und F-36. Ein Chaosrückgang und eine automatische Kopplung von Reputation und Chaos sind bisher nicht bestätigt.

### Meilenstein 5 Wochenmarkt und Einzelstücke ergänzen

**Arbeit:**

- Markttag und Wochenrhythmus je Welt festlegen und in die Stadtkarte einbauen.
- Ein exotisches, einmaliges Material anbieten. Beim Bau wird es im Produkt gebunden und kann nicht für ein zweites Exemplar verwendet werden.
- Das daraus gebaute Einzelstück über Lager und Auslage insgesamt einmal verkaufen. Danach wird es aus dem Besitz und sämtlichen Angeboten entfernt.
- Den gesetzten Verkaufspreis ohne erneuten Materialkostenabzug gutschreiben; frühere Einkaufsausgaben bleiben in der wirtschaftlichen Betrachtung erhalten.
- Einen mietbaren Marktstand, dessen Abrechnung und das besondere Ereignis umsetzen. Verhältnis zum eigenen Laden und mögliche Mehrfachangebote ausdrücklich regeln.

**Fertig, wenn:** Der Markt nur an den vorgesehenen Tagen verfügbar ist. Ein einmaliges Material lässt sich nicht doppelt verarbeiten und ein Einzelstück auch über beide Welten hinweg nicht doppelt verkaufen. Einkauf und Verkauf ergeben die vorgesehenen Geldänderungen. Der eigene Stand verursacht die vereinbarte Miete und löst das besondere Ereignis aus.

**Vorher klären:** F-21, F-27 und F-28 sowie die Kaufentscheidung für Einzelstücke aus F-26.

### Meilenstein 6 Geschichte Schulden und Spielenden verbinden

**Arbeit:**

- Erbe, einfache Startwaren, Omas Warnbrief und beide ersten Gläubigerbesuche integrieren.
- Startwerte und Schuldenbeträge an der bisherigen Wirtschaft prüfen. Beide Schulden müssen in ihrer jeweiligen Währung durch Handel bezahlbar sein. Prüfen, dass Geldwerte ausschließlich über Warenhandel zwischen Euro und Fantasywährung übertragen werden können; direkter Tausch und zusätzliche Transfermechanismen sind ausgeschlossen (E-053).
- Forderungen je Welt als noch offen, bezahlt oder gescheitert führen. Gläubigerbesuche an Welttag 1 und 366 genau einmal auslösen; vorzeitige Tilgung ausschließen.
- Folgen eines zerstörten Ladens und Weiterlauf bis zur Fälligkeit der anderen Welt festlegen. Dabei klären, was nach einer bereits erfolgreichen Zahlung weiter möglich ist.
- Chaosgrenze, Priorität gleichzeitiger Endauslöser und Darstellung der vier Endtypen umsetzen.
- Vorbereitete Spielstände kurz vor Fälligkeit und vor der Chaosgrenze anlegen.

**Fertig, wenn:** Alle vier Endtypen mit Testspielständen erreichbar sind. Eine noch nicht fällige Schuld zählt nicht als gescheiterte Zahlung. Nur Tagesrunden in einer Welt bringen deren Frist näher; die inaktive Welt pausiert. Ladenzerstörung, Zahlung und Endauswertung funktionieren auch dann, wenn die beiden Fälligkeiten nacheinander erreicht werden.

**Vorher klären:** F-27, F-29 und F-30; Chaosgrenze aus F-07 und F-16.

### Meilenstein 7 Erste spielbare Fassung prüfen und weitergeben

**Arbeit:**

- Den gesamten Ablauf vom Start bis zu den Enden prüfen; kurze manuelle Partien mit einer Simulation ganzer Schuldenfristen ergänzen.
- Masse, hochwertige Ware, vorsichtige Einführung fremder Materialien und wiederholtes Dumping vergleichen. Prüfen, ob unterschiedliche Handelsweisen sinnvolle Entscheidungen erzeugen und das gute Ende erreichbar ist.
- Speichern und Laden für alle eingeführten Zustände vervollständigen, einschließlich Fähigkeiten, bekannten Rezepten, Prototypqualität, Einzelstücken, Gewöhnung, Reputation, Schulden und ausgelösten Ereignissen.
- Sinnvolle automatisierte Prüfungen für Abrechnung, Tageszähler, einmalige Verkäufe und Endbedingungen ergänzen. Die Bedienung der vollständigen Tagesrunde im exportierten Spiel manuell prüfen.
- Texte, lesbare Menüs, Rückmeldungen bei ungültigen Handlungen sowie Fenstergrößen prüfen.
- Einen PC-Testbuild mit kurzer Spielanleitung und bekannten offenen Punkten bereitstellen. Beobachtungen aus Spieltests in konkrete Folgeaufgaben überführen.

**Fertig, wenn:** Der exportierte Build kann ohne Editor vom Spielstart bis zu einem Ende gespielt und an Tagesgrenzen gespeichert werden. Abrechnung und Endbedingungen bestehen die vorgesehenen Prüfungen. Blockierende Fehler sind behoben; verbleibende Einschränkungen sind dokumentiert.

## Vorgeschlagene technische Aufteilung

Die Oberfläche zeigt den Zustand und übergibt Spielerentscheidungen an die Spiellogik. Verkauf, Chaos und Endbedingungen werden unabhängig von einzelnen Menüs berechnet. So lassen sich Wirtschaftswerte prüfen und weitere Handwerke ergänzen, ohne den Tagesablauf neu aufzubauen.

| Teil | Aufgabe |
| --- | --- |
| Spielzustand | Gemeinsames Lager, Geld je Währung und gemeinsamer Fähigkeits- und Rezeptstand; aktive Welt sowie getrennte Weltzustände und Auslagen, Schulden und dauerhafte Ereignisfolgen |
| Tagessteuerung | Kostenlose Weltwahl zu Rundenbeginn, feste Welt während der Runde, Besuchsgrenze, Tagesphasen, einmalige Abrechnung und Übergang zum nächsten Tag |
| Bibliothek | Lernfortschritt, Grenze von einmal Lernen pro Besuch und Rezeptkäufe |
| Herstellung | Rezeptzugang, Materialverfügbarkeit, gebaute Exemplare und Einzelstücke |
| Handel | Lokale Preise, Kostenbasis, Tageslimit, Absatz und Gutschriften |
| Weltfolgen | Chaos, Gewöhnung und Reputation gemäß den jeweils festgelegten Regeln |
| Ereignisse und Enden | Auswahl, Reaktionen, feste Termine und Prüfung der Endbedingungen |
| Spielstand | Speichern, Laden und Kennzeichnung der Datenversion |
| Oberfläche | Startmenü, Weltwahl, Stadtkarte, Händler, Bibliothek, Werkstatt, Lager, Auslage, Ereignis und Tagesabschluss |

**Vorschlag für Daten:** Materialien, Rezepte, Produkteigenschaften und Ereignisdefinitionen als eigene Godot-Resources verwalten. Gebaute Exemplare erhalten stabile Kennungen; Auslagen und Spielstände verweisen darauf. Unveränderliche Definitionen und veränderlicher Spielzustand werden getrennt geführt. Godot stellt Resources als Datencontainer und für die Bearbeitung im Inspector bereit. [Godot Resources](https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html)

**Vorschlag für Geld:** Eurobestände in ganzen Cent und Fantasybestände in ganzen Pfennig führen. Die Anzeige zerlegt diese Werte in die bestätigten Untereinheiten. Produkte referenzieren Materialien und deren Einkaufswährungen; historische Einkaufsausgaben und laufende Stückkosten aus gültigen Preisen werden getrennt geführt. Die Finanzierung verteilt beide Anfangsbestände in Ladenplatzreihenfolge, sämtliche Einnahmen werden erst danach hinzugefügt. Produktwerte und Verkaufspreise bleiben je Welt eigenständig. Die technische Zahlenskala erlaubt keinen Währungstausch.

Menüs lassen sich mit Control-Nodes und Containern aufbauen. Das Speichersystem orientiert sich an Godots Dateizugriff; der erste Testbuild nutzt die Exportfunktion für das gewählte PC-System. [Godot Oberfläche](https://docs.godotengine.org/en/stable/tutorials/ui/index.html), [Spielstände](https://docs.godotengine.org/en/stable/tutorials/io/saving_games.html), [Windows Export](https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_windows.html)

## Fortschritt und nächste Arbeit

| Punkt | Stand |
| --- | --- |
| Engine und Plattformfamilie | Godot 4.7.2 Standard, Windows x86_64, GDScript, Compatibility |
| Roadmap | Mit tatsächlichem Stand von Version 0.3.0 ergänzt |
| Erster Umfang und technische Aufteilung | 18 Materialien, vier Rezepte, Bibliothek und Handelsberechnung umgesetzt |
| Meilenstein 0 | Regelgrundlage für den ersten Handelsablauf festgelegt; endgültige Balance bleibt offen |
| Meilenstein 1 Umsetzung | Grundprojekt und Windows-Testbuild 0.1.0 umgesetzt und abgenommen; Prüfstand in der Entwicklungsanleitung |
| Meilenstein 2 Regelgrundlage | Weltwahl und gemeinsamer Fähigkeits- und Rezeptstand bestätigt; Aufgaben und Abnahme konkretisiert |
| Meilenstein 2 Umsetzung | Tagesablauf, zwei Welten und Spielstände in 0.2.0 umgesetzt und abgenommen; Prüfstand in der Entwicklungsanleitung |
| Meilenstein 3 Umsetzung | Handelsablauf und Speicherformat 2 in Version 0.3.0 umgesetzt; Prüfstand in der Entwicklungsanleitung |
| Meilensteine 4 bis 7 Umsetzung | Noch nicht begonnen |

**Als Nächstes:** Den Handelsablauf mit der vorläufigen Balance spielen und anschließend Meilenstein 4 konkretisieren: erste wirksame Ereignisse, Chaos und Reaktionen der Welt. Die [Handelsregeln 0.3.0](handelsprototyp-0.3.md) sind dafür die überprüfbare Ausgangsbasis.

Kalendertermine folgen, sobald Umfang und verfügbare Arbeitszeit feststehen. Jeder Meilenstein wird anhand seines spielbaren Ergebnisses und seiner Fertig-Bedingung abgeschlossen. Nach Meilenstein 7 wird entschieden, welche zusätzlichen Handwerke, Inhalte und Gestaltungsschritte in die nächste Fassung kommen.
