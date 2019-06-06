    
node {
    def project = 'earroyoh'
    def appName = 'spark-2'
    def imageTag = "${appName}:${env.BUILD_NUMBER}"
//    def imageTag = "docker.io/${project}/${appName}:${env.BUILD_NUMBER}"
    
    checkout scm
    
    stage('Build image') {
        steps {
            sh("docker build -t ${imageTag} .")
        }
    stage('Push image to regitry') {
        steps {
           sh("docker push docker.io/${project}/${imageTag}")
        }
    }
}
