pipeline {
    agent any
    stages {
        stage('Pull Docker Image') {
            steps {
                // Pull the pre-built Docker image from Docker Hub
                script {
                    sh 'docker pull urmsandeep/ai-artistic-style-service:latest'
                }
            }
        }
        stage('Run Tests') {
            steps {
                // Run tests to ensure the container works correctly
                script {
                    sh '''
                    docker run --rm -p 5001:5001 urmsandeep/ai-artistic-style-service:latest pytest tests/
                    '''
                }
            }
        }
        stage('Deploy Service') {
            steps {
                // Deploy the service using Docker Compose
                script {
                    sh '''
                    docker-compose down
                    docker-compose up -d
                    '''
                }
            }
        }
        stage('Verify Deployment') {
            steps {
                // Check if the service is running and responding
                script {
                    sh '''
                    sleep 5
                    curl -X POST http://127.0.0.1:5001/styleTransfer -F "image=@devops.jpg" --output styled_output.jpg
                    '''
                }
            }
        }
    }
    post {
        always {
            // Clean up dangling Docker containers and images
            sh 'docker system prune -f'
        }
        success {
            echo 'Pipeline executed successfully. The service is running and functional!'
        }
        failure {
            echo 'Pipeline failed. Check logs for errors.'
        }
    }
}
