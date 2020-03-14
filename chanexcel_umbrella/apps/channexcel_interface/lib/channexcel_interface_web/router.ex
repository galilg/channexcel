defmodule ChannexcelInterfaceWeb.Router do
  use ChannexcelInterfaceWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ChannexcelInterfaceWeb do
    pipe_through :browser

    get "/", PageController, :index
    post "/test", PageController, :test
  end

  # Other scopes may use custom stacks.
  # scope "/api", ChannexcelInterfaceWeb do
  #   pipe_through :api
  # end
end
