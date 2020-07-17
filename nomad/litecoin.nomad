# here we are simply configuraing the job name, the datacenters in which it will run and the type of job (in our case, a service)
# we are also configuring the group, the volume to be created, the restart rules, where our volume will be mounted, we are also configuring
# the docker image we are using, the ports that litecoin server requires to run and the resource limits and the ports the container will use.
# NOTE: I'm not 100% sure on this technology yet, so i'm not sure my service stanza is quite right, but I thought i'd give it a go

job "mysql-server" {
  datacenters = ["dc1"]
  type        = "service"

  group "litecoin" {
    count = 1

    volume "litecoindata" {
      type      = "host"
      read_only = false
    }

    restart {
      attempts = 10
      interval = "5m"
      delay    = "25s"
      mode     = "delay"
    }

    task "litecoinserver" {
      driver = "docker"

      volume_mount {
        volume      = "litecoindata"
        destination = "/home/litecoin/.litecoin"
        read_only   = false
      }

      config {
        image = "somerepo/litecoin:0.17.1"

        port_map {
          portone = 9332
          portwo = 9333
          portthree = 19332
          portfour = 19333
          portfive = 19444
        }
      }

      resources {
        cpu    = 500
        memory = 2048
      }

      service {
        name = "litecoin-server"
        port = "portone"
        port = "portwo"
        port = "portthree"
        port = "portfour"
        port = "portfive"
      }
    }
  }
}

