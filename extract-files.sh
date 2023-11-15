#!/bin/bash
#
# Copyright (C) 2016 The CyanogenMod Project
# Copyright (C) 2017-2020 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

set -e

DEVICE=rosemary
VENDOR=xiaomi

# Load extract_utils and do some sanity checks
MY_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "${MY_DIR}" ]]; then MY_DIR="${PWD}"; fi

ANDROID_ROOT="${MY_DIR}/../../.."

HELPER="${ANDROID_ROOT}/tools/extract-utils/extract_utils.sh"
if [ ! -f "${HELPER}" ]; then
    echo "Unable to find helper script at ${HELPER}"
    exit 1
fi
source "${HELPER}"

# Default to sanitizing the vendor folder before extraction
CLEAN_VENDOR=true

KANG=
SECTION=

while [ "${#}" -gt 0 ]; do
    case "${1}" in
        -n | --no-cleanup )
                CLEAN_VENDOR=false
                ;;
        -k | --kang )
                KANG="--kang"
                ;;
        -s | --section )
                SECTION="${2}"; shift
                CLEAN_VENDOR=false
                ;;
        * )
                SRC="${1}"
                ;;
    esac
    shift
done

if [ -z "${SRC}" ]; then
    SRC="adb"
fi

function blob_fixup {
    case "$1" in
        vendor/bin/mnld)
            "${PATCHELF}" --replace-needed "libsensorndkbridge.so" "libsensorndkbridge-hidl.so" "$2"
            ;;
        vendor/bin/mtk_agpsd)
           "${PATCHELF}" --replace-needed "libcrypto.so" "libcrypto-v32.so" "${2}"
           "${PATCHELF}" --replace-needed "libssl.so" "libssl-v32.so" "${2}"           
            ;;
        vendor/bin/hw/android.hardware.gnss-service.mediatek |\
        vendor/lib64/hw/android.hardware.gnss-impl-mediatek.so)
            "$PATCHELF" --replace-needed "android.hardware.gnss-V1-ndk_platform.so" "android.hardware.gnss-V1-ndk.so" "$2"
            ;;
        vendor/bin/hw/vendor.mediatek.hardware.mtkpower@1.0-service)
            "${PATCHELF}" --replace-needed "android.hardware.power-V2-ndk_platform.so" "android.hardware.power-V2-ndk.so" "${2}"
            ;;
        vendor/lib64/libwifi-hal-mtk.so)
            "$PATCHELF" --set-soname libwifi-hal-mtk.so "${2}"
            ;;
        vendor/lib64/libmtkcam_stdutils.so)
            "${PATCHELF}" --replace-needed "libutils.so" "libutils-v32.so" "${2}"
            ;;
        vendor/lib*/hw/vendor.mediatek.hardware.pq@2.13-impl.so)
            "${PATCHELF}" --replace-needed "libutils.so" "libutils-v32.so" "${2}"
            ;;
        vendor/lib64/libvendor.goodix.hardware.biometrics.fingerprint@2.1.so)
            "${PATCHELF_0_8}" --remove-needed "libhidlbase.so" "${2}"
            sed -i "s/libhidltransport.so/libhidlbase-v32.so\x00/" "${2}"
            ;;
        vendor/lib*/libaalservice.so)
            "${PATCHELF}" --replace-needed "libsensorndkbridge.so" "libsensorndkbridge-hidl.so" "$2"
            ;;
        vendor/lib*/libcam.utils.sensorprovider.so)
            "${PATCHELF}" --replace-needed "libsensorndkbridge.so" "libsensorndkbridge-hidl.so" "$2"
            ;;
        vendor/lib64/libgf_hal.so)
            sed -i 's/\xff\xc3\x01\xd1\xfd\x7b\x06\xa9/\x00\x00\x80\xd2\xc0\x03\x5f\xd6/g' "${2}"
            ;;
        vendor/lib*/librgbwlightsensor.so)
            "${PATCHELF}" --replace-needed "libsensorndkbridge.so" "libsensorndkbridge-hidl.so" "$2"
            ;;
        vendor/lib64/hw/fingerprint.fpc.default.so)
            sed -i 's/\xff\x43\x01\xd1\xfd\x7b\x02\xa9/\xc0\x03\x5f\xd6\xfd\x7b\x02\xa9/g' "${2}"
            ;;
        lib64/libsink.so)
            "${PATCHELF}" --add-needed "libshim_sink.so" "$2"
            ;;
    esac
}

# Initialize the helper
setup_vendor "${DEVICE}" "${VENDOR}" "${ANDROID_ROOT}" false "${CLEAN_VENDOR}"

extract "${MY_DIR}/proprietary-files.txt" "${SRC}" "${KANG}" --section "${SECTION}"

"${MY_DIR}/setup-makefiles.sh"
