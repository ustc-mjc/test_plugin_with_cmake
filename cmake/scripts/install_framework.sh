#! /bin/bash
set -ex

if [ -d $1 ]; then
    TARGET_FRAMEWORK=$1
    FRAMEWORK_NAME=$(basename ${TARGET_FRAMEWORK})
    BASE_NAME=${FRAMEWORK_NAME%.*}
else
    BASE_NAME=$1
    TARGET_FRAMEWORK=${CONFIGURATION_BUILD_DIR}/${BASE_NAME}.framework
fi
check_info_plist=$2

if [ ! -d ${TARGET_FRAMEWORK} ]; then
    echo "cannot find ${BASE_NAME}.framework at ${TARGET_FRAMEWORK}"
    exit 1
fi

# check info.plist
if [ ${check_info_plist} = "true" ];then
    if [ ! -f ${TARGET_FRAMEWORK}/Info.plist ]; then
        echo "First check: cannot find ${TARGET_FRAMEWORK}/Info.plist"
        exit 1
    fi
fi

# Create the framework folder
mkdir -p ${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}
# Copy all to the target folder
rm -rf ${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}/${BASE_NAME}.framework
cp -aH ${TARGET_FRAMEWORK} ${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}

rm -rf ${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}/${BASE_NAME}.framework/Headers
if [ -d ${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}/${BASE_NAME}.framework/Versions ]; then
    rm -rf ${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}/${BASE_NAME}.framework/Versions/Current/Headers
fi

# double check info.plist
if [ ${check_info_plist} = "true" ];then
    if [ ! -f ${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}/${BASE_NAME}.framework/Info.plist ]; then
        echo "Double check: cannot find ${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}/${BASE_NAME}.framework/Info.plist"
        exit 1
    fi
fi

code_sign_if_enabled() {
    if [ -n "${EXPANDED_CODE_SIGN_IDENTITY:-}" -a "${CODE_SIGNING_ALLOWED}" != "NO" ]; then
        # Use the current code_sign_identity
        echo "Code Signing $1 with Identity ${EXPANDED_CODE_SIGN_IDENTITY_NAME}"
        local code_sign_cmd="/usr/bin/codesign --force --sign ${EXPANDED_CODE_SIGN_IDENTITY} ${OTHER_CODE_SIGN_FLAGS:-} --preserve-metadata=identifier,entitlements '$1'"

        echo "$code_sign_cmd"
        eval "$code_sign_cmd"
    fi
}

# if [ "${CONFIGURATION}" == "Debug" && "${ARCHS}" == "arm64" $$ "${PLATFORM_NAME}" == "iphoneos" ]; then 
if [ "${CONFIGURATION}" == "Debug" ]; then 
    code_sign_if_enabled ${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}/${BASE_NAME}.framework
else
    echo "nothing to do"
    # codesign --remove-signature ${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}/${BASE_NAME}.framework
fi
