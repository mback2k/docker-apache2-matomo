#!/bin/bash

if [ ! -f "${MATOMO_CONFIG_DIR}/matomo.js" ]; then
    cp -ar "${MATOMO_CONFIG_DIST_DIR}" -T "${MATOMO_CONFIG_DIR}"
fi

exit 0
