
tajima_files <- list.files("results/group_region", full.names=T, pattern="Tajima")

tajima <- vapply(tajima_files, function(x) {
    df <- read.table(x, header=T)
    if (nrow(df) > 0) return(df$TajimaD)
    else return(NA)
    }, double(1))
names(tajima) <- sub("results/group_region/(\\S+)\\.Tajima\\.D", "\\1", names(tajima))

tajima_s <- vapply(tajima_files, function(x) {
    df <- read.table(x, header=T)
    if (nrow(df) > 0) return(df$N_SNPS)
    else return(NA)
    }, double(1))
names(tajima_s) <- sub("results/group_region/(\\S+)\\.Tajima\\.D", "\\1", names(tajima))

pi_files <- list.files("results/group_region", full.names=T, pattern="scaled\\.pi")

pi <- vapply(pi_files, function(x) {
    df <- read.table(x, header=T)
    if (nrow(df) > 0) return(df$PI)
    else return(NA)
    }, double(1))
names(pi) <- sub("results/group_region/(\\S+)\\.windowed\\.scaled\\.pi", "\\1", names(pi))

df <- data.frame(
    Region = strsplit(names(tajima), "\\.") |> sapply(function(x) x[[1]]),
    Group = strsplit(names(tajima), "\\.") |> sapply(function(x) x[[2]]),
    TajimaD = tajima,
    S = tajima_s[names(tajima)],
    pi = pi[names(tajima)]
)

write.csv(df, snakemake@output[[1]], row.names=F)
