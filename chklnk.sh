#chklnk
if [ ! $1 ]; then
	return 1
fi
file=$1
dir=$(dirname $file)
base=$(basename $file)
if [ ! -e $file ] && [ ! -d $file ]; then
	echo "$file: not found"
	return 1
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

