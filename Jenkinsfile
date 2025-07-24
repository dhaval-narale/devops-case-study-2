pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID     = credentials('aws-access-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
        DOCKERHUB_CREDS       = credentials('dockerhub-creds')
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'develop',
                    url: 'https://github.com/dhaval-narale/devops-case-study-2.git'
            }
        }

        stage('Build and Push Docker Image') {
            steps {
                sh '''
                echo "$DOCKERHUB_CREDS_PSW" | docker login -u "$DOCKERHUB_CREDS_USR" --password-stdin
                chmod +x ./build_and_push.sh
                ./build_and_push.sh
                '''
            }
        }

        stage('Terraform Apply') {
            steps {
                dir('infra') {
                    sh '''
                    terraform init
                    terraform apply -auto-approve
                    '''
                }
            }
        }

        stage('Ansible Deploy') {
            steps {
                sh '''
                ansible-playbook -i ansible/hosts.ini ansible/deploy.yml
                '''
            }
        }
    }
}
