job "2048-game" {
  datacenters = ["dc1"]  
  type = "service"
  group "game" {
    count = 1 # number of instances

    network {
      port "http" {
        static = 80
      }
    }
 
    task "2048" {
      driver = "docker"
 
      config {
        image = "alexwhen/docker-2048"

        ports = [
          "http"
        ]

      }

      resources {
        cpu    = 500 # 500 MHz
        memory = 256 # 256MB
      }
    }
  }
}
