pipeline {
    parameters {
        booleanParam(name: 'autoApprove', defaultValue: false, description: 'Automatically run apply after generating plan?')
    }
    environment {
        AWS_ACCESS_KEY_ID     = credentials('d606132b-5ac6-4e54-ad35-23af9ce87757')
        AWS_SECRET_ACCESS_KEY = credentials('d606132b-5ac6-4e54-ad35-23af9ce87757')
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
                dir("terraform") {
                    // 初始化 Terraform
                    sh "docker run --rm -v ${env.WORKSPACE}/terraform:/workspace -w /workspace hashicorp/terraform:latest terraform init"
                    // 生成计划文件
                    sh "docker run --rm -v ${env.WORKSPACE}/terraform:/workspace -w /workspace hashicorp/terraform:latest terraform plan -out=tfplan"
                    // 导出计划文本
                    sh "docker run --rm -v ${env.WORKSPACE}/terraform:/workspace -w /workspace hashicorp/terraform:latest terraform show -no-color tfplan > tfplan.txt"
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
                    // 应用 Terraform 计划
                    sh "docker run --rm -v ${env.WORKSPACE}/terraform:/workspace -w /workspace hashicorp/terraform:latest terraform apply -input=false tfplan"
                }
            }
        }
    }
}
