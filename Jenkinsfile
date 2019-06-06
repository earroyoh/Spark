    
node {
    def project = 'earroyoh'
    def appName = 'spark-2'
    def imageTag = "${appName}:${env.BUILD_NUMBER}"
//    def imageTag = "docker.io/${project}/${appName}:${env.BUILD_NUMBER}"
    
    checkout scm
    
    stage('Build image') {
        sh("chmod 755 docker")
        sh("docker build -t ${imageTag} .")
    }
    stage('Push image to regitry') {
        sh("docker push docker.io/${project}/${imageTag}")
    }
}
