pipeline {
    agent any

    environment {
        GIT_COMMIT = "${env.GIT_COMMIT ?: 'latest'}"
        IMAGE = "dhavalnarale/devops-nodejs-app:${GIT_COMMIT}"
        SSH_KEY_PATH = '/var/lib/jenkins/.ssh/devops-server-key' 
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'develop', url: 'https://github.com/dhaval-narale/devops-case-study-2.git'
            }
        }

        stage('Build & Push Docker Image') {
            steps {
                script {
                    withDockerRegistry([credentialsId: 'DockerHub', url: '']) {
                        sh 'chmod +x scripts/build_and_push.sh'
                        sh './scripts/build_and_push.sh'
                    }
                }
            }
        }

        stage('Copy SSH Key') {
            steps {
                sh 'cp /var/lib/jenkins/.ssh/devops-server-key.pub infra/'
            }
        }

        stage('Terraform Apply - Provision Infra') {
            steps {
                dir('infra') {
                    sh 'terraform init'
                    timeout(time: 30, unit: 'MINUTES') {
                        sh 'terraform apply -auto-approve'
                        sh 'terraform refresh'
                    }
                }
            }
        }

        stage('Prepare Ansible Hosts') {
            steps {
                script {
                    def ec2_ip = sh(script: "terraform -chdir=infra output -raw ec2_pub_ip", returnStdout: true).trim()
                    writeFile file: 'ansible/hosts.ini', text: """
                    [app_server]
                    ${ec2_ip} ansible_user=ubuntu ansible_ssh_private_key_file=${SSH_KEY_PATH} ansible_ssh_common_args='-o StrictHostKeyChecking=no'
                    """
                }
            }
        }

        stage('Ansible Deployment') {
            steps {
                timeout(time: 10, unit: 'MINUTES') {
                    sh "cp ${SSH_KEY_PATH} ansible/"
                    sh 'ansible-playbook -i ansible/hosts.ini ansible/deploy.yml'
                }
            }
        }
    }

    post {
        success {
            echo "Pipeline executed successfully!"
        }
        failure {
            echo "Pipeline failed. Check logs."
        }
    }
}
