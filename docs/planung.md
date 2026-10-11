# Planung

**Status:** Vorschlag für die nächsten Schritte; Umfang und Termine sind offen.

**Umsetzungsstand:** Godot-Grundprojekt, Tagesablauf, Spielstände und vollständiger Handelsablauf sind mit Windows-x64-Testbuild 0.3.0 umgesetzt. Einrichtung, Export und Prüfstand stehen in [Entwicklung](entwicklung.md), die bestätigte Testbalance in [Handelsregeln 0.3.0](handelsprototyp-0.3.md). Als Nächstes folgen Chaos, Reputation, Gewöhnung und Ereignisse.

Godot als Engine und PC als erste Plattformfamilie sind inzwischen bestätigt (E-046). Die [Roadmap für die Umsetzung](roadmap.md) ordnet die verbleibenden Regelentscheidungen und die technische Arbeit in prüfbare Meilensteine ein. Diese Planung beschreibt weiterhin die fachliche Klärung des Konzepts.

## Aktuelle Phase

Die Dokumentationsbasis steht. Spielerrolle, Erbschaft, die beiden Absatzwelten und die grundlegende Handelsaufgabe sind beschrieben. Jede Welt hat einen eigenen Chaoswert. Die [Ideensammlung](ideensammlung.md) führt Vorschläge und bestätigte Regeln zu Shopauswahl, magischen Startfähigkeiten, Stadtkarten, Tageszügen und funktionalen Orten zusammen. E-067 ersetzt den früheren Wechselort-Vorschlag im Shop durch die kostenlose Weltwahl zu Rundenbeginn; danach bleibt die Welt für diese Runde fest.

F-01 ist inzwischen geklärt: Der Spieler tritt das Erbe seiner Oma an, übernimmt ihr Geschäft und erhält die vorhandenen Waren als Startkapital. Im Lager findet er ihren Warnbrief vor Chaos. Danach fordern Kredithaie in unserer Welt und Halsabschneider in der Fantasywelt Omas Geld zurück. Die Forderungen sind ähnlich hoch; beide gewähren ein Jahr Zeit (E-026 bis E-028). Der bestätigte Einstieg steht in [Spielstart und Geschichte](spielstart-und-geschichte.md).

Der Tagesablauf ist durch E-032 bestätigt: Welt wählen, auf der Stadtkarte ein Gebäude auswählen, dort Tagesgeschäfte erledigen und die Runde beenden. Danach folgt ein Ereignis mit Reaktion und gegebenenfalls Entscheidung, zuletzt der Tagesabschluss. Der Tag umfasst einen Ortsbesuch. Die Beschreibung steht in [Spielablauf](spielablauf.md).

Die Regelgrundlage für Meilenstein 2 der Roadmap ist ergänzt: kostenlose Weltwahl am Rundenbeginn und feste Welt während der Runde (E-067), gemeinsamer Fähigkeits- und Rezeptstand in beiden Welten (E-068). Die Umsetzung umfasst jetzt beide Stadtkarten, den Tagesablauf und einen gespeicherten Grundzustand (E-070 bis E-074). Lernwerte, Rezeptzugang nach dem Kauf und wirtschaftliche Berechnungen werden vor den abhängigen Arbeitsschritten weiter ausgearbeitet.

Der Wochenmarkt ist als wöchentliche Gelegenheit mit exotischen Händlern und Kunden beschrieben. Der Spieler kann dort einkaufen und selbst einen Stand mieten und Waren anbieten; die Teilnahme als Verkäufer führt zu einem besonderen Ereignis.

Die aktuelle Ausrichtung des eigenen Geschäfts liegt auf Handwerksbetrieben: Tischler, Bäcker, Fleischer, Alchemie, Töpferei, Schmied, Atelier und Schneider. Rezepte nennen Materialarten ohne physische Zutatenmengen (E-035). Der gebaute Prototyp kommt ins Lager und wandert beim Ausstellen in die Auslage (E-050). Das Küchenstuhlbeispiel bestätigt Bau und Ausstellen im selben Ladenbesuch, Kosten in ursprünglichen Einkaufswährungen, deren Vorfinanzierung und den Prototypverkauf bei fehlendem Geld (E-049 bis E-052). Nachfrage, Tageslimit und finanzierbare Anzahl bestimmen zusätzliche Verkäufe. Analyse zeigt den sonst verborgenen Wert in Goldmark und Euro. Die Testformeln und Betriebsregeln der Tischlerei sind in [Handelsregeln 0.3.0](handelsprototyp-0.3.md) festgelegt und umgesetzt.

Für die spätere Ausarbeitung bleiben die genaue Berechnung und ein möglicher Rückgang der Chaoswerte, weitere Sortimente sowie der endgültige Spielstart offen. Der Tagesablauf, fünf Orte je Welt, Lernen, Beschaffung und Verkaufsberechnung sind für den Handelsprototyp umgesetzt. Weitere Ereignisauslöser und das besondere Markt-Ereignis stehen in F-27, die Standregeln in F-28.

Die räumliche Verbindung wurde konkretisiert: gleicher Grundriss in beiden Welten und ein einziges gemeinsames Lager, während die übrigen Räume getrennt sind. Einkäufe und gebaute Produkte landen dort. Der Spieler wählt ein Exemplar für die Auslage; normale Verkäufe verbrauchen es nicht (E-038 und E-039). Das magische Lager hat praktisch unbegrenzt Platz. Rücknahme und Wechsel erfolgen über das Lager; bearbeitet wird nur die Auslage des besuchten eigenen Ladens der aktiven Welt (E-057). Für dieselbe Variante in beiden Läden werden zwei separate Prototypen benötigt (E-058). Der Prototyp verwendet drei feste Auslagenplätze je Welt; physischer Lagerzugang außerhalb der Besuchsmenüs bleibt offen. Die Zeit im Lager bleibt Teil von F-06; der Marktstand Teil von F-28.

Währungen und Untereinheiten sind bestätigt: Goldmark, Silbergroschen und Pfennig sowie Euro und Cent. Ein direkter Tausch ist ausgeschlossen. Warenpreise bilden lokale Wertunterschiede ab; Pfennig und Cent dienen nur der Orientierung. Die Regeln stehen in [Handel und Währungen](handel-und-waehrungen.md); die Wirtschaftswerte und Verkaufsformeln des ersten Tests stehen in den [Handelsregeln 0.3.0](handelsprototyp-0.3.md).

Das PDF vom 8. Oktober 2026 ist mit dem vorhandenen Stand abgeglichen. Schuldenfristen und Niederlage durch zu hohes Chaos sind durch das Gespräch bestätigt und konkretisiert (E-029 und E-031). Ein Ortsbesuch und ein anschließendes Ereignis pro Tagesrunde sind inzwischen durch E-032 bestätigt. Der eigene Laden verkauft ausschließlich bei dessen Besuch in der aktiven Welt (E-056). Produktakzeptanz, Kundenerwartung, Startberufe und Weiterbildung sind als weitere Mechaniken ergänzt. Startmagie und Ladenpaar-Auswahl bleiben auszuarbeiten; siehe [PDF Abgleich](pdf-abgleich.md).

Eine Aktion ist ein Ortsbesuch mit den dort vorgesehenen Tätigkeiten (E-013, I-049). E-032 bestätigt einen solchen Besuch pro Tagesrunde.

Die Informationsregel ist geklärt und durch Gespräche ergänzt: Chaoswerte bleiben geheim. Ereignisse am Rundenende zeigen Folgen; Gespräche während eines Besuchs fremder Geschäfte können zunehmendes Misstrauen erkennen lassen (E-021). Eigenes Nachdenken und Lernen aus Fehlern, auch aus einer Niederlage ohne gesonderte Vorabwarnung, gehören zum Spielerlebnis (E-020). I-043 bleibt verworfen. Die Endbedingungen sind durch E-031 bestätigt. Konkrete Gespräche, Ereignisse, Chaosgrenzwert und Übergänge bleiben bei F-14, F-27 und F-29 offen.

Ein eigener Reputationswert und die sozialen Folgen wiederholter Dumpingpreise sind bestätigt (E-022). Die Führung, Anzeige, Berechnung, Erholung und weiteren Folgen der Reputation stehen bei F-36 aus; siehe [Reputation und Gespräche](reputation-und-gespraeche.md).

Für F-17 ist ein wichtiger Indikator bestätigt: Mit zunehmender Gewöhnung verringert sich die Preisdifferenz einer Ware zwischen den Welten (E-023). Gewöhnungsentwicklung, Vergleichsmethode und Preisänderungen bleiben bei F-17, F-26 und F-31 auszuarbeiten. Die Regel steht in [Handel und Währungen](handel-und-waehrungen.md).

Für F-16 ist der Auslöser eines Anstiegs bestätigt: Das Angebot von Risikowaren erhöht Chaos durch merkwürdige Eigenschaften oder die Entwertung anderer Waren (E-024). Ogerfleisch in unserer Welt und eine Uhr in der Fantasywelt ergänzen die Beispiele (E-025). Stärke, Mengenwirkung, Verhältnis zu tatsächlichen Verkäufen, Gewöhnung und möglicher Rückgang bleiben offen.

## Vorgeschlagene Arbeitsschritte

| Schritt | Ergebnis | Voraussetzung |
| --- | --- | --- |
| 0. Spieler-Shop berechenbar machen | Gebautes ins Lager, dauerhaftes Ausstellungsstück wählen, Preis setzen; Wert- und Absatzformel mit maximalen Tagesverkäufen und Materialkosten; Einzelstücke aus einmaligen Marktmaterialien berücksichtigen | E-038 bis E-042; F-25, F-26 und F-37; [Handwerk und Herstellung](handwerk-und-herstellung.md) |
| 1. Verbleibende Regeln klären | Handwerksauswahl und Herstellung im Tagesablauf, Startfähigkeiten und konkrete Ereignisse; Ladenverkauf nur beim eigenen Ladenbesuch ist bestätigt | F-22, F-37, F-23, F-26 und F-27; ergänzend F-20 und E-056 |
| 2. Chaoswerte und Zugang klären | Risikowarenangebote als Chaosursache geklärt; genaue Berechnung und möglicher Rückgang offen. Sortimente und Erreichbarkeit klären; Einkauf ins Lager und Bestückung geklärt. | F-13 und F-16; ergänzend F-02 und F-03 |
| 3. Spielsituation beschreiben | Eine konkrete Warenwahl und ein Verkauf mit Entscheidung, Zeitpunkt und Chaosfolgen | Schritt 2; F-04, F-14 und F-17 |
| 4. Verbindung prüfen | Gewählte Regeln und Beispiele für mögliche Konflikte | Schritt 3; F-05 bis F-07 |
| 5. Umfang eingrenzen | Kleinste spielbare Situation und bewusst vertagte Ideen | Schritte 3 und 4 |
| 6. Umsetzung vorbereiten | Anforderungen und technische Fragen aus dem geklärten Konzept | Entscheidung über den Übergang zur Umsetzung |

Für F-29 sind die Termine und vier Endtypen geklärt: Gläubiger als Ereignis an Welttag 1, Rückkehr genau 365 Tage später an Tag 366. Keine vorzeitige Tilgung; bei Nichtzahlung nehmen sie den betroffenen Laden auseinander (E-029). Zu hohes Chaos oder zwei unbezahlte Schulden führen zu Game Over. Genau eine bezahlte Schuld ergibt einen Sieg mit Verbleib in dieser Welt; beide bezahlten Schulden ergeben das gute Ende (E-031). Eine neue Aufgabe danach bleibt optional (I-069). E-032 klärt die Ereignisphase nach dem Beenden der Runde. Zusammenführung fester und allgemeiner Ereignisse, Schadensumfang, Chaosgrenzwert und Übergang bei zeitversetzten Terminen bleiben bei F-27 und F-29 auszuarbeiten; siehe [Spielenden](spielenden.md).

Für F-30 sind einfache, zum Geschäft passende Startwaren bestätigt (E-030); konkrete Sorten, Mengen, Werte und Forderungsbeträge bleiben offen. Keine laufenden Betriebskosten sind die aktuelle Entwurfsrichtung (I-067). Währungen sind geklärt. Akzeptanz, Berufe, Weiterbildung und Kundenerwartung stehen in F-31 bis F-34. F-35 zur Risikoinformation ist geklärt; die Reputationsregeln stehen bei F-36 aus.

## Vorschlag zur ersten spielbaren Prüfung aus dem PDF

I-046 beschreibt zwei Karten, ein Ladenpaar, gemeinsames Lager, getrennte Tageszähler, drei Aktionsarten aus dem PDF und ein kleines Sortiment mit sicheren und auffälligen Waren. Damit lassen sich Handel, Produktakzeptanz und Chaos prüfen. Ein Ortsbesuch pro Tagesrunde und die Ereignisfolge sind durch E-032 bestätigt. Der erste Tischlerei-Test umfasst inzwischen Schmied, Sägewerk und Schneider mit je drei Waren sowie die Bibliothek für Wertverbesserungen und Rezeptkäufe (E-063 bis E-066). Das [Testsortiment und der Startbestand](testsortiment-und-startbestand.md) schlagen konkrete Materialien, Preise, Rezepte und Anfangswerte vor. Lernwerte und Herstellungsformeln werden vor der Umsetzung festgelegt; weitere Ladenpaare und Charakterkombinationen folgen später.

## Wann der erste Konzeptstand ausreichend klar ist

- [x] Die Grundidee lässt sich in wenigen Sätzen erklären.
- [ ] Rolle, Ziel und Handlungsmöglichkeiten des Spielers sind beschrieben.
- [ ] Eine typische Spielsituation ist vollständig beschrieben.
- [ ] Der Beitrag jeder Welt zum Spielerlebnis ist verständlich.
- [ ] Die Verbindung der Welten folgt nachvollziehbaren Regeln.
- [ ] Chaosentstehung und Verlustgrenzen sind beschrieben; Auswirkungen werden gemäß E-020 und E-021 durch Ereignisse und Gespräche erfahrbar.
- [ ] Kritische offene Fragen und ihre Abhängigkeiten sind benannt.
- [ ] Der Umfang einer ersten spielbaren Prüfung ist abgegrenzt.

## Planung ohne vorzeitige Festlegung

Godot 4.7.2 Standard, GDScript, Compatibility und Windows x86_64 bilden die umgesetzte technische Grundlage. GameState, GameSession und SaveService trennen Daten, Steuerung und Speicherung; der Datenkatalog sowie Markt- und Handelsregeln ergänzen den Handelsablauf. Die [Roadmap](roadmap.md) führt die abgeschlossenen Schritte und spätere Arbeit. Budget, Termine und der vollständige spätere Funktionsumfang bleiben offen.

## Nächste konkrete Arbeit

Das bestätigte [Küchenstuhlbeispiel](herstellungs-kosten-verkaufsregeln.md) konkretisiert Materialkauf in beiden Währungen, Bau, Lager und Auslage sowie die Verkaufsabrechnung. Materialien werden beim Bau verbraucht (E-047). Zusätzliche Verkäufe brauchen vorab Geld für ihre Materialkosten in den ursprünglichen Einkaufswährungen; erst danach werden Einnahmen gutgeschrieben (E-049, ersetzt E-048). Der Prototyp wandert beim Ausstellen aus dem Lager (E-050). Bei fehlender Finanzierung wird er selbst ohne weiteren Kostenabzug verkauft; nach einer noch finanzierbaren Teilmenge bleibt er bis zu einer späteren Runde erhalten (E-051 und E-052).

Als Nächstes den Handelsprototyp spielen und Meilenstein 4 konkretisieren: Chaos, Gewöhnung, Reputation und wirksame Ereignisse. Nachfrage, Qualität, Werte, Mengenbasis, Rundung, drei Auslagenplätze und Wochenpreise sind für 0.3.0 bereits festgelegt. Die bestehende Finanzierung und der indirekte Währungstransfer durch Warenhandel bleiben Grundlage. Konkrete exotische Einzelstücke und ihre Kaufentscheidung folgen im Wochenmarkt-Schritt. Deren Materialkosten sind beim Einkauf bezahlt; beim einmaligen Verkauf wird der volle Preis gutgeschrieben (E-043 und E-044). Weitere Ideen stehen in der [Ideensammlung](ideensammlung.md).

Wenn die Chaosregeln weiter ausgearbeitet werden, F-16 und F-31 in [Offene Fragen](offene-fragen.md) beantworten. Anschließend Mobiltelefon, Heiltrank oder das Feuerzeug aus dem PDF als Beispiel verwenden: Nutzen, Preis, Ladenpassung, Akzeptanz, mögliche Verbreitung und Chaosfolgen beschreiben. Die daraus abgeleiteten Regeln bleiben zunächst Vorschläge in [Chaoswert](chaoswert.md).
