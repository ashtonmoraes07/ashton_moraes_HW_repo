#!/bin/bash
# hw6_awk.sh
# Author: Ashton Moraes
# Description: Generates all HW06 task outputs using awk, cut, and sort

# Ensure output directory exists
mkdir -p hw06/out

##########################
# Task 1: Column selection & header
##########################
echo "Running Task 1..."
cut -f1,3,4,7,8,9 /mnt/scratch/CS131_jelenag/reviews.tsv | head -n 1 > hw06/out/task1.tsv
cut -f1,3,4,7,8,9 /mnt/scratch/CS131_jelenag/reviews.tsv | tail -n +2 >> hw06/out/task1.tsv

##########################
# Task 2: Verified-only, non-empty review text
##########################
echo "Running Task 2..."
awk -F'\t' 'NR==1 {
    print "review_id\tproduct_id\tproduct_category\tstar_rating\thelpful_votes\ttotal_votes"
    next
}
{
    body = $14
    gsub(/^ +| +$/, "", body)
    if ($12 == "Y" && length(body) >= 30)
        print $3 "\t" $4 "\t" $7 "\t" $8 "\t" $9 "\t" $10
}' /mnt/scratch/CS131_jelenag/reviews.tsv > hw06/out/task2.tsv

##########################
# Task 3: Helpfulness ratio bands
##########################
echo "Running Task 3..."
awk -F'\t' 'NR>1 {
    total = $10
    helpful = $9
    if (total == 0) band = "NA"
    else {
        ratio = helpful / total
        if (ratio >= 0.8) band = "HI"
        else if (ratio >= 0.5) band = "MID"
        else if (ratio >= 0.1) band = "LO"
        else band = "ZERO"
    }
    count[band]++
}
END {
    print "band\tcount"
    for (b in count)
        print b "\t" count[b]
}' /mnt/scratch/CS131_jelenag/reviews.tsv | sort -nr -k2,2 > hw06/out/task3.tsv

##########################
# Task 4: Per-product rating summary (min 50 reviews)
##########################
echo "Running Task 4..."
awk -F'\t' 'NR>1 {
    pid = $4
    sum[pid] += $8
    count[pid]++
}
END {
    print "product_id\tcount\tavg_star_rating"
    for (p in sum)
        if (count[p] >= 50)
            printf "%s\t%d\t%.2f\n", p, count[p], sum[p]/count[p]
}' /mnt/scratch/CS131_jelenag/reviews.tsv | sort -k3,3nr -k2,2nr > hw06/out/task4.tsv

##########################
# Task 5: Category × star distribution (verified only)
##########################
echo "Running Task 5..."
awk -F'\t' 'NR>1 && $12=="Y" {
    cat = $7
    star = $8
    star_count[cat, star]++
    total[cat]++
}
END {
    print "product_category\tstar_1\tstar_2\tstar_3\tstar_4\tstar_5\ttotal"
    for (c in total)
        printf "%s\t%d\t%d\t%d\t%d\t%d\t%d\n", c, star_count[c,1], star_count[c,2], star_count[c,3], star_count[c,4], star_count[c,5], total[c]
}' /mnt/scratch/CS131_jelenag/reviews.tsv | sort -t$'\t' -k7,7nr > hw06/out/task5.tsv

##########################
# Task 6: Monthly review volume & avg star
##########################
echo "Running Task 6..."
awk -F'\t' 'NR>1 {
    month = substr($15,1,7)
    sum[month] += $8
    count[month]++
}
END {
    print "month\tcount\tavg_star_rating"
    for (m in sum)
        printf "%s\t%d\t%.2f\n", m, count[m], sum[m]/count[m]
}' /mnt/scratch/CS131_jelenag/reviews.tsv | sort -k1,1 > hw06/out/task6.tsv

##########################
# Task 7: Keyword signal (broken|defect|return|refund)
##########################
echo "Running Task 7..."
awk -F'\t' 'NR>1 && $12=="Y" {
    body = tolower($14)
    if (body ~ /broken/) count["broken"]++
    else if (body ~ /defect/) count["defect"]++
    else if (body ~ /return/) count["return"]++
    else if (body ~ /refund/) count["refund"]++
}
END {
    print "keyword\tcount"
    for (k in count) print k "\t" count[k]
}' /mnt/scratch/CS131_jelenag/reviews.tsv | sort -nr -k2,2 > hw06/out/task7.tsv

##########################
# Task 8: Power users (≥5 reviews/day)
##########################
echo "Running Task 8..."
awk -F'\t' 'NR>1 {
    key = $2 "\t" $15
    count[key]++
}
END {
    print "customer_id\tdate\tcount"
    for (k in count)
        if (count[k] >= 5) print k "\t" count[k]
}' /mnt/scratch/CS131_jelenag/reviews.tsv | sort -t$'\t' -k3,3nr -k2,2 > hw06/out/task8.tsv

##########################
# Task 9: Category verified-purchase share
##########################
echo "Running Task 9..."
awk -F'\t' 'NR>1 {
    cat = $7
    total[cat]++
    if ($12=="Y") verified[cat]++
}
END {
    print "product_category\tcount_all\tpct_verified"
    for (c in total)
        printf "%s\t%d\t%.1f\n", c, total[c], (verified[c]/total[c])*100
}' /mnt/scratch/CS131_jelenag/reviews.tsv | sort -t$'\t' -k3,3nr -k2,2nr > hw06/out/task9.tsv

##########################
# Task 10: Top-N products by helpfulness lift (count_all ≥100)
##########################
echo "Running Task 10..."
awk -F'\t' 'NR>1 && $10>0 {
    pid=$4
    sum_ratio[pid] += ($9/$10)
    count_with_votes[pid]++
    count_all[pid]++
}
NR>1 && $10==0 {
    pid=$4
    count_all[pid]++
}
END {
    print "product_id\tcount_all\tavg_helpfulness_ratio"
    for (p in count_all)
        if (count_all[p]>=100 && count_with_votes[p]>0)
            printf "%s\t%d\t%.2f\n", p, count_all[p], sum_ratio[p]/count_with_votes[p]
}' /mnt/scratch/CS131_jelenag/reviews.tsv | sort -t$'\t' -k3,3nr -k2,2nr > hw06/out/task10.tsv

echo "All tasks completed! Outputs are in hw06/out/"

