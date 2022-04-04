#!/usr/bin/env ruby

require_relative '../config/environment'
require_relative 'mqtt_exec'

MqttExec.new.run!


# puts 'Running mqtt service!!!'


# def run_mqtt_exec
#   require_relative '../config/environment'
#   require_relative 'mqtt_exec'

#   MqttExec.new.run!
# end

# if ARGV[0] == 'stop'
#   run_mqtt_exec()
#   return
# end

# def dedect_pid_file(pid_file)
#   puts 'running dedect_pid_file'
#   pid = ::File.read(pid_file).to_i rescue 0
#   puts pid
#   if pid == 0
#     run_mqtt_exec()
#     return
#   end

#   is_process_working = Process.kill(0, pid) rescue 0
#   puts is_process_working
#   if is_process_working != 1
#     run_mqtt_exec()
#     return
#   end
#   puts 'end dedect_pid_file'
# end


# pid_file = "#{__dir__}/mqtt_etc/pids/mqtt_exec.pid".gsub("/exec/", "/")

# puts pid_file

# if File.exists?(pid_file)
#   dedect_pid_file(pid_file)
# else
#   run_mqtt_exec()
# end

# run_mqtt_exec()

# puts 'End mqtt service!!!'

