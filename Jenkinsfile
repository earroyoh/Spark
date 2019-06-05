    
node {
    def project = 'earroyoh'
    def appName = 'spark-2'
    def imageTag = "docker.io/${project}/${appName}:${env.BUILD_NUMBER}"
    
    checkout scm
    
    stage 'Build image'
    sh("docker build -t ${imageTag} .")

    stage 'Push image to regitry'
    sh("docker push ${imageTag}")
}
