pipeline {
    agent any

    environment {
        IMAGE_TAG = "devops-case-study:${env.BUILD_ID}"
    }

    options {
        timestamps()  // 💡 Pro Tip 1: Adds timestamp to log entries
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build and Push Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                    sh '''
                        echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin
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
                    timeout(time: 20, unit: 'MINUTES') {  // 💡 Pro Tip 2: Prevents hanging
                        sh '''
                            terraform init
                            terraform apply -auto-approve
                        '''
                    }
                }
            }
        }

        stage('Ansible Deploy') {
            steps {
                dir('ansible') {
                    sh '''
                        ansible-playbook -i hosts.ini deploy.yml
                    '''
                }
            }
        }
    }
}
