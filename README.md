## DIY Population PCA
Overlay your samples (vcf) onto the 1000G dataset. Obviously you can use another population VCF if you have other needs. You will need your "population" VCF to have genotypes for every individual person, otherwise....this can't work. 

## Step One - Get akt
Illumina's [akt](https://github.com/Illumina/akt) can calculate PCA for a multi-sample VCF

## Step Two - Get 1000G VCF
I'm going to 100% cheat and just grab it from [biowulf](hpc.nih.gov), as the admins have made a merged all chromosome vcf `/fdb/1000genomes/release/20130502/reduced.ALL.phase3_shapeit2_mvncall_integrated_v5.20130502.genotypes.vcf.gz`

If you are starting from scratch then you'll have the download the chromosome specific vcfs from http://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/ then merge them all together with something like `bcftools concat`.

**Open a github issue if you want to be lazy and I'll make this file available to you**

## Step Three - Only keep AC above 30 and PASS on your VCF
Obviously tweak `FAIL_MCGAUGHEY` to match your FAIL pattern (usually just `FAIL`)
`bcftools view --min-ac 30 ../vcfs.GATK.vcf.gz | zgrep -v FAIL_MCGAUGHEY | bgzip > vcfs.AC30.PASS.vcf.gz`

`tabix -p vcf vcfs.AC30.PASS.vcf.gz`

## Step Four - Filter down 1000G VCF to positions in your VCF
`bcftools isec /fdb/1000genomes/release/20130502/reduced.ALL.phase3_shapeit2_mvncall_integrated_v5.20130502.genotypes.vcf.gz vcfs.AC30.PASS.vcf.gz -p intersection -n =2 -w 1 -O z`

## Step Five - Merge VCFs together
`bcftools merge vcfs.AC30.PASS.vcf.gz intersection/0000.vcf.gz -O z -o cohort_1000G.vcf.gz`

`tabix -p cohort_1000G.vcf.gz`

## Step Six - Run akt pca
`~/git/akt/./akt pca --force cohort_1000G.vcf.gz  > akt.pca.txt`

## Step Seven - Plot
Run [pca_plot.R](pca_plot.R)
