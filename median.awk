#/usr/bin/env awk
# This program prints median of numeric data from first column
{
	count[NR] = $1;
}
END {
	if (NR % 2) {
		print count[(NR + 1) / 2];
	} else {
		print (count[(NR / 2)] + count[(NR / 2) + 1]) / 2.0
	}
}