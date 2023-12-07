# M346_Projekt

## Erste Schritte

1. Benutzer/Benutzername/.aws/configure oder mit aws configure die credentials hinterlegen für die cli (die credentials findet man im learner Lab unter AWS Details)
2. Öffnen Sie die Kommandozeile
3. Vergewissern Sie sich, dass Sie sich im Ordner ./AWS_CLI befinden, falls nicht, wechseln Sie in diesen Ordner
4. Fügen Sie den folgenden Befehl ein

```cmd
    ./setup.sh
```

## Ändern der Umgebungsvariablen

1. Öffnen Sie die Kommandozeile
2. Vergewissern Sie sich, dass Sie sich im Ordner ./AWS_CLI befinden, falls nicht, wechseln Sie in diesen Ordner
3. Fügen Sie den folgenden Befehl ein

```cmd
    ./change_variable.sh
```

## Gebrauchte Pakete in der Lambda Funktion

- aws-sdk
- sharp

## Tests

### Ausführen des Setup.sh Scripts

*Durgeführt am 32.12.2022 von Maurin Schickli*

In diesem Test testen wir das Aufbauen der S3 Buckets, der lambda Funktion und das automatische Hoch und herunterladen eines Bildes

1.) Als erstes wird das Script mit ./setup.sh ausgeführt
2.) Alle Bucket Namen werden gesetzt. Die Namen werden geprüft ob sie verfügbar sind mit der AWS Cloud.
3.) Die anzahl Prozent wird angegeben.

![Screenshot 2022-12-23 150301](https://user-images.githubusercontent.com/67188361/209350838-7e84c7ec-fffc-429d-b2f3-ba99414b37e4.png)

4.) Das bild wird automatisch hochgeladen

![Screenshot 2022-12-23 150642](https://user-images.githubusercontent.com/67188361/209350868-b0c56517-4569-47c6-9e5f-8e0513fcb352.png)

5.) Von der Lambda Funktion verarbeitet und in dem zweiten S3 Bucket mit resize-'dateiname' abgelegt
6.) Bild wird automatisch in das Download verzeichnis heruntergeladen.

![Screenshot 2022-12-23 150828](https://user-images.githubusercontent.com/67188361/209350904-6d6c8781-9b9c-4411-856f-a5c404270e2d.png)

Bei diesem test haben wir gemerkt das die Bucketnames immer in Kleinbuchstaben geschriben werden muss. Dies haben wir dann ergänzt.

### Normales hochladen eines Bildes

*Durgeführt am 32.12.2022 von Maurin Schickli*

1.) Öffnen des Buckets auf der AWS Site
2.) Hochladen des Bildes in den Bucket

![image](https://user-images.githubusercontent.com/67188361/209352812-c2501715-5fb9-43f2-93af-84788372cde9.png)

3.) Das Bild wird automatisch von der Lambda funktion erkannt und verarbeitet
4.) Neues Bild im anderen S3 Bucket anschauen und überpprüfen.
![image](https://user-images.githubusercontent.com/67188361/209352921-cd83c300-3007-4994-bc5b-23299bfb6fe5.png)

Das Testing lief ohne Probleme ab. Bei kleinen Bildern funktioniert das verkleinern jedoch wird die Datei grösser dadurch. bei Grösseren Bildern funktioniert die Funktion ohne Probleme. Man sieht, wenn man beide Bilder vergleicht, einen Unterschied in der Qualität.
![image](https://user-images.githubusercontent.com/67188361/209353151-dda95e14-4f49-46c6-9d7d-0f1da9344ddd.png)

## Reflexion

### Damjan

Ich denke, dass ich in dem Modul gut abgeschnitten und viel gelernt habe. Die Theorie, die wir behandelten, war interessant. Es war auch nützlich, dass ich die Möglichkeit hatte, die Theorie in der Praxis anzuwenden, denn so konnte ich mein Verständnis vertiefen und festigen. Dennoch war es manchmal schwierig, alles unter einen Hut zu bringen, da ich nebenbei noch ein anderes Projekt im Modul 254 hatte. Ich habe mich bemüht, meine Zeit effektiv zu nutzen und meine Aufgaben zu meiner Zufriedenheit zu erledigen.

Insgesamt denke ich, dass mir das Modul sehr viel gebracht hat. Ich denke auch, dass die Aufgabenteilung fair war und jeder die Chance hatte, etwas beizutragen. Vielleicht hätten wir etwas mehr Zeit haben können, um alles zu erledigen, ohne unter Zeitdruck zu stehen, aber ich denke, wir haben das Beste aus der Situation gemacht. Alles in allem war es eine positive Erfahrung und ich bin froh, dass ich dieses Projekt erledigen konnte.

  
### Cyrill

Ich finde, dass ich gut gearbeitet habe in diesem Projekt, denn ich habe stets vorwärts gemacht und mich bemüht mein Teil der Aufgabe zu erledigen. Ein Verbesserungsvorschlag fürs nächste Projekt wäre, dass wir die Aufgabenteilung besser machen, da es nicht immer zu 100% klar war, wer was macht. Ansonsten haben wir gut zusammen gearbeitet. Wir haben viel so gearbeitet, dass einer den Code schreibt und die anderen die verschiedenen AWS-CLI Befehle vorbereiten, sodass der der den Code schreibt, die Befehle nur noch einfügen muss.

### Maurin

Das projekt war sehr interessant und lehrreich. Wir mussten viel lernen über die AWS Cloud und über die AWS CLI. Der Anfang war sehr schwierig weil wir nicht wussten wo anzufangen. mit der zeit hat sich dann immer mehr zusammengefügt. Manchmal war es schwierig, alles einzubeziehen, da ich ein anderes Projekt in Modul 254 hatte. Ich habe meine Zeit effizient genutzt und alles getan, um die Aufgaben erfolgreich zu erledigen. Allem in allem denke ich, dass das Modul mir sehr geholfen hat. Ich hatte das Gefühl, dass die Aufgaben gerecht verteilt waren und dass jeder die Möglichkeit hatte, seinen Beitrag zu leisten. Insgesamt war es eine positive Erfahrung, und ich bin froh, dass wir das Projekt abschließen konnten.


