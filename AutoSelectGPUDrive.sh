#!/bin/bash

# 檢測 GPU 類型（假設 Adreno）
GPU=$(cat /proc/cpuinfo | grep -i "adreno" || echo "unknown")
HAS_ADRENO=$(echo "$GPU" | grep -i "adreno" | wc -l)

# 檢測主機 Vulkan 可用性
HAS_HOST_VULKAN=$(ls /system/lib64/libvulkan.so 2>/dev/null && echo "yes" || echo "no")

# 檢測 Turnip 安裝
HAS_TURNIP=$(ls /usr/share/vulkan/icd.d/freedreno_icd* 2>/dev/null && echo "yes" || echo "no")

# 檢測 virglrenderer-android（假設已裝）
HAS_VIRGL=$(ls /data/data/com.termux/files/usr/lib/libvirglrenderer.so 2>/dev/null && echo "yes" || echo "no")

echo "檢測結果：Adreno=$HAS_ADRENO, 主機Vulkan=$HAS_HOST_VULKAN, Turnip=$HAS_TURNIP, VirGL=$HAS_VIRGL"

# 自動選擇邏輯
if [ "$HAS_ADRENO" -gt 0 ] && [ "$HAS_TURNIP" = "yes" ]; then
    echo "使用 Turnip + Zink（Adreno GPU 同 Turnip 可用）"
    export VK_ICD_FILENAMES=/usr/share/vulkan/icd.d/freedreno_icd.aarch64.json
    export MESA_LOADER_DRIVER_OVERRIDE=zink
elif [ "$HAS_HOST_VULKAN" = "yes" ]; then
    echo "使用 Android 主機 Vulkan + Zink（主機 Vulkan 可用）"
    export LD_LIBRARY_PATH=/system/lib64:$LD_LIBRARY_PATH
    export VK_ICD_FILENAMES=/system/lib64/vulkan/icd.d/qcom_icd.json
    export MESA_LOADER_DRIVER_OVERRIDE=zink
elif [ "$HAS_VIRGL" = "yes" ]; then
    echo "使用 virglrenderer-android（VirGL 可用）"
    export GALLIUM_DRIVER=virgl
else
    echo "無可用 GPU 加速，使用 llvmpipe（軟件渲染）"
    export MESA_LOADER_DRIVER_OVERRIDE=llvmpipe
fi