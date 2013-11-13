#chklnk
#
# Copyright (C) 2013  hoholee12@naver.com
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# Changelogs:
# alpha version
# 0.0.1 - first release
set +e
if [ ! $1 ]; then
	return 1
fi
file=$1
dir=$(dirname $file)
base=$(basename $file)
if [ ! -e $file ] && [ ! -d $file ]; then
	echo "$file: not found"
	return 127
fi
count=0
for i in $(ls -l $dir | grep $base | head -1); do
	count=$((count+1))
	if [ $i == "->" ]; then
		found=y
		break
	fi
done
if [ ! $found ] || [ $file == "/" ]; then
	echo "$file: is not a symlink"
	return 1
fi
#link=$((count-1))
orig=$((count+1))
linked_file=$(ls -l $dir | grep $base | head -1 | awk '{print $'"$orig"'}')
echo "$linked_file"

