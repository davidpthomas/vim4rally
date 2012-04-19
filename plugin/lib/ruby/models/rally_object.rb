class RallyObject

  public

  # convert blocked flag from String (rally side) to true bool; simplifies coding
  def blocked?
    return (@ref.blocked == "true") ? true : false
  end

  protected

  # store given values in local cache
  def cache(name, value)
    @cache = {} if @cache.nil?
    @cache[name] = value
  end

  private

  # Call/proxy internal rally reference for methods not on local object
  # Note: Cached values will be returned if set within object; reduces calls to rally
  # Note: Force nill values to return as empty string ""
  # Note: the underlying Rally REST objects rely heavily on method_missing
  #       so this proxy just hijacks the call and modifies the return
  def method_missing sym, *args
    response = ( !@cache.nil? && @cache.has_key?(sym) )? @cache[sym] : @ref.send(sym)
    return (response.nil?) ? String.new : response
  end

end
