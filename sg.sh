#/bin/sh

# BASE_PATH="/home/lijin/extern_projects/allwinner/h6/android/android"
BASE_PATH="."
java -jar $BASE_PATH/prebuilts/sdk/tools/lib/signapk.jar $BASE_PATH/build/target/product/security/platform.x509.pem $BASE_PATH/build/target/product/security/platform.pk8 $1 $2



