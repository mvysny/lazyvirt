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
  end

  wait_thr.pid
end
