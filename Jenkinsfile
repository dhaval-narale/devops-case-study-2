pipeline {
    agent any

    environment {
        AWS_DEFAULT_REGION = 'ap-south-1'
        IMAGE_TAG = "${GIT_COMMIT.take(7)}"
    }

    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'develop', url: 'https://github.com/dhaval-narale/devops-case-study-2.git'
            }
        }

        stage('Build & Push Docker Image') {
            environment {
                DOCKER_HUB_CREDENTIALS = credentials('dockerhub-creds')
            }
            steps {
                sh 'echo "$DOCKER_HUB_CREDENTIALS_PSW" | docker login -u "$DOCKER_HUB_CREDENTIALS_USR" --password-stdin'
                sh 'export GIT_COMMIT=$(git rev-parse --short HEAD)'
                sh './scripts/build_and_push.sh'
            }
        }

        stage('Terraform Apply') {
            environment {
                AWS_ACCESS_KEY_ID = credentials('aws-creds').accessKey
                AWS_SECRET_ACCESS_KEY = credentials('aws-creds').secretKey
            }
            steps {
                dir('infra') {
                    sh 'terraform init'
                    sh 'terraform apply -auto-approve'
                }
            }
        }

        stage('Deploy with Ansible') {
            steps {
                sshagent(credentials: ['ansible-key']) {
                    sh 'ansible-playbook -i ansible/hosts.ini ansible/deploy.yml'
                }
            }
        }
    }
}
