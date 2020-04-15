defmodule MyHive.Regex.RegularExpressions do

  @phone ~r/^(\+\d{1,2}\s)?\(?\d{3}\)?[\s.-]\d{3}[\s.-]\d{4}$/
  @email ~r/\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  def phone_regex do
    @phone
  end

  def email_regex do
    @email
  end

  def css_hex do
    ~r/#([a-f]|[A-F]|[0-9]){3}(([a-f]|[A-F]|[0-9]){3})?\b/
  end

end
