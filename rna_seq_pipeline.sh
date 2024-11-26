#Clean raw data
fastp -i ${i}.R1.fq.gz -o ${i}_clean.R1.fq.gz -I ${i}.R2.fq.gz -O ${i}_clean.R2.fq.gz
#Align clean data to the reference genome
hisat2 --dta -t -p 8 --rna-strandness RF -x hisat2_index \
 -1 ${i}_clean.R1.fq.gz \
 -2 ${i}_clean.R2.fq.gz \
 -S ${i}.sam
samtools view -bhS ${i}.sam | samtools sort -@ 4 -o ${i}_sorted.bam
samtools index ${i}_sorted.bam
#Calculate gene expression with featurecounts
featureCounts -T 10 -p -a anno.gtf -o readcounts.txt ${i}_sorted.bam 