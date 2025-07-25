pipeline {
    agent any

    environment {
        DOCKER_USERNAME = 'dhavalnarale'
        IMAGE_NAME = "devops-case-study"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'develop', url: 'https://github.com/dhaval-narale/devops-case-study-2.git'
            }
        }

        stage('Build and Push Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-cred', usernameVariable: 'DOCKERHUB_USERNAME', passwordVariable: 'DOCKERHUB_PASSWORD')]) {
                    sh '''
                        echo "$DOCKERHUB_PASSWORD" | docker login -u "$DOCKERHUB_USERNAME" --password-stdin
                        chmod +x ./scripts/build_and_push.sh
                        ./scripts/build_and_push.sh
                    '''
                }
            }
        }

        stage('Terraform Apply') {
            environment {
                AWS_ACCESS_KEY_ID     = credentials('aws-access-key-id')
                AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
            }
            steps {
                dir('infra') {
                    timeout(time: 8, unit: 'MINUTES') {
                        sh 'terraform init'
                        sh 'terraform apply -auto-approve'
                    }
                }
            }
        }

        stage('Ansible Deploy') {
            steps {
                echo "=== Ansible Deployment ==="
                sh '''
                    ansible-playbook -i infra/inventory.ini ansible/deploy.yml
                '''
            }
        }
    }
}
