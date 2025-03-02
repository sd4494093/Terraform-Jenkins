pipeline {
    agent any
    parameters {
        booleanParam(name: 'autoApprove', defaultValue: false, description: 'Automatically run apply after generating plan?')
    }
    environment {
        AWS_ACCESS_KEY_ID     = credentials('your-aws-credentials-id')
        AWS_SECRET_ACCESS_KEY = credentials('your-aws-credentials-id')
    }
    stages {
        stage('Checkout') {
            steps {
                dir("terraform") {
                    // 显式指定 branch 为 main
                    git branch: 'main', url: "https://github.com/sd4494093/Terraform-Jenkins.git"
                }
            }
        }
        stage('Plan') {
            agent {
                docker {
                    image 'hashicorp/terraform:latest'
                    args '-v ${WORKSPACE}/terraform:/workspace -w /workspace'
                }
            }
            steps {
                // 如果此处有 checkout 步骤，也需要指定 branch: 'main'
                // 例如：
                // checkout([$class: 'GitSCM', branches: [[name: '*/main']], ...])
                sh 'terraform init'
                sh 'terraform plan -out=tfplan'
                sh 'terraform show -no-color tfplan > tfplan.txt'
            }
        }
        // 其它阶段...
    }
}
