#!/usr/bin/env bash

#
# The Clear BSD License
#
# Copyright (c) 2021 Bitsy Darel
# All rights reserved.
#

echo "Installing vcshooks script..."

flutter pub global activate vcshooks

flutter pub global run vcshooks --project-type dart .
