pipeline {
    agent any
    parameters {
        booleanParam(name: 'autoApprove', defaultValue: false, description: 'Automatically run apply after generating plan?')
    }
    environment {
        AWS_ACCESS_KEY_ID     = credentials('d606132b-5ac6-4e54-ad35-23af9ce87757')
        AWS_SECRET_ACCESS_KEY = credentials('d606132b-5ac6-4e54-ad35-23af9ce87757')
    }
    stages {
        stage('Checkout') {
            steps {
                dir("terraform") {
                    git branch: 'main', url: "https://github.com/sd4494093/Terraform-Jenkins.git"
                }
            }
        }
        stage('Plan') {
            agent {
                docker {
                    image 'hashicorp/terraform:latest'
                    args '-v /var/jenkins_home/workspace/jenkins_terroform/terraform:/workspace -w /workspace'
                }
            }
            steps {
                sh 'terraform init'
                sh 'terraform plan -out=tfplan'
                sh 'terraform show -no-color tfplan > tfplan.txt'
            }
        }
        stage('Approval') {
            when {
                not {
                    equals expected: true, actual: params.autoApprove
                }
            }
            steps {
                script {
                    def plan = readFile 'terraform/tfplan.txt'
                    input message: "Do you want to apply the plan?",
                          parameters: [text(name: 'Plan', description: 'Please review the plan', defaultValue: plan)]
                }
            }
        }
        stage('Apply') {
            agent {
                docker {
                    image 'hashicorp/terraform:latest'
                    args '-v /var/jenkins_home/workspace/jenkins_terroform/terraform:/workspace -w /workspace'
                }
            }
            steps {
                sh 'terraform apply -input=false tfplan'
            }
        }
    }
}
