    
node {
    def project = 'earroyoh'
    def appName = 'spark-2'
    def imageTag = "${appName}:${env.BUILD_NUMBER}"
//    def imageTag = "docker.io/${project}/${appName}:${env.BUILD_NUMBER}"
    
    checkout scm
    
    stage('Build image') {
        sh("/bin/sh -c /usr/bin/docker build -t ${imageTag} ./Spark-over-Docker")
    }
    stage('Push image to regitry') {
        sh("/bin/sh -c /usr/bin/docker push docker.io/${project}/${imageTag}")
    }
}
