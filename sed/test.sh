echo "the day and night and day" | sed 's/day/night/'
echo "the day and night and day" | sed 's/day/night/g'

echo "/usr/local/bin/" | sed 's/\/usr\/local\/bin/\/common\/bin/'
echo "/usr/local/bin/" | sed 's:/usr/local/bin:/common/bin:'
echo "/usr/local/bin/" | sed 's|/usr/local/bin|/common/bin|'

echo "123 abc" | sed 's/[0-9][0-9]*/& &/'

echo "abcd123" | sed 's/\([a-z]*\).*/\1/'
echo "abcd123" | sed 's/\([a-z]*\)/\1/' # all
echo "ABCDabcd123" | sed 's/\([a-z]*\).*/\1/' # nothing
echo "ABCDabcd123" | sed 's/\([a-z]*\)/\1/' # all

echo "HELLO hello world 123" | sed 's/\([a-z][a-z]*\) \([a-z][a-z]*\)/\2 \1/'