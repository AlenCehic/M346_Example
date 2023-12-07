# Autor: Damjan Djukic, Maurin Schickli, Cyrill Koller
# Date: 2022-12-20
# Beschreibung: Skript zum Erstellen der lambda Funktion, der Buckets und der Variablen

BUCKET_NAME_ORIGINAL=""
BUCKET_NAME_COMPRESSED=""
PERCENTAGE_RESIZE=0

ARN=$(aws sts get-caller-identity --query "Account" --output text)

# write $ARN to notification.json file
sed -i "s/ACCOUNT_ID/$ARN/g" ./configs/notification.json

# Erstellen der lambda Funktion
while true; do

    # Name des Buckets abfragen
    echo ""
    echo "Geben sie den Namen des Buckets fuer die originalen Bilder ein: (kleinbuchstaben)"
    # In Variable speichern
    read BUCKET_NAME_ORIGINAL

  # Uebpruefen ob Bucket existiert
  RESULT=$(aws s3api head-bucket --bucket $BUCKET_NAME_ORIGINAL 2>&1)

  # Ueberpruefen der Antwort
  if [[ $RESULT == *"Not Found"* ]]; then
    echo "Bucket $BUCKET_NAME_ORIGINAL ist verfuegbar"
    echo ""
    echo "-----------------------------"
    echo ""
    aws s3api create-bucket --bucket "$BUCKET_NAME_ORIGINAL" --region us-east-1
    echo "-----------------------------"
    break
  else
    echo "Bucket $BUCKET_NAME_ORIGINAL ist nicht verfuegbar, bitte nochmals versuchen"
    echo ""
    echo "-----------------------------"
  fi
done

while true; do

    # Name des Buckets abfragen
    echo "Geben sie den Namen des Buckets fuer die verkleinerten Bildern ein: (kleinbuchstaben)"
    # In Variable speichern
    read BUCKET_NAME_COMPRESSED

  # Uebpruefen ob Bucket existiert
  RESULT=$(aws s3api head-bucket --bucket $BUCKET_NAME_COMPRESSED 2>&1)

  # Ueberpruefen der Antwort
  if [[ $RESULT == *"Not Found"* ]]; then
    echo "Bucket $BUCKET_NAME_COMPRESSED ist verfuegbar"
    echo ""
    echo "-----------------------------"
    echo ""
    aws s3api create-bucket --bucket "$BUCKET_NAME_COMPRESSED" --region us-east-1
    echo "-----------------------------"
    break
  else
    echo "Bucket $BUCKET_NAME_COMPRESSED ist nicht verfuegbar, bitte nochmals versuchen"
    echo ""
    echo "-----------------------------"
    echo ""
  fi
done

while true; do
  read -p "Geben Sie einen Prozentsatz fuer die Verkleinerung des Bildes ein (als ganze Zahl, ohne Prozentzeichen): " PERCENTAGE_RESIZE

  if [[ $PERCENTAGE_RESIZE =~ ^[0-9]+$ ]]; then
    echo "Sie haben $PERCENTAGE_RESIZE% eingegeben."
    break
  else
    echo "Fehler: Sie haben keinen gültigen Prozentsatz eingegeben."
  fi
done

aws lambda delete-function --function-name compressImage

# Erstellen der lambda Funktion
aws lambda create-function --function-name compressImage --runtime nodejs18.x --role arn:aws:iam::$ARN:role/LabRole --handler lambdaScript.handler --zip-file fileb://./lambdaScript.zip --memory-size 256

# Berechtigung fuer S3 Bucket
aws lambda add-permission --function-name compressImage --action "lambda:InvokeFunction" --principal s3.amazonaws.com --source-arn arn:aws:s3:::$BUCKET_NAME_ORIGINAL --statement-id "$BUCKET_NAME_ORIGINAL"
# Bucket notification
aws s3api put-bucket-notification-configuration --bucket "$BUCKET_NAME_ORIGINAL" --notification-configuration '{
    "LambdaFunctionConfigurations": [
        {
            "LambdaFunctionArn": "arn:aws:lambda:us-east-1:'$ARN':function:compressImage",
            "Events": [
                "s3:ObjectCreated:Put"
            ]
        }
    ]
}'

# Erstellen der Variablen
aws lambda update-function-configuration --function-name compressImage --environment "Variables={BUCKET_NAME_ORIGINAL=$BUCKET_NAME_ORIGINAL,BUCKET_NAME_COMPRESSED=$BUCKET_NAME_COMPRESSED, PERCENTAGE_RESIZE=$PERCENTAGE_RESIZE}" --query "Environment"

# Testbild hochladen
aws s3 cp ./testimage/enchantements.png s3://$BUCKET_NAME_ORIGINAL/enchantements.png

# Testbild herunterladen

# Get the latest image in the S3 bucket
LATEST_IMAGE=$(aws s3 ls s3://$BUCKET_NAME_COMPRESSED --recursive | sort | tail -n 1 | awk '{print $4}')

echo "Das Bild kann gefunden werden unter: C:\Users\Public\Downloads"

# Download the latest image to the download directory
aws s3 cp s3://$BUCKET_NAME_COMPRESSED/$LATEST_IMAGE "C:\Users\Public\Downloads"
