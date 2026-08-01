pipeline{
    agent any

    environment{
        TAG = "${env.BUILD_NUMBER}"
    }

    

    stages{
        stage("checkout"){
            steps{
                git url:' https://github.com/samar-raghav1/forever.git'  , branch: 'new'

                echo "Code checked out successfully"
            }
        }

        stage("docker build stage"){
            steps{
                echo "Building docker image for frontend"
                sh 'docker build -t forever-frontend:${TAG} ./frontend'
                echo "Building docker image for backend"
                sh 'docker build -t forever-backend:${TAG} ./backend'
                echo "Building docker image for admin"
                sh 'docker build -t forever-admin:${TAG} ./admin'

                echo "Docker images built successfully"
            }
        }

        
        stage("docker push stage"){
            steps{
                withCredentials([usernamePassword(
                    credentialsId: 'jenkins-docker' ,
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]){
                    sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                    sh 'docker tag forever-frontend:${TAG} samarraghav1/forever-frontend:${TAG}'
                    sh 'docker tag forever-backend:${TAG} samarraghav1/forever-backend:${TAG}'
                    sh 'docker tag forever-admin:${TAG} samarraghav1/forever-admin:${TAG}'
                    sh 'docker push samarraghav1/forever-frontend:${TAG}'
                    sh 'docker push samarraghav1/forever-backend:${TAG}'
                    sh 'docker push samarraghav1/forever-admin:${TAG}'

                    echo "Docker images pushed successfully"
                }
            }
        }

        stage("deploy stage"){
            steps{
                echo "Deploying the application using docker-compose"
                sh 'docker compose up -d --build'

                echo "Application deployed successfully"
            }
        }
        

    }
}