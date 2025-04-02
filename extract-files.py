#!/usr/bin/env -S PYTHONPATH=../../../tools/extract-utils python3
#
# SPDX-FileCopyrightText: 2024 The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

from extract_utils.fixups_blob import (
    blob_fixup,
    blob_fixups_user_type,
)
from extract_utils.fixups_lib import (
    lib_fixup_remove,
    lib_fixups,
    lib_fixups_user_type,
)
from extract_utils.main import (
    ExtractUtils,
    ExtractUtilsModule,
)

namespace_imports = [
    'hardware/mediatek',
    'hardware/xiaomi',
    'vendor/xiaomi/rosemary'
]


def lib_fixup_vendor_suffix(lib: str, partition: str, *args, **kwargs):
    return f'{lib}_{partition}' if partition == 'vendor' else None


lib_fixups: lib_fixups_user_type = {
    **lib_fixups,
    ('vendor.mediatek.hardware.videotelephony@1.0',): lib_fixup_vendor_suffix,
}

blob_fixups: blob_fixups_user_type = {
    'system_ext/lib64/libimsma.so': blob_fixup()
        .replace_needed('libsink.so', 'libsink-mtk.so'),
    'system/priv-app/ImsService/ImsService.apk': blob_fixup()
        .apktool_patch('blob-patches/ImsService.patch', '-r'),
    ('vendor/bin/hw/android.hardware.gnss-service.mediatek', 'vendor/lib64/hw/android.hardware.gnss-impl-mediatek.so'): blob_fixup()
        .replace_needed('android.hardware.gnss-V1-ndk_platform.so', 'android.hardware.gnss-V1-ndk.so'),
    'vendor/bin/hw/android.hardware.media.c2@1.2-mediatek-64b': blob_fixup()
        .add_needed('libstagefright_foundation-v33.so')
        .replace_needed('libavservices_minijail_vendor.so', 'libavservices_minijail.so'),
    'vendor/bin/hw/mtkfusionrild' : blob_fixup()
        .add_needed('libutils-v32.so'),
    'vendor/bin/hw/vendor.mediatek.hardware.mtkpower@1.0-service': blob_fixup()
        .replace_needed('android.hardware.power-V2-ndk_platform.so', 'android.hardware.power-V2-ndk.so'),
    'vendor/etc/init/android.hardware.media.c2@1.2-mediatek.rc': blob_fixup()
        .add_line_if_missing('    interface android.hardware.media.c2@1.0::IComponentStore default')
        .add_line_if_missing('    interface android.hardware.media.c2@1.1::IComponentStore default')
        .add_line_if_missing('    interface android.hardware.media.c2@1.2::IComponentStore default'),
    'vendor/lib64/libmtkcam_featurepolicy.so': blob_fixup()
        .binary_regex_replace(b'\x34\xE8\x87\x40\xB9', b'\x34\x28\x02\x80\x52'),
    'vendor/lib/hw/audio.primary.mt6785.so' : blob_fixup()
        .add_needed('libstagefright_foundation-v33.so')
        .replace_needed('libalsautils.so', 'libalsautils-v31.so'),
    ('vendor/lib64/libmtkcam_stdutils.so', 'vendor/lib64/hw/android.hardware.camera.provider@2.6-impl-mediatek.so'): blob_fixup()
        .replace_needed('libutils.so', 'libutils-v32.so'),
    ('vendor/bin/mnld', 'vendor/lib64/libaalservice.so', 'vendor/lib64/libcam.utils.sensorprovider.so', 'vendor/lib64/librgbwlightsensor.so'): blob_fixup()
        .replace_needed('libsensorndkbridge.so', 'android.hardware.sensors@1.0-convert-shared.so'),
    'vendor/lib64/hw/vendor.mediatek.hardware.pq@2.15-impl.so': blob_fixup()
        .replace_needed('libutils.so', 'libutils-v32.so'),
    'vendor/lib64/libgf_hal.so': blob_fixup()
        .binary_regex_replace(b'\xFF\xC3\x01\xD1\xFD\x7B\x06\xA9', b'\x00\x00\x80\xD2\xC0\x03\x5F\xD6'),
    'vendor/lib64/hw/fingerprint.fpc.default.so': blob_fixup()
        .binary_regex_replace(b'\xFF\x43\x01\xD1\xFD\x7B\x02\xA9', b'\xC0\x03\x5F\xD6\xFD\x7B\x02\xA9'),
    ('vendor/lib64/libteei_daemon_vfs.so', 'vendor/lib64/lib3a.flash.so'): blob_fixup()
         .add_needed('liblog.so'),
     'vendor/lib64/libmnl.so' : blob_fixup()
         .add_needed('libcutils.so'),
    ('vendor/lib/libnvram.so', 'vendor/lib64/libnvram.so', 'vendor/lib64/libsysenv.so', 'vendor/bin/hw/android.hardware.neuralnetworks@1.3-service-mtk-neuron') : blob_fixup()
         .add_needed('libbase_shim.so'),
    'vendor/lib64/hw/hwcomposer.mt6785.so' : blob_fixup()
         .add_needed('libprocessgroup_shim.so'),
    'vendor/lib64/libgoodixhwfingerprint.so': blob_fixup()
        .replace_needed('libvendor.goodix.hardware.biometrics.fingerprint@2.1.so', 'vendor.goodix.hardware.biometrics.fingerprint@2.1.so')
}  # fmt: skip

module = ExtractUtilsModule(
    'rosemary',
    'xiaomi',
    blob_fixups=blob_fixups,
    lib_fixups=lib_fixups,
    namespace_imports=namespace_imports,
    add_firmware_proprietary_file=True,
)

if __name__ == '__main__':
    utils = ExtractUtils.device(module)
    utils.run()
