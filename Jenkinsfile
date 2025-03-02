pipeline {
    agent {
        docker {
            image 'hashicorp/terraform:latest'
            // 如果需要挂载工作区，确保容器内能访问 Jenkins 工作区；一般无需额外设置，Jenkins 会自动挂载 WORKSPACE
            // args '-v /var/jenkins_home/workspace:/workspace'
        }
    }
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
                // 在工作区中 checkout 代码到 terraform 目录
                dir("terraform") {
                    git branch: 'main', url: "https://github.com/sd4494093/Terraform-Jenkins.git"
                }
            }
        }
        stage('Plan') {
            steps {
                dir("terraform") {
                    // 在容器内直接执行 terraform 命令
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
