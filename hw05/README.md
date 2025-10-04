
# HW05 - Text Processing with `sed`

## Overview
This assignment focuses on processing Amazon review data using Linux command-line tools, specifically `sed`.  
The goal was to clean review text, remove unwanted characters, filter common stop words, and produce token frequency counts.

## Files
- **proj_sed.sh** – Bash script with all `sed` commands used for text cleaning.  
- **review_body_raw.txt** – Extracted raw review bodies (before cleaning).  
- **review_body_clean.txt** – Review text after cleaning (HTML tags, punctuation, and stop words removed).  
- **tokens_top.tsv** – Table of most frequent tokens from the cleaned text.  
- **product_id.txt** – Product ID that contains multiple reviews for analysis.  

## Steps Performed
1. Extracted review text from the dataset.  
2. Removed HTML tags, p
