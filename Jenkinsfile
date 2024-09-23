node {
    
    stage("Git checkout") {
        git 'https://github.com/St0rmXY/cicd-kube-docker.git'
    }
    
    stage("sending docker file to Ansible server over ssh") {
        sshagent(['ansible_push']) {
          sh 'ssh -o StrictHostKeyChecking=no ubuntu@172.31.42.56'
          sh 'scp /var/lib/jenkins/workspace/pipeline-demo/* ubuntu@172.31.42.56:/home/ubuntu/'
      }
    }
    
      
    stage("Docker Build Image"){
        sshagent(['ansible_push']) {
          sh 'ssh -o StrictHostKeyChecking=no ubuntu@172.31.42.56 cd /home/ubuntu/'
          sh 'ssh -o StrictHostKeyChecking=no ubuntu@172.31.42.56 docker image build -t $JOB_NAME:v1.$BUILD_ID .'
      }    
    }
    
    stage("Docker Image Tagging"){
        sshagent(['ansible_push']) {
          sh 'ssh -o StrictHostKeyChecking=no ubuntu@172.31.42.56 cd /home/ubuntu/'
          sh 'ssh -o StrictHostKeyChecking=no ubuntu@172.31.42.56 docker image tag $JOB_NAME:v1.$BUILD_ID unlowx/$JOB_NAME:v1.$BUILD_ID'
          sh 'ssh -o StrictHostKeyChecking=no ubuntu@172.31.42.56 docker image tag $JOB_NAME:v1.$BUILD_ID unlowx/$JOB_NAME:latest'
        }
    }
    
    stage("Push Docker Images to Dockerhub"){
        sshagent(['ansible_push']) {
            withCredentials([string(credentialsId: 'dockerhub_password', variable: 'dockerhub_password')]) {
              sh "docker login -u unlowx -p ${dockerhub_password}"  
              sh 'ssh -o StrictHostKeyChecking=no ubuntu@172.31.42.56 docker image push unlowx/$JOB_NAME:v1.$BUILD_ID'
              sh 'ssh -o StrictHostKeyChecking=no ubuntu@172.31.42.56 docker image push unlowx/$JOB_NAME:v1.$BUILD_ID'
              
              sh 'ssh -o StrictHostKeyChecking=no ubuntu@172.31.42.56 docker image rm unlowx/$JOB_NAME:v1.$BUILD_ID unlowx/$JOB_NAME:latest $JOB_NAME:v1.$BUILD_ID'
            }
        }
    }
    
    stage("Copy Files from ansible to Kubernetes server"){
        sshagent(['kubernetes_server']) {
            sh 'ssh -o StrictHostKeyChecking=no ubuntu@172.31.20.252'
            sh 'scp /var/lib/jenkins/workspace/pipeline-demo/* ubuntu@172.31.42.56:/home/ubuntu/'
        }
    }
    
    stage("kubernetes deployment using ansible"){
        sshagent(['ansible_push']) {
           sh 'ssh -o StrictHostKeyChecking=no ubuntu@172.31.42.56 cd /home/ubuntu'
           sh 'ssh -o StrictHostKeyChecking=no ubuntu@172.31.42.56 ansible-playbook ansible.yaml'
        }
    }
}