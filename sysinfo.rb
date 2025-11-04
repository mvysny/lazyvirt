# Pretty-format bytes with suffixes like k, m, g (for KiB, MiB, GiB), showing one decimal place when needed.
# @param bytes [Integer] size in bytes
# @return [String] "1.0K", "23.8M", "8.0G" and such
def format_byte_size(bytes)
  return '0' if bytes.zero?
  units = %w[B K M G T P]

  # Use 1024-based units (KiB, MiB, etc.)
  exp = (Math.log(bytes, 1024)).floor
  exp = 5 if exp > 5 # Cap at petabytes

  value = bytes.to_f / (1024 ** exp)
  
  # Show one decimal if it's not a whole number, otherwise none
  formatted = if value >= 10 || value.truncate == value
                value.round.to_s
              else
                value.round(1)
              end

  "#{formatted}#{units[exp]}"
end

# Memory usage: `total` and `available`, in bytes, both {Integer}
class MemoryUsage < Data.define(:total, :available)
  def used
    total - available
  end
  def percent_used
    used * 100 / total
  end
  def to_s
    "#{format_byte_size(used)}/#{format_byte_size(total)} (#{percent_used}%)"
  end
end

# Memory statistics: `ram` and `swap`, both {MemoryUsage}.
class MemoryStat < Data.define(:ram, :swap)
  def to_s
    "RAM: #{ram}, SWAP: #{swap}"
  end
end

# Obtains system information from host Linux
class SysInfo
  # @return [MemoryStat] memory statistics
  def memory_stats(meminfo_file = nil)
    meminfo_file = meminfo_file || File.read('/proc/meminfo')
    mem = meminfo_file.lines.map { |it| it.strip.split(':') } .to_h
    ram = MemoryUsage.new(total: mem['MemTotal'].strip.to_i * 1024,
      available: mem['MemAvailable'].strip.to_i * 1024)
    swap = MemoryUsage.new(total: mem['SwapTotal'].strip.to_i * 1024,
      available: mem['SwapFree'].strip.to_i * 1024)
    MemoryStat.new(ram, swap)
  end
end

