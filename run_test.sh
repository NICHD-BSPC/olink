#!/usr/bin/env bash

Rscript -e "rmarkdown::render('olink_analysis.Rmd', params=list(contrast_groups=list(B1_v_T1=c('B', 'T1'), B_vs_HC=c('B','HC'), T1_vs_HC=c('T1', 'HC')), sampletable_name='data/sample_table_template.tsv', metadatatable_name='data/metadata.tsv', cutoff=0.75))"
