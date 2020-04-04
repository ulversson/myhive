defmodule MyHive.Regex.RegularExpressions do 

  def css_hex do 
    ~r/#([a-f]|[A-F]|[0-9]){3}(([a-f]|[A-F]|[0-9]){3})?\b/
  end  

end  