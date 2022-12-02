/*
 * Copyright (C) 2021 The LineageOS Project
 *
 * SPDX-License-Identifier: Apache-2.0
 */

#include <libinit_dalvik_heap.h>
#include <libinit_variant.h>

#include "vendor_init.h"

static const variant_info_t rosemary_info = {
    .hwc_value = "Global",
    .sku_value = "",
    .device = "rosemary",
    .nfc = true,
};

static const variant_info_t secret_info = {
    .hwc_value = "Global_PA",
    .sku_value = "",
    .device = "secret",
    .nfc = false,
};

static const std::vector<variant_info_t> variants = {
    rosemary_info,
    secret_info,
};

void vendor_load_properties() {
    search_variant(variants);
    set_dalvik_heap();
}
