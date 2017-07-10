defmodule Email do
  use Bamboo.Phoenix, view: InjectDetect.EmailView

  @from {"Inject Detect", "hello@injectdetect.com"}

  def welcome_text_email(user) do
    new_email()
    |> to(user.email)
    |> from(@from)
    |> subject("Welcome to Inject Detect!")
    |> put_text_layout({InjectDetect.LayoutView, "email.text"})
    |> render("welcome.text", user: user)
  end

  def welcome_html_email(user) do
    welcome_text_email(user)
    |> put_html_layout({InjectDetect.LayoutView, "email.html"})
    |> render("welcome.html", user: user)
  end

  def verify_text_email(user, requested_token) do
    new_email()
    |> to(user.email)
    |> from(@from)
    |> subject("Sign in requested")
    |> put_text_layout({InjectDetect.LayoutView, "email.text"})
    |> render("verify.text", user: user, requested_token: requested_token)
  end

  def verify_html_email(user, requested_token) do
    verify_text_email(user, requested_token)
    |> put_html_layout({InjectDetect.LayoutView, "email.html"})
    |> render("verify.html", user: user, requested_token: requested_token)
  end

  def unexpected_text_email(user, application, unexpected_query) do
    new_email()
    |> to(user.email)
    |> from(@from)
    |> subject("Unexpected query detected!")
    |> put_text_layout({InjectDetect.LayoutView, "email.text"})
    |> render("unexpected.text", user: user, application: application, unexpected_query: unexpected_query)
  end

  def unexpected_html_email(user, application, unexpected_query) do
    unexpected_text_email(user, application, unexpected_query)
    |> put_html_layout({InjectDetect.LayoutView, "email.html"})
    |> render("unexpected.html", user: user, application: application, unexpected_query: unexpected_query)
  end

end
