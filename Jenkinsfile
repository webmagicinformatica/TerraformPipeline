pipeline { 
    agent any 
    
    stages {
        stage('Terraform Workspace Setup') { 
            steps { 
                sh 'terraform workspace new ${GIT_BRANCH}'
            }
            steps { 
                sh 'terraform workspace select ${GIT_BRANCH}'
            }
        }
        stage('Plan') { 
            steps { 
                sh 'terraform plan -out=tf${GIT_BRANCH}_plan -input=false -var-file=${GIT_BRANCH}.tfvar -var env=${GIT_BRANCH}'
            }
        }
        stage('Apply') { 
            steps { 
                sh 'terraform apply -lock=false -input=false tf${GIT_BRANCH}_plan'
            }
        }
    }
} 