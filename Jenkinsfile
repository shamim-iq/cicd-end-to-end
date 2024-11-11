pipeline {
    agent any
     
    environment {
        IMAGE_TAG = "${BUILD_NUMBER}"
    }
    
    stages {
        stage('Checkout') {
            steps {
                git credentialsId: 'github-access', 
                url: 'https://github.com/shamim-iq/cicd-end-to-end.git',
                branch: 'main'
            }
        }

        stage('Build Docker') {
            steps {
                script {
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

        stage('Push the artifacts') {
            steps {
                script {
                    sh '''
                    echo 'Push to Repo'
                    docker push iqbal777/todo-list:${BUILD_NUMBER}
                    '''
                }
            }
        }

        stage('Checkout K8S manifest SCM') {
            steps {
                git credentialsId: 'github-access', 
                url: 'https://github.com/shamim-iq/cicd-end-to-end.git',
                branch: 'main'
            }
        }
        
        stage('Update K8S manifest & push to Repo') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'github-access', passwordVariable: 'GIT_PASSWORD', usernameVariable: 'GIT_USERNAME')]) {
                        sh '''
                        cat deploy/deploy.yaml
                        ls -l deploy/
                        sed -i'' "s/${BUILD_NUMBER-1}/${BUILD_NUMBER}/g" deploy/deploy.yaml
                        cat deploy/deploy.yaml
                        git add .
                        git commit -m 'Updated deploy.yaml for version ${BUILD_NUMBER}'
                        git remote -v
                        git push https://$GIT_USERNAME:$GIT_PASSWORD@github.com/shamim-iq/cicd-end-to-end.git HEAD:main
                        '''                        
                    }
                }
            }
        }
    }
}
