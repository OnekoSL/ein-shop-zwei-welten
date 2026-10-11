# Herstellung und Verkauf mit Kostenrechnung

**Stand:** 11. Oktober 2026  
**Status:** Die bestätigten Regeln sind in Version 0.3.0 umgesetzt. Konkrete Nachfrage-, Qualitäts- und Wertformeln sowie Preisperioden stehen in den [Handelsregeln 0.3.0](handelsprototyp-0.3.md). Dieses Dokument erläutert die grundlegende Abrechnung und ihre Beispiele. E-048 zur eigenen Euro-Kostenbasis ist durch E-049 ersetzt.

Der Spieler kauft Materialien und baut daraus einen Prototyp. Dieser kommt zunächst ins gemeinsame Lager und wird anschließend in die Auslage gestellt. Er ermöglicht den Verkauf zusätzlicher, rechnerisch produzierter Waren. Vor diesen Verkäufen müssen die Materialkosten in allen benötigten Währungen bezahlt werden können. Reicht das verbliebene Produktionsbudget für kein weiteres Exemplar, wird der Prototyp bei positiver Nachfrage selbst wie ein Einzelstück verkauft. Bei null Nachfrage bleibt er stehen.

## Materialkauf und Bau des Prototyps

Jeder Einkauf bezahlt das gewählte Material in der Währung des besuchten Händlers. Das Material kommt ins gemeinsame Lager. Beim Bau werden die verwendeten Materialposten verbraucht; der fertige Prototyp ersetzt sie im Lager. Eine zusätzliche Zahlung beim Bau erfolgt nicht, weil diese Materialien bereits bezahlt sind.

Das bestätigte Beispiel verwendet das Rezept **Küchenstuhl = Eichenholz + magische Nägel**:

- Einmal Eichenholz für 10 Euro kaufen.
- Einmal magische Nägel für 10 Silber kaufen.
- Beide Materialposten für einen Küchenstuhlprototyp verbrauchen.

Die Angaben 1× bezeichnen verfügbare Materialposten und gebaute Exemplare. Kilogramm, einzelne Nägel, Chargengrößen oder Zutatenmengen innerhalb eines Postens müssen nicht verwaltet werden. Für den Bau eines weiteren Prototyps müssen die erforderlichen Materialien erneut gekauft werden (E-047).

Im eigenen Laden kann der Spieler den gerade gebauten Prototyp noch während desselben Besuchs ausstellen. Das Beispiel bestätigt damit Herstellung und anschließende Vorbereitung des Verkaufs innerhalb eines Ladenbesuchs. Weitere Herstellungsbeschränkungen sind nicht festgelegt.

## Produktqualität

**Bestätigt durch E-054:** Die Qualität entsteht aus den verwendeten Materialien und den Fähigkeiten der Spielfigur. Version 0.3.0 verwendet den kaufmännisch gerundeten Durchschnitt der Materialbeiträge plus zwei Punkte je Tischlerstufe über Stufe 1. Die Qualität wird beim Bau festgeschrieben.

Die resultierende Qualität beeinflusst den Wert und die Tagesverkaufsgrenze gemäß E-041 und E-045. **E-055 bestätigt:** Bestehende Prototypen behalten bei späteren Fähigkeitsverbesserungen ihre beim Bau bestimmte Qualität. Zusätzliche Verkaufsware folgt weiterhin der Qualität dieses Prototyps. Für ein Angebot mit der durch verbesserte Fähigkeiten erreichbaren Qualität muss ein neuer Prototyp gebaut werden; dafür sind wie bisher erneut Materialien erforderlich.

Die Beispielgrenze von fünf Stühlen bleibt ein vorgegebener Rechenwert und legt weder Materialien noch Fähigkeiten auf bestimmte Qualitätszahlen fest.

## Lager und Auslage

Beim Ausstellen wird der Prototyp **aus dem Lager in die Auslage verschoben**. Er bleibt im Besitz, belegt aber keinen Lagerbestand mehr. Ein Exemplar wird nicht gleichzeitig im Lager und in der Auslage gezählt (E-050).

Für das Küchenstuhlbeispiel gilt nach dem Ausstellen:

| Ort | Bestand |
| --- | --- |
| Gemeinsames Lager | Leer |
| Auslage des besuchten eigenen Ladens | Ein Küchenstuhlprototyp |

Die normale Tagesproduktion verbraucht oder vervielfacht den Prototyp nicht. Produzierte Verkaufsware wird rechnerisch abgerechnet; ein manuelles Nachfüllen aus dem Lager entfällt. Solange mindestens ein zusätzlicher Stuhl finanziert und verkauft werden kann, bleibt der Prototyp ausgestellt.

Wenn der Prototyp selbst verkauft wird, verschwindet er aus dem Besitz und der Auslage. Das zugehörige Angebot endet. Für ein erneutes Angebot braucht der Spieler wieder einen passenden Prototyp (E-051).

**Rücknahme und Wechsel sind bestätigt (E-057):** Ein Prototyp wird aus der Auslage zurück ins gemeinsame Lager gelegt. Von dort kann ein anderes Exemplar in die Auslage gestellt werden. Solche Verschiebungen sind innerhalb des eigenen Ladenbesuchs beliebig möglich; ein Exemplar steht dabei immer an genau einem Ort.

Der Spieler kann nur die Auslage des besuchten eigenen Ladens in der aktiven Welt bearbeiten. Ein Transfer aus dem Fantasygeschäft ins reale Geschäft erfolgt deshalb über zwei Ladenbesuche:

1. Im Fantasygeschäft den Prototyp aus der Auslage ins gemeinsame Lager zurücknehmen.
2. In einer späteren Runde das reale Geschäft besuchen und denselben Prototyp aus dem Lager dort ausstellen.

Ein in der Fantasy-Auslage verbliebener Prototyp kann beim Besuch des realen Ladens nicht entnommen werden. Ein direkter Wechsel zwischen beiden Auslagen in derselben Runde ist ausgeschlossen.

**Gleiche Variante, getrennte Exemplare (E-058):** Soll beispielsweise der Küchenstuhl aus Eichenholz und magischen Nägeln in beiden Geschäften angeboten werden, müssen zwei Prototypen gebaut werden. Jeder Bau verbraucht seine eigenen Materialposten. Dasselbe Exemplar kann nicht gleichzeitig in beiden Auslagen stehen.

Version 0.3.0 hat drei feste Auslagenplätze je Laden. Rücknahme und Ausstellen erfolgen beim Besuch des jeweiligen eigenen Ladens über das gemeinsame Lager.

## Ladenverkauf nur beim eigenen Ladenbesuch

**Bestätigt durch E-056:** Nur der besuchte eigene Laden in der aktiven Welt verkauft am Ende dieser Runde. Während eines Händlerbesuchs oder eines anderen Ortsbesuchs verkauft der eigene Laden nicht; der Laden der inaktiven Welt verkauft ebenfalls nicht.

Ohne Ladenverkauf findet dessen Produktions- und Verkaufsabrechnung nicht statt: keine Materialkosten für zusätzliche Waren, keine Ladenverkaufseinnahmen und kein Prototypverkauf wegen fehlender Finanzierung. Der Spieler kann daher Materialien bei einem Händler einkaufen, während seine ausgestellten Prototypen erhalten bleiben. Verkäufe an einem eigenen Wochenmarktstand sind gesondert geregelt.

## Materialkosten in mehreren Währungen

Die laufenden Materialkosten eines zusätzlichen Produkts ergeben sich aus den jeweils gültigen Preisen der verwendeten Materialien (E-061). Die ursprünglichen Einkaufswährungen bleiben getrennt. Bei unveränderten Preisen benötigt der Küchenstuhl aus dem Beispiel je zusätzlichem Verkauf:

**10 Euro und 10 Silber**

Auch bei einem Verkaufspreis in Silber werden die Eurokosten weiterhin vom Eurobestand bezahlt. Verkaufserlöse in Silber ersetzen kein fehlendes Eurobudget. Es gibt weder eine gemeinsame umgerechnete Kostensumme noch einen direkten Währungstausch (E-016 und E-049).

Die Kosten für den ersten Materialkauf bezahlen den Prototyp. Jeder spätere Materialkostenabzug bezahlt neu produzierte Verkaufsware. Der Prototyp wurde bereits bezahlt und verursacht bei seinem eigenen Verkauf keinen erneuten Materialkostenabzug.

**Vorschlag zur technischen Abbildung:** Am Prototyp die verwendeten Materialien und deren Bezugswelt beziehungsweise Einkaufswährung referenzieren. Für die laufende Produktion die gültigen Materialpreise abrufen und getrennt in Cent und Pfennig summieren. Die bereits bezahlten Einkaufsausgaben bleiben als historische Kosten erhalten; sie sind keine unveränderlichen Stückkosten für spätere Verkäufe.

**Umgesetzt in 0.3.0:** Jedes Material hat eine eindeutige Preisquelle in seiner Bezugswelt. Bei der Weltwahl werden die Preise der aktiven Welt anhand ihres nächsten Welttags aktualisiert; die inaktive Welt behält ihre zuletzt gültigen Preise. Einkauf und Abrechnung verwenden diese Preise während des gesamten Tages. Die Wochenfaktoren sind in den [Handelsregeln](handelsprototyp-0.3.md) festgelegt. Der Prototyp muss bei Preisänderungen nicht neu gebaut werden; seine Qualität bleibt erhalten.

**Rechenprobe mit geänderten Preisen:** Steigt Eichenholz von 10 auf 15 Euro, während magische Nägel weiterhin 10 Silber kosten, kostet jeder zusätzliche Stuhl nun 15 Euro und 10 Silber. Mit 40 Euro und 240 Silber sind bei Nachfrage sechs und Limit fünf nur zwei zusätzliche Stühle finanzierbar. Nach 30 Euro und 20 Silber Materialkosten sowie 80 Silber Einnahmen bleiben **10 Euro und 300 Silber**; der Prototyp bleibt ausgestellt. Der frühere Einkauf des Prototyps wird nicht erneut belastet.

## Indirekter Transfer zwischen den Währungen

**Warenhandel ist die einzige Möglichkeit, Geldwerte zwischen Euro und Fantasywährung zu übertragen (E-053).** Im Küchenstuhlbeispiel ermöglichen Euroausgaben für Holz einen späteren Verkauf gegen Silber. Umgekehrt können Ausgaben in Fantasywährung über passende Warenverkäufe Euroeinnahmen erzeugen.

Für die fünf zusätzlichen Küchenstühle werden 50 Euro und 50 Silber abgezogen; anschließend werden 200 Silber gutgeschrieben. Der Nettoeffekt dieses Verkaufsdurchlaufs ist **−50 Euro und +150 Silber**. Es gibt keinen festen Umtauschkurs und keine weitere Transferaktion. Warenkosten, Preis, Nachfrage, Tageslimit und vorhandenes Produktionsgeld bestimmen den erreichbaren Gegenwert.

Die Geldbestände bleiben getrennt. Bereits vorhandenes Silber kann fehlende Eurokosten nicht direkt decken; dafür muss der Spieler zunächst wieder Euro durch Warenhandel erwirtschaften.

## Nachfrage Tageslimit und Finanzierung

Zunächst wird ermittelt, wie viele Produkte zum gesetzten Preis verkauft werden könnten. Das ist die **Nachfrage D**, noch ohne Begrenzung durch Produktlimit oder verfügbares Geld. Danach greifen zwei Grenzen:

- **Tageslimit L:** Maximale Verkaufszahl des Produkts. Im Beispiel fünf Küchenstühle.
- **Finanzierbare Anzahl A:** Zahl der Produkte, deren sämtliche Materialkosten vor den Verkaufseinnahmen bezahlt werden können.

Für positive Kosten je Stück gilt:

**Finanzierbare Anzahl in Euro = abrunden(Eurobestand / Eurokosten je Stück)**

**Finanzierbare Anzahl in Fantasywährung = abrunden(Fantasybestand / Fantasykosten je Stück)**

**A = kleinste finanzierbare Anzahl aller benötigten Währungen**

Bei mehreren Angeboten bezeichnet der Geldbestand in dieser Rechnung das für den jeweiligen Ladenplatz noch verfügbare Budget: Anfangsbestand minus bereits zugewiesene Produktionskosten früherer Plätze. Einnahmen sind darin noch nicht enthalten (E-059 und E-062). Die Stückkosten entsprechen den für diesen Abrechnungslauf gültigen Materialpreisen.

Eine Währung ohne Materialkosten für dieses Produkt begrenzt die Finanzierung nicht. Für die Berechnung werden Geld und Kosten in ganzen Cent beziehungsweise Pfennig geführt. Im Beispiel steht S für Silber beziehungsweise Silbergroschen; 100 Pfennig sind 1 S und 100 S sind 1 Goldmark.

Wenn mindestens ein Produkt finanzierbar ist und Nachfrage besteht:

**Normale Verkäufe n = min(D, L, A)**

Damit können bei Nachfrage sechs, Tageslimit fünf und Finanzierung neun nur fünf Küchenstühle verkauft werden. Bei Finanzierung vier bleiben es vier, auch wenn Nachfrage und Tageslimit höher sind.

Die Nachfrage wird unabhängig vom Tageslimit ermittelt. Die bisher vorgeschlagene Formel, die bereits mit dem Tageslimit multiplizierte, wird für diesen Ablauf nicht weiterverwendet: Sie konnte keine sechs nachgefragten Stühle bei einem Limit von fünf darstellen. Eine passende Nachfrageformel wird bei F-26 ausgearbeitet. Die umgekehrt zur Qualität proportionale Tagesgrenze aus E-045 bleibt bestehen; fünf ist der Wert dieses Beispiels, keine Grenze für alle Produkte.

## Kosten zuerst und Einnahmen danach

Für die berechnete normale Verkaufszahl n gilt:

1. Die Anzahl anhand von Nachfrage, Tageslimit und vorhandenen Geldbeständen festlegen.
2. Sämtliche Materialkosten für diese Anzahl in ihren jeweiligen Währungen abziehen.
3. `n × Verkaufspreis` in der Verkaufswährung vormerken und erst nach der Finanzierung sämtlicher Ladenplätze gutschreiben.

Die Einnahmen dieses Verkaufsdurchlaufs finanzieren keine zusätzlichen Produkte innerhalb desselben Durchlaufs. Das gilt auch zwischen Ladenplätzen: Alle Kosten werden aus dem Anfangsbudget zugewiesen, sämtliche Einnahmen erst danach gutgeschrieben (E-062). Es wird nicht nach jedem verkauften Stuhl erneut berechnet, ob nun ein weiterer finanzierbar wäre. Konten werden durch die Materialabrechnung nicht negativ.

Für jede Währung w wird die Geldänderung getrennt berechnet:

**Neuer Geldbestand w = bisheriger Geldbestand w − n × Materialkosten w + Verkaufsgutschrift w**

Die Verkaufsgutschrift ist nur in der Verkaufswährung ungleich null. So entstehen im Küchenstuhlbeispiel bei fünf Verkäufen Eurokosten von 50 Euro, Silberkosten von 50 S und anschließend Einnahmen von 200 S.

Die ältere Formel `Verkäufe × (Preis − Materialkosten)` lässt sich bei einer gemeinsamen Währung weiterhin verwenden. Bei gemischten Währungen werden Geldänderungen getrennt ausgewiesen; Euro und Silber werden nicht zu einem Tageserlösbetrag verrechnet. Die Tagesübersicht kann Kostenabzug, Zwischenstände und Verkaufsgutschrift zeigen.

## Mehrere Angebote nach Ladenplätzen abrechnen

**Bestätigt durch E-059 und E-062:** Die Ladenplätze bestimmen die Reihenfolge. Platz 1 wird vor Platz 2, Platz 2 vor Platz 3 berücksichtigt; leere Plätze werden übersprungen. Der Spieler kann durch Verschieben über das Lager die Belegung und damit die Priorität seiner Angebote verändern.

1. Die Geldbestände vom Beginn der Ladenabrechnung als gemeinsames Produktionsbudget übernehmen.
2. Die Angebote in Ladenplatzreihenfolge prüfen. Bei null Nachfrage bleibt das Exemplar stehen; der Platz verbraucht kein Budget.
3. Bei positiver Nachfrage die zusätzliche Verkaufszahl aus Nachfrage, Tageslimit und verbliebenem Budget bestimmen. Deren Materialkosten abziehen; die Einnahmen zunächst sammeln.
4. Ist kein zusätzliches Produkt finanzierbar, den Prototyp bei positiver Nachfrage selbst verkaufen und entfernen. Keine Materialkosten abziehen; auch diese Einnahme zunächst sammeln.
5. Erst nach allen Plätzen sämtliche Verkaufsgutschriften in ihren jeweiligen Währungen hinzufügen.

Ein Prototyp, der nach einer noch finanzierbaren positiven Verkaufsmenge stehen bleibt, wird später in demselben Durchlauf nicht nochmals geprüft oder verkauft (E-052). Die Geldänderung je Währung ist Anfangsbestand minus sämtliche Produktionskosten plus sämtliche Verkaufsgutschriften.

**Rechenprobe:** Vor der Abrechnung stehen zwei bereits bezahlte Prototypen für zwei unterschiedliche Angebote auf Platz 1 und 2. Das verfügbare Geld beträgt 20 Euro und 20 Silber. Für beide Angebote werden Nachfrage sechs, Tageslimit fünf, Stückkosten von 10 Euro und 10 Silber und ein Verkaufspreis von 40 Silber als Testwerte verwendet.

| Platz | Ergebnis | Materialkosten | Später gutzuschreiben |
| --- | --- | --- | --- |
| 1 | Zwei zusätzliche Produkte; Prototyp bleibt | 20 Euro und 20 Silber | 80 Silber |
| 2 | Kein Produktionsbudget mehr; bei positiver Nachfrage Prototyp verkaufen | Keine | 40 Silber |

Nach beiden Plätzen werden insgesamt 120 Silber gutgeschrieben. Endbestand: **0 Euro und 120 Silber**. Die 80 Silber von Platz 1 stehen Platz 2 nicht zur Finanzierung zur Verfügung. Bei null Nachfrage auf Platz 2 bliebe dessen Prototyp stehen und der Endbestand wäre stattdessen **0 Euro und 80 Silber**.

## Verkauf des Prototyps bei fehlendem Geld

Wenn beim Prüfen des Ladenplatzes das verbliebene Produktionsbudget nicht einmal für die Materialkosten eines zusätzlichen Produkts reicht und positive Nachfrage besteht, wird der ausgestellte Prototyp selbst verkauft (E-051, E-059 und E-060). Das gilt nur beim eigenen Ladenbesuch. Im Küchenstuhlbeispiel bedeutet das:

- Keine zusätzliche Produktion und kein Materialkostenabzug.
- Einmalig den gesetzten Preis von 40 S gutschreiben.
- Den Prototyp aus dem Besitz und der Auslage entfernen.
- Das Küchenstuhlangebot beenden.

Dieser Vorgang wird wie der Verkauf eines bereits bezahlten Einzelstücks abgerechnet. Er macht ein gewöhnliches Produkt nicht schon beim Bau zu einem exotischen Einzelstück; der Anlass ist das fehlende Geld für die zusätzliche Produktion.

**Bestätigte Fallunterscheidung:** Sind beispielsweise vier Stühle finanzierbar, werden diese vier verkauft und der Prototyp bleibt in dieser Runde erhalten. Auch wenn der anschließende Geldstand für keinen weiteren Stuhl reicht, wird der Prototyp erst in einer späteren Runde bei positiver Nachfrage verkauft, wenn beim Prüfen seines Ladenplatzes kein zusätzlicher Stuhl mehr finanzierbar ist (E-052, E-060 und E-062).

**Null Nachfrage, E-060:** Auch bei fehlendem Geld bleibt der Prototyp stehen, wenn niemand kaufen möchte. Für dieses Angebot gibt es keine Produktion, keinen Materialkostenabzug und keine Einnahmen. Die bestätigten Küchenstuhlbeispiele und die folgenden Finanzierungsproben setzen positive Nachfrage voraus.

## Bestätigtes Küchenstuhlbeispiel

Ausgangspunkt: **100 Euro und 100 S**, Lager leer. Die Runden sind die aufeinanderfolgenden Spielerzüge; Tageszähler beider Welten werden weiterhin getrennt geführt. Der Startbetrag und das leere Lager beschreiben diese Rechenprobe und ersetzen nicht den noch offenen geerbten Startbestand.

| Schritt | Handlung | Eurobestand | Silberbestand | Lager | Auslage |
| --- | --- | --- | --- | --- | --- |
| Anfang | Noch keine Einkäufe | 100 € | 100 S | Leer | Leer |
| Runde 1 | Einmal Eichenholz für 10 € kaufen | 90 € | 100 S | Einmal Eichenholz | Leer |
| Runde 2 | Einmal magische Nägel für 10 S kaufen | 90 € | 90 S | Eichenholz und magische Nägel | Leer |
| Runde 3 Bau | Beide Materialien für den Küchenstuhlprototyp verbrauchen | 90 € | 90 S | Ein Küchenstuhlprototyp | Leer |
| Runde 3 Ausstellen | Prototyp aus dem Lager in den Laden stellen; Preis 40 S, Tageslimit fünf | 90 € | 90 S | Leer | Ein Küchenstuhlprototyp |
| Runde 3 Kosten | Nachfrage sechs, Limit fünf, Finanzierung neun; Kosten für fünf Stühle bezahlen | 40 € | 40 S | Leer | Ein Küchenstuhlprototyp |
| Runde 3 Einnahmen | Fünf Verkäufe zu je 40 S gutschreiben | **40 €** | **240 S** | **Leer** | **Ein Küchenstuhlprototyp** |

Die Finanzierung vor den Einnahmen beträgt `min(90 / 10, 90 / 10) = 9`. Die tatsächliche Verkaufszahl ist `min(6, 5, 9) = 5`. Die Bestände nach dem Kostenabzug sind 40 Euro und 40 S; danach steigt nur die Silberkasse durch die Gutschrift von 200 S.

### Fortsetzung bei gleicher Nachfrage und gleichem Preis

Die Fortsetzung setzt voraus, dass der Spieler in jeder dieser Runden den eigenen Laden der Verkaufswelt besucht, das Angebot bestehen bleibt und Ereignisse keine zusätzlichen Geldänderungen verursachen.

| Runde | Geld vor der Abrechnung | Finanzierbare Anzahl | Normale Verkäufe | Materialabzug | Verkaufsgutschrift | Geld danach | Prototyp |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 4 | 40 € und 240 S | Vier | Vier | 40 € und 40 S | 160 S | **0 € und 360 S** | Bleibt ausgestellt |
| 5 | 0 € und 360 S | Null | Keine | Kein Abzug | 40 S für den Prototyp | **0 € und 400 S** | Verkauft; Angebot endet |

Runde 4 verwendet den Eurobestand vollständig. Das Silberbudget würde mehr Produktion erlauben, kann aber den fehlenden Eurobestand nicht ersetzen. Deshalb greift in Runde 5 der Prototypverkauf.

### Weitere Finanzierungsfälle

Für dieselben Stückkosten, denselben Preis, Nachfrage sechs und Limit fünf:

| Geld vor der Abrechnung | Normale Verkäufe | Ergebnis |
| --- | --- | --- |
| 90 € und 25 S | Zwei | Nach 20 € und 20 S Kosten sowie 80 S Einnahmen: 70 € und 85 S; Prototyp bleibt |
| 10 € und 10 S | Einer | Nach beiden Kostenabzügen und 40 S Einnahmen: 0 € und 40 S; Prototyp bleibt in dieser Runde |
| 9 € und 90 S | Keine | Prototyp für 40 S verkaufen, ohne Kostenabzug: 9 € und 130 S; Angebot endet |

## Einzelstücke und offene Regeln

Exotische Einzelstücke aus einmaligen Wochenmarkt-Materialien bleiben von vornherein auf einen tatsächlichen Verkauf begrenzt (E-043 und E-044). Ihr voller Preis wird ohne erneuten Materialkostenabzug gutgeschrieben. Für sie wird keine zusätzliche Serienware produziert. Der Prototypverkauf bei fehlender Finanzierung verwendet denselben Zahlungsweg.

Die ursprünglichen Vorschläge mit lokalen Kostenpauschalen, alleiniger Begrenzung von Verlustangeboten und sofortiger Verrechnung des Erlöses gelten nicht mehr. Die neue Kosten- und Finanzierungsregel gilt bei jeder Preiswahl, auch wenn ein Verkauf wirtschaftlich profitabel wäre.

Nachfrage, Qualität, Mengenbasis, Rundung, Werte, Materialpreisquellen, drei Auslagenplätze und Analyse sind für den ersten Handelsablauf festgelegt und automatisiert geprüft. Die Abrechnung erfolgt nach dem neutralen Ereignis im vorbereiteten nächsten Spielstand; erst erfolgreiches Speichern übernimmt Verkäufe und Tagesfortschritt.

Offen bleiben die endgültige Balance, der geerbte Startbestand, einmalige Wochenmarkt-Materialien sowie das Zusammenspiel mit zukünftigen Ereigniswirkungen. Chaosberechnung, Gewöhnung und Reputation folgen als getrennte Arbeitsschritte. Die Regelgrundlage für den ersten Handelsablauf in der [Roadmap](roadmap.md) ist damit abgeschlossen.

Grundlagen: [Handwerk und Herstellung](handwerk-und-herstellung.md), [Handel und Währungen](handel-und-waehrungen.md), E-047 und E-049 bis E-062 in [Entscheidungen](entscheidungen.md). Zugehörige Fragen: F-04, F-05, F-24 bis F-27, F-30 und F-37 in [Offene Fragen](offene-fragen.md).
