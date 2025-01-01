pipeline {
    agent any

    stages {
        stage('Pull Docker Image') {
            steps {
                script {
                    echo 'Pulling the latest Docker image for the AI Artistic Style Service...'
                    sh 'docker pull urmsandeep/ai-artistic-style-service:latest'
                }
            }
        }
        stage('Run Tests') {
            steps {
                script {
                    echo 'Running tests for the AI Artistic Style Service...'
                    sh '''
                    docker run --rm -p 5001:5001 urmsandeep/ai-artistic-style-service:latest &
                    sleep 5
                    curl -X POST http://127.0.0.1:5001/styleTransfer -F "image=@test-image.jpg" -o output.json
                    '''
                }
            }
        }
        stage('Deploy Service') {
            steps {
                script {
                    echo 'Deploying the service using Docker Compose...'
                    sh '''
                    docker-compose down
                    docker-compose up -d
                    '''
                }
            }
        }
        stage('Verify Deployment') {
            steps {
                script {
                    echo 'Verifying the deployment...'
                    sh '''
                    sleep 5
                    curl -X POST http://127.0.0.1:5001/styleTransfer -F "image=@test-image.jpg" -o output.json
                    '''
                }
            }
        }
    }

    post {
        always {
            script {
                echo 'Cleaning up Docker system...'
                sh 'docker system prune -f'
            }
        }
        success {
            script {
                echo 'Pipeline executed successfully!'
            }
        }
        failure {
            script {
                echo 'Pipeline failed. Check logs for errors.'
            }
        }
    }
}
