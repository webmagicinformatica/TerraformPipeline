#!/usr/bin/env groovy
pipeline {

    options {
        buildDiscarder(logRotator(numToKeepStr: '5', daysToKeepStr: '14'))
        timestamps()
    }
    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_KEY')

    }

	parameters {
       choice(choices: 'plan\napply\ndestroy', description: 'Please select terrafrom action', name: 'TERRAFORM_ACTION')
       choice(choices: 'stores_api\ngdpr', description: 'Please select the service to be created.', name: 'PROJECT')
       choice(choices: 'prod', description: 'Please select the environment name.', name: 'ENV_NAME')
    }

    stages {
        stage('Terraform init') {
        steps {
          sh '''
					     chmod +x ./provision.sh
              ./provision.sh -e ${ENV_NAME} -r init -p ${PROJECT}
              '''
            }
        }

        stage('Terraform plan') {
            steps {
                sh  '''
                    ./provision.sh -e ${ENV_NAME} -r plan -p ${PROJECT}
				'''
            }

        }

        stage('Terrafrom apply or destroy') {
            steps {
              sh  '''
                      ./provision.sh -e ${ENV_NAME} -r ${TERRAFORM_ACTION} -p ${PROJECT}
                '''
              }
        }
    }
}
