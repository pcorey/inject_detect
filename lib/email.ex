defmodule Email do
  use Bamboo.Phoenix, view: InjectDetect.EmailView

  @from "hello@injectdetect.com"

  def welcome_text_email(to, name) do
    new_email()
    |> to(to)
    |> from(@from)
    |> subject("Welcome to Inject Detect!")
    |> put_text_layout({InjectDetect.LayoutView, "email.text"})
    |> render("welcome.text", name: name)
  end

  def welcome_html_email(to, name) do
    welcome_text_email(to, name)
    |> put_html_layout({InjectDetect.LayoutView, "email.html"})
    |> render("welcome.html", name: name)
  end

end
