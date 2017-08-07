defmodule InjectDetect.Router do
  use InjectDetect.Web, :router

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

  pipeline :graphql do
    plug :fetch_session
    plug :fetch_flash
    plug InjectDetect.Web.Context
  end

  scope "/", InjectDetect do
    pipe_through :browser # Use the default browser stack

    # get "/auth/:token", AuthController, :index
  end

  scope "/api", InjectDetect do
    pipe_through :api

    post "/ingest", IngestController, :create
    post "/stripe", StripeController, :webhook
  end

  scope "/graphiql" do
    pipe_through :graphql
    forward "/", Absinthe.Plug.GraphiQL, schema: InjectDetect.Schema
  end

  scope "/graphql" do
    pipe_through :graphql
    forward "/", Absinthe.Plug, schema: InjectDetect.Schema
  end

  if Mix.env == :dev do
    forward "/sent_emails", Bamboo.EmailPreviewPlug
  end

  get "/*route", InjectDetect.IndexController, :get

end
