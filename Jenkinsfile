node ('Slave'){
  String jdktool = tool name: "jdk8", type: 'hudson.model.JDK'
  def mvnHome = tool name: 'maven'
  List javaEnv = [
    "PATH+MVN=${jdktool}/bin:${mvnHome}/bin",
    "M2_HOME=${mvnHome}",
    "JAVA_HOME=${jdktool}"
  ]
  withEnv(javaEnv) {
    stage('Clear & Checkout') {
      cleanWs()
      git url: 'https://github.com/vdt-mik/DevOps028'
    }
    stage('Test & Build') {
      try {
      sh 'mvn clean test'
      sh 'mvn clean package'
      } catch (e) {
          currentBuild.result = 'FAILURE'
        }    
    }
    stage ('Post') {
      if (currentBuild.result == null || currentBuild.result == 'SUCCESS') {
        archiveArtifacts artifacts: 'target/*.jar', onlyIfSuccessful: true  
        sh 'tar -czf liquibase.tar.gz liquibase'
        sh 'aws s3 cp target/Samsara-*.jar s3://mik-bucket/'
        sh 'aws s3 cp liquibase.tar.gz s3://mik-bucket/'
        sh 'aws s3 cp aws/user-data.sh s3://mik-bucket/'
      }
    }
  }           
  stage('Deploy RDS') {
    sh 'chmod +x aws/rds.sh && ./aws/rds.sh'
  }
  stage('Deploy ASG') {
    sh 'chmod +x aws/asg.sh && ./aws/asg.sh'
  }  
  stage('Check APP') {
    timeout(time: 1, unit: 'MINUTES') {
      waitUntil {
        try {
          APP_URI = sh(
          script: "aws ssm get-parameters --names APP_URL --with-decryption --output text | awk '{print \$4}'",
          returnStdout: true
          ).trim()
          def response = httpRequest "http://$APP_URI/login" 
          println("Status: "+response.status) 
          println("Content: "+response.content)
          return true
        } catch (Exception e) {
            return false
          }
      }
    }     
  } 
}