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
                        echo 'Building Docker Image'
                        docker login -u $DOCKER_HUB_USERNAME -p $DOCKER_HUB_PASSWORD
                        docker build -t iqbal777/todo-list:${IMAGE_TAG} .
                        '''
                    }
                }
            }
        }

        stage('Push the artifacts') {
            steps {
                script {
                    sh '''
                    echo 'Pushing Docker image to Repo'
                    docker push iqbal777/todo-list:${IMAGE_TAG}
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
                        
                        // Check if the commit was made by Jenkins to prevent infinite loops
                        def isJenkinsCommit = sh(script: "git log -1 --pretty=%an", returnStdout: true).trim() == "Jenkins"
                        
                        if (!isJenkinsCommit) {
                            sh '''
                            echo "Updating Kubernetes manifest"
                            cat deploy/deploy.yaml
                            sed -i "s/iqbal777\\/todo-list:[0-9]\\+/iqbal777\\/todo-list:${IMAGE_TAG}/" deploy/deploy.yaml
                            cat deploy/deploy.yaml
                            git add .
                            git commit -m "Updated deploy.yaml for version ${IMAGE_TAG}"
                            git remote -v
                            git push https://$GIT_USERNAME:$GIT_PASSWORD@github.com/shamim-iq/cicd-end-to-end.git HEAD:main
                            '''
                        } else {
                            echo "Skipping Git push to prevent infinite loop triggered by Jenkins commit"
                        }
                    }
                }
            }
        }
    }
}
