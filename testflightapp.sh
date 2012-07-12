#!/bin/sh

API_TOKEN="709e57ff570c077c8c80d0c96dd360ab_Mjc4ODQyMjAxMi0wMS0xNiAwNjo1ODoyMi40NDE3OTQ"
TEAM_TOKEN="9027be7eee7b774169b20eb1dab3e276_NTQxMzEyMDEyLTAxLTE2IDA3OjMwOjAxLjk1MzgzMw"

ADHOC_CONFIGURATION_NAME="AdHoc_Distribution"
ADHOC_CERTIFICATE="iPhone Distribution: Ivan Dzyamulych"

BUNDLE_DISPLAY_NAME="Expenses"
BUNDLE_EXECUTABLE_NAME="Expenses"

GROWL="/usr/local/bin/growlnotify -a Xcode -t TestFlight"
ARCHIVE_DIRECTORY_PATH="${PROJECT_DIR}/../Build"
PROVISIONING_PROFILE_PATH="$ARCHIVE_DIRECTORY_PATH/${BUNDLE_EXECUTABLE_NAME}.mobileprovision"
APPLICATION_PATH="${CONFIGURATION_BUILD_DIR}/${BUNDLE_EXECUTABLE_NAME}.app"

if [[ "${EFFECTIVE_PLATFORM_NAME}" == "-iphoneos" && "${CONFIGURATION}" == $ADHOC_CONFIGURATION_NAME && -e $APPLICATION_PATH ]]
then
BUNDLE_VERSION=$(defaults read "$APPLICATION_PATH/Info" CFBundleVersion)
BUNDLE_SHORT_VERSION=$(defaults read "$APPLICATION_PATH/Info" CFBundleShortVersionString)
BUNDLE_IDENTIFIER=$(defaults read "$APPLICATION_PATH/Info" CFBundleIdentifier)
BUNDLE_NAME="${BUNDLE_DISPLAY_NAME} ${BUNDLE_SHORT_VERSION}(${BUNDLE_VERSION})"
APP_FILEPATH="${ARCHIVE_DIRECTORY_PATH}/${BUNDLE_EXECUTABLE_NAME}_${BUNDLE_SHORT_VERSION}.${BUNDLE_VERSION}.ipa"
DSYM_FILEPATH="${ARCHIVE_DIRECTORY_PATH}/${BUNDLE_EXECUTABLE_NAME}_${BUNDLE_SHORT_VERSION}.${BUNDLE_VERSION}.dSYM.zip"

# Archive the application for Ad-Hoc distribution
echo "Creating .ipa for ${BUNDLE_NAME}" | ${GROWL}
/usr/bin/xcrun -sdk iphoneos PackageApplication "$APPLICATION_PATH" -o "$APP_FILEPATH" --sign "$ADHOC_CERTIFICATE" --embed "$PROVISIONING_PROFILE_PATH"
echo "Created .ipa for ${BUNDLE_NAME}" | ${GROWL}

# Zip DSYM
echo "Zipping .dSYM for ${BUNDLE_NAME}" | ${GROWL}
zip -r "${DSYM_FILEPATH}" "${CONFIGURATION_BUILD_DIR}/${BUNDLE_EXECUTABLE_NAME}.app.dSYM"
echo "Created .dSYM for ${BUNDLE_NAME}" | ${GROWL}

# Upload
echo "Uploading ${BUNDLE_NAME}" | ${GROWL}

curl \
	-F file=@"${APP_FILEPATH}" \
	-F dsym=@"${DSYM_FILEPATH}" \
	-F api_token="${API_TOKEN}" \
	-F team_token="${TEAM_TOKEN}" \
	-F notes="New release" \
	-F notify="True" \
	-F distribution_lists="Internal" \
	http://testflightapp.com/api/builds.json

echo "Uploaded to TestFlight" | ${GROWL}
fi