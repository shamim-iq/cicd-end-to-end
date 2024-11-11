pipeline {
    agent any
    
    environment {
        IMAGE_TAG = "${BUILD_NUMBER}"
    }
    
    stages {
        stage('Checkout'){
            steps {
                git credentialsId: 'github-access', 
                url: 'https://github.com/shamim-iq/cicd-end-to-end.git',
                branch: 'main'
            }
        }

        stage('Build Docker'){
            steps{
                script{
                    withCredentials([usernamePassword(credentialsId: 'docker-hub-access', passwordVariable: 'DOCKER_HUB_PASSWORD', usernameVariable: 'DOCKER_HUB_USERNAME')]) {
                        sh '''
                        echo 'Build Docker Image'
                        docker login -u $DOCKER_HUB_USERNAME -p $DOCKER_HUB_PASSWORD
                        docker build -t iqbal777/todo-list:${BUILD_NUMBER} .
                        '''
                    }
                }
            }
        }

        stage('Push the artifacts'){
            steps{
                script{
                    sh '''
                    echo 'Push to Repo'
                    docker push iqbal777/todo-list:${BUILD_NUMBER}
                    '''
                }
            }
        }
    }
}
