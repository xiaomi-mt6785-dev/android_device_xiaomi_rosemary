/*
 * Copyright (C) 2021 The LineageOS Project
 *
 * SPDX-License-Identifier: Apache-2.0
 */

#include <libinit_dalvik_heap.h>
#include <libinit_variant.h>

#include "vendor_init.h"

static const variant_info_t maltose_info = {
    .hwc_value = "",
    .sku_value = "",
    .vendor_sku_value = "maltose",

    .brand = "Redmi",
    .device = "maltose",
    .marketname = "Redmi Note 10S",
    .model = "M2101K7BL",
    .build_fingerprint = "Redmi/maltose_global/maltose:12/SP1A.210812.016/V14.0.7.0.TKLMIXM:user/release-keys",

    .nfc = false,
};

static const variant_info_t rosemary_info = {
    .hwc_value = "",
    .sku_value = "",
    .vendor_sku_value = "rosemary",

    .brand = "Redmi",
    .device = "rosemary",
    .marketname = "Redmi Note 10S",
    .model = "M2101K7BNY",
    .build_fingerprint = "Redmi/rosemary_global/rosemary:12/SP1A.210812.016/V14.0.7.0.TKLMIXM:user/release-keys",

    .nfc = true,
};

static const variant_info_t rosemaryp_info = {
    .hwc_value = "",
    .sku_value = "",
    .vendor_sku_value = "rosemaryp",

    .brand = "POCO",
    .device = "rosemary",
    .marketname = "POCO M5s",
    .model = "2207117BPG",
    .build_fingerprint = "POCO/rosemary_p_global/rosemary:12/SP1A.210812.016/V14.0.7.0.TKLMIXM:user/release-keys",

    .nfc = true,
};

static const variant_info_t secret_info = {
    .hwc_value = "",
    .sku_value = "",
    .vendor_sku_value = "secret",

    .brand = "Redmi",
    .device = "secret",
    .marketname = "Redmi Note 10S",
    .model = "M2101K7BG",
    .build_fingerprint = "Redmi/secret_global/secret:12/SP1A.210812.016/V14.0.7.0.TKLMIXM:user/release-keys",

    .nfc = false,
};

static const variant_info_t secretr_info = {
    .hwc_value = "",
    .sku_value = "",
    .vendor_sku_value = "secretr",

    .brand = "Redmi",
    .device = "secret",
    .marketname = "Redmi Note 11 SE",
    .model = "22087RA4DI",
    .build_fingerprint = "Redmi/secret_global2/secret:12/SP1A.210812.016/V14.0.7.0.TKLMIXM:user/release-keys",

    .nfc = false,
};

static const std::vector<variant_info_t> variants = {
    maltose_info,
    rosemary_info,
    rosemaryp_info,
    secret_info,
    secretr_info,
};

void vendor_load_properties() {
    search_variant(variants);
    set_dalvik_heap();
}
