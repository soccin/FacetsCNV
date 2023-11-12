#!/bin/bash

set -e

SDIR="$( cd "$( dirname "$0" )" && pwd )"

TUMOR=$1
NORMAL=$2

GENOME=$($SDIR/Facets.app/bin/getGenomeBuildBAM.sh $TUMOR)

case $GENOME in

    b37)
    VCF=$SDIR/Facets.app/dat/human_hg19_b137_facets.vcf.gz
    ;;

    *)
    echo
    echo "Unknown genome "$GENOME
    echo
    exit
    ;;
esac

if [[ ! "$LD_LIBRARY_PATH" =~ htslib/htslib-1.9 ]]; then
    echo "Add htslib-1.9 to lib path"
    export LD_LIBRARY_PATH=/opt/common/CentOS_7-dev/htslib/htslib-1.9:$LD_LIBRARY_PATH
fi

normalId=$($SDIR/Facets.app/bin/getBAMSMTag.sh $NORMAL)
tumorId=$($SDIR/Facets.app/bin/getBAMSMTag.sh $TUMOR)


ODIR=counts/$(basename ${VCF/.vcf*/})/${tumorId}___${normalId}
mkdir -p $ODIR
echo
echo $ODIR
echo

$SDIR/Facets.app/bin/snp-pileup -g -A -P 100 -r 25,0 -q 15 -Q 20 -v $VCF \
    $ODIR/counts_${tumorId}___${normalId}_.txt.gz $NORMAL $TUMOR

md5sum $ODIR/counts_${tumorId}___${normalId}_.txt.gz >$ODIR/counts_${tumorId}___${normalId}_.txt.gz.md5
