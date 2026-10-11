# Handelsregeln des Prototyps 0.3.0

**Stand:** 11. Oktober 2026  
**Status:** Bestätigte Umsetzung von Meilenstein 3. Die Zahlen dienen der Testbalance. Chaos, Gewöhnung, Reputation und reagierende Konkurrenz folgen später.

## Besuch und Warenfluss

Jede Welt besitzt Sägewerk, Schmied, Schneider, Bibliothek und eigenen Laden. Ein Tag erlaubt einen Ortsbesuch. Nur beim Besuch des eigenen Ladens wird dessen Auslage am Tagesende abgerechnet; die andere Welt bleibt unverändert. Die 18 Materialien und Rezeptpreise aus [Testsortiment](testsortiment-und-startbestand.md) sind übernommen. Jeder Händler bietet seine drei Materialien unbegrenzt an.

Einkäufe kosten die Währung der Bezugswelt und gehen sofort ins gemeinsame Lager. Bei fehlendem Geld wird nichts abgebucht. Der Lagerbestand zählt Materialposten. Ein Bau verbraucht je einen Posten pro Rezeptgruppe; keine physischen Zutatenmengen oder Produktionschargen. Während eines Ladenbesuchs können beliebig viele Exemplare gebaut werden, solange Materialien vorhanden sind. Der Bau kostet kein zusätzliches Geld.

Jeder Laden besitzt drei feste Plätze. Ein konkretes Exemplar gelangt aus dem Lager auf einen freien Platz; der Preis wird ausdrücklich in Euro oder Silber eingegeben. Mindestens ein Cent/Pfennig, höchstens zwei Nachkommastellen, Komma und Punkt sind erlaubt. Zurücknehmen lässt den Platz leer; nichts rückt nach. Wechsel erfolgen über das Lager. Nur die aktive Auslage ist zugänglich. Ein Welttransfer braucht zwei Ladenbesuche; gleiche Varianten in beiden Läden brauchen zwei Exemplare.

## Lernen und Analyse

Ein Bibliotheksbesuch erlaubt eine kostenlose Lernaktion und zusätzliche Rezeptkäufe. Tischlern steigt von anfangs 1 um eine Stufe bis 10. Analyse wird einmalig in der Fantasybibliothek statt einer Tischlerstufe gelernt. Fähigkeiten und Rezeptwissen gelten gemeinsam. Gekaufte Rezepte sind sofort bekannt, ein zweiter Kauf ist ausgeschlossen.

Analyse ist in beiden eigenen Läden kostenlos an Exemplaren des gemeinsamen Lagers oder der aktiven Auslage anwendbar. Die gespeicherte Analysefreigabe zeigt deren Wert in Euro und Goldmark; 1 Goldmark = 100 Silber = 10.000 Pfennig. Qualität und Chaoseinfluss werden nicht als Zahlen angezeigt. Ausgaben, Lernen und Analyse werden mit dem Tagesabschluss gespeichert; Verwerfen nimmt auch diese Aktionen zurück.

## Qualität und Wert

Die drei Materialien jedes Händlers tragen in der Reihenfolge des Testsortiments Qualität 10, 20 und 30 bei. Der Materialpreis ist kein Eingang der Qualitätsformel.

`Qualität = gerundeter Durchschnitt der Materialbeiträge + 2 × (Tischlerstufe − 1)`

Der Durchschnitt wird kaufmännisch gerundet. Die Qualität wird beim Bau gespeichert und bleibt auch bei späterem Lernen unverändert. Zusätzliche Verkaufsware übernimmt diese Qualität.

| Rezept | Mengenbasis | Grundwert je Qualitätspunkt in unserer Welt | Grundwert je Qualitätspunkt in der Fantasywelt |
| --- | ---: | ---: | ---: |
| Küchenstuhl | 100 | 2 € | 1,50 S |
| Beistelltisch | 80 | 2,50 € | 2 S |
| Holztruhe | 60 | 3 € | 2,50 S |
| Polsterstuhl | 80 | 3,50 € | 3 S |

`Tageslimit = max(1, abrunden(Mengenbasis / max(1, Qualität)))`

Der innere Mindestwert erhält die Berechenbarkeit älterer Testexemplare mit Qualität null. Neue Bauten haben positive Qualität.

`Wert je Welt = Qualität × örtlicher Grundwert + Materialaufschläge`

Reale Materialien erhalten in der Fantasywelt je Materialstufe 5/10/15 S Aufschlag. Fantasy-Materialien erhalten in unserer Welt 0/10/20 € Aufschlag. Im Ursprungsland entfällt der Aufschlag. Diese festen Unterschiede sind die vorläufige Grundlage für spätere Chaos- und Gewöhnungswirkungen, noch keine Chaossimulation.

Eiche und magische Nägel bei Tischlerstufe 1 ergeben Qualität 20, Küchenstuhl-Limit 5 und Werte von 50 € beziehungsweise 40 S. Beide Werte werden getrennt berechnet; es gibt keinen direkten Währungstausch.

## Nachfrage

| Kategorie | Interessenten Unter-/Mittel-/Oberschicht | Budgets € | Budgets S |
| --- | --- | --- | --- |
| Stühle einschließlich Polsterstuhl | 12 / 12 / 8 | 25 / 60 / 160 | 20 / 50 / 120 |
| Tische | 8 / 8 / 4 | 30 / 80 / 200 | 25 / 70 / 160 |
| Truhen | 6 / 6 / 4 | 40 / 100 / 240 | 30 / 90 / 200 |

Alltagsmöbel und Feine Möbel bieten je Welt lokale Küchenstühle, Beistelltische und Holztruhen an. Der Alltagsanbieter hat Qualität 10 und verlangt den Produktwert. Der Premiumanbieter hat Qualität 30 und verlangt vier Drittel seines Produktwerts. Sortiment und Verkaufspreise sind fest.

Für jede Gruppe und Kategorie werden Angebote oberhalb ihres Budgets ausgeschlossen. Der Grundwert der Attraktivität lautet `max(0, 2 × bewerteter Warenwert / Preis − 1)`. Die Unterschicht quadriert diese Attraktivität. Die Mittelschicht verwendet sie unverändert. Die Oberschicht multipliziert zuvor den Warenwert mit `Qualität / 20`.

Die Käufer verteilen sich proportional auf Nichtkauf (Gewicht 1), Alltagsanbieter, Premiumanbieter und Spielerladen. Der Spielerladen zählt mit seinem besten passenden Angebot. Seine gewonnenen Käufer verteilen sich anschließend proportional auf seine Angebote. Dadurch erzeugen identische zusätzliche Angebote keine neuen Interessenten, können aber ihre eigenen Produktionslimits nutzen.

Zunächst werden ganze Käufer abgerundet; verbleibende Käufer gehen an die größten Nachkommareste. Bei Gleichstand gilt Nichtkauf, Alltagsanbieter, Premiumanbieter, Spielerladen; innerhalb des Spielerladens die gespeicherte Erstellreihenfolge. Ladenpositionen beeinflussen nur die Finanzierung. Nicht erfüllte Käufe entfallen ohne Umverteilung oder Übertrag in den nächsten Tag. Es gibt keinen Zufall.

| Preis des Beispielstuhls in der Fantasywelt | Nachfrage |
| --- | ---: |
| 25 S | 10 |
| 40 S | 6 |
| 60 S | 1 |
| 80 S | 0 |

Vorher sieht der Spieler Preis, laufende Materialkosten und Tageslimit. Nachfrage und tatsächlicher Absatz erscheinen erst im Tagesabschluss.

## Materialpreise und Abrechnung

Bis einschließlich Welttag 7 gelten die Anfangspreise. Bei der Wahl einer Welt ab Tag 8 wird deren Preiswoche aktualisiert. Jeder Schritt dauert sieben aktive Welttage; die andere Welt behält ihre zuletzt veröffentlichten Preise. Während des Tages bleiben alle Preise fest.

| Händler | Ab Tag 8 | Ab Tag 15 | Ab Tag 22 |
| --- | ---: | ---: | ---: |
| Sägewerk | 110 % | 90 % | 100 % |
| Schmied | 90 % | 100 % | 110 % |
| Schneider | 100 % | 110 % | 90 % |

Ab Tag 29 wiederholt sich der Dreierschritt. Faktoren beziehen sich auf den Anfangspreis; Beträge werden auf ganze Cent/Pfennig gerundet. Produktionskosten folgen diesen aktuellen Quellenpreisen in ihren ursprünglichen Währungen. Bereits bezahlte Einkäufe und bestehende Qualität werden nicht rückwirkend verändert.

Die Nachfrage D wird vor Tageslimit L und Finanzierung A bestimmt. Plätze 1 bis 3 teilen das Geld zu Beginn der Abrechnung. `A` ist das kleinste abgerundete Verhältnis von verbleibendem Geld zu positiven Stückkosten über beide Währungen. Zusätzliche Verkäufe sind `min(D, L, A)`. Kosten aller Plätze werden zuerst abgezogen; alle Einnahmen, auch aus Prototypverkäufen, werden danach gutgeschrieben.

Bei D > 0 und A = 0 wird der Prototyp selbst zum gesetzten Preis verkauft, ohne weitere Kosten. Er verschwindet aus Besitz und Auslage. Nach einer noch finanzierbaren Teilmenge bleibt er in derselben Runde erhalten; bei D = 0 bleibt er immer erhalten. Normale Verkäufe verbrauchen keine Lagerposten.

Das [Küchenstuhlbeispiel](herstellungs-kosten-verkaufsregeln.md) führt damit zu 40 € / 240 S, anschließend 0 € / 360 S und beim späteren Prototypverkauf zu 0 € / 400 S. Bei zwei Angeboten und anfangs je 20 Euro und Silber verkauft Platz 1 zwei zusätzliche Stücke, Platz 2 seinen Prototyp: Endbestand 0 € / 120 S. Bei null Nachfrage auf Platz 2 bleibt dieser erhalten und der Endbestand beträgt 0 € / 80 S.

## Tagesgrenze und technische Zuständigkeiten

Der Datenkatalog führt stabile Material- und Rezept-IDs, Herkunftswährung und sämtliche Testparameter. TradeRules berechnet Qualität, Wert, Limit und Abrechnung; MarketRules berechnet die Nachfrage. Beide sind unabhängig von Oberflächen. GameSession validiert die Besuchsaktionen. GameState enthält die Daten, SaveService die Speicherung. Ansichten erhalten Kopien und senden Aktionswünsche.

Runde beenden sperrt die Besuchsaktionen. Nach dem neutralen Ereignis wird ein vollständiger nächster Zustand vorbereitet. Erst erfolgreiches Speichern übernimmt Verkäufe und Welttag. Bei Fehlern bleibt derselbe vorbereitete Abschluss für einen erneuten Versuch erhalten. Verwerfen lädt beim Fortsetzen die letzte Tagesgrenze.

Format 2 ergänzt feste Auslagenplätze, Preisstände und Preisperioden, Erstellreihenfolge und ID-Zähler, Analysefreigaben und Handelsbericht. Format 1 wird beim Lesen im Speicher migriert. Bestehende Qualität und Bestände werden nicht neu berechnet. Erst ein erfolgreicher Schreibvorgang ersetzt die alte Datei und sichert sie zuvor. Unbekannte Inhalte, überzählige alte Auslagenplätze oder beschädigte Daten werden verständlich abgewiesen und nicht gelöscht.

Der letzte Bericht enthält Geld zu Tagesbeginn und -ende, Einkaufs- und Rezeptausgaben sowie je Platz D/L/A, zusätzliche Verkäufe, Prototypverkauf, Kosten und Erlös. Testverfahren und tatsächlicher Prüfstand stehen in [Entwicklung](entwicklung.md).
