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

    .nfc = false,
};

static const std::vector<variant_info_t> variants = {
    maltose_info,
    rosemary_info,
    rosemaryp_info,
    secret_info,
    secretr_info,
};

void vendor_process_bootenv() {
    search_variant(variants);
    set_dalvik_heap();
}

void vendor_load_properties() {
#if __ANDROID_API__ < 36
    vendor_process_bootenv();
#endif
}
