#!/bin/sh
# simple calculator example based on flex/bison
# Copyright (C) 2011  anton0xf <anton0xf@gmail.com>

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

echo "$1"
(echo "$1" | ./$PROGRAM) || echo FAIL
val=$(echo "$1" | ./$PROGRAM)
if [ "$val" = "$2" ]
then
    echo " ---------------- OK"
else
    echo " ---------------- FAIL"
fi
