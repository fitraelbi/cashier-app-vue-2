pipeline{
    agent any
    parameters {
        booleanParam(name: 'RUNTEST', defaultValue: true, description: 'Toggle this value for testing')
    }
    environment {
        registry = "fitrakz/frontend"
        registry_develop = "fitrakz/frontend"
        registry_backend = "fitrakz/backend"
        registryCredential = 'dockerHub'
    }
    stages{
        stage('Build Project'){
            steps{
                nodejs('node12') {
                    sh 'yarn install'
                }
            }
        }
        stage('Build Docker Image Develop'){
            when {
                expression {
                    BRANCH_NAME == 'develop2'
                }
            }
            steps{
               script {             
                 def dockerfile = 'dockerfile'
                docker.withRegistry('', registryCredential) {
                    def app = docker.build(registry, "-f ${dockerfile} https://github.com/fitraelbi/cashier-app-vue-2.git#develop2")
                    app.push("latest")
                    def backend = docker.build(registry_backend, "-f ${dockerfile} https://github.com/fitraelbi/cashier-restaurant-app-nodejs3.git#main")
                    backend.push("latest")
                  }
               }
            }
        }
        stage('Remove Image'){
            steps{
                echo 'Remove....'
                sh "docker rmi -f $(docker images -a -q)"
            }
        }
        stage('Run Testing'){
            when {
                expression {
                    params.RUNTEST
                }
            }
            steps{
                echo 'Testing....'
            }
        }
        stage('Deploy Development'){
            when {
                expression {
                    BRANCH_NAME == 'develop2'
                }
            }
            steps{
                script {
                   sshPublisher(
                        publishers: [
                            sshPublisherDesc(
                                configName: 'Development',
                                verbose: false,
                                transfers: [
                                    sshTransfer(
                                        execCommand: 'cd ansible && ansible-playbook -i hosts setup-dev.yml',
                                        execTimeout: 120000,
                                    )
                                ]
                            )
                        ]
                    )
                }
            }
        }
    }
}
