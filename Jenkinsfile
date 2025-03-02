pipeline {
    parameters {
        booleanParam(name: 'autoApprove', defaultValue: false, description: 'Automatically run apply after generating plan?')
    }
    environment {
        AWS_ACCESS_KEY_ID     = credentials('7d87d588-1bf2-4211-a5ae-481c88601838')
        AWS_SECRET_ACCESS_KEY = credentials('7d87d588-1bf2-4211-a5ae-481c88601838')
    }
    agent {
        docker {
            image 'hashicorp/terraform:latest'
            // 如有需要，可以在 args 中增加挂载卷或者其他参数
             args '-v /path/on/host:/path/in/container'
        }
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
            steps {
                dir("terraform") {
                    sh 'terraform init'
                    sh 'terraform plan -out=tfplan'
                    sh 'terraform show -no-color tfplan > tfplan.txt'
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
                dir("terraform") {
                    sh 'terraform apply -input=false tfplan'
                }
            }
        }
    }
}
