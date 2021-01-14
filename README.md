# contact: nicholas.larue.johnson@gmail.com

#Overview of this analysis
We use the Kruskal-Wallis rank-sum test which is a non-parametric version of an ANOVA that does not require normally distributed data. For two conditions, this is the same as the Wilcoxon test performed by Dencker et al, but has the advantage of being able to compare more than 2 conditions if we need to do so in the future.

Here, we:

- perform principal components analysis on samples and proteins to look for possible outliers. Any actual
ourliers must be removed in the code.
- perform a Kruskal-Wallis rank-sum test for each of the proteins
- perform a Benjamini-Hochberg multiple-testing correction to get adjusted p-values (which are equivalent to false discovery rate, or FDR). This is less harsh of a correction than the Boneforroni-like adjustment used by Dencker et al, leading to more proteins being called as differentially abundant.

## Setup
### Installing miniconda
If it is not already installed, please follow the instructions 
[here](https://docs.conda.io/en/latest/miniconda.html).

### Setting up the environment
After installing miniconda, enter the directory containing the
requirements.txt file and activate the environment:
`conda create -p env/ --file requirements.txt`

### Setting up olink data
There should be one Excel file for every panel of Olink data.

## Steps required for analysis
1. Make metadata table
2. Make sample/panel table
3. Run Rmd file

### Making the metadata table
The purpose of this file is to match sample names with experimental groups.
Create a file, metadata.tsv, following the template in the data folder. 
The first column must be named "sample". The second must be named "group". 
Under the first column put all the sample names,
and in the second put the sample group or type.

Example:
```
sample 	group
HC_sample1	control
TR_sample2	treatment
```

### Making the sample/panel table
The purpose of this table is to match file names with panel nicknames, and to ensure
only samples are pulled from excel sheets.
Create a file, sample_table.tsv, after the template in the data folder. The name column can be 
any nickname for a panel, but should be small, simple, and alphanumeric characters only.
The sample_prefix column should have a comma-separated list of all prefixes of samples. Any prefixes
listed must be distinct to samples to exclude non-sample data. The purpose of specifying prefixes
is primarily to exclude extraneous data but can also be used to specifically choose particular 
samples.

Example:

All samples may be preceded by either ME/CFS- or HC, giving sample names 
such as:
HC-sample1, ME/CFS-sample2.

|file_name_location           | sheet_name  | name   | sample_prefix|
|:----------------------------| :-----------| :------| :------------|
|data/new_v3_Metabolism.xlsx  | NPX Data    | Metab  | ME/CFS-,HC   |
|data/new_v3_Inflammation.xlsx| Sheet1      | Inflam | ME/CFS-,HC   |
|data/new_v3_Exploratory.xlsx | Sheet1      | Exp    | ME/CFS-,HC   |


### Running
First, activate the environment as described earlier.
Next, rename the Rmd file if you choose.
Then, type `R` to activate the R interpreter.
Finally, enter rmarkdown::render("/full/path/to/olink_analysis", params=list())
Within "list", create a comma-separated list of arguments.
The only required argument is the list of contrast pairs. As many pairs of contrasts
may be listed as desired.

Example:
```
contrast_groups=list(contrast1=c("treat", "control"), contrast2=c("treat2", "treat1"))

An example of the full command:
rmarkdown::render("full/path/to/olink_analysis.Rmd", 
                    params=list(contrast_groups=list(treat_v_control=c("treat", "control")),
                                sampletable_name="data/sample_table_template.tsv",
                                metadatatable_name="data/metadata.tsv",
                                cutoff=0.75)
                    )
```
*Cutoff* refers to the maximum percentage of low-quality/invalid values permitted in a 
panel or sample before it is eliminated from the analysis. For example, the default 0.75
means only samples with >25% of proteins with valid values will be included, and similarly
only proteins with >25% of samples will be included.

## Results
The results are viewable in the html file created with the same name as the Rmd file.
