
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

Hinweis: Doppelte Werte werden nicht physisch gelöscht, sondern lediglich von der Anzeige der Ergebnismenge ausgeschlossen. Mit der Abfrage "*SELECT DISTINCT * FROM Tabellenname;*" werden alle doppelt vorhandenen Zeilen des Datensatzes entfernt.
