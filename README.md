# Ein Shop, zwei Welten

Spielkonzept und erster Godot-Prototyp für Windows.

**Stand:** 11. Oktober 2026  
**Status:** Godot-Grundprojekt und Windows-Testbuild 0.1.0 umgesetzt; Spielmechaniken in Planung  
**Titel:** „Ein Shop, zwei Welten“ beschreibt die Grundidee. Ein Spieltitel ist noch offen.

## Prototyp starten

Der erste Prototyp enthält Hauptmenü und Spielansicht. Die portable ZIP liegt nach dem Build unter `build/windows/EinShopZweiWelten-0.1.0-windows-x64.zip`. Vollständig entpacken und `EinShopZweiWelten.exe` starten.

Für Entwicklung und erneuten Export: [Einrichtung, Build und Prüfungen](docs/entwicklung.md). Verwendet werden Godot 4.7.2 Standard, GDScript und der Compatibility-Renderer für Windows x86_64. Engine, Importcache und Buildausgaben sind nicht Teil der Versionsverwaltung.

## Gesicherter Ausgangspunkt

- Die Grundidee ist ein Spiel mit einem Shop und zwei Welten.
- Der Spieler ist ein Isekai-Charakter und tritt das Erbe seiner Oma an. Einfache, zum Geschäft passende Waren bilden sein Startkapital (E-026 und E-030).
- Das geerbte Geschäft hat einen Laden in unserer Welt und einen in einer Fantasywelt.
- Das Geschäftskonzept richtet sich auf Handwerksbetriebe aus: Tischler, Bäcker, Fleischer, Alchemie, Töpferei, Schmied, Atelier und Schneider. Der Spieler kauft Rohstoffe und stellt daraus Produkte her (E-033). Rezepte nennen Materialarten ohne Mengenangaben, etwa Stuhl = Holz + Nägel. Die Qualität ergibt sich aus Materialien und Fähigkeiten der Spielfigur (E-054). Die Materialwahl beeinflusst außerdem den Chaoseinfluss; Qualität und Chaoseinfluss bestimmen den Produktwert. Gebautes kommt ins Lager; der Spieler wählt ein Exemplar für die Auslage, das bei normalen Verkäufen erhalten bleibt (E-038 und E-039). Das Mikromanagement soll möglichst klein bleiben.
- Der Spieler muss geeignete Waren finden und in beiden Welten verkaufen können.
- Jede Welt hat einen eigenen Chaoswert. Der Spieler soll beide Werte möglichst niedrig halten.
- Der Einfluss umfasst eine Mischung aus wirtschaftlichen Folgen, fremder Technik oder Magie und dem möglichen Bekanntwerden der anderen Welt.
- Die Idee wirkt zunächst einfach, birgt aber Potenzial und komplexe Probleme.
- Das Konzept wird weiter ausgearbeitet; das technische Grundprojekt mit Windows-Testbuild ist umgesetzt.
- Die Umsetzung erfolgt in Godot, zunächst als PC-Spiel (E-046). Die [Roadmap](docs/roadmap.md) beschreibt den vorgeschlagenen Weg zur ersten spielbaren Fassung.
- Für den ersten Tischlerei-Test liefern Schmied, Sägewerk und Schneider jeweils drei verschiedene Materialien (E-063 und E-065). Eine Bibliothek ermöglicht Wertverbesserungen und Rezeptkäufe; pro Besuch ist einmal Lernen zusätzlich zu Rezeptkäufen möglich (E-064 und E-066). [Testsortiment und Startbestand](docs/testsortiment-und-startbestand.md) enthält vorgeschlagene Materialien, Preise und Teststartwerte.
- Beim Bau werden Materialien verbraucht; für weitere Prototypen werden sie erneut gekauft (E-047). Beim Ausstellen wandert der Prototyp aus dem Lager in die Auslage (E-050). Zusätzliche Verkäufe benötigen vorab Geld für sämtliche Materialkosten in den ursprünglichen Einkaufswährungen; deren Höhe folgt den gültigen Materialpreisen (E-049 und E-061). Reicht das Produktionsbudget für kein weiteres Produkt und besteht Nachfrage, wird der Prototyp selbst ohne erneuten Materialkostenabzug verkauft und das Angebot endet (E-051). Bei null Nachfrage bleibt er stehen (E-060). Nach einer noch finanzierbaren Teilmenge bleibt er in derselben Runde erhalten (E-052). Das [Küchenstuhlbeispiel](docs/herstellungs-kosten-verkaufsregeln.md) zeigt die vollständige Abrechnung.
- Die Dokumentation wird in Markdown-Dateien geführt.
- Eine Aktion ist der Besuch eines anderen Ladens, des Wochenmarkts oder des eigenen Geschäfts. Die dort vorgesehenen Tätigkeiten gehören zu diesem Besuch (E-013).
- Ein Tageszug beginnt mit der kostenlosen Weltwahl; dafür ist kein vorheriger Ladenbesuch nötig. Danach bleibt die Welt für diese Runde fest (E-067). Es folgen Stadtkarte und ein Ortsbesuch. Der Spieler erledigt seine Tagesgeschäfte und beendet die Runde. Danach folgt ein Ereignis mit Reaktion und gegebenenfalls Entscheidung; zuletzt wird der Tagesabschluss präsentiert (E-032).
- Fähigkeiten und gekaufte Rezepte gelten gemeinsam in beiden Welten (E-068). Der Lernfortschritt zählt beim Bau neuer Prototypen auch in der anderen Welt; bestehende behalten ihre gespeicherte Qualität (E-055).
- Alle eingekauften Waren landen im gemeinsamen Lager (E-014).
- Der eigene Laden verkauft nur bei dessen Besuch in der aktiven Welt. Während eines Händlerbesuchs oder eines anderen Ortsbesuchs und in der inaktiven Welt gibt es keine Ladenverkäufe oder dafür anfallende Produktionskosten (E-056).
- Alle Angebote teilen die Geldbestände vom Beginn der Abrechnung in Ladenplatzreihenfolge. Frühe Plätze erhalten zuerst Produktionsbudget; sämtliche Einnahmen werden erst nach allen Plätzen gutgeschrieben und finanzieren keine weiteren Produkte derselben Runde (E-059 und E-062).
- Prototypen werden über das gemeinsame Lager zurückgenommen und gewechselt. Nur die Auslage des besuchten eigenen Ladens der aktiven Welt lässt sich bearbeiten. Für dieselbe Variante in beiden Läden müssen zwei separate Prototypen gebaut werden (E-057 und E-058).
- Das gemeinsame Lager hat praktisch unbegrenzt Platz. Der Spieler wählt gebaute Exemplare für seine Auslage; normale Verkäufe zusätzlicher Produkte verbrauchen diese nicht. Der Tagesabsatz hängt vom gesetzten Preis und verborgenen Produktwert ab und wird durch Tageslimit und finanzierbare Anzahl begrenzt. Das Tageslimit ist umgekehrt proportional zur Qualität: günstigere Materialien erlauben Masse, hochwertige Waren haben ein niedrigeres Limit (E-045). Materialabzüge und Verkaufsgutschriften werden je Währung getrennt geführt (E-049). Analyse zeigt den Produktwert in Goldmark und Euro. Einzelstücke entstehen aus einmaligen, exotischen Wochenmarkt-Materialien. Sie werden tatsächlich nur einmal verkauft; dabei wird der volle Verkaufspreis ohne erneuten Materialkostenabzug gutgeschrieben (E-043 und E-044). Ebenso wird ein Prototyp bei fehlender Finanzierung selbst verkauft (E-051).
- Die Fantasywelt nutzt Goldmark, Silbergroschen und Pfennig; unsere Welt nutzt Euro und Cent. Geldwerte können ausschließlich indirekt über Warenhandel zwischen den Währungen übertragen werden: in einer Währung bezahlen und in der anderen verkaufen, in beide Richtungen (E-053). Ein direkter Währungstausch und andere Transfermechanismen sind ausgeschlossen. Pfennig und Cent dienen als Größenvergleich; Warenpreise bilden den jeweiligen Wert in jeder Welt ab (E-015 bis E-017).
- Die Chaoswerte bleiben geheim. Der Spieler entdeckt Auswirkungen durch Ereignisse am Rundenende und indirekte Gesprächshinweise in fremden Geschäften. Lernen aus Fehlentscheidungen, auch aus einer Niederlage ohne gesonderte Vorabwarnung, gehört zum gewünschten Spielerlebnis (E-020 und E-021).
- Der Spieler hat einen Reputationswert. Wiederholte Dumpingpreise machen andere Händler zu Feinden und verschlechtern sein Ansehen bei ihnen (E-022).
- Die Preisdifferenz einer Ware zwischen beiden Welten ist ein wichtiger Gewöhnungsindikator: Mit zunehmender Gewöhnung wird der Unterschied kleiner (E-023).
- Das Angebot von Risikowaren erhöht Chaos, wenn Waren in der Zielwelt zu merkwürdig sind oder andere Waren wertlos machen. Ogerfleisch in unserer Welt und eine Uhr in der Fantasywelt sind weitere Beispiele (E-024 und E-025).
- Im Lager findet der Spieler Omas Warnbrief vor Chaos. Die Gläubiger erscheinen je Welt an Tag 1 und genau 365 Tage später an Tag 366 erneut. Vorzeitige Tilgung ist ausgeschlossen; beim zweiten Besuch nehmen sie das Geld oder bei Nichtzahlung den betroffenen Laden auseinander (E-027 bis E-029).
- Vier Endtypen sind bestätigt: vorzeitiges Game Over durch zu hohes Chaos, Game Over bei zwei unbezahlten Schulden, Sieg mit Verbleib in der Welt einer bezahlten Schuld und das gute Ende bei beiden bezahlten Schulden. Eine neue Aufgabe nach dem guten Ende ist optional (E-031, I-069).

## Dokumente

| Datei | Zweck |
| --- | --- |
| [Ideensammlung](docs/ideensammlung.md) | Nach Themen sortierte Ideen zu Spielstart, Fähigkeiten, Shop und Lager, Stadtkarten, Handel und Rundenende |
| [PDF Abgleich](docs/pdf-abgleich.md) | Überschneidungen, neue Überlegungen und abweichende Varianten aus dem beigefügten Spielkonzept |
| [Spielidee](docs/spielidee.md) | Grundgedanke, gewünschtes Spielerlebnis und Profil des Spiels |
| [Spielstart und Geschichte](docs/spielstart-und-geschichte.md) | Omas Erbe, Warenbestand als Startkapital, Warnbrief und Schuldenforderungen beider Welten |
| [Spielenden](docs/spielenden.md) | Die vier Endtypen, Zahlungsergebnisse beider Welten und mögliche Fortsetzung nach dem guten Ende |
| [Spielablauf](docs/spielablauf.md) | Spielerrolle, Ziele, Handlungen und wiederkehrender Ablauf |
| [Welten und Shop](docs/welten-und-shop.md) | Eigenschaften der Welten, ihre Verbindung und zentrale Regelprobleme |
| [Handel und Währungen](docs/handel-und-waehrungen.md) | Magisches Lager, direkte Bestückung beider Geschäfte, Währungsstufen und eigene Warenpreise je Welt |
| [Handwerk und Herstellung](docs/handwerk-und-herstellung.md) | Handwerksbereiche, Rohstoffkauf, Herstellung und Einbindung in Tagesablauf und Lager |
| [Testsortiment und Startbestand](docs/testsortiment-und-startbestand.md) | Drei Waren je Materialhändler, vorgeschlagene Testpreise, Bibliothek, Rezeptangebot und Teststart für die Tischlerei |
| [Herstellung und Verkauf mit Kostenrechnung](docs/herstellungs-kosten-verkaufsregeln.md) | Bestätigtes Küchenstuhlbeispiel mit gemischten Materialkosten, Vorfinanzierung, Lager und Auslage sowie Prototypverkauf |
| [Nachfrage und reagierende Konkurrenz](docs/nachfrage-und-konkurrenz.md) | Entwurf für Kundengruppen, preisabhängige Kaufentscheidungen, Anpassungen anderer Geschäfte und Marktfolgen von Chaos |
| [Chaoswert](docs/chaoswert.md) | Bedeutung des Chaoswerts, bestätigte Beispiele und offene Regeln |
| [Reputation und Gespräche](docs/reputation-und-gespraeche.md) | Indirekte Hinweise in fremden Geschäften und soziale Folgen wiederholter Dumpingpreise |
| [Offene Fragen](docs/offene-fragen.md) | Zentrale Fragen mit stabilen IDs und vorgeschlagener Reihenfolge |
| [Entscheidungen](docs/entscheidungen.md) | Bestätigte Festlegungen mit Begründung und Herkunft |
| [Planung](docs/planung.md) | Nächste Arbeitsschritte und Kriterien für einen ersten Konzeptstand |
| [Roadmap](docs/roadmap.md) | Umsetzung in Godot für PC mit vorgeschlagenem Umfang, Meilensteinen, Abhängigkeiten und Abnahmekriterien |
| [Entwicklung und Testbuild](docs/entwicklung.md) | Godot-Einrichtung, reproduzierbarer Windows-Export, Bedienung, Tests und aktueller Prüfstand |

## Umgang mit der Dokumentation

- **Bestätigt:** ausdrücklich festgelegt; die Grundlage steht im Entscheidungsprotokoll.
- **Vorschlag:** eine Möglichkeit zur Diskussion, noch keine Festlegung.
- **Offen:** benötigt eine Antwort oder eine Entscheidung.

Offene Fragen werden zentral in `docs/offene-fragen.md` geführt. Antworten werden in das zuständige Konzeptdokument übernommen. Verbindliche Festlegungen erhalten zusätzlich einen Eintrag in `docs/entscheidungen.md`.

Neue Ideen bleiben als Vorschläge erkennbar. Widersprüche werden festgehalten und geklärt, bevor abhängige Regeln weiter ausgearbeitet werden.

## Einstieg

Weitere Einfälle werden zunächst in der [Ideensammlung](docs/ideensammlung.md) eingeordnet. Die Sammlung behandelt Shopauswahl und magische Startfähigkeiten, zwei Stadtkarten, Tageszüge, Zeit nur in der aktiven Welt sowie Geschäfte, Produktionsstätten und einen Wochenmarkt. Der frühere Wechselort-Vorschlag im Shop ist durch die kostenlose Weltwahl zu Rundenbeginn ersetzt (E-067).

Die räumliche Verbindung ist weiter konkretisiert: gleicher Grundriss in beiden Welten, getrennte Räume außerhalb eines einzigen gemeinsamen Lagers für beide Geschäfte.

Auch die Orte der Stadtkarten spiegeln sich durch vergleichbare Funktionen, etwa Heiler und Hausarzt oder Krämer und kleiner Supermarkt. Die Gegenstücke stehen in der [Ideensammlung](docs/ideensammlung.md).

Die aktuelle Ausrichtung liegt auf Handwerksbetrieben mit einfachen Rezepten und wenig Mikromanagement. Produkte werden im Lager gesammelt, ein konkretes Exemplar wird für die Auslage gewählt und bleibt bei normalen Verkäufen erhalten. Preiswahl, verborgener Wert, Materialkosten und maximale Tagesverkäufe bestimmen den Erlös. Die Objektdefinitionen, Analyse und die Abrechnung der Einzelstücke stehen in [Handwerk und Herstellung](docs/handwerk-und-herstellung.md). Frühere Ladenpaare bleiben als Varianten erhalten.

Der Tagesablauf ist bestätigt: Welt wählen, Gebäude auf der Stadtkarte auswählen, dort Tagesgeschäfte erledigen, Runde beenden, Ereignis erleben und reagieren, zuletzt den Tagesabschluss ansehen. Preise ansehen, einkaufen und Gespräche gehören zum Besuch; im eigenen Laden werden Waren und Verkaufspreise vorbereitet. Verkauf in fremden Gebäuden bleibt eine Option. Der Ablauf steht in [Spielablauf](docs/spielablauf.md).

Einmal pro Woche bietet der Wochenmarkt exotische Händler und Kunden. Der Spieler kann dort einkaufen sowie einen eigenen Stand mieten und Waren anbieten. Die Teilnahme als Verkäufer führt zu einem besonderen Ereignis.

Für den aktuellen Entwurf sind keine laufenden Betriebskosten vorgesehen (Vorschlag I-067). Wareneinkäufe und die vorgesehene Miete eines eigenen Marktstands bleiben Ausgaben der gewählten Aktionen.

Das PDF ergänzt Berufe, Weiterbildung, Produktakzeptanz, Kundenerwartungen und weitere Optionen. Die Schuldenfristen sind inzwischen konkretisiert: Erster Gläubigerbesuch an Welttag 1, Rückkehr 365 Tage später an Tag 366. Die Varianten zu Startmagie, Tagesaktionen, Ereignissen und Ladenpaaren stehen im [PDF Abgleich](docs/pdf-abgleich.md); eine unveränderte Quellenkopie liegt in `docs/quellen/`.

**F-18** ist geklärt: ein Ortsbesuch pro Tag, Ereignis nach dem Beenden der Runde, Tagesabschluss zuletzt. **F-37** beschreibt einfache Rezepte und Materialverbrauch; das Küchenstuhlbeispiel bestätigt Bau und Ausstellen im selben Ladenbesuch. **F-25** umfasst das Verschieben des Prototyps aus dem Lager in die Auslage. **F-26** enthält die bestätigte Vorfinanzierung aller Materialkosten in den Einkaufswährungen sowie den Prototypverkauf bei fehlendem Geld. Nachfrage- und Wertformeln, Qualitätsskala und weitere Betriebsregeln bleiben offen. Exotische Einzelstücke und Prototypen beim eigenen Verkauf werden ohne erneuten Materialkostenabzug abgerechnet. Analyse zeigt die Werte beider Welten; Erwerb und Anwendung bei **F-24**. Weitere Fragen stehen in [Offene Fragen](docs/offene-fragen.md).
