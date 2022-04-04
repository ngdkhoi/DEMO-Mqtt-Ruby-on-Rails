class BaseExec

  def initialize()
    @prefix = self.class.name.underscore
    @pid_file = Rails.root.join("mqtt_etc/pids/#{@prefix}.pid")
    @log_file = Rails.root.join("mqtt_etc/logs/#{@prefix}.log")
  end

  def run!

    if ARGV[0].present?
      handle_commands()
    end

    puts "[#{@prefix}] STARTING ..."

    check_pid()

    daemonize() unless @is_systemd

    write_pid()

    redirect_output()
  end

  def write_pid
    puts 'Write PID'
    begin
      dir = File.dirname(@pid_file)

      FileUtils.mkdir_p(dir) unless File.exist?(dir)

      File.open(@pid_file, ::File::CREAT | ::File::EXCL | ::File::WRONLY) do |file|
        file.write("#{Process.pid}")
      end

      at_exit { File.delete(@pid_file) if File.exists?(@pid_file) }
    rescue Errno::EEXIST
      check_pid()
      retry
    end
  end

  def check_pid
    puts 'Check PID'
    status = pid_status()
    case status
    when :running, :not_owned
      puts "Another instance is running. Check #{@pid_file}."
      exit(1)
    when :dead
      File.delete(@pid_file)
    end
  end

  def pid_status
    return :exited unless File.exists?(@pid_file)
    pid = ::File.read(@pid_file).to_i
    return :dead if pid == 0
    Process.kill(0, pid)
    return :running
  rescue Errno::ESRCH
    :dead
  rescue Errno::EPERM
    :not_owned
  end

  def daemonize
    puts 'Daemonizing ...'
    Process.daemon
  end

  def redirect_output
    FileUtils.mkdir_p(File.dirname(@log_file), mode: 0755)
    FileUtils.touch(@log_file)
    File.chmod(0755, @log_file)
    $stderr.reopen(@log_file, 'w')
    $stdout.reopen($stderr)
    $stdout.sync = $stderr.sync = true
  end

  def handle_commands()
    puts "Handle Commands"
    case ARGV[0]
    when 'stop'
      stop()
      puts "[#{@prefix}] STOPPED"
      exit
    when 'systemd'
      puts "Is systemd"
      @is_systemd = true
    end
  end

  def stop()
    status = pid_status()
    case status
    when :running, :not_owned
      pid = ::File.read(@pid_file).to_i
      Process.kill('QUIT', pid)
    when :dead
      File.delete(@pid_file)
    end
  end

end
