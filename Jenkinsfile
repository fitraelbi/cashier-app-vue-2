pipeline{
    agent any
    parameters {
        booleanParam(name: 'RUNTEST', defaultValue: true, description: 'Toggle this value for testing')
    }
    environment {
        registry = "fitrakz/production-cashier-app"
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
        stage('Build Docker Image Productio'){
            when {
                expression {
                    BRANCH_NAME == 'production'
                }
            }
            steps{
               script {             
                 def dockerfile = 'dockerfile'
                docker.withRegistry('', registryCredential) {
                    def app = docker.build(registry, "-f ${dockerfile} https://github.com/fitraelbi/cashier-app-vue-2.git#production")
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
                sh "docker rmi ${registry}:latest"
                sh "docker rmi ${registry_backend}:latest"
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
                    BRANCH_NAME == 'production'
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
                                        execCommand: 'cd ansible && ansible-playbook -i hosts setup-production.yml',
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
