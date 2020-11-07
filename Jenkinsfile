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
                    BRANCH_NAME == 'develop'
                }
            }
            steps{
               script {             
                 def dockerfile = 'dockerfile'
                docker.withRegistry('', registryCredential) {
                    def app = docker.build(registry, "-f ${dockerfile} https://github.com/fitraelbi/cashier-app-vue-2#develop2")
                    app.push("latest")
                    def backend = docker.build(registry_backend, "-f ${dockerfile} https://github.com/fitraelbi/cashier-restaurant-app-nodejs3.git#dev")
                    backend.push("latest")
                  }
               }
            }
        }
        stage('Remove Image'){
            steps{
                echo 'Remove....'
                sh "docker rmi ${registry_develop}:latest"
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
    }
}
