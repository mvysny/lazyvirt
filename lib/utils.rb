require 'open3'

# Runs command asynchronously, logging stderr lazily once it fails.
# The function terminates immediately.
# @param command [String] the command to run
def async_run(command)
  _stdin, combined_output, wait_thr = Open3.popen2e(command)

  Thread.new do
    status = wait_thr.value
    output = combined_output.read
    combined_output.close

    if status.success?
      $log.debug("#{command}: exited successfully")
    else
      $log.error("#{command} failed with #{status.exitstatus}: #{output}")
    end
  rescue StandardError => e
    $log.fatal("Fatal error running '#{command}'", e)
  end

  wait_thr.pid
end

# Pretty-format bytes with suffixes like k, m, g (for KiB, MiB, GiB), showing one decimal place when needed.
# @param bytes [Integer] size in bytes
# @return [String] "1.0K", "23.8M", "8.0G" and such
def format_byte_size(bytes)
  return '0' if bytes.zero?
  return "-#{format_byte_size(-bytes)}" if bytes.negative?

  units = ['', 'K', 'M', 'G', 'T', 'P']

  # Use 1024-based units (KiB, MiB, etc.)
  exp = Math.log(bytes, 1024).floor
  exp = 5 if exp > 5 # Cap at petabytes

  value = bytes.to_f / (1024**exp)

  # Show one decimal if it's not a whole number, otherwise none
  decimals = value >= 10 || value.round == value ? 0 : 1
  "#{value.round(decimals)}#{units[exp]}"
end
