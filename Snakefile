configfile: "config.yaml"


rule all:
    input:
        "results/collect_vcftools_region_res.csv"


rule vcftools_group_region:
    input:
        vcf = config["vcf"],
        keep = lambda w: config["group"][w.grp]
    output:
        "results/group_region/{grp}.{region}.vcf.gz"
    params:
        chromosome = lambda w: config["region"][w.region]["chromosome"],
        start = lambda w: config["region"][w.region]["start"],
        end = lambda w: config["region"][w.region]["end"],
    shell:
        "vcftools --gzvcf {input.vcf} --keep {input.keep} --chr {params.chromosome} --from-bp {params.start} --to-bp {params.end} --recode --stdout | bgzip > {output}"


rule vcftools_region_tajima_d:
    input:
        vcf = "{prefix}.vcf.gz",
    output:
        "{prefix}.Tajima.D"
    params:
        out = "{prefix}",
        window = config["region_window"]
    shell:
        "vcftools --gzvcf {input.vcf} --TajimaD {params.window} --out {params.out}"


rule vcftools_region_pi:
    input:
        vcf = "{prefix}.vcf.gz",
    output:
        "{prefix}.windowed.pi"
    params:
        out = "{prefix}",
        window = config["region_window"]
    shell:
        "vcftools --gzvcf {input.vcf} --window-pi {params.window} --window-pi-step {params.window} --out {params.out}"


rule scale_region_pi:
    input:
        "results/group_region/{grp}.{region}.windowed.pi"
    output:
        "results/group_region/{grp}.{region}.windowed.scaled.pi"
    params:
        start = lambda w: config["region"][w.region]["start"],
        end = lambda w: config["region"][w.region]["end"]
    script:
        "scripts/scale_region_pi.R"


rule collect_vcftools_region_res:
    input:
        expand("results/group_region/{grp}.{region}.Tajima.D", region=config["region"], grp=config["group"]),
        expand("results/group_region/{grp}.{region}.windowed.scaled.pi", region=config["region"], grp=config["group"])
    output:
        "results/collect_vcftools_region_res.csv"
    script:
        "scripts/collect_vcftools_region_res.R"

