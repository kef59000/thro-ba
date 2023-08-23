
# Grundlegende SQL-Befehle

Allgemeines: Falls Spaltennamen und Tabellennamen Leerzeichen oder Bindestrich enthalten, muss in MS Access der Ausdruck in eckige Klammern gesetzt werden, z.B. [Lieferanten-Nr] oder [Telefon privat].

## Die SELECT-Anweisung

    SELECT Spaltenname(n) FROM Tabellenname(n);

Bestandteile der SELECT-Anweisung:

- **SELECT**: Festlegen der Tabellenspalte(n)
- **FROM**: Tabelle(n), die abgefragt werden soll(en)

Beispiel: Zeigen Sie von allen Angestellten den Namen, den Vornamen und die Telefonnummer an.

    SELECT Nachname, Vorname, [Telefon privat] FROM Personal;

Hinweis: Folgen nach SELECT mehrere Spaltennamen, werden diese durch ein Komma getrennt.

Auswahl aller Spalten:

    SELECT * FROM Tabellenname;

Beispiel: Zeigen Sie alle Kundendaten an.

    SELECT * FROM Kunden;

Entfernen doppelt vorhandener Zeileneinträge:

    SELECT DISTINCT Spaltenname FROM Tabellenname;

Beispiel: Zeigen Sie alle Orte aus der Tabelle Bestellungen ohne Duplikate an.

    SELECT DISTINCT Ort FROM Bestellungen;

Hinweis: Doppelte Werte werden nicht physisch gelöscht, sondern lediglich von der Anzeige der Ergebnismenge ausgeschlossen. Mit der Abfrage **SELECT DISTINCT * FROM Tabellenname;** werden alle doppelt vorhandenen Zeilen des Datensatzes entfernt.

## Sortieren der Ergebnismenge

    SELECT Spaltenname(n) FROM Tabellenname ...
    ... ORDER BY Spaltenname ASC: aufsteigende Sortierung
    ... ORDER BY Spaltenname DESC: absteigende Sortierung

Hinweis: **ORDER BY** ist abhängig vom Datentyp (z.B. Zahlen, Groß-Kleinschreibung usw.)

Beispiel: Zeigen Sie alle Daten der Kunden absteigend nach dem Land sortiert an.

    SELECT * FROM Kunden ORDER BY Land DESC;

## Zuordnung einer Spaltenbezeichnung

Soll im Rahmen einer Abfrage ein Alias für eine Spalte verwendet werden, wird der Spaltenname mit **AS** festgelegt.

Beispiel: Zeigen Sie zu jedem Artikel ausgehend vom Einzelpreis den Preis mit Mehrwertsteuer an.

    SELECT DISTINCT Artikelname, Einzelpreis*1.16 AS Mehrwertsteuer
    FROM Artikeldaten;

## Abfrage von Teileinträgen einer Spalte

Sollen von den Einträgen in den Zeilen einer Spalte nur eine bestimmte Anzahl von Zeichen bei einer Abfrage berücksichtigt werden, kann dies mit **LEFT** oder **RIGHT** festgelegt werden.

- **LEFT**(Spaltenname, ganze Zahl n): In den Zeilen der ausgewählten Spalte werden nur die ersten n Zeichen berücksichtigt.
- **RIGHT**(Spaltenname, ganze Zahl n): In den Zeilen der ausgewählten Spalte werden nur die letzten n Zeichen berücksichtigt.

Beispiel: Von den Artikelnamen sollen nur die ersten sechs Stellen ausgegeben werden.

    SELECT LEFT(Artikelname, 6) FROM Artikeldaten;

## Speichern einer Abfrage als Tabelle

Mit Hilfe von **INTO** lässt sich das Ergebnis einer Abfrage als neue Tabelle abspeichern.

Beispiel: Zeigen Sie alle Artikel mit ihrem entsprechenden Einzelpreis an, wobei die Artikel nach dem Einzelpreis in absteigender Reihenfolge sortiert sind. Speichern Sie das Ergebnis als neue Tabelle unter dem Tabellennamen "Preisliste".

    SELECT DISTINCT Artikelname, Einzelpreis INTO Preisliste
    FROM Bestellungen ORDER BY Einzelpreis DESC;

Hinweis: Soll der Tabellenname *Leerzeichen* oder einen *Bindestrich* enthalten, dürfen die eckigen Klammern nicht vergessen werden.

## Mathematische Operatoren

- Addition: +
- Subtraktion: -
- Division: /
- Multiplikation: *

Beispiel: Zeigen Sie alle Artikel mit ihrem Einzelpreis an, wobei Sie zu jedem Einzelpreis eine Kostenpauschale in Höhe von 5 Euro addieren.

    SELECT DISTINCT Artikelname, Einzelpreis+5 FROM Artikel;

## Daten filtern

Bisher: Alle Zeilen einer Tabelle werden angezeigt. Jetzt: Verfeinerung der Abfrage durch Filterung von Daten (z.B.: "Welche Kunden wohnen in Berlin?")

### Die WHERE-Klausel

    SELECT Spaltenname(n) FROM Tabellenname(n) WHERE Suchbedingung;

### Suchbedingungen

Vergleichsoperatoren:
- $=$ ist gleich
- $<$ kleiner als
- $>$ größer als
- $<>$ ungleich
- $<=$ kleiner gleich
- $>=$ größer gleich


Hinweis: Sind Wörter Suchbegriffe, müssen sie immer in einfachen Anführungszeichen (') stehen; bei Datum und Zeit wird die Raute (#) verwendet. Außerdem muss das amerikanische Datum verwendet werden (mm/dd/yyyy).

Beispiel: Zeigen Sie die Datensätze aller Kunden an, die aus Deutschland stammen.

    SELECT * FROM Kunden WHERE Land = 'Deutschland';

### Wertebereiche

... Spaltenname **BETWEEN** Wert1 **AND** Wert2;

**BETWEEN … AND** definiert einen Wertebereich, wobei *Wert1* und *Wert2* als Grenzen noch Bestandteil des Wertebereichs sind.

Beispiel: Zeigen Sie alle Daten zu den Mitarbeitern an, die zwischen 01.01.1993 und 31.12.1993 eingestellt wurden.

    SELECT * FROM Personal WHERE Einstellung
    BETWEEN #01/01/1993# AND #12/31/1993#;

### Elemente einer Menge

... **IN** (‘Wert1’, ‘Wert2’, ‘Wert3’);

**IN** vergleicht die Werte in einer Spalte mit einer Liste explizit definierter Werte.

Beispiel: Zeigen Sie alle Firmen an, die in London, Paris oder Portland ansässig sind.

    SELECT Firma FROM Kunden WHERE Ort IN ('London', 'Paris', 'Portland');
 
### Mustervergleich

Mit **LIKE** werden Datenwerte einer Spalte mit einem Muster verglichen.
- $*$ liefert eine beliebige Zeichenfolge der Länge n.
- $?$ liefert eine beliebige Zeichenfolge der Länge 1.
- \# liefert eine numerische Zeichenfolge der Länge 1.

Beispiel: Zeigen Sie die Datensätze aller Kunden an, in deren Kunden-Code der Buchstabe 'a' vorkommt.

    SELECT * FROM Kunden WHERE [Kunden-Code] LIKE '*a*';

### Nullwert

Mit der Bedingung **IS NULL** kann überprüft werden, welche Werte den Wertausdruck Null enthalten, also die Felder einer Spalte, die keinen Eintrag enthalten.

Beispiel: Zeigen Sie die Datensätze alle Kunden an, bei denen in der Spalte Region kein Eintrag vorhanden ist.

    SELECT * FROM Kunden WHERE Region IS NULL;

### Zeilenausschluss

Mit dem Zusatz **NOT** können Zeilen ausgeschlossen werden.

Beispiel: Zeigen Sie die Datensätze aller Mitarbeiter an, die nicht zwischen dem 01.01.1993 und dem 31.12.1993 eingestellt wurden.

    SELECT * FROM Personal WHERE Einstellung
    NOT BETWEEN #01/01/1993# AND #12/31/1993#;

### Kombinieren von Bedingungen

Eine Abfrage kann dadurch verfeinert werden, indem mehrere Bedingungen kombiniert werden. Die Kombination erfolgt mit Hilfe bool’scher Operatoren.

- NOT – nicht
- AND – sowohl als auch, d.h. alle Bedingungen müssen erfüllt sein
- OR – mindestens eine Bedingung muss erfüllt sein

Beispiel: Zeigen Sie alle Firmen an, die in Berlin oder Paris ansässig sind.

    SELECT Firma FROM Kunden WHERE Ort = 'Berlin' OR Ort = 'Paris';

Hinweis: Bei der Kombination von mehreren Operatoren ist es sinnvoll Klammern zu setzen, um so die Richtigkeit der Abfrage zu garantieren.

## Tabellen verknüpfen

### Tabellen verknüpfen mit INNER JOIN

    SELECT Spaltenname(n) FROM Tabellenname
    INNER JOIN Tabellenname ON Suchbedingung;

Bisher wurde jeweils nur eine Tabelle abgefragt. Mit dem **INNER JOIN** Befehl können mehrere Tabellen in eine Abfrage integriert werden.

Mit **INNER JOIN** wird die Schnittmenge mehrerer Tabellen gebildet, indem zueinander passende Spaltenwerte verschiedener Tabellen verglichen werden.

**INNER JOIN** gibt nur solche Zeilen zurück, bei denen die verglichenen Spaltenwerte der verknüpften Tabellen übereinstimmen, bzw. der Abfragebedingung gerecht werden.

Werden in verschiedenen Tabellen Spalten mit gleichem Namen verglichen, müssen die Namen voll qualifiziert angegeben werden, d. h. vor den Spaltennamen muss durch einen Punkt getrennt der jeweilige Tabellenname angegeben werden. Sind die Spaltennamen nicht identisch, wäre dies eigentlich nicht erforderlich, trägt aber dazu bei, den SQL-Befehl verständlicher zu machen (besonders dann, wenn mit mehr als einer Tabelle gearbeitet wird).

Falls in einer Abfrage mehr als zwei Tabellen verknüpft werden sollen, also **INNER JOIN ... ON ...**
mehrmals auftaucht, muss aus Syntaxgründen mit Klammern gearbeitet werden.

#### Fragestellungen, die den INNER JOIN Befehl erfordern
- Welche Kunde haben welche Artikel bestellt?
- Welcher Mitarbeiter hat welche Bestellung bearbeitet?
- Welche Artikel sind Bestandteil welcher Kategorie?
- Aus welchen Kategorien haben die Kunden Produkte bestellt?

Beispiel: Welche Kunden haben welchen Auftrag wann erteilt?

    SELECT Kunden.[Kunden-Code], Kunden.Firma, Bestellungen.[Bestell-Nr], Bestellungen.Bestelldatum FROM Kunden INNER JOIN
    Bestellungen ON Kunden.[Kunden-Code]=Bestellungen.[Kunden-Code];

#### Verknüpfung einer Tabelle mit sich selbst (Self-Join)

Einzelne Spalten einer Tabelle können auch mit sich selbst verglichen werden, beispielsweise um eigentlich gleiche Datensätze zu finden, die jedoch aufgrund eines Tippfehlers von Access als zwei unterschiedliche Datensätze verstanden werden.

Um die Tabelle mit sich selbst vergleichen zu können, müssen aus dieser zunächst zwei virtuelle Tabellen gebildet werden. Dieser Schritt wird durch den Parameter **AS** erreicht.

In einem zweiten Schritt müssen dann die einzelnen Spalten der Tabelle miteinander verglichen werden. Aus Übersichtlichkeitsgründen sollte nur bei einem Spaltenvergleich "ungleich" gewählt werden, bei allen anderen "gleich".

    SELECT Bezeichnung1.* FROM Tabellenname AS Bezeichnung1, Tabellenname AS Bezeichnung2
    WHERE Bezeichnung1.Spaltenname_x = Bezeichnung2.Spaltenname_x AND ...
    AND Bezeichnung1.Spaltenname_y <> Bezeichnung2.Spaltenname_y AND ... ;

Beispiel: Zeigen Sie die Daten aller Kunden an, falls mehr als ein Kunde in einem PLZ-Bereich wohnt.

    SELECT DISTINCT a.* FROM Kunden AS a, Kunden AS b
    WHERE a.Postleitzahl = b.Postleitzahl AND a.[Kunden-Nr] <> b.[Kunden-Nr];
 
## Aggregatfunktion

Abfragen mit **SELECT**, **FROM** und **WHERE** liefern einzelne Zeilen der gewählten Tabelle. Es wird jedoch keine Aggregation des Ergebnisses durchgeführt, d.h. die Daten werden nicht zusammengefasst.

Die Abfrage mit einer Aggregatfunktion dagegen ermöglicht die Zusammenfassung mehrerer Zeilen zu einer Ergebniszeile.

Sollen die aggregierten Werte nach bestimmten Kriterien gegliedert werden (z.B. Region, Datum, Verkäufer etc.), muss die Aggregatfunktion in Verbindung mit der **GROUP BY**-Klausel verwendet werden (siehe unten). In diesem Fall wird die Tabelle zunächst entsprechend der festgelegten Kriterien in Teiltabellen zerlegt und für jede Teiltabelle der entsprechende Wert berechnet. Man erhält somit pro Teiltabelle eine Ergebniszeile. Das Gesamtergebnis der Abfrage setzt sich aus allen Ergebniszeilen zusammen.

- MAX(Spaltenname) -> größter Wert einer Spalte
- MIN(Spaltenname) -> kleinster Wert einer Spalte
- SUM(Spaltenname) -> Summe der Spaltenwerte
- AVG(Spaltenname) -> Durchschnitt der Spaltenwerte
- COUNT(Spaltenname) -> Anzahl der Nicht-Null-Werte einer Spalte
- COUNT(*) -> Anzahl der Datensätze in einer Tabelle

### Daten gruppieren – GROUP BY

Die **GROUP BY**-Klausel definiert eine oder mehrere Spalten als Gruppenkennzeichen, wonach die Zeilen gruppiert werden. Es werden also Zeilen mit gleichen Spaltenwerten zusammengefasst.

Das Ergebnis einer **SELECT**-Abfrage wird gruppiert und dargestellt.

In der der **GROUP BY**-Klausel müssen alle Spaltennamen, die hinter dem **SELECT**-Befehl stehen, berücksichtigt werden. Spaltennamen in Aggregatfunktionen sind hierbei jedoch nicht betroffen.

Beispiel: Zeigen Sie an, wie hoch der in den jeweiligen Städten erzielte Umsatz ist.

    SELECT Stadt, SUM(Umsatz) AS Umsatzsummesumme
    FROM Auftragsdaten
    GROUP BY Stadt;

### Gruppierte Daten filtern – HAVING

Die **HAVING**-Klausel spezifiziert Gruppen von Zeilen, die in der logischen Tabelle einer **SELECT**-Anweisung erscheinen sollen. Sie wird auf die **GROUP BY**-Klausel angewendet.

Die **HAVING**-Klausel unterscheidet sich von der **WHERE**-Klausel dadurch, dass sie auf Gruppen von Zeilen angewendet wird und nicht auf einzelne Zeilen.

Mit der **HAVING**-Klausel können bereits gruppierte und berechnete Spalten noch stärker gefiltert werden.

Aggregatfunktionen können nicht in Verbindung mit **WHERE** verwendet werden.

Beispiel: Zeigen Sie alle Abteilungen, die mindestens drei Mitarbeiter haben, so an, dass neben der Abteilung die Mitarbeiterzahl ausgewiesen wird.

    SELECT Abteilung, COUNT(Name) AS Mitarbeiteranzahl FROM Mitarbeiter
    GROUP BY Abteilung HAVING COUNT(Name) >=3;

## Geschachtelte SQL-Abfragen

Da das Ergebnis von SQL-Abfragen Tabellen sind, ist es möglich, mit geschachtelten Abfragebefehlen zu arbeiten.

Bei der Abarbeitung der Verschachtelungen wird von innen nach außen vorgegangen, d.h. die Ergebnis-Tabelle der innersten Abfrage bildet die Grundlage für die sich an diese anschließende Abfrage usw.

Anwendungsmöglichkeit: Strukturierung komplexer Abfragen.

Wichtig: korrekte Klammersetzung zur Abgrenzung der Verschachtelungen.

Beispiel: Nennen Sie die Anzahl der Artikel, deren Einzelpreis mehr als 9 Euro beträgt.

    SELECT COUNT(*) AS [Einzelpreis über 9 Euro]
    FROM (SELECT [Artikel-Nr] FROM Artikel WHERE Einzelpreis > 9);

