defmodule MyHive.Radiology.RadiologyConfig do

  def radiology_config() do
    Application.get_env(:my_hive, MyHiveWeb.Endpoint)[:radiology]
  end

  def browser do
    radiology_config()[:browser]
  end

  def username do
    radiology_config()[:username]
  end

  def password do
    radiology_config()[:password]
  end
end
