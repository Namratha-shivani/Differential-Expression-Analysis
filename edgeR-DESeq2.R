# installing packages
if (!require("BiocManager", quietly = TRUE))
    install.packages("BiocManager")

BiocManager::install("edgeR")
BiocManager::install("DESeq2")
install.packages("EnhancedVolcano")

# laoding libraries
library(edgeR)
library(DESeq2)
library(EnhancedVolcano)

# Loding the gene counts and the meta data
counts <- read.csv('counts.csv')
covariates <- read.csv('covariates.csv') # covariates used here are the age, sex, disease

col = paste(colnames(covariates),collapse="+")
col=as.factor(col)

# performing differential expression using DESeq2
dds <- DESeqDataSetFromMatrix(countData = counts,
                              colData   = covariates,
                              design = ~age+msex+disease)

# removing genes that have counts less frequency 
dds <- dds[ rowSums(cpm(dds) >100) >= 2, ]

dds <- DESeq(dds, betaPrior = TRUE)

result_de <- subset(results(dds,alpha = 0.05),padj<0.05)
result_de <- result_de[order(result_de$padj),]
result <- data.frame(result_de)

# Creating volcano plot
EnhancedVolcano(result,rownames(result),
                x = "log2FoldChange",
                y = 'padj',
                title = "Differentially Expressed genes")


# -------------------------------------------------------------------------------------------------------------------------------

# performing differential expression using edgeR

dge <- DGEList(counts)
dge <- dge[ rowSums(cpm(dge)>100)>=2,]

design.mat <- model.matrix(~age+msex+disease, data = covariates)
d <- calcNormFactors(dge)
fit1 <- estimateDisp(d, design.mat)
fit1 <- glmFit(fit1, design.mat)
fit1 <- glmLRT(fit1)

results_ed <- subset(topTags(fit1, n=nrow(fit$table))$table, FDR <0.05)

# Creating volcano plot
EnhancedVolcano(results_ed,rownames(results_ed),
                x = "log2FoldChange",
                y = 'padj',
                title = "Differentially Expressed genes")

