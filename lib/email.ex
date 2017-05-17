defmodule Email do
  use Bamboo.Phoenix, view: InjectDetect.EmailView

  @from "hello@injectdetect.com"

  def welcome_text_email(to, application) do
    new_email()
    |> to(to)
    |> from(@from)
    |> subject("Welcome to Inject Detect!")
    |> put_text_layout({InjectDetect.LayoutView, "email.text"})
    |> render("welcome.text", application: application)
  end

  def welcome_html_email(to, application) do
    welcome_text_email(to, application)
    |> put_html_layout({InjectDetect.LayoutView, "email.html"})
    |> render("welcome.html", application: application)
  end

  def verify_text_email(to, requested_token) do
    new_email()
    |> to(to)
    |> from(@from)
    |> subject("Sign in requested")
    |> put_text_layout({InjectDetect.LayoutView, "email.text"})
    |> render("verify.text", requested_token: requested_token)
  end

  def verify_html_email(to, requested_token) do
    verify_text_email(to, requested_token)
    |> put_html_layout({InjectDetect.LayoutView, "email.html"})
    |> render("verify.html", requested_token: requested_token)
  end

  def unexpected_text_email(to, application, unexpected_query) do
    new_email()
    |> to(to)
    |> from(@from)
    |> subject("Unexpected query detected!")
    |> put_text_layout({InjectDetect.LayoutView, "email.text"})
    |> render("unexpected.text", application: application, unexpected_query: unexpected_query)
  end

  def unexpected_html_email(to, application, unexpected_query) do
    unexpected_text_email(to, application, unexpected_query)
    |> put_html_layout({InjectDetect.LayoutView, "email.html"})
    |> render("unexpected.html", application: application, unexpected_query: unexpected_query)
  end

end
