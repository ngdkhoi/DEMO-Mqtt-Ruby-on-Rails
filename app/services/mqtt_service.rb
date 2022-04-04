class MqttService
  require 'mqtt'

  def self.send_payload_data(topic, payload)
    client = MQTT::Client.connect(
      :host => ENV['MQTT_HOST'],
      :port => ENV['MQTT_PORT'],
      :username => ENV['MQTT_USERNAME_CLIENT'],
      :password => ENV['MQTT_PASSWORD_CLIENT']
    ) rescue nil
    client.publish(topic, payload)
  end

  def self.test_payload
    (1..100).each do |number|
      send_payload_data("fcb_topic/test_layload", "Index#{number}")
    end
  end

  def self.subscribe
    @host = ENV['MQTT_HOST']
    @port = ENV['MQTT_PORT']
    @username = ENV['MQTT_USERNAME']
    @password = ENV['MQTT_PASSWORD']
    puts '[MQTTExec] Connecting to MQTT Server ...'

    connection_string = "mqtt://#{@username}:#{@password}@#{@host}:#{@port}"

    MQTT::Client.connect(connection_string) do |client|

      puts "[MQTTExec]Connected to MQTT Server."

      # Subscribe to any topics have prefix 'fcb_topic/'
      client.subscribe('fcb_topic/#')

      # Poll to get messages from any topic
      client.get do |topic, message|

        # Using thread here is an example.
        # In fact, it's optional, we can use Sidekiq instead.
        puts "topic: #{topic}, message: #{message}"
        # MqttSettings::HandlePayloadDataCommand.process(topic, message)

      end # End get block
    end
  end

end
