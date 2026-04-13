#!/usr/bin/env bash

if swaync-client --status-dnd | grep -q "true"; then
    echo ""
else
    echo ""
fi
