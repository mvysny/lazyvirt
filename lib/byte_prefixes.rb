# frozen_string_literal: true

class Numeric
  def KiB
    self * 1024
  end

  def MiB
    self * 1024 * 1024
  end

  def GiB
    self * 1024 * 1024 * 1024
  end
end
