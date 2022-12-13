#
# Copyright (C) 2022 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

LOCAL_PATH := $(call my-dir)

ifneq ($(filter rosemary, $(TARGET_DEVICE)),)
include $(call all-makefiles-under,$(LOCAL_PATH))

VENDOR_SYMLINKS := \
    $(TARGET_OUT_VENDOR)/lib \
    $(TARGET_OUT_VENDOR)/lib64 \
    $(TARGET_OUT_VENDOR)/lib/hw \
    $(TARGET_OUT_VENDOR)/lib64/hw

$(VENDOR_SYMLINKS): $(LOCAL_INSTALLED_MODULE)
	$(hide) echo "Making vendor symlinks"
	@mkdir -p $(TARGET_OUT_VENDOR)/lib/hw
	@mkdir -p $(TARGET_OUT_VENDOR)/lib64/hw
	@ln -sf libSoftGatekeeper.so $(TARGET_OUT_VENDOR)/lib/hw/gatekeeper.default.so
	@ln -sf libSoftGatekeeper.so $(TARGET_OUT_VENDOR)/lib64/hw/gatekeeper.default.so
	@ln -sf $(TARGET_BOARD_PLATFORM)/libdpframework.so $(TARGET_OUT_VENDOR)/lib/libdpframework.so
	@ln -sf $(TARGET_BOARD_PLATFORM)/libpq_prot.so $(TARGET_OUT_VENDOR)/lib/libpq_prot.so
	@ln -sf $(TARGET_BOARD_PLATFORM)/libmtk_drvb.so $(TARGET_OUT_VENDOR)/lib/libmtk_drvb.so
	@ln -sf $(TARGET_BOARD_PLATFORM)/libnir_neon_driver.so $(TARGET_OUT_VENDOR)/lib/libnir_neon_driver.so
	@ln -sf $(TARGET_BOARD_PLATFORM)/libdpframework.so $(TARGET_OUT_VENDOR)/lib64/libdpframework.so
	@ln -sf $(TARGET_BOARD_PLATFORM)/libpq_prot.so $(TARGET_OUT_VENDOR)/lib64/libpq_prot.so
	@ln -sf $(TARGET_BOARD_PLATFORM)/libmcv_runtime.mtk.so $(TARGET_OUT_VENDOR)/lib64/libmcv_runtime.mtk.so
	@ln -sf $(TARGET_BOARD_PLATFORM)/libmtk_drvb.so $(TARGET_OUT_VENDOR)/lib64/libmtk_drvb.so
	@ln -sf $(TARGET_BOARD_PLATFORM)/libnir_neon_driver.so $(TARGET_OUT_VENDOR)/lib64/libnir_neon_driver.so
	@ln -sf $(TARGET_BOARD_PLATFORM)/libneuron_runtime.5.so $(TARGET_OUT_VENDOR)/lib64/libneuron_runtime.5.so
	@ln -sf $(TARGET_BOARD_PLATFORM)/libneuron_runtime.so $(TARGET_OUT_VENDOR)/lib64/libneuron_runtime.so
	@ln -sf /vendor/lib/egl/libGLES_mali.so $(TARGET_OUT_VENDOR)/lib/hw/vulkan.$(TARGET_BOARD_PLATFORM).so
	@ln -sf /vendor/lib64/egl/libGLES_mali.so $(TARGET_OUT_VENDOR)/lib64/hw/vulkan.$(TARGET_BOARD_PLATFORM).so
	$(hide) touch $@

ALL_DEFAULT_INSTALLED_MODULES += $(VENDOR_SYMLINKS)

endif
