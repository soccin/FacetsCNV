require(tidyverse)

dz=NULL
f=function(df,pos) {

    dy=df %>%
        filter(nchar(X4)==1 & nchar(X5)==1) %>%
        mutate(X1=paste0("chr",X1)) %>%
        mutate(X8=".")

    dd=diff(dy$X2)
    ii=c(which(dd>100 | dd<0),nrow(dy))

    write_tsv(dy[ii,],OVCF,col_names=F,append=T)

}

VCF="/fscratch/socci/common_all_20180418.vcf.gz"
#VCF="test.vcf"
OVCF="dbsnp_b151_GRCh38p7_CLEAN.vcf"

header=readLines(VCF,n=1000)
header=header[grepl("^#",header)]
write(header,OVCF)

read_tsv_chunked(
    VCF,
    callback=SideEffectChunkCallback$new(f),
    comment="#",col_names=F,
    chunk_size=10000,
    progress=T
)

#df=read_tsv(VCF,comment="#",col_names=F,n_max=100,progress=T)
