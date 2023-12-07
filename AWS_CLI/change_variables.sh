# Autor: Damjan Djukic, Maurin Schickli, Cyrill Koller
# Datum: 2022-12-20
# Beschreibung: Skript zum Ändern der Variablen für die lambda Funktion

BUCKET_NAME_ORIGINAL=""
BUCKET_NAME_COMPRESSED=""
PERCENTAGE_RESIZE=0

# Display menu

# Aktion ausführen
while true; do

    echo "Waehlen Sie eine Aktion aus:"
    echo "1. Neuen Bucket für die originalen Bilder erstellen"
    echo "2. Neuen Bucket für die verkleinerten Bilder erstellen"
    echo "3. Verkleinerungswert ändern"
    echo "4. Exit"
    echo "5. Delete all buckets"
    read -p "Waehlen sie eine Nummer aus: " action

    case $action in
    1)
        # neuen Bucket für die originalen Bilder erstellen
        echo ""
        echo "Geben sie den Namen des Buckets ein:"
        read BUCKET_NAME_ORIGINAL

        RESULT=$(aws s3api head-bucket --bucket $BUCKET_NAME_ORIGINAL 2>&1)

        if [[ $RESULT == *"Not Found"* ]]; then
            echo "Bucket $BUCKET_NAME_ORIGINAL ist verfuegbar"
            echo ""
            echo "-----------------------------"
            echo ""
            aws s3api create-bucket --bucket "$BUCKET_NAME_ORIGINAL" --region us-east-1

            # Aendert die Variable BUCKET_NAME_ORIGINAL in der lambda Funktion
            NEW_ENVVARS=$(aws lambda get-function-configuration --function-name compressImage --query "Environment.Variables | merge(@, \`{\"BUCKET_NAME_ORIGINAL\":\"$BUCKET_NAME_ORIGINAL\"}\`)")
            aws lambda update-function-configuration --function-name compressImage --environment "{ \"Variables\": $NEW_ENVVARS }"

            echo "-----------------------------"
            # $bucket="false"
        else
            echo "Bucket $BUCKET_NAME_ORIGINAL ist nicht verfuegbar, bitte nochmals versuchen"
            echo ""
            echo "-----------------------------"
        fi
        ;;
    2)
        # neuen Bucket für die verkleinerten Bilder erstellen
        echo ""
        echo "Geben sie den Namen des Buckets ein:"
        read BUCKET_NAME_COMPRESSED

        RESULT=$(aws s3api head-bucket --bucket $BUCKET_NAME_COMPRESSED 2>&1)

        if [[ $RESULT == *"Not Found"* ]]; then
            echo "Bucket $BUCKET_NAME_COMPRESSED ist verfuegbar"
            echo ""
            echo "-----------------------------"
            echo ""
            aws s3api create-bucket --bucket "$BUCKET_NAME_COMPRESSED" --region us-east-1

            # Aendert die Variable BUCKET_NAME_COMPRESSED in der lambda Funktion
            NEW_ENVVARS=$(aws lambda get-function-configuration --function-name compressImage --query "Environment.Variables | merge(@, \`{\"BUCKET_NAME_COMPRESSED\":\"$BUCKET_NAME_COMPRESSED\"}\`)")
            aws lambda update-function-configuration --function-name compressImage --environment "{ \"Variables\": $NEW_ENVVARS }"

            echo "-----------------------------"
            break
        else
            echo "Bucket $BUCKET_NAME_COMPRESSED ist nicht verfuegbar, bitte nochmals versuchen"
            echo ""
            echo "-----------------------------"
        fi
        ;;
    3)
        read -p "Geben Sie einen Prozentsatz fuer die Verkleinerung des Bildes ein (als ganze Zahl, ohne Prozentzeichen): " PERCENTAGE_RESIZE

        if [[ $PERCENTAGE_RESIZE =~ ^[0-9]+$ ]]; then
            echo "Sie haben $PERCENTAGE_RESIZE% eingegeben."
            NEW_ENVVARS=$(aws lambda get-function-configuration --function-name compressImage --query "Environment.Variables | merge(@, \`{\"PERCENTAGE_RESIZE\":\"$PERCENTAGE_RESIZE\"}\`)")
            aws lambda update-function-configuration --function-name compressImage --environment "{ \"Variables\": $NEW_ENVVARS }"
            break
        else
            echo "Fehler: Sie haben keinen gültigen Prozentsatz eingegeben."
        fi
        ;;
    4)
        echo "Ende"
        exit 0
        ;;
    5)
        # Löscht alle Buckets
        aws s3 ls | awk '{print $3}' | while read bucket; do
            echo "Deleting bucket $bucket"
            aws s3 rb s3://$bucket --force
        done
        ;;


    *)
        # Invalid selection
        echo "Ungueltige Auswahl"
        ;;
    esac
done
