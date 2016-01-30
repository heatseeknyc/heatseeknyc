class NullObject
  def method_missing(*args, &block)
    nil
  end

  def nil?
    true
  end
end
