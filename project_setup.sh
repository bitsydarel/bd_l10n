#!/usr/bin/env bash

#
# The Clear BSD License
#
# Copyright (c) 2021 Bitsy Darel
# All rights reserved.
#

echo "Installing vcshooks script..."

pub global activate vcshooks 1.0.0-nullsafety.0

pub global run vcshooks --project-type dart .
