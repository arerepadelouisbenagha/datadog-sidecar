pipeline {
    agent any

    environment {
        DOCKER_USERNAME = credentials('dockerhub-username')
        DOCKER_TOKEN = credentials('dockerhub-token')
        SERVER_USERNAME = credentials('server-username')
        SERVER_SSH_KEY = credentials('server-ssh-key')
    }

    stages {
        stage('git clone') {
            steps {
                script {
                    git branch: 'main', credentialsId: 'github-login', url: 'https://github.com/arerepadelouisbenagha/devops-automation.git'
                }
            }
    stage('Deploy to Target Server') {
        steps {
            withCredentials([
                usernamePassword(credentialsId: 'dockerhub-credentials', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_TOKEN'),
                sshUserPrivateKey(credentialsId: 'server-ssh-key', keyFileVariable: 'SSH_KEY_FILE', usernameVariable: 'SERVER_USERNAME')
            ]) {
                sh """
                    export DOCKER_USERNAME=${DOCKER_USERNAME}
                    export DOCKER_TOKEN=${DOCKER_TOKEN}
                    export SERVER_USERNAME=${SERVER_USERNAME}
                    export SERVER_HOST='52.3.224.2'
                    chmod +x deploy-to-target.sh
                    ssh-agent bash -c 'ssh-add ${SSH_KEY_FILE}; scripts/deploy-to-target.sh'
                """
            }
        }
    }

    }

    post {
        always {
            cleanWs()
        }
    }
}

