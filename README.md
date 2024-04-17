# Differential-Expression-Analysis
The goal of differential expression testing is to determine which genes are expressed at different levels between conditions. These genes can offer biological insight into the processes affected by the condition(s) of interest.

# DESeq2

### How DESeq2 works?
**STEP1 - Size Factor Estimation and Normalization**
1. Read counts are modeled as a Negative Binomial Distribution.
2. Median-of-ratios method is used to estimate the size factors which are crucial for correcting for differences in sequencing depth between samples.
3. Normalization is then performed based on these size factors ensuring the values of genes are comparable across samples.

**STEP2 - Design Matrix Construction**
1. For categorical variables or factors with two or more levels, DESeq2 utilizes expanded design matrices. This includes an indicator variable for each level of each factor, in addition to an intercept column. This allows for a more comprehensive modeling of the data.
2. The purpose of the intercept column in the design matrix could be helpful for understanding its role in the modeling process.

<p align="center">
  <img src="images/DESeq2.png" width="500" height="200" alt="Alt Text">
</p>

**STEP3 - Dispersion Estimation**

In DESeq2, it's assumed that genes of similar average expression strength have similar dispersion. Dispersion estimation is crucial for accurately modeling the variance of gene expression counts across samples.

1. _Gene-wise Dispersion_: Begin by fitting a negative binomial GLM, which provides a rough method-of-moments estimate of dispersion based on within-group variances and means. This accounts for variability in gene expression levels across different conditions.
2. _Dispersion Fit_: Perform a regression fit of gene-wise dispersion estimates.
3. _Final Dispersion Estimate_: Form a logarithmic posterior for the dispersion and use its maximum (MAP value) as the final estimate of the dispersion.

# EdgeR
### How EdgeR works?
**Normalization**

- edgeR utilizes a weighted trimmed mean of the log expression ratios between samples for normalization. This approach accounts for differences in sequencing depth between samples and ensures that expression values are comparable across samples.

**Modeling the Data**

- The data are modeled as negative binomial (NB) distributed. Notably, the NB distribution reduces to Poisson when dispersion equals zero.

**Dispersion Estimation**

- edgeR estimates gene-wise dispersions by conditional maximum likelihood, conditioning on the total count for each gene. An empirical Bayes procedure is then applied to shrink the dispersions towards a consensus value. This procedure effectively borrows information between genes, leading to more stable dispersion estimates.

**Differential Expression Analysis**

- Differential expression is assessed for each gene using an exact test analogous to Fisher's exact test. However, this test is adapted for overdispersed data, making it suitable for the negative binomial distribution used in edgeR.

## REFERENCES
1. Love, M.I., Huber, W. & Anders, S. Moderated estimation of fold change and dispersion for RNA-seq data with DESeq2. Genome Biol 15, 550 (2014). https://doi.org/10.1186/s13059-014-0550-8 (https://genomebiology.biomedcentral.com/articles/10.1186/s13059-014-0550-8#citeas).
2. Robinson MD, McCarthy DJ, Smyth GK. edgeR: a Bioconductor package for differential expression analysis of digital gene expression data. bioinformatics. 2010 Jan 1;26(1):139-40. (https://www.ncbi.nlm.nih.gov/pmc/articles/PMC2796818/).


