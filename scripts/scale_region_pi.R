windowed_pi <- readr::read_tsv(snakemake@input[[1]])

if (nrow(windowed_pi) == 0) {
    windowed_pi$PI <- NA
} else {
    windowed_pi$PI <- windowed_pi$PI * (windowed_pi$BIN_END - windowed_pi$BIN_START + 1) / (snakemake@params$end - snakemake@params$start + 1)
}

windowed_pi$BIN_START <- snakemake@params$start
windowed_pi$BIN_END <- snakemake@params$end

readr::write_tsv(windowed_pi, snakemake@output[[1]])

