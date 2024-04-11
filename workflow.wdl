version 1.0

workflow check_VCFs {

    meta {
	author: "Phuwanat"
        email: "phuwanat.sak@mahidol.edu"
        description: "Check VCF"
    }

     input {
        Array[File] vcf_files
        File ref_fa
        File ref_fai
    }

    scatter(this_file in vcf_files) {
		call run_checking { 
			input: vcf = this_file, ref_fa = ref_fa, ref_fai = ref_fai
		}
	}

    output {
        Array[Array[File]] report_files = run_checking.out_files
    }

}

task run_checking {
    input {
        File vcf
        File ref_fa
        File ref_fai
        Int memSizeGB = 8
        Int threadCount = 2
        Int diskSizeGB = 2*round(size(vcf, "GB")) + 10
	String out_name = basename(vcf, ".vcf.gz")
    }
    
    command <<<
	python /checkVCF/checkVCF.py -r ~{ref_fa} -o ~{out_name} ~{vcf}
    >>>

    output {
        Array[File] out_files = glob("*.check.*")
    }

    runtime {
        memory: memSizeGB + " GB"
        cpu: threadCount
        disks: "local-disk " + diskSizeGB + " SSD"
        docker: "phuwanat/checkvcf:v2"   # digest: quay.io/biocontainers/bcftools:1.16--hfe4b78e_1
        preemptible: 2
    }

}
