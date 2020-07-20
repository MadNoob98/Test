# Below we are defining the job name, the DC it will run in, the group, the task (so what our stack is named), the driver (docker), the docker
# image, the arguments to pass to the container, so listen on the litecoin ports, the network resource limits, the persistent volume and the volume
# driver. This was my second attempt, as the first nomad job I wrote, wasn't really docker friendly.

job "litecoin" {
  datacenters = ["dc1"]

  group "testing" {
    task "litecoinserver" {
      driver = "docker"

      config {
        image = "somerepo/litecoin-core:0.17.1"

        args = [
          "-listen",
          ":9332",
          ":9333",
          ":19332",
          ":19333",
          ":19444",
        ]
      }

      resources {
        cpu    = 100
        memory = 2048
       
        network {
          mbits = 10
          }
        }
     
       volumes = [
          "name=litecoindata,size=5,repl=1/:/home/litecoind/.litecoin",
        ]
        volume_driver = "pxd"
      }
    }
  }
}

