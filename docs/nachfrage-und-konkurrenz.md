# Nachfrage und reagierende Konkurrenz

**Stand:** 11. Oktober 2026  
**Status:** Drei Kundengruppen und zwei feste Konkurrenten sind mit deterministischer Nachfrage in 0.3.0 umgesetzt. Verbindliche Testformeln: [Handelsregeln 0.3.0](handelsprototyp-0.3.md). Die folgenden Vorschläge zu Konkurrenzreaktionen, neuen Waren und Chaos bleiben spätere Ausbauschritte.

Der Verkaufspreis soll der stärkste unmittelbar veränderbare Regler für das Kaufinteresse sein. Entscheidend ist sein Verhältnis zum wahrgenommenen Nutzen der Ware und zu vergleichbaren Konkurrenzangeboten. Bedarf, Kaufkraft und Vertrauen bestimmen, welche Kunden überhaupt einen Kauf erwägen. Konkurrenz reagiert auf die Entscheidungen des Spielers; Chaos verändert die Marktbedingungen.

Die bestätigte Abrechnung bleibt bestehen: Erst Nachfrage ermitteln, anschließend Tageslimit und Finanzierung anwenden. Materialkosten werden vor den Verkaufseinnahmen in ihren ursprünglichen Währungen bezahlt. Geldwerte können ausschließlich über Warenhandel zwischen den Währungen übertragen werden.

## Drei Kundengruppen

Für den ersten Test werden Kunden als Gruppen berechnet. Jede Gruppe besitzt je Welt und Produktkategorie eine Zahl aktueller Kaufinteressenten, ein Kaufbudget und Gewichtungen für Produkteigenschaften. Die Anzahl der Kaufinteressenten beschreibt den Bedarf an diesem Tag; sie ist nicht die gesamte Bevölkerung.

| Gruppe | Vorgeschlagene Schwerpunkte |
| --- | --- |
| Unterschicht | Enges Kaufbudget; Preis und grundlegender Nutzen wiegen stark. |
| Mittelschicht | Größeres Budget; Preis, Qualität und Haltbarkeit werden gegeneinander abgewogen. |
| Oberschicht | Hohes Budget; Qualität, besondere Eigenschaften und gegebenenfalls Prestige wiegen stärker. Der Preis bleibt relevant. |

Diese Gewichtungen sind Spielparameter. Keine Gruppe kauft automatisch, nur weil sie sich eine Ware leisten könnte. Auch wohlhabende Kunden benötigen einen Anlass und ein attraktives Angebot. Besondere oder magische Eigenschaften können je Zielwelt nützlich, uninteressant oder abschreckend sein.

## Ablauf der Nachfrageberechnung

Die Nachfrage für den eigenen Laden wird nur in Runden mit einem Besuch dieses Ladens in der aktiven Welt zur Verkaufsabrechnung verwendet (E-056). Bei anderen Ortsbesuchen ist der eigene Laden kein verfügbares Verkaufsangebot in der Kundenverteilung. Der Laden der inaktiven Welt verkauft ebenfalls nicht.

1. **Bedarf bestimmen:** Wie viele Kunden jeder Gruppe suchen heute beispielsweise einen Küchenstuhl?
2. **Bezahlbare Angebote prüfen:** Welche passenden Angebote liegen innerhalb ihres Kaufbudgets?
3. **Angebote bewerten:** Preis im Verhältnis zum wahrgenommenen Nutzen, Qualität, besondere Eigenschaften und Vertrauen berücksichtigen. Bei ansonsten gleichen Bedingungen soll ein niedrigerer Preis das Kaufinteresse nicht senken.
4. **Kaufinteresse verteilen:** Spieler- und Konkurrenzangebote konkurrieren um dieselben Kunden. Ein Kunde kann auch auf den Kauf verzichten. Mehrere Stuhlvarianten erzeugen keine zusätzlichen Kunden für denselben Bedarf.
5. **Spielernachfrage zusammenzählen:** Daraus ergibt sich die Nachfrage D vor der Produktionsbegrenzung. Diese Zahl darf über dem Tageslimit liegen.
6. **Verkäufe abrechnen:** Die bestätigte Regel `Verkäufe = min(D, Tageslimit, finanzierbare Anzahl)` anwenden.

Die Qualität der Spielerprodukte entsteht aus Materialien und Fähigkeiten der Spielfigur (E-054). Sie fließt in den Produktwert ein und beeinflusst damit die Bewertung des Angebots; die Preisentscheidung erfolgt auf Grundlage dieser Produkteigenschaften. Die Qualität selbst wird nicht durch den gesetzten Verkaufspreis verändert.

Der durch Analyse sichtbare Produktwert bleibt eine Grundlage für den Nutzenvergleich. Wie Kundengruppen ihn gewichten und besondere Eigenschaften bewerten, muss zusammen mit der Wertformel festgelegt werden. Der geheime Weltchaoswert wird dabei nicht automatisch noch einmal als pauschaler Abzug vom Produktwert verwendet.

Bewertung und Rundung sind für 0.3.0 festgelegt. Es gibt keinen Zufall. Kunden verteilen sich zunächst auf Geschäfte und Nichtkauf, dann auf passende Spielerangebote; nicht erfüllte Käufe entfallen. Die Platzreihenfolge steuert ausschließlich das Produktionsbudget. Sämtliche Einnahmen folgen nach der Finanzierung aller Plätze.

## Warum ein niedrigerer Preis nicht immer mehr Verkäufe bringt

Im bestätigten Küchenstuhlbeispiel beträgt die Nachfrage bei 40 Silber sechs und das Tageslimit fünf. Bei ausreichendem Geld werden fünf Stühle verkauft.

**Berechneter Testfall in 0.3.0:** Eine Preissenkung auf 25 Silber erzeugt zehn Kaufinteressenten; wegen desselben Tageslimits bleiben trotzdem nur fünf Verkäufe möglich. Die Verkaufsgutschrift sänke von 200 auf 125 Silber bei gleichen Materialkosten. Die Preissenkung würde zusätzliche Nachfrage erzeugen, aber den tatsächlichen Absatz nicht erhöhen.

Preisoptimierung bedeutet deshalb, Kaufinteresse, verfügbare Produktionsmenge und Finanzierung gemeinsam zu betrachten.

## Wie andere Geschäfte reagieren können

Konkurrenten erhalten ein kleines Profil: Sortiment, Preise, Qualität beziehungsweise verfügbare Varianten, Absatz und eine einfache Strategie. Ein günstiger Alltagsanbieter und ein Anbieter hochwertiger Waren reagieren unterschiedlich.

| Veränderung durch den Spieler | Mögliche Reaktion der Konkurrenz |
| --- | --- |
| Vergleichbare Ware wird deutlich günstiger angeboten. | Preis prüfen und gegebenenfalls senken, soweit die eigenen Kosten es erlauben. |
| Der Spieler gewinnt Kunden mit höherer Qualität. | Eine bessere Variante entwickeln oder sich auf günstigere Kundenangebote konzentrieren. |
| Eine neue Warenart verändert den bisherigen Bedarf. | Ein passendes Produkt entwickeln oder auf ein anderes Sortiment ausweichen. |
| Auffällige Waren lösen Misstrauen aus. | Vertraute lokale Waren hervorheben und Vertrauen als Verkaufsargument nutzen. |

Die Anpassung erfolgt mit Verzögerung. Für neue Konkurrenzwaren werden zunächst vorbereitete Rezepte und Materialvarianten verwendet. Welche Waren ein Geschäft entwickeln darf, welche Kosten und Dauer entstehen und ob Materialien der anderen Welt erreichbar sind, bleiben offen. Die Konkurrenz erhält damit keine automatisch bestätigte Fähigkeit zum Weltenwechsel oder zu fremder Magie.

**Vorschlag zum Zeitpunkt:** Markt und Konkurrenzangebote zu Tagesbeginn sowie die nach den Tagesgeschäften verbleibenden Spielerangebote bilden die Grundlage der Nachfrage. Konkurrenzreaktionen aus der Auswertung werden frühestens am nächsten aktiven Tag dieser Welt wirksam. Die inaktive Welt entwickelt sich nicht weiter. Der endgültige Zusammenhang mit Tagesereignissen bleibt bei F-27 zu klären.

## Chaos als Veränderung der Marktbedingungen

Das Angebot merkwürdiger Waren und die Entwertung anderer Waren sind bereits bestätigte Chaosursachen, auch ohne Verkäufe. Die Marktreaktion darf diesen Auslöser nicht auf tatsächlichen Absatz beschränken.

Für die Nachfrage werden konkrete Folgen vorgeschlagen: Misstrauen gegenüber auffälligen Waren, verschobener Bedarf oder Störungen einzelner Geschäfte. Je nach Folge können bestimmte Angebote Kunden verlieren und andere gewinnen. Chaos muss deshalb nicht jede Nachfrage im selben Verhältnis senken. Welche Folgen ausgelöst werden und wie stark sie wirken, bleibt festzulegen.

Produktauffälligkeit, Gewöhnung, Reputation und Weltchaos bleiben getrennte Größen. Ein guter Ruf bei Händlern ist noch kein bestätigter Vertrauensbonus bei Kunden. Die Konkurrenz kann wirtschaftlich reagieren, während Gespräche und Ereignisse die gesellschaftlichen Folgen zeigen. Chaoswerte und interne Gewichtungen werden dem Spieler nicht angezeigt.

## Umgesetzter Test und weitere Ausarbeitung

0.3.0 umfasst drei Kundengruppen, die Kategorien Stühle einschließlich Polsterstuhl, Tische und Truhen sowie zwei feste Konkurrenten je Welt. Bedarf, Kaufbudgets und Formeln sind als Testbalance festgelegt; Zahlen und Rechenproben stehen in [Handelsregeln 0.3.0](handelsprototyp-0.3.md).

Verzögerte Konkurrenzreaktionen, neue Konkurrenzwaren, Chaos und Gewöhnung bleiben auszuarbeiten. Eine vollständige Haushalts- oder Lieferkettensimulation ist weiterhin keine Voraussetzung.

Grundlagen: [Herstellung und Verkauf mit Kostenrechnung](herstellungs-kosten-verkaufsregeln.md), [Handel und Währungen](handel-und-waehrungen.md), [Chaoswert](chaoswert.md), [Reputation und Gespräche](reputation-und-gespraeche.md) und [Roadmap](roadmap.md). Offene Entscheidungen gehören zu F-26, F-31, F-36 und F-38 in [Offene Fragen](offene-fragen.md).
