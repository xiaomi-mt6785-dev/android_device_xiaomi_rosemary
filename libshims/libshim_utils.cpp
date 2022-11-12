/*
 * Copyright (C) 2022 The LineageOS Project
 *
 * SPDX-License-Identifier: Apache-2.0
 */

#include <utils/String8.h>

using namespace android;

extern "C" {

void _ZN7android7String87toUpperEv(String8* thisptr) {
    const size_t length = thisptr->size();
    if (length == 0) return;

    char* buf = thisptr->lockBuffer(length);
    for (size_t i = length; i > 0; --i) {
        *buf = static_cast<char>(toupper(*buf));
        buf++;
    }
    thisptr->unlockBuffer(length);
}

}
