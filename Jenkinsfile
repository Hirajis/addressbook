pipeline {
    agent none
    parameters {
        string(name:'Env', defaultValue:'Test', description: 'env to compile')
        booleanParam(name: 'executeTests', defaultValue:true, description:'Decide to run')
        choice(name:'APPVERSION', choices:['1.1','1.2','1.3'])
    }
    environment {
        DEVSERVER='ec2-user@172.31.7.201'
        DEPLOYSERVER='ec2-user@172.31.9.62'
        IMAGE_NAME='suryawanshihiraji/addressbook'
    }

    stages {
        stage('Compile') {
            agent any
            steps {
                script {
                    echo 'Running test'
                    echo "compile in env ${params.Env}"
                }
            }
        }
        stage('UnitTest') {
            agent any
            when {
                expression{
                    params.executeTests == true
                }
            }
            steps {
                script{
                    echo "Unit testing stage"
                }
            }
        }
        stage('Package') {
            agent any
            steps {
                script{
                    sshagent(['aws-key']) {
                        withCredentials([usernamePassword(credentialsId: 'docker-hub-creds', passwordVariable: 'dockerpassword', usernameVariable: 'dockeruser')]) {
                        echo "Packaging the version ${params.APPVERSION}"
                        sh "scp -o StrictHostKeyChecking=no server-config.sh ${DEVSERVER}:/home/ec2-user"
                        sh "ssh -o StrictHostKeyChecking=no ${DEVSERVER} 'bash ~/server-config.sh ${IMAGE_NAME} ${BUILD_NUMBER}'"
                        sh "ssh ${DEVSERVER} sudo docker login -u ${dockeruser} -p ${dockerpassword}"
                        sh "ssh ${DEVSERVER} sudo docker push ${IMAGE_NAME}:${BUILD_NUMBER}"
                    }
                    }
                }
            }
        }
        stage('Deploy') {
            agent any
            steps {
                script {
                    sshagent(['aws-key']) {
                        withCredentials([usernamePassword(credentialsId: 'docker-hub-creds', passwordVariable: 'dockerpassword', usernameVariable: 'dockeruser')]) {
                        echo "Deploying the app"

                        sh "ssh -o StrictHostKeyChecking=no ${DEPLOYSERVER} sudo yum install docker -y"
                        sh "ssh ${DEPLOYSERVER} sudo systemctl start docker"
                        sh "ssh ${DEPLOYSERVER} sudo docker login -u ${dockeruser} -p ${dockerpassword}"
                        sh "ssh ${DEPLOYSERVER} sudo docker run -itd -P ${IMAGE_NAME}:${BUILD_NUMBER}"
                    }
                    }
                }
            }
        }
    }
    
}