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
    }

    scatter(this_file in vcf_files) {
		call run_checking { 
			input: vcf = this_file, ref_fa = ref_fa
		}
	}

    output {
        Array[File] report.file = run_checking.out_file
    }

}

task run_checking {
    input {
        File vcf
        File ref_fa
        Int memSizeGB = 8
        Int threadCount = 2
        Int diskSizeGB = 2*round(size(vcf, "GB"))
	String out_name = basename(vcf, ".vcf.gz")
    }
    
    command <<<
	python checkVCF.py -r ~{ref_fa} -o ~{out_name} ~{vcf}
    >>>

    output {
        File report.files = glob("*.check.*")
    }

    runtime {
        memory: memSizeGB + " GB"
        cpu: threadCount
        disks: "local-disk " + diskSizeGB + " SSD"
        docker: "python@sha256:4e98ebe9359684d858cf40c98b77dbfd0e829a67bec1322f2d9b1d68df44afef"   # digest: quay.io/biocontainers/bcftools:1.16--hfe4b78e_1
        preemptible: 2
    }

}
