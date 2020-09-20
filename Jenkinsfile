    
node {
    def project = 'earroyoh'
    def appName = 'spark-3'
    def imageTag = "${appName}:${env.BUILD_NUMBER}"
//    def imageTag = "docker.io/${project}/${appName}:${env.BUILD_NUMBER}"
    
    checkout scm
    
    stage('Build image') {
        sh("/usr/bin/docker build -t ${imageTag} ./Spark-over-Docker")
    }
    stage('Push image to registry') {
        sh("/usr/bin/docker push docker.io/${project}/${imageTag}")
    }
}
