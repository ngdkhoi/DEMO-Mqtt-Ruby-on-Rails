require_relative 'base_exec'

class MqttExec < BaseExec

    def initialize()
        super()
        # Do some initialization if you want

        @host = ENV['MQTT_HOST']
        @port = ENV['MQTT_PORT']
        @username = ENV['MQTT_USERNAME']
        @password = ENV['MQTT_PASSWORD']
    end

    def run!
        super

        begin

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

          end # End MQTT::Client block

        rescue SystemExit, Interrupt
          puts '[MQTTExec] End.'
        end

    end

end
