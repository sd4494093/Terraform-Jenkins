pipeline {
    parameters {
        booleanParam(name: 'autoApprove', defaultValue: false, description: 'Automatically run apply after generating plan?')
    }
    environment {
        AWS_ACCESS_KEY_ID     = credentials('7d87d588-1bf2-4211-a5ae-481c88601838')
        AWS_SECRET_ACCESS_KEY = credentials('7d87d588-1bf2-4211-a5ae-481c88601838')
    }
    agent any
    stages {
        stage('Checkout') {
            steps {
                dir("terraform") {
                    git branch: 'main', url: "https://github.com/sd4494093/Terraform-Jenkins.git"
                }
            }
        }
        stage('Plan') {
            steps {
                script {
                    docker.image('hashicorp/terraform:latest').inside {
                        dir("terraform") {
                            sh 'terraform init'
                            sh 'terraform plan -out=tfplan'
                            sh 'terraform show -no-color tfplan > tfplan.txt'
                        }
                    }
                }
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
            steps {
                script {
                    docker.image('hashicorp/terraform:latest').inside {
                        dir("terraform") {
                            sh 'terraform apply -input=false tfplan'
                        }
                    }
                }
            }
        }
    }
}
