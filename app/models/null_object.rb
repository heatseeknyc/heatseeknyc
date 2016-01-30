class NullObject
  def method_missing(*)
    nil
  end

  def nil?
    true
  end
end
