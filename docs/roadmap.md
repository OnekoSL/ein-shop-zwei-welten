# Roadmap für die Umsetzung in Godot

**Stand:** 11. Oktober 2026  
**Bestätigt:** Godot als Engine, zunächst ein PC-Spiel (E-046); erster Build mit Godot 4.7.2 Standard, GDScript und Windows x86_64 (E-069).  
**Status:** Umsetzungsvorschlag. Meilenstein 0 ist in Bearbeitung; ein [Regelentwurf mit Rechenbeispielen](herstellungs-kosten-verkaufsregeln.md) und ein [Testsortiment](testsortiment-und-startbestand.md) liegen vor. Schmied, Sägewerk, Schneider mit je drei Waren und die Bibliothek gehören zum bestätigten ersten Tischlerei-Test (E-063 bis E-066). Weitere Umfangsdetails, Meilensteine und technische Aufteilung sind Vorschläge. Aufwand und Termine werden nach Eingrenzung des Umfangs geschätzt.

Das erste Ziel ist eine spielbare Fassung, in der der Spieler in beiden Welten Materialien beschafft, Produkte herstellt, Angebote vorbereitet und die wirtschaftlichen sowie gesellschaftlichen Folgen erlebt. Dafür wird zunächst eine Tischlerei umgesetzt. Das bereits ausgearbeitete Beispiel „Stuhl = Holz + Nägel“ erlaubt es, Materialwahl, Qualität, Preis, Tagesabsatz und Chaos gemeinsam zu prüfen. Danach folgen Wochenmarkt, Einzelstücke und die vollständigen Spielenden.

Die bestätigten Regeln aus [Entscheidungen](entscheidungen.md) gelten als Grundlage. Offene Regeln werden vor dem jeweils abhängigen Arbeitsschritt konkretisiert. Vorläufige Formeln und Testwerte bleiben als solche gekennzeichnet und werden erst nach Bestätigung als verbindliche Festlegungen übernommen.

## Umfang der ersten spielbaren Fassung

Die bestätigten Einkaufsorte und Bibliotheksfunktionen werden mit folgenden vorgeschlagenen Testinhalten umgesetzt:

| Bestandteil | Erster Umfang |
| --- | --- |
| Spielweise | Einzelspieler; Bedienung über Stadtkarte und Menüs |
| Welten | Unsere Welt und Fantasywelt; getrennte Tageszähler, Geldbestände, Angebote und geheime Chaoswerte |
| Handwerk | Eine Tischlerei in beiden Welten; Küchenstuhl als bekanntes Startrezept, drei weitere Rezepte als Bibliotheksangebot vorgeschlagen |
| Materialien | Je drei verschiedene Waren bei Schmied, Sägewerk und Schneider sind bestätigt; vorgeschlagen sind je Welt drei Holzarten, drei Nägelarten und drei Stoffarten gemäß Testsortiment |
| Orte | Eigener Laden, Schmied, Sägewerk, Schneider und Bibliothek; diese Orte in jeder Welt vorzusehen ist der Testvorschlag. Wochenmarkt ab Meilenstein 5 |
| Bibliothek | Werte verbessern und Rezepte kaufen; einmal lernen je Besuch zusätzlich zu Rezeptkäufen. Trainierbare Werte, Lernzuwachs, Grenzen und mögliche Kosten noch klären |
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

**Aktueller Stand:** Das [Küchenstuhlbeispiel](herstellungs-kosten-verkaufsregeln.md) bestätigt Materialverbrauch, Herstellung und Ausstellen im Ladenbesuch, Verschieben aus dem Lager in die Auslage, Vorfinanzierung in ursprünglichen Einkaufswährungen und Prototypverkauf bei fehlendem Geld (E-047 und E-049 bis E-052). Die frühere Euro-Kostenbasis aus E-048 ist ersetzt. Nachfrage- und Qualitätsformeln sowie weitere Betriebsregeln bleiben offen.

**Arbeit:**

- Das [Testsortiment und den Startzustand](testsortiment-und-startbestand.md) für die Tischlerei verwenden: drei Materialhändler mit je drei Waren, Bibliothek und Küchenstuhlrezept. Materialnamen, Preise, weitere Rezepte und Startwerte bleiben vorläufig; den endgültigen geerbten Warenbestand getrennt festlegen.
- Für die Bibliothek trainierbare Werte, Lernzuwachs, Grenzen und mögliche Kosten festlegen. Einmal lernen und zusätzlich Rezepte kaufen je Besuch ist bestätigt (E-066). Fähigkeiten und gekaufte Rezepte gelten gemeinsam in beiden Welten (E-068); den Zeitpunkt der Nutzbarkeit nach dem Kauf noch klären.
- Festlegen, wann ein Exemplar hergestellt wird, wie der Materialkauf seine Herstellung ermöglicht und was dabei verbraucht wird. Rezepte bleiben ohne Zutatenmengen.
- Rücknahme und Auslagewechsel immer über das Lager abbilden; Zugriff nur auf die Auslage des besuchten eigenen Ladens der aktiven Welt (E-057). Für dieselbe Variante in beiden Läden zwei separate Prototypen verwenden (E-058). Die Anzahl der Auslagenplätze klären.
- Die Qualität aus Materialien und Fähigkeiten beim Bau bestimmen (E-054 und E-055); spätere Fähigkeitsverbesserungen verändern bestehende Prototypen nicht. Relevante Fähigkeiten und Gewichtung klären. Qualitätsskala, Mengenbasis, Rundung, Wert- und Absatzformel an günstigen und hochwertigen Stühlen durchrechnen. Das Tageslimit folgt weiterhin Mengenbasis / Qualität.
- Laufende Stückkosten aus gültigen Materialpreisen in den ursprünglichen Einkaufswährungen berechnen (E-061). Referenzpreise bei mehreren Materialhändlern und deren Gültigkeitszeitpunkt klären. Alle Angebote aus dem gemeinsamen Anfangsbudget in Ladenplatzreihenfolge finanzieren; sämtliche Einnahmen erst danach gutschreiben (E-059 und E-062). Bei null Nachfrage bleibt der Prototyp ohne Budgetverbrauch stehen (E-060). Beide Geldbestände bleiben getrennt und direktes Tauschen ausgeschlossen.
- Ladenverkäufe ausschließlich beim Besuch des eigenen Ladens in der aktiven Welt abrechnen (E-056). An anderen Besuchstagen keine zugehörigen Produktionskosten und keinen Prototypverkauf wegen fehlender Finanzierung auslösen. Die interne Abrechnung als vorläufigen Ablauf festhalten und spätestens vor Meilenstein 4 mit Ereignisfolgen abstimmen.

**Fertig, wenn:** Eine mehrtägige Beispielsituation vom Einkauf über Herstellung und Auslage bis zur Abrechnung vollständig durchgerechnet ist. Sie umfasst beide Währungen und mindestens eine Materialbeschaffung aus der anderen Welt. Die Geldänderungen sind eindeutig; keine offene Regel verhindert die Umsetzung dieses Beispiels.

**Betroffene Fragen:** F-04, F-11, F-20, F-22, F-24, F-25, F-26, F-30, F-33 und F-37. Antworten gehören in [Handwerk und Herstellung](handwerk-und-herstellung.md), [Testsortiment und Startbestand](testsortiment-und-startbestand.md), [Handel und Währungen](handel-und-waehrungen.md) und [Offene Fragen](offene-fragen.md).

**Ergänzender Entwurf:** [Nachfrage und reagierende Konkurrenz](nachfrage-und-konkurrenz.md) beschreibt drei Kundengruppen und wenige konkurrierende Geschäfte als möglichen ersten Test. Bedarf, Budgets und Preisbewertung werden in Meilenstein 0 konkretisiert. Verzögerte Konkurrenzreaktionen, neue Waren und Chaosfolgen werden schrittweise ergänzt; ihr genauer Umfang bleibt bei F-38 offen.

### Meilenstein 1 Godot-Projekt und Export einrichten

**Stand:** Grundprojekt und Windows-Release-Testbuild 0.1.0 umgesetzt und abgenommen. Import, Export, automatische Eingabe- und Layoutprüfungen sowie Tastaturbedienung und Fensterschließen des entpackten Builds sind geprüft. Die Mausbedienung im Release-Build wurde zusätzlich vom Nutzer bestätigt. Details: [Entwicklung und Prüfstand](entwicklung.md).

**Umgesetzt:**

- Godot 4.7.2 Standard mit geprüften Windows-x64-Exportvorlagen, GDScript und Compatibility-Renderer eingerichtet.
- Projekt unter `game/` mit App, Hauptmenü, Spielansicht und gemeinsamem Theme erstellt.
- Starten, Zurück, Escape, Beenden, Tastaturfokus und skalierbare Oberfläche mit 1280 × 720 Startgröße und 960 × 540 Mindestgröße umgesetzt.
- PowerShell-7-Werkzeuge für Einrichtung und Windows-Release-Export samt ZIP, Prüfsumme und Fehlerbehandlung erstellt.
- Lokale Versionsverwaltung auf `main` eingerichtet; Quellen, Ressourcen, Werkzeuge und Dokumentation versioniert.

**Fertig, wenn:** Das Projekt im Editor startet und ein exportierter Testbuild unabhängig vom Editor geöffnet und beendet werden kann. Projektstart und Export sind kurz dokumentiert.

### Meilenstein 2 Tagesablauf und Spielzustand umsetzen

**Regelgrundlage ergänzt:** Die Weltwahl zu Rundenbeginn ist kostenlos und gilt für die gesamte Runde (E-067). Fähigkeiten und gekaufte Rezepte sind gemeinsam für beide Welten (E-068). Für diese beiden Fragen ist keine weitere Festlegung nötig. Meilenstein 2 ist damit konkretisiert; die technische Umsetzung hat noch nicht begonnen.

**Arbeit:**

- Weltwahl, Stadtkarte, genau einen Ortsbesuch, Runde beenden, Ereignis und Tagesabschluss als feste Folge umsetzen. Die kostenlose Weltwahl benötigt keinen vorherigen Ladenbesuch. Nach der Weltwahl einen weiteren Wechsel bis zum Abschluss dieser Runde ausschließen. Zunächst kann das Tagesereignis ein einfacher neutraler Text sein.
- Nur den Tageszähler der aktiven Welt fortschreiben. Die Tagesnummer des aktuellen Besuchs und der anschließende Wechsel zum nächsten Tag müssen eindeutig sein.
- Gemeinsames Lager, Geldbestände je Währung sowie einen gemeinsamen Fähigkeits- und Rezeptstand verwalten. Tageszähler, Auslagen und weitere weltbezogene Zustände separat führen. Gemeinsamer Lernfortschritt wirkt in beiden Welten, während die Zeit der inaktiven Welt pausiert. In diesem Meilenstein die Daten vorsehen; Lernen, Rezeptkäufe und vollständigen Handel in Meilenstein 3 umsetzen.
- Wiederholtes Auslösen des Tagesabschlusses verhindern; jede Tagesrunde wird genau einmal abgerechnet.
- Einen Grundspielstand nach dem Tagesabschluss speichern und laden. Neue Zustände werden in späteren Meilensteinen ergänzt.

**Fertig, wenn:** Mehrere Runden mit kostenloser Weltwahl zu Beginn durchlaufen werden können. Innerhalb einer Runde sind ein weiterer Weltwechsel und ein zweiter Ortsbesuch ausgeschlossen. Nur der Tageszähler der aktiven Welt schreitet voran; weltbezogene Zeitabläufe der inaktiven Welt pausieren. Gemeinsame Bestände, Fähigkeiten und Rezepte bleiben in beiden Welten verfügbar. Nach Speichern, Beenden und Laden stimmen Welt, Tageszähler, Geld, Lager, Auslagen, gemeinsamer Fähigkeits- und Rezeptstand sowie Tagesphase überein.

**Abnahmebeispiele:** Zwei abgeschlossene Runden in unserer Welt und eine in der Fantasywelt erhöhen deren Tageszähler um zwei beziehungsweise eins. Der Wechsel selbst kostet weder Geld noch einen zusätzlichen Tag. Ein vorbereiteter Fähigkeits- und Rezeptstand ist nach dem Weltwechsel identisch verfügbar und nach Speichern und Laden erhalten. Ein Exemplar in einer Auslage bleibt ausschließlich dort; der gemeinsame Wissensstand erlaubt keinen Zugriff auf die inaktive Auslage (E-057 und E-058).

**Verbleibende Abgrenzung:** Physischer Lagerzugang und spätere zeitabhängige Wirkungen bleiben bei F-06 und F-25 offen. Für den ersten Ablauf werden Bestandsdaten und die bestätigten Zugriffsregeln verwendet. Die genaue Verkaufs- und Ereignisberechnung folgt in Meilenstein 3 und 4; die sichtbare Tagesfolge bleibt durch E-032 vorgegeben. Speichern an abgeschlossenen Tagesgrenzen bleibt der technische Vorschlag.

### Meilenstein 3 Den vollständigen Handelsablauf spielen

**Arbeit:**

- Schmied, Sägewerk und Schneider mit je drei Waren, sichtbaren lokalen Preisen und Einkauf ins gemeinsame Lager umsetzen. Testnamen und Preise aus dem Testsortiment verwenden.
- Die Bibliothek mit einmal Lernen pro Besuch und zusätzlichen Rezeptkäufen umsetzen. Lernfortschritt und bekannte Rezepte im Spielzustand speichern; Geldkosten nach den in Meilenstein 0 festgelegten Regeln abbuchen. Der Bibliotheksbesuch löst keine eigenen Ladenverkäufe aus.
- Rezept und Materialvarianten auswählen, Produkt herstellen und das gebaute Exemplar im Lager ablegen.
- Qualität aus Materialien und aktuellem Fähigkeitsstand beim Bau bestimmen und am Exemplar speichern. Zusätzliche Verkaufsware übernimmt die Prototypqualität; späteres Lernen verändert bestehende Exemplare nicht (E-055).
- Exemplare im Lager nach Produkttyp gruppieren; ein konkretes Exemplar ausstellen, über das Lager zurücknehmen oder wechseln und seinen Preis setzen. Nur die besuchte aktive Auslage bearbeiten; zwei getrennte Prototypen für dieselbe Variante in beiden Läden verwenden.
- Nachfrage, Tageslimit und vorab finanzierbare Anzahl getrennt berechnen. Gültige Materialpreise über die Materialreferenzen des Prototyps verwenden. Alle Ladenplätze nach ihrer Reihenfolge aus dem Anfangsbudget finanzieren und erst danach sämtliche Einnahmen gutschreiben. Bei fehlender Finanzierung und positiver Nachfrage den Prototyp selbst verkaufen; bei null Nachfrage ohne Kosten stehen lassen. Wert- und Nachfrageformeln aus Meilenstein 0 umsetzen.
- Analyse zur Anzeige des Produktwerts in Goldmark und Euro einbauen. Für den Prototyp Erwerb und Anwendung ausdrücklich festlegen; Chaoswerte und gesonderter Chaoseinfluss bleiben verborgen.
- Tagesabrechnung mit Verkaufszahl und Geldänderung anzeigen. Bekannte Materialkosten und Preis bleiben für die Kalkulation zugänglich.

**Fertig, wenn:** Der Spieler Materialien kaufen, einen Stuhl bauen, aus dem Lager in die Auslage verschieben und damit Einnahmen erzielen kann. Nachfrage, Tageslimit und Geld begrenzen zusätzliche Verkäufe. Das bestätigte Küchenstuhlbeispiel ergibt 40 Euro und 240 Silber; bei gleicher Nachfrage folgen 0 Euro und 360 Silber sowie in der nächsten Runde der Prototypverkauf mit 0 Euro und 400 Silber. Alle Materialkosten werden vor den Einnahmen in ihren ursprünglichen Währungen abgezogen. Normale Verkäufe lassen den Prototyp erhalten, sein eigener Verkauf beendet das Angebot. Qualität und Preis wirken nach den festgelegten Formeln.

**Vorher klären:** Verbleibende Punkte aus F-24, F-25, F-26, F-33 und F-37. Keine Zutatenmengen, Produktionschargen oder manuelle Nachfüllpflicht ergänzen.

**Zusätzliche Abnahme für E-056 bis E-058:** Ein Händlerbesuch verursacht keine Ladenverkäufe, Produktionskosten oder Prototypverkäufe wegen fehlender Finanzierung. Ein Prototyp kann über das Lager und zwei Ladenbesuche in verschiedenen Runden die Welt wechseln. Der Zugriff auf die andere Auslage ist ausgeschlossen. Zwei separat gebaute Exemplare erlauben dieselbe Variante in beiden Läden, ohne ein Exemplar doppelt zu zählen.

**Zusätzliche Abnahme für E-059 bis E-062:** Ladenplätze bestimmen die Budgetpriorität. Ein früheres Angebot kann das Budget eines späteren verbrauchen; seine Einnahmen stehen diesem noch nicht zur Verfügung. Bei null Nachfrage bleibt ein nicht finanzierbarer Prototyp erhalten. Geänderte Materialpreise verändern die zusätzliche Produktionsmenge und Kosten, während Prototypqualität und historische Einkaufsausgaben erhalten bleiben. Die Rechenproben für zwei Angebote und teureres Eichenholz aus den Verkaufsregeln ergeben die vorgesehenen Geldbestände.

**Zusätzliche Abnahme für E-063 bis E-066:** Jeder der drei Materialhändler bietet genau drei Sorten im ersten Test. Ein Bibliotheksbesuch erlaubt einmal Lernen und zusätzlich Rezeptkäufe; ein zweites Lernen im selben Besuch ist ausgeschlossen. Der eigene Laden verkauft währenddessen nicht. Ein gekauftes Rezept wird nach den festgelegten Zugangsregeln nutzbar. Später gebaute Prototypen berücksichtigen den verbesserten Fähigkeitsstand, bestehende behalten ihre gespeicherte Qualität. Ein Polsterstuhl prüft im vorgeschlagenen Sortiment auch den Stoffeinkauf.

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
| Roadmap | Mit tatsächlichem Stand des ersten Testbuilds ergänzt |
| Erster Umfang und technische Aufteilung | Materialhändler, je drei Waren und Bibliotheksfunktionen bestätigt; Testinhalte und technische Aufteilung vorgeschlagen |
| Meilenstein 0 | In Bearbeitung; Regelentwurf und Rechenbeispiele vorhanden, weitere Festlegungen offen |
| Meilenstein 1 Umsetzung | Grundprojekt und Windows-Testbuild 0.1.0 umgesetzt und abgenommen; Prüfstand in der Entwicklungsanleitung |
| Meilenstein 2 Regelgrundlage | Weltwahl und gemeinsamer Fähigkeits- und Rezeptstand bestätigt; Aufgaben und Abnahme konkretisiert |
| Meilensteine 2 bis 7 Umsetzung | Noch nicht begonnen |

**Als Nächstes:** Nachfrageformel, Qualitätsskala, Mengenbasis und Wertformel konkretisieren. Für den bestätigten Bibliotheksumfang müssen trainierbare Werte, Lernzuwachs und Rezeptzugang festgelegt werden. Das [Testsortiment](testsortiment-und-startbestand.md) liefert vorläufige Materialien, Preise, Rezepte und Startwerte. Die bestätigte Finanzierung und der Prototypverkauf aus dem [Küchenstuhlbeispiel](herstellungs-kosten-verkaufsregeln.md) bleiben verbindliche Grundlage. Die Zahl der Auslagenplätze und die Referenzpreise bei mehreren Materialhändlern werden anschließend geklärt. Verkauf nur beim eigenen Ladenbesuch und Transfers über das Lager sind durch E-056 bis E-058 bestätigt; Ladenplatzpriorität, Erhalt bei null Nachfrage, dynamische Materialkosten und gemeinsame Vorfinanzierung durch E-059 bis E-062.

Kalendertermine folgen, sobald Umfang und verfügbare Arbeitszeit feststehen. Jeder Meilenstein wird anhand seines spielbaren Ergebnisses und seiner Fertig-Bedingung abgeschlossen. Nach Meilenstein 7 wird entschieden, welche zusätzlichen Handwerke, Inhalte und Gestaltungsschritte in die nächste Fassung kommen.
