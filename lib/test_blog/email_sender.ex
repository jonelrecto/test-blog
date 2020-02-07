defmodule TestBlog.EmailSender do
    import Bamboo.Email
    # import Bamboo.Phoenix

    def verification_email(user) do
      params = %{token: user.verification_token, id: user.id, email: user.email}
      link = "localhost:4000/api/verify/" <> params.id <> "/"<> params.token
      new_email(
        to: params.email,
        from: "darksiege32@gmail.com",
        subject: "welcome to api app",
        html_body: "<strong> thanks for signin app <br>
          Please verify your account <br>

           <a> #{link} </a>
        </strong>",
        text_body: ""
      )
    end



    # def verification_email(token, %{"email" => email}) do
    #   base_email()
    #    |> to(email)
    #    |> subject("Verification Email")
    #    |> html_body("<strong>Welcome</strong>")
    #    |> from("darksiege32@gmail.com")
    #
    # end
    #
    # defp base_email do
    #   new_mail()
    #     |> from("darksiege32@gmail.com")
    #     |> put_html_layout({TestBlogWeb.EmailView, "email.html"})
    # end

    # def welcome_email do
    #   base_email() # Build your default email then customize for welcome
    #   |> to("centinel.seven@gmail.com")
    #   |> subject("Welcome!!!")
    #   |> html_body("<strong>Welcome</strong>")
    #   |> text_body("Welcome")
    # end
    #
    # defp base_email do
    #   new_email()
    #   |> from("darksiege32@gmail.com") # Set a default from
    #   |> put_html_layout({TestBlogWeb.EmailView, "email.html"}) # Set default layout
    # end


end
