pipeline {
    agent any

    environment {
        DOCKERHUB_CREDS = credentials('dockerhub-creds')
        AWS_ACCESS_KEY_ID = credentials('aws-access-key-id').accessKey
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key').secretKey
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'develop', url: 'https://github.com/dhaval-narale/devops-case-study-2.git'
            }
        }

        stage('Build and Push Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                    sh 'echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin'
                    sh 'chmod +x ./scripts/build_and_push.sh'
                    sh './scripts/build_and_push.sh'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                dir('infra') {
                    withEnv(["AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}", "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}"]) {
                        sh 'terraform init'
                        sh 'terraform apply -auto-approve'
                    }
                }
            }
        }

        stage('Ansible Deploy') {
            steps {
                sh '''
                    ansible-playbook -i ansible/hosts.ini ansible/deploy.yml \
                    --private-key ansible-key.pem
                '''
            }
        }
    }
}
