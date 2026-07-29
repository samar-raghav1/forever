pipeline{
    agent any

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
                sh 'docker build -t forever-frontend:latest ./frontend'
                echo "Building docker image for backend"
                sh 'docker build -t forever-backend:latest ./backend'
                echo "Building docker image for admin"
                sh 'docker build -t forever-admin:latest ./admin'

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
                    sh 'docker tag forever-frontend:latest samarraghav1/forever-frontend:latest'
                    sh 'docker tag forever-backend:latest samarraghav1/forever-backend:latest'
                    sh 'docker tag forever-admin:latest samarraghav1/forever-admin:latest'
                    sh 'docker push samarraghav1/forever-frontend:latest'
                    sh 'docker push samarraghav1/forever-backend:latest'
                    sh 'docker push samarraghav1/forever-admin:latest'

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