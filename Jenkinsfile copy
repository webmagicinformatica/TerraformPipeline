node {

  parameters {
  choice choices: ['prod', 'dev'], description: '', name: 'env'
  choice choices: ['plan', 'apply'], description: '', name: 'action'
}


  git 'https://github.com/webmagicinformatica/TerraformPipeline.git'
  if(action == 'plan') {
    stage('init') {
        sh """
            terraform init
        """
    }
    stage('plan') {
		try {
        sh label: 'terraform plan', script: "terraform workspace new ${ENV}"
    } catch (err) {
        echo "Caught: ${err}"
        sh label: 'terraform plan', script: "terraform workspace select ${ENV}"
    }
	sh label: 'terraform plan', script: "terraform plan -out=tf${ENV}_plan -input=false -var-file=${ENV}.tfvar -var env=${ENV}"
    }
  }
  
  if(action == 'apply') {
    stage('init') {
        sh """
            terraform init
        """
    }
    stage('Apply') {
		try {
        sh label: 'terraform plan', script: "terraform workspace new ${ENV}"
    } catch (err) {
        echo "Caught: ${err}"
        sh label: 'terraform plan', script: "terraform workspace select ${ENV}"
		sh label: 'terraform plan', script: "terraform plan -out=tf${ENV}_plan -input=false -var-file=${ENV}.tfvar -var env=${ENV}"
    }
	sh label: 'terraform plan', script: "terraform apply -lock=false -input=false tf${ENV}_plan"
    }
  }
}
