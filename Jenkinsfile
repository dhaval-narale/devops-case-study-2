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
            environment {
                DOCKER_PASSWORD = credentials('dockerhub-password')
            }
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-cred', passwordVariable: 'DOCKERHUB_CREDS_PSW', usernameVariable: 'DOCKERHUB_CREDS')]) {
                    sh '''
                        echo "$DOCKERHUB_CREDS_PSW" | docker login -u "$DOCKERHUB_CREDS" --password-stdin
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
                        script {
                            echo "=== Terraform Init ==="
                            sh 'terraform init'
                            
                            echo "=== Terraform Apply ==="
                            sh 'terraform apply -auto-approve'
                            
                            echo "=== Terraform Apply Completed Successfully ==="
                        }
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
