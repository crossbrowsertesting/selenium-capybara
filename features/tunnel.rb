require 'rest-client'

def start_tunnel(username, authkey)
  response = RestClient.get('https://' + username + ':' + authkey + '@crossbrowsertesting.com/api/v3/tunnels?num=1')
  response = JSON.parse(response)
  tunnel_state = response['tunnels'][0]['state']

  if tunnel_state != 'running'
    puts 'Running cbt_tunnels'
    tunnel = fork do
      tunnel_user = username.sub('%40', '@')
      proc = "cbt_tunnels --username " + tunnel_user + ' --authkey ' + authkey + ' > tunnel.log'
      exec proc
    end
    Process.detach(tunnel)

    begin
      response = RestClient.get('https://' + username + ':' + authkey + '@crossbrowsertesting.com/api/v3/tunnels?num=1')
      response = JSON.parse(response)
      puts response['tunnels'][0]['state']
      tunnel_state = response['tunnels'][0]['state']
      sleep(4.0)
    end while (tunnel_state != 'running')
  end 
end