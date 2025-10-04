Script started on 2025-10-03 18:24:30-04:00
bash-4.4$ #!/usr/bin/env bash
bash-4.4$ # HW05: sed pipelines & text cleaning (TSV)
bash-4.4$ set -euo pipefail
bash-4.4$ 
bash-4.4$ INPUT_TSV="/mnt/scratch/CS131_jelenag/reviews.tsv"
bash-4.4$ 
bash-4.4$ echo "[0/4] Choose a product..."
[0/4] Choose a product...
bash-4.4$ # Example: pick product with multiple reviews & punctuation
bash-4.4$ echo "B001234XYZ" > product_id.txt
bash-4.4$ 
bash-4.4$ PRODUCT_ID=$(< product_id.txt)
bash-4.4$ 
bash-4.4$ echo "[1/4] Extract review_body for product_id=${PRODUCT_ID} …"
[1/4] Extract review_body for product_id=B001234XYZ …
bash-4.4$ tail -n +2 "$INPUT_TSV" | grep -P "\t${PRODUCT_ID}\t" | cut -f14 > review_body_raw.ttxt
sed -E 's/^[[:space:]]+//; s/[[:space:]]+$//; s/[[:space:]]+/ /g' \
> review_body_clean.txt

echo "[3/4] Tokenize & count → tokens_top.tsv…"
tr -cs '[:alnum:]' '\n' < review_body_clean.txt | \
tr '[:upper:]' '[:lower:]' | \
sort | uniq -c | sort -k1,1nr | \
awk '{print $2 "\t" $1}' > tokens_top.tsv

echo "Done. Outputs:"
echo "  - product_id.txt"
echo "  - review_body_raw.txt"
echo "  - review_body_clean.txt"
echo "  - tokens_top.tsv"

Script done on 2025-10-03 18:24:38-04:00
