module Simple
end

module Simple::UI
  extend self

  VERSION = "0.3.0"

  def self.verbosity
    @verbosity ||= 1
  end

  def self.verbosity=(verbosity)
    @verbosity = verbosity
  end

  COLORS = {
    clear:      "\e[0m",  # Embed in a String to clear all previous ANSI sequences.
    bold:       "\e[1m",  # The start of an ANSI bold sequence.
    black:      "\e[30m", # Set the terminal's foreground ANSI color to black.
    red:        "\e[31m", # Set the terminal's foreground ANSI color to red.
    green:      "\e[32m", # Set the terminal's foreground ANSI color to green.
    yellow:     "\e[33m", # Set the terminal's foreground ANSI color to yellow.
    blue:       "\e[34m", # Set the terminal's foreground ANSI color to blue.
    magenta:    "\e[35m", # Set the terminal's foreground ANSI color to magenta.
    cyan:       "\e[36m", # Set the terminal's foreground ANSI color to cyan.
    white:      "\e[37m", # Set the terminal's foreground ANSI color to white.

    on_black:   "\e[40m", # Set the terminal's background ANSI color to black.
    on_red:     "\e[41m", # Set the terminal's background ANSI color to red.
    on_green:   "\e[42m", # Set the terminal's background ANSI color to green.
    on_yellow:  "\e[43m", # Set the terminal's background ANSI color to yellow.
    on_blue:    "\e[44m", # Set the terminal's background ANSI color to blue.
    on_magenta: "\e[45m", # Set the terminal's background ANSI color to magenta.
    on_cyan:    "\e[46m", # Set the terminal's background ANSI color to cyan.
    on_white:   "\e[47m"  # Set the terminal's background ANSI color to white.
  }

  @@started_at = Time.now

  MESSAGE_COLOR = {
    :info     => :cyan,
    :warn     => :yellow,
    :error    => :red,
    :success  => :green,
  }

  MIN_VERBOSITY = {
    :debug    => 3,
    :info     => 2,
    :warn     => 1,
    :error    => 0,
    :success  => 0
  }

  def debug(msg, *args)
    Simple::UI.log :debug, msg, *args
  end

  def info(msg, *args)
    Simple::UI.log :info, msg, *args
  end

  def warn(msg, *args)
    Simple::UI.log :warn, msg, *args
  end

  def error(msg, *args)
    Simple::UI.log :error, msg, *args
  end

  def success(msg, *args)
    Simple::UI.log :success, msg, *args
  end

  def benchmark(msg, *args, &block)
    severity = :warn
    if msg.is_a?(Symbol)
      severity, msg = msg, args.shift
    end

    start = Time.now
    r = yield

    msg += ": #{(1000 * (Time.now - start)).to_i} msecs."
    Simple::UI.log severity, msg, *args

    r
  rescue StandardError
    msg += "raises #{$!.class.name} after #{(1000 * (Time.now - start)).to_i} msecs."
    Simple::UI.log severity, msg, *args
    raise $!
  end

  def self.colored=(colored)
    @colored = colored
  end

  def self.colored?
    if @colored.nil?
      @colored = STDERR.tty?
    end

    @colored != false
  end

  private

  def self.log(sym, msg, *args)
    rv = args.empty? ? msg : args.first

    return rv unless verbosity >= MIN_VERBOSITY[sym]

    unless args.empty?
      msg += ": " + args.map(&:inspect).join(", ")
    end

    if color = colored? && COLORS[MESSAGE_COLOR[sym]]
      msg = "#{color}#{msg}#{COLORS[:clear]}"
    end

    if verbosity > 2
      source = caller[1]
      source.gsub!( Dir.getwd, "." )
      source.gsub!( File.expand_path("~"), "~" )
      msg = "%-90s from: %s" % [ msg, source ]
    end

    STDERR.puts msg

    rv
  end
end
