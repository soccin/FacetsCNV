samtools view -H $1 \
    | egrep "^@RG" \
    | fgrep SM: \
    | tr '\t' '\n' \
    | fgrep SM: \
    | uniq \
    | sed 's/SM://' \
    | xargs \
    | tr ' ' ','
