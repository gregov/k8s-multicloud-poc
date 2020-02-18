# Description:
#   Hubot Kubernetes REST API helper commands.
#
# Dependencies:
#   None
#
# Commands:
#   hubot guestbook list - List deployed versions
#   hubot guestbook deploy 123 - Deploy version 123
#   hubot guestbook delete 123 - Delete version 123
#   hubot guestbook current - Return current active version
#   hubot guestbook enable 123 - Activate version 123
#
# Author:
#   Greg Reboul

# adding some sugar
String::startsWith ?= (s) -> @slice(0, s.length) == s

module.exports = (robot) ->
  fs = require 'fs'
  getToken = ->
    fs.readFileSync "/var/run/secrets/kubernetes.io/serviceaccount/token"
  token = getToken()

  robot.respond /guestbook list/i, (res) ->
    options =
        rejectUnauthorized: false
    robot.http("https://kubernetes.default/apis/types.kubefed.io/v1beta1/namespaces/global/federateddeployments", options)
    .header("Authorization", "Bearer #{token}")
    .header("Content-Type", "application/json")
    .get() (error, response, body) ->
      if error
        robot.logger.error error
        return res.reply "Error getting FederatedDeployments: #{error} #{response} #{body}"
      
      data = JSON.parse body
      
      reply = "FederatedDeployments:\n"
      for rc in data.items
        if rc.metadata.name.startsWith "guestbook"
          console.log(rc.status)
          labels = JSON.stringify rc.metadata.labels
          image = rc.spec.template.spec.template.spec.containers[0].image
          if rc.status? && rc.status.conditions? 
            status = rc.status.conditions[0].status 
          else 
            status = "Pending"
          reply += "\n>*#{labels}*: \n" +
                   ">Image: #{image}\n" +
                   ">Ready: #{status}\n" 
      res.reply reply

  robot.respond /guestbook deploy (\d+)/i, (res) ->
    if res.match[1] and res.match[1] != ""
      version = res.match[1]

    payload = {
      "apiVersion": "types.kubefed.io/v1beta1",
      "kind": "FederatedDeployment",
      "metadata": {
        "labels": {"app": "guestbook", "version": version},
        "name": "guestbook-#{version}",
        "namespace": "global"
      },
      "spec": {
        "placement": {
          "clusters": [
            {"name": "cluster-federation-aws"},
            {"name": "cluster-federation-azure"},
            {"name": "cluster-federation-gcp"}
          ]
        },
        "template": {
          "metadata": {
            "labels": {"app": "guestbook", "version": version}
          },
          "spec": {
            "replicas": 3,
            "selector": {
              "matchLabels": {"app": "guestbook", "version": version}
            },
            "template": {
              "metadata": {
                "labels": {"app": "guestbook", "version": version}
              },
              "spec": {
                "containers": [
                  {
                    "image": "docker.pkg.github.com/gregov/arctiq-ext-mission/guestbook-go:#{version}",
                    "name": "guestbook-#{version}",
                    "ports": [{"containerPort": 3000, "name": "http-server"}]
                  }
                ],
                "imagePullSecrets": [{"name": "regcred"}]
              }
            }
          }
        }
      }
    }
    console.log JSON.stringify payload
    options =
        rejectUnauthorized: false
    robot.http("https://kubernetes.default/apis/types.kubefed.io/v1beta1/namespaces/global/federateddeployments", options)
    .header("Authorization", "Bearer #{token}")
    .header("Content-Type", "application/json")
    .post(JSON.stringify payload) (error, response, body) ->
      if error
        robot.logger.error error
        return res.reply "Error creating the deployment: #{error} #{response} #{body}"

      reply = "\n"
      reply += "Creating guestbook-#{version}"
      res.reply reply

  robot.respond /guestbook current/i, (res) ->
    options =
        rejectUnauthorized: false
    robot.http("https://kubernetes.default/apis/types.kubefed.io/v1beta1/namespaces/global/federatedservices/guestbook", options)
    .header("Authorization", "Bearer #{token}")
    .header("Content-Type", "application/json")
    .get() (error, response, body) ->
      if error
        robot.logger.error error
        return res.reply "Error getting FederatedService: #{error} #{response} #{body}"
      data = JSON.parse body
      reply = "Current:\n"
      reply += JSON.stringify data.spec.template.spec.selector
      res.reply reply

  robot.respond /guestbook enable (\d+)/i, (res) ->
    if res.match[1] and res.match[1] != ""
      version = res.match[1]
    payload = [{"op": "replace", "path": "/spec/template/spec/selector/version", "value": version}]
    options =
        rejectUnauthorized: false
    console.log(JSON.stringify payload)
    robot.http("https://kubernetes.default/apis/types.kubefed.io/v1beta1/namespaces/global/federatedservices/guestbook", options)
    .header("Authorization", "Bearer #{token}")
    .header("Content-Type", "application/json-patch+json")
    .patch(JSON.stringify payload) (error, response, body) ->
      if error
        robot.logger.error error
        return res.reply "Error creating the deployment: #{error} #{response} #{body}"

      reply = "\n"
      reply += "Enabling guestbook-#{version}"
      res.reply reply

  robot.respond /guestbook delete (\d+)/i, (res) ->
    if res.match[1] and res.match[1] != ""
      version = res.match[1]
    options =
      rejectUnauthorized: false
    robot.http("https://kubernetes.default/apis/types.kubefed.io/v1beta1/namespaces/global/federateddeployments/guestbook-#{version}", options)
    .header("Authorization", "Bearer #{token}")
    .header("Content-Type", "application/json")
    .delete() (error, response, body) ->
      if error
        robot.logger.error error
        return res.reply "Error deleting the deployment: #{error} #{response} #{body}"

      reply = "\n"
      reply += "Deleting guestbook-#{version}"
      res.reply reply